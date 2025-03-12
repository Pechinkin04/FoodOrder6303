//
//  FoodOrder6303App.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 04.03.2025.
//

import SwiftUI

@main
struct FoodOrder6303App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var firestoreService = FirestoreService.shared
    
    var body: some Scene {
        WindowGroup {
            DishesView()
                .environmentObject(firestoreService)
        }
    }
}
