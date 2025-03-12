//
//  Dish.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 10.03.2025.
//

import Foundation
import SwiftUI

struct Dish: Identifiable, Codable {
    var id: UUID = UUID()
    
    var name:           String
    var img:            [ImageDish] // Список URL изображений
    var coomposition:   String
    var ccal:           Int
    var weight:         Int
    var price:          Int
    var kitchenType:    KitchenType
    var dishType:       DishType
    
    init(id: UUID = UUID(),
         name:          String = "",
         img:           [ImageDish] = [],
         coomposition:  String = "",
         ccal:          Int = 0,
         weight:        Int = 0,
         price:         Int = 0,
         kitchenType:   KitchenType = .russian,
         dishType:      DishType = .breakfasts) {
        self.id = id
        self.name = name
        self.img = img
        self.coomposition = coomposition
        self.ccal = ccal
        self.weight = weight
        self.price = price
        self.kitchenType = kitchenType
        self.dishType = dishType
    }
}

struct ImageDish: Identifiable, Codable {
    var id: UUID = UUID()
    var imgUrl: String // Только URL изображения
    
    init(id: UUID = UUID(), imgUrl: String = "") {
        self.id = id
        self.imgUrl = imgUrl
    }
}


enum KitchenType: Identifiable, Codable, CaseIterable {
    case russian
    case french
    case asian
    case caucasian
    case italian
    case mediterranean
    case fusion
    case molecular
    
    var id: Self { self }
    
    var name: String {
        switch self {
            case .russian:       return "Русская"
            case .french:        return "Французская"
            case .asian:         return "Азиатская"
            case .caucasian:     return "Кавказская"
            case .italian:       return "Итальянская"
            case .mediterranean: return "Средиземноморская"
            case .fusion:        return "Фьюжн"
            case .molecular:     return "Молекулярная"
        }
    }
    
    var text: String {
        switch self {
            case .russian:       return "борщ, пельмени, блины, пироги, уха"
            case .french:        return "рататуй, луковый суп, фуа-гра, нисуаз"
            case .asian:         return "суши, вок, димсам, мисо-суп"
            case .caucasian:     return "хачапури, шашлык, хинкали, лобио"
            case .italian:       return "пицца, лазанья, ризотто, спагетти"
            case .mediterranean: return "меза, хумус, рыба на гриле, греческий салат"
            case .fusion:        return "сочетание элементов разных национальных традиций, например, японско-французская кухня"
            case .molecular:     return "создание необычных вкусовых форм и сочетаний с помощью химии и физики, например, твёрдый борщ или воздушная пена из чёрного хлеба"
        }
    }
    
    var emoji: String {
        switch self {
            case .russian:       return "🇷🇺"
            case .french:        return "🇫🇷"
            case .asian:         return "🇯🇵"
            case .caucasian:     return "🇦🇲"
            case .italian:       return "🇮🇹"
            case .mediterranean: return "🇬🇷"
            case .fusion:        return "🌍"
            case .molecular:     return "🔬"
        }
    }
}

enum DishType: Identifiable, Codable, CaseIterable {
    case breakfasts
    case snacks;
    case salads
    case soups
    case hotDishes
    case sideDishes
    case desserts
    
    var id: Self { self }
    
    var name: String {
        switch self {
            case .breakfasts: return "Завтраки"
            case .snacks: return "Закуски"
            case .salads: return "Салаты"
            case .soups: return "Супы"
            case .hotDishes: return "Горячие блюда"
            case .sideDishes: return "Гарниры"
            case .desserts: return "Десерты"
        }
    }
    
    var emoji: String {
        switch self {
            case .breakfasts: return "🥞"
            case .snacks: return "🍿"
            case .salads: return "🥗"
            case .soups: return "🥣"
            case .hotDishes: return "🍲"
            case .sideDishes: return "🥘"
            case .desserts: return "🍰"
        }
    }
}
