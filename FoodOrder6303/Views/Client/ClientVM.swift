//
//  ClientVM.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import Foundation
import SwiftUI
import Firebase

var mockAccountClient = Client(id: UUID(uuidString: "8017E388-C6F8-4EA4-9F92-3E1D39DAF2CC"
                                       ) ?? UUID(),
                               login: "example@gmail.com",
                               password: "12345",
                               name: "",
                               phone: "",
                               adresses: [Adress(id: UUID(uuidString: "B36FCF8B-9B19-42DA-8FCD-083323329C76") ?? UUID(), name: "Московское шоссе 34")],
                               role: .client,
                               isWork: false)

class ClientVM: ObservableObject {
    
    @Published var tabSelected: Int = 0
    var account: Client
    @Published var orders: [Order] = []
    private var db = Firestore.firestore()
    
    init(account: Client) {
        self.account = account
        fetchOrders(for: account.id)
    }
    
    
    func fetchOrders(for accountID: UUID) {
        db.collection("orders")
            .whereField("accountID", isEqualTo: accountID.uuidString)
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
