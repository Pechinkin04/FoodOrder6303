//
//  CourierView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 23.04.2025.
//

import SwiftUI

struct CourierView: View {
    @EnvironmentObject var mainVM: MainVM
    @StateObject var courVM = CourierVM()
    
    var body: some View {
        TabView(selection: $courVM.tabSelected) {
            CourierDeliveryView()
                .tabItem {
                    Image(systemName: "menucard.fill")
                    Text("Заказы")
                }.tag(0)
            
            CourierOrdersView()
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("История")
                }.tag(1)
            
            CourierAccountView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Аккаунт")
                }.tag(2)
        }
        .environmentObject(courVM)
        .environmentObject(mainVM)
        .onAppear {
            guard let userID = mainVM.account?.id else { return }
            courVM.courierID = userID
            courVM.fetchOrders(for: userID)
        }
    }
}

#Preview {
    CourierView()
        .environmentObject(MainVM())
}
