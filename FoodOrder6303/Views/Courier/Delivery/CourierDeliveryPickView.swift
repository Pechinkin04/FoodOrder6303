//
//  CourierDeliveryPickView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 26.04.2025.
//

import SwiftUI
import Firebase

struct CourierDeliveryPickView: View {
    @Environment(\.presentationMode) var presentationMode
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
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            info
            btn
            
            if isLoad {
                LoadProgressView()
            }
        }
        .alert(item: $alertItem, content: { alert in
            Alert(title: alert.message,
                  message: alert.message,
                  dismissButton: alert.btns)
        })
        .animation(.default, value: isLoad)
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Заказ")
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(Array(order.dishes.enumerated()), id: \.element.key) { (index, element) in
                    let (dish, count) = element
                    DishOrderCard(
                        dish: dish,
                        count: Binding(
                            get: { order.dishes[dish] ?? 0 },
                            set: { order.dishes[dish] = $0 }
                        ),
                        showCountPicker: false
                    )
                    .onChange(of: count) {
                        if count == 0 {
                            order.dishes[dish] = nil
                        }
                    }
                }
                
//                Text(order.adress)
//                    .foregroundStyle(.textMain)
//                .embedInTextField(title: "Адрес")
                
                HStack {
                    Text("Адрес:")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.textMain)
                    Spacer()
                    Text(order.adress)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.textMain)
                }
                
                DatePicker("Дата поставки", selection: $order.date, displayedComponents: .date)
                DatePicker("Время поставки", selection: $order.date, displayedComponents: .hourAndMinute)
                
                HStack {
                    Text("Сумма заказа:")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.textMain)
                    Spacer()
                    Text("\(order.price)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.textMain)
                }
                
//                Menu {
//                    ForEach(OrderStatus.allCases) { status in
//                        Button {
//                            order.status = status
//                        } label: {
//                            Text(status.raw)
//                        }
//                    }
//                } label: {
//                    HStack {
//                        Text(order.status.raw)
//                            .foregroundStyle(.textMain)
//                        Spacer()
//                        Circle()
//                            .fill(order.status.color)
//                            .frame(width: 12, height: 12)
//                    }
//                        .embedInTextField(title: "Статус заказа")
//                }
            }
            .padding()
            .padding(.bottom, 100)
        }
    }
    
    
    var btn: some View {
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
                .overlay {
                    Text("Зажми")
                        .font(.system(size: 12))
                        .foregroundStyle(.bgMain.opacity(0.7))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding()
                }
                .onLongPressGesture {
                    nextStatus()
                }
            
//            if isLoad {
//                LoadProgressView()
//            }
        }
        .clipShape(.rect(cornerRadius: 15))
        
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding()
    }
    
    private func nextStatus() {
        if order.status == .confirmed {
            order.status = .delivery
        } else {
            order.status = .delivered
        }
        
        isLoad = true
        Task {
            do {
                let encodedOrder = try Firestore.Encoder().encode(order)
                try await Firestore.firestore()
                    .collection("orders")
                    .document(order.id.uuidString)
                    .setData(encodedOrder, merge: false)
                print("Заказ успешно создан")
            } catch {
                print("Ошибка при создании заказа: \(error)")
                DispatchQueue.main.async {
                    self.isLoad = false
                    alertItem = APError.orderCreationError.alert
                }
            }
            isLoad = false
            
            if order.status.priority <= 0 {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    CourierDeliveryPickView(order: .constant(mockOrder))
}
