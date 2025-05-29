//
//  AdminOrdersView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct AdminOrdersView: View {
    @EnvironmentObject var mainVM: MainVM
    @EnvironmentObject var vm: AdminVM
    
    var activeOrders: [Order] { vm.orders.filter { $0.status.priority > 0 } }
    var pastOrders: [Order] { vm.orders.filter { $0.status.priority <= 0 } }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bgMain.ignoresSafeArea()
                
                info
            }
        }
    }
    
    var couriers: [Client] {
        mainVM.accounts.filter { $0.role == .courier }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
                
                if !activeOrders.isEmpty {
                    Section(header: pinnedActive) {
                        ForEach(activeOrders) { order in
                            let courier = couriers.first(where: { $0.id == order.courierID })
                            
                            NavigationLink {
                                AdminOrderView(order: order)
                                    .navigationBarBackButtonHidden()
                                    .environmentObject(vm)
                                    .environmentObject(mainVM)
                            } label: {
                                ClientWithCourier(order: order, courier: courier)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                
                Spacer().frame(height: 22)

                if !pastOrders.isEmpty {
                    Section(header: pinnedPast) {
                        ForEach(pastOrders) { order in
                            let courier = couriers.first(where: { $0.id == order.courierID })
                            
                            NavigationLink {
                                AdminOrderView(order: order)
                                    .navigationBarBackButtonHidden()
                                    .environmentObject(vm)
                                    .environmentObject(mainVM)
                            } label: {
                                ClientWithCourier(order: order, courier: courier)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }

    
    var pinnedActive: some View {
        Text("Активные заказы")
            .font(.system(size: 24, weight: .semibold))
            .foregroundStyle(.textMain)
            .frame(height: 32)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .background(LinearGradient(
                gradient: Gradient(
                    stops: [
                        .init(color: .bgMain.opacity(0), location: 0.0),
                        .init(color: .bgMain.opacity(0.5), location: 0.2),
                        .init(color: .bgMain.opacity(0.5), location: 0.8),
                        .init(color: .bgMain.opacity(0), location: 0)
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea())
    }
    
    var pinnedPast: some View {
        Text("Выполненные заказы")
            .font(.system(size: 24, weight: .semibold))
            .foregroundStyle(.textMain)
            .frame(height: 32)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .background(LinearGradient(
                gradient: Gradient(
                    stops: [
                        .init(color: .bgMain.opacity(0), location: 0.0),
                        .init(color: .bgMain.opacity(0.5), location: 0.2),
                        .init(color: .bgMain.opacity(0.5), location: 0.8),
                        .init(color: .bgMain.opacity(0), location: 0)
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea())
    }
}

#Preview {
    AdminOrdersView()
        .environmentObject(AdminVM())
        .environmentObject(MainVM())
}

struct ClientWithCourier: View {
    var order:   Order
    var courier: Client?
    
    var body: some View {
        ClientOrderCard(order: order)
            .overlay(
                Text(courier?.name ?? "")
                    .font(.caption)
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 6)
            )
    }
}
