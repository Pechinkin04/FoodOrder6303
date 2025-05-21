//
//  CourierOrdersView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 25.04.2025.
//

import SwiftUI

struct CourierOrdersView: View {
    @EnvironmentObject var courVM: CourierVM
    
    var activeOrders: [Order] { courVM.orders.filter { $0.status.priority > 0 }.sorted { $0.date > $1.date } }
    var pastOrders: [Order] { courVM.orders.filter { $0.status.priority <= 0 }.sorted { $0.date > $1.date } }
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            if courVM.orders.isEmpty {
                Text("Отсутсвует история заказов")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.textMain)
                    .padding(.horizontal, 20)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        if activeOrders.count > 0 {
                            Text("Активные заказы")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.textMain)
                            
                            ForEach(activeOrders) { order in
                                ClientOrderCard(order: order)
                            }
                        }
                        
                        if pastOrders.count > 0 {
                            Text("Прошлые заказы")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.textMain)
                            
                            ForEach(pastOrders) { order in
                                ClientOrderCard(order: order)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
//        .onAppear {
//            courVM.fetchOrders(for: UUID(uuidString: "1E024403-CB16-4C98-8D74-95FE2172F083") ?? UUID())
//        }
    }
}

#Preview {
    CourierOrdersView()
        .environmentObject(CourierVM())
}
