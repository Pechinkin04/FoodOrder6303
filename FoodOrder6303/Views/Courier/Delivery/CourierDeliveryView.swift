//
//  CourierDeliveryView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 25.04.2025.
//

import SwiftUI
import Firebase

struct CourierDeliveryView: View {
    @EnvironmentObject var courVM: CourierVM
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bgMain.ignoresSafeArea()
                
                if courVM.orders.filter({ $0.status.priority > 0 }).isEmpty {
                    Text("Отсутсвуют заказы")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.textMain)
                        .padding(.horizontal, 20)
                } else {
                    info
                }
            }
            .animation(.default, value: courVM.orders.filter({ $0.status.priority > 0 }).count)
         
            .navigationTitle("Текущие заказы")
            
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
//        .onAppear {
//            courVM.fetchOrders(for: UUID(uuidString: "1E024403-CB16-4C98-8D74-95FE2172F083") ?? UUID())
//        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Выберите заказ для доставки")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.textMain)
                
                ForEach(courVM.orders.filter({ $0.status.priority > 0 })) { order in
                    NavigationLink {
                        CourierDeliveryPickView(order: binding(for: order))
                    } label: {
                        CourierOrderCard(order: binding(for: order))
                            .animation(.default, value: order.status)
                    }
                }
            }
            .padding()
        }
    }
    
    func binding(for order: Order) -> Binding<Order> {
        guard let index = courVM.orders.firstIndex(where: { $0.id == order.id }) else {
//            fatalError("Order not found")
//            return $courVM.orders.first ?? .constant(mockOrder)
            return .constant(mockOrder)
        }
        return $courVM.orders[index]
    }
}

#Preview {
    CourierDeliveryView()
        .environmentObject(CourierVM())
}

struct CourierOrderCard: View {
    @Binding var order: Order
    var nameDishes: String {
        order.dishes.reduce("", { $0 + $1.key.name + "\n" })
    }
    var status: String {
        switch order.status {
            case .confirmed: return "Взять в доставку"
//            case .delivery: return "Доставлен"
            default: return "Доставлен"
        }
    }
    
    @State private var isLoad = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 14) {
                imgs
                info
            }
            
            ZStack {
                Text(status)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.bgMain)
                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 8)
                    .frame(height: 70)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.prime)
                    )
                
                if isLoad {
                    LoadProgressView()
                }
            }
            .clipShape(.rect(cornerRadius: 15))
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 30)
        .alert(item: $alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.btns)
        }
        .animation(.default, value: isLoad)
    }
    
    var imgs: some View {
        LazyVGrid(columns: [GridItem(spacing: 5), GridItem()], alignment: .leading, spacing: 5) {
            ForEach(Array(order.dishes.enumerated()), id: \.element.key) { (index, element) in
//                let (dish, count) = element
                let (dish, _) = element
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
                    .multilineTextAlignment(.leading)
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
