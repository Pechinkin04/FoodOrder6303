//
//  ModeratorOrdersView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 23.04.2025.
//

import SwiftUI

struct ModeratorOrdersView: View {
    @EnvironmentObject var vm: ModeratorVM
    var activeOrders: [Order] { vm.orders.filter { $0.status.priority > 0 } }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bgMain.ignoresSafeArea()
                
                if activeOrders.isEmpty {
                    Text("Активных заказов нет")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.textMain)
                        .padding(.horizontal, 20)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Активные заказы")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.textMain)
                            
                            ForEach(activeOrders) { order in
                                NavigationLink {
                                    ModeratorOrderView(order: order)
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    ModeratorOrderCard(order: order)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AboutUsView()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    ModeratorOrdersView()
        .environmentObject(ModeratorVM())
}

struct ModeratorOrderCard: View {
    var order: Order
    var nameDishes: String {
        order.dishes.reduce("", { $0 + $1.key.name + "\n" })
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 14) {
                imgs
                info
            }
            
            Text("Назначить курьера")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.bgMain)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.prime)
                )
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 30)
    }
    
    var imgs: some View {
        LazyVGrid(columns: [GridItem(spacing: 5), GridItem()], alignment: .leading, spacing: 5) {
            ForEach(Array(order.dishes.enumerated()), id: \.element.key) { (index, element) in
                let (dish, _) = element
//                let (dish, count) = element
                AppetizerRemoteImage(urlString: dish.img.first?.imgUrl ?? "")
                    .frame(width: 46, height: 46)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .frame(width: 97, height: 97, alignment: .topLeading)
    }
    
    var info: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(nameDishes)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.textMain)
                    .lineLimit(3)
                Spacer()
                Text(order.status.raw)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(order.status.color)
            }
            .layoutPriority(2)
            HStack {
                Text(order.adress)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Text("\(order.price)")
                    .font(.system(size: 18, weight: .bold))
                    .layoutPriority(1)
            }
            .foregroundStyle(.textMain)
        }
    }
}
