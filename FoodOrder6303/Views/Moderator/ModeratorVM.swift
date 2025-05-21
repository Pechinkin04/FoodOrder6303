import Foundation
import SwiftUI
import Firebase

class ModeratorVM: ObservableObject {
    
    @Published var tabSelected: Int = 0
    @Published var couriers: [Client] = []
    @Published var orders: [Order] = []
    
    private var db = Firestore.firestore()
    
    init() {
        fetchCouriers()
        fetchOrders()
    }
    
    // Метод для фильтрации курьеров по состоянию работы
    func fetchCouriers() {
        db.collection("accounts")
            .whereField("role", isEqualTo: "courier")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Ошибка при получении курьеров: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("Нет курьеров")
                    return
                }

                do {
                    self.couriers = try documents.map { doc in
                        let data = doc.data()
                        return try Firestore.Decoder().decode(Client.self, from: data)
                    }
                    
                    // Применяем фильтрацию курьеров по isWork (активный или нет)
                    self.couriers = self.couriers.filter { $0.isWork }
                    
                } catch {
                    print("Ошибка декодирования курьеров: \(error.localizedDescription)")
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
