//
//  ModeratorHistoryViews.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 23.04.2025.
//

import SwiftUI

struct ModeratorHistoryViews: View {
    @EnvironmentObject var mainVM: MainVM
    @EnvironmentObject var vm: ModeratorVM
    
    var activeOrders: [Order] { vm.orders.filter { $0.status.priority > 0 } }
    var pastOrders: [Order] { vm.orders.filter { $0.status.priority <= 0 } }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bgMain.ignoresSafeArea()
                
                info
                
                logoutBtn
            }
        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
                
                if !activeOrders.isEmpty {
                    Section(header: pinnedActive) {
                        ForEach(activeOrders) { order in
                            NavigationLink {
                                ModeratorOrderView(order: order)
                                    .navigationBarBackButtonHidden()
                                    .environmentObject(vm)
                            } label: {
                                ClientOrderCard(order: order)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                
                Spacer().frame(height: 22)

                if !pastOrders.isEmpty {
                    Section(header: pinnedPast) {
                        ForEach(pastOrders) { order in
                            NavigationLink {
                                ModeratorOrderView(order: order)
                                    .navigationBarBackButtonHidden()
                                    .environmentObject(vm)
                            } label: {
                                ClientOrderCard(order: order)
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
    
    var logoutBtn: some View {
        Button {
            mainVM.logout()
        } label: {
            Text("Выйти")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red)
                )
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding()
    }
}

#Preview {
    ModeratorHistoryViews()
        .environmentObject(ModeratorVM())
        .environmentObject(MainVM())
}
