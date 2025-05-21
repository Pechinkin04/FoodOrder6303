//
//  CourierVM.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 23.04.2025.
//

import Foundation
import Firebase

class CourierVM: ObservableObject {
    
    @Published var tabSelected: Int = 0
    
    var courierID: UUID?
    @Published var orders: [Order] = []
    private var db = Firestore.firestore()
    
    init() {
        
    }
    
    func fetchOrders(for courierID: UUID) {
        db.collection("orders")
            .whereField("courierID", isEqualTo: courierID.uuidString)
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
                } catch {
                    print("Ошибка декодирования заказов: \(error.localizedDescription)")
                }
            }
    }
}
