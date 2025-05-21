//
//  ClientOrdersView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct ClientOrdersView: View {
    @EnvironmentObject var clientVM: ClientVM
    
    var activeOrders: [Order] { clientVM.orders.filter { $0.status.priority > 0 } }
    var pastOrders: [Order] { clientVM.orders.filter { $0.status.priority <= 0 } }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bgMain.ignoresSafeArea()
                
                info
            }
        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
                
                if !activeOrders.isEmpty {
                    Section(header: pinnedActive) {
                        ForEach(activeOrders) { order in
                            ClientOrderCard(order: order)
                                .padding(.horizontal, 20)
                        }
                    }
                }
                
                Spacer().frame(height: 22)

                if !pastOrders.isEmpty {
                    Section(header: pinnedPast) {
                        ForEach(pastOrders) { order in
                            NavigationLink {
                                ClientRepeatOrderView(order: order)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                ClientOrderCard(order: order)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
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
        Text("Прошлые заказы")
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
    ClientOrdersView()
        .environmentObject(ClientVM(account: mockAccountClient))
}

struct ClientOrderCard: View {
    var order: Order
    var nameDishes: String {
        order.dishes.reduce("", { $0 + $1.key.name + "\n" })
    }
    
    var body: some View {
        HStack(spacing: 14) {
            imgs
            info
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 30)
        .multilineTextAlignment(.leading)
    }
    
    var imgs: some View {
        LazyVGrid(columns: [GridItem(spacing: 5), GridItem()], alignment: .leading, spacing: 5) {
            ForEach(Array(order.dishes.enumerated()), id: \.element.key) { (index, element) in
                let (dish, count) = element
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
