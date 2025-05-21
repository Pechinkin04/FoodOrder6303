//
//  AdminMainView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct AdminMainView: View {
    @EnvironmentObject var mainVM: MainVM
    @StateObject var adminVM: AdminVM = AdminVM()
    
    var body: some View {
        TabView(selection: $adminVM.tabSelected) {
            DishesView()
                .tabItem {
                    Image(systemName: "menucard.fill")
                    Text("Блюда")
                }.tag(0)
            
            AdminOrdersView()
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Заказы")
                }.tag(1)
            
            AdminClerksView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Сотрудники")
                }.tag(2)
            
            AdminClientsView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Клиенты")
                }.tag(3)
        }
        .environmentObject(adminVM)
        .environmentObject(mainVM)
    }
}

#Preview {
    AdminMainView()
        .environmentObject(MainVM())
}
