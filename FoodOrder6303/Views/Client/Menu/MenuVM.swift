//
//  MenuVM.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class MenuVM: ObservableObject {
    @AppStorage("accountIDStorage") var accountID: String = ""
    
    @Published var dishes: [Dish] = []
    @Published var searchDish: String = ""
    @Published var showFilter: Bool = false
    @Published var sortByUp: Bool = true
    @Published var kitchType: KitchenType?
    @Published var dishType: DishType?
    var dishFilter: [Dish] {
        var dishFilter = dishes
        
        if let kitchType = kitchType {
            dishFilter = dishFilter.filter { $0.kitchenType == kitchType }
        }
        
        if let dishType = dishType {
            dishFilter = dishFilter.filter { $0.dishType == dishType }
        }
        
        dishFilter.sort(by: { sortByUp ? $0.price < $1.price : $0.price > $1.price })
        
        if searchDish.isEmpty {
            return dishFilter
        } else {
            return dishFilter.filter { $0.name.lowercased().contains(searchDish.lowercased()) }
        }
    }
    
    @Published var order: Order = Order(accountID: UUID())
    
    @Published var adresses: [Adress]
    
    private var db = Firestore.firestore()
    
    init(adresses: [Adress] = []) {
        self.adresses = adresses
        
        self.order = Order(accountID: UUID(uuidString: self.accountID) ?? UUID())
        fetchDishes()
    }
    
    func fetchDishes() {
        db.collection("dishes").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            do {
                self.dishes = try documents.map { queryDocumentSnapshot -> Dish in
                    let data = queryDocumentSnapshot.data()
                    
                    // Декодируем в объект типа Dish
                    let dish = try Firestore.Decoder().decode(Dish.self, from: data)
                    return dish
                }
            } catch {
                print(error)
            }
            
        }

    }
    
    @Published var isLoad: Bool = false
    @Published var alertItem: AlertItem?
    
    
    func createOrder(_ order: Order) {
        isLoad = true
        Task {
            do {
                let encodedOrder = try Firestore.Encoder().encode(order)
                try await db.collection("orders").document(order.id.uuidString).setData(encodedOrder)
                print("Заказ успешно создан")
                DispatchQueue.main.async {
                    self.order = Order(accountID: UUID())
                }
            } catch {
                print("Ошибка при создании заказа: \(error)")
                DispatchQueue.main.async {
                    self.alertItem = APError.orderCreationError.alert
                }
            }
            
            DispatchQueue.main.async {
                self.isLoad = false
            }
        }
    }
    
    func updateOrder(_ order: Order) {
        Task {
            do {
                let encodedOrder = try Firestore.Encoder().encode(order)
                try await db.collection("orders").document(order.id.uuidString).setData(encodedOrder, merge: true)
                print("Заказ успешно обновлён")
            } catch {
                print("Ошибка при обновлении заказа: \(error)")
                DispatchQueue.main.async {
                    self.alertItem = APError.orderUpdateError.alert
                }
            }
        }
    }


    func deleteOrder(_ order: Order) {
        Task {
            do {
                try await db.collection("orders").document(order.id.uuidString).delete()
                print("Заказ успешно удалён")
            } catch {
                print("Ошибка при удалении заказа: \(error)")
                DispatchQueue.main.async {
                    self.alertItem = APError.orderDeleteError.alert
                }
            }
        }
    }

}
