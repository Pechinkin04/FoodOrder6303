//
//  AdminOrderView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 29.04.2025.
//

import SwiftUI
import Firebase

struct AdminOrderView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mainVM: MainVM
    @EnvironmentObject var vm: AdminVM
    @State var order: Order
    
    @State private var isLoad: Bool = false
    @State private var alertItem: AlertItem?
    
    var couriers: [Client] {
        mainVM.accounts.filter { $0.role == .courier }
    }
    
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.textMain)
                        .padding(2)
                }
            }
        }
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
                
                Menu {
                    ForEach(couriers) { courier in
                        Button {
                            order.courierID = courier.id
                        } label: {
                            Text(courier.name)
                        }
                    }
                } label: {
                    let courier = couriers.first(where: { $0.id == order.courierID })
                    Text(courier?.name ?? "Выбрать курьера")
                        .foregroundStyle(.textMain.opacity(courier == nil ? 0.5 : 1))
                        .embedInTextField(title: "Курьер")
                }
                
                Menu {
                    ForEach(OrderStatus.allCases) { status in
                        Button {
                            order.status = status
                        } label: {
                            Text(status.raw)
                        }
                    }
                } label: {
                    HStack {
                        Text(order.status.raw)
                            .foregroundStyle(.textMain)
                        Spacer()
                        Circle()
                            .fill(order.status.color)
                            .frame(width: 12, height: 12)
                    }
                        .embedInTextField(title: "Статус заказа")
                }
            }
            .padding()
            .padding(.bottom, 70)
        }
    }
    
    var btn: some View {
        Button {
            saveOrder()
        } label: {
            Text("Сохранить")
                .font(.system(size: 15, weight: .semibold))
                .embedInButton(cornRadius: 12)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    func saveOrder() {
        isLoad = true
        Task {
            do {
                let encodedOrder = try Firestore.Encoder().encode(order)
                try await Firestore.firestore()
                    .collection("orders")
                    .document(order.id.uuidString)
                    .setData(encodedOrder, merge: false)
                print("Заказ успешно создан")
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                print("Ошибка при создании заказа: \(error)")
                DispatchQueue.main.async {
                    self.isLoad = false
                    alertItem = APError.orderCreationError.alert
                }
            }
        }
    }
}

#Preview {
    AdminOrderView(order: mockOrder)
        .environmentObject(AdminVM())
        .environmentObject(MainVM())
}
