//
//  DishesVM.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 10.03.2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class DishesVM: ObservableObject {
    @Published var dishes: [Dish] = []
    @Published var searchDish: String = ""
    var dishFilter: [Dish] {
        if searchDish.isEmpty {
            return dishes
        } else {
            return dishes.filter { $0.name.lowercased().contains(searchDish.lowercased()) }
        }
    }

    private var db = Firestore.firestore()
    
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
    
    public func upload(dish: Dish, newImages: [UIImage]) {
        isLoad = true
        Task {
            do {
                try await FirestoreService.shared.uploadDish(dish, images: newImages)
                DispatchQueue.main.async {
                    self.isLoad = false
                }
            } catch {
                DispatchQueue.main.async { [self] in
                if let apError = error as? APError {
                    alertItem = apError.alert
                } else {
                    alertItem = APError.invalidError.alert
                }
                print(error.localizedDescription)
                    isLoad = false
                }
            }
        }
    }
}
