//
//  Client.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import Foundation
import SwiftUI

enum Role: String, Identifiable, CaseIterable, Codable {
    case client
    case courier
    case moderator
    case admin

    var id: Self { self }
}

extension Role {
    var raw: String {
        switch self {
            case .client: return "Клиент"
            case .courier: return "Курьер"
            case .moderator: return "Модератор"
            case .admin: return "Администратор"
        }
    }

    var emoji: String {
        switch self {
            case .client: return "👕"
            case .courier: return "🚚"
            case .moderator: return "🧑‍💻"
            case .admin: return "🧑‍💼"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
            case .client:       ClientView()
            case .courier:      CourierView()
            case .moderator:    ModeratorView()
            case .admin:        AdminMainView()
        }
    }
}


public protocol User: Identifiable, Codable {
    var id: UUID { get }
    
    var login:      String { get set }
    var password:   String { get set }
    var name:       String { get set }
    var phone:      String { get set }
}

struct Client: User, Codable {
//    static func == (lhs: Client, rhs: Client) -> Bool {
//        lhs.id == rhs.id
//    }
//    
    var id = UUID()
    
    var login:      String = ""
    var password:   String = ""
    var name:       String = ""
    var phone:      String = ""
    
    var adresses:   [Adress] = []
    
    var role: Role = .client
    var isWork:     Bool = true
}

struct Adress: Identifiable, Codable, Equatable {
    var id = UUID()
    
    var name: String = ""
}
