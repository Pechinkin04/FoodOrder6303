//
//  Order.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import Foundation
import SwiftUI

struct Order: Identifiable, Codable {
    var id = UUID()
    
    var date: Date = Date()
    var adress: String = ""
    var dishes: [Dish: Int] = [:]
    
    var price: Int { dishes.reduce(0) { $0 + $1.key.price * $1.value } }
    var status: OrderStatus = .confirmation
    var accountID: UUID
    var courierID: UUID?
}

enum OrderStatus: Identifiable, Codable, CaseIterable {
    // Статусы для заказа: подтверждение, Доставка, Доставлено
    case confirmation, confirmed, delivery, delivered, camceled
    
    var id: Self { self }
    
    var priority: Int {
        switch self {
            case .confirmation, .confirmed, .delivery: return 1
            default: return 0
        }
    }
    
    var raw: String {
        switch self {
            case .confirmation: return "Подтверждение"
            case .confirmed:    return "Подтверждено"
            case .delivery:     return "Доставка"
            case .delivered:    return "Доставлено"
            case .camceled:     return "Отменено"
        }
    }
    
    var color: Color {
        switch self {
            case .confirmation: return .brown
            case .confirmed:    return .orange
            case .delivery:     return .yellow
            case .delivered:    return .green
            case .camceled:     return .red
        }
    }
}
