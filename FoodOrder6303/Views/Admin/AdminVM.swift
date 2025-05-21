//
//  AdminVM.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import Foundation
import Firebase

class AdminVM: ObservableObject {
    
    @Published var tabSelected: Int = 0
    
    @Published var alertItem: AlertItem?
    @Published var isLoad: Bool = false
    
    @Published var orders: [Order] = []
    private var db = Firestore.firestore()
    
    init () {
        fetchOrders()
    }
    
    
    public func createClerk(clerk: Client) {
        isLoad = true
        Task {
            do {
                try await FirestoreService.shared.createClientAccount(clerk)
                print("Аккаунт успешно создан")
                DispatchQueue.main.async { [self] in
                    isLoad = false
                }
            } catch {
                print("Ошибка при создании аккаунта: \(error)")
                DispatchQueue.main.async { [self] in
                    if let apError = error as? APError {
                        alertItem = apError.alert
                    } else {
                        alertItem = APError.invalidError.alert
                    }
                    
                    isLoad = false
                }
            }
        }

    }
    
    public func updateClerk(_ clerk: Client) {
        isLoad = true
        Task {
            do {
                try await FirestoreService.shared.updateClientAccount(clerk)
                print("Аккаунт успешно обновлён")
                DispatchQueue.main.async {
                    self.isLoad = false
                }
            } catch {
                print("Ошибка при обновлении аккаунта: \(error)")
                DispatchQueue.main.async {
                    if let apError = error as? APError {
                        self.alertItem = apError.alert
                    } else {
                        self.alertItem = APError.invalidError.alert
                    }
                    self.isLoad = false
                }
            }
        }
    }
    
    public func deleteClerk(_ clerk: Client) {
        isLoad = true
        Task {
            do {
                try await FirestoreService.shared.deleteClientAccount(clerk)
                print("Аккаунт успешно удалён")
                DispatchQueue.main.async {
                    self.isLoad = false
                }
            } catch {
                print("Ошибка при удалении аккаунта: \(error)")
                DispatchQueue.main.async {
                    if let apError = error as? APError {
                        self.alertItem = apError.alert
                    } else {
                        self.alertItem = APError.invalidError.alert
                    }
                    
                    self.isLoad = false
                }
            }
        }
    }
    
    // Метод для фильтрации заказов по статусу
    func fetchOrders() {
        db.collection("orders")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Ошибка при получении заказов: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("Нет заказов")
                    return
                }

                do {
                    self.orders = try documents.map { doc in
                        let data = doc.data()
                        return try Firestore.Decoder().decode(Order.self, from: data)
                    }
                    
                    // Применяем фильтрацию заказов по статусу (например, только активные заказы)
//                    self.orders = self.orders.filter { $0.status == .confirmation }
                    
                } catch {
                    print("Ошибка декодирования заказов: \(error.localizedDescription)")
                }
            }
    }
}
