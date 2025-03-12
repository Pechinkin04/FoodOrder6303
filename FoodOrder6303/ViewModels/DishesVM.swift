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
}
