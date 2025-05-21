//
//  ClientRepeatOrderView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 23.04.2025.
//

import SwiftUI
import Firebase

struct ClientRepeatOrderView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var order: Order
    
    @State private var isLoad: Bool = false
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
        .onAppear {
            let newOrder = Order(adress: order.adress,
                                 dishes: order.dishes,
                                 accountID: order.accountID)
            order = newOrder
        }
        
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
                
                Text(order.adress)
                    .foregroundStyle(.textMain)
                .embedInTextField(title: "Адрес")
                
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
            }
            .padding()
            .padding(.bottom, 70)
        }
    }
    
    var btn: some View {
        Button {
            createOrder()
        } label: {
            Text("Повторить заказ")
                .font(.system(size: 15, weight: .semibold))
                .embedInButton(cornRadius: 12)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    func createOrder() {
        isLoad = true
        Task {
            do {
                let encodedOrder = try Firestore.Encoder().encode(order)
                try await Firestore.firestore().collection("orders").document(order.id.uuidString).setData(encodedOrder)
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
    ClientRepeatOrderView(order: mockOrder)
}

var mockOrder = Order(date: Date(),
                      adress: "Московское шоссе 34Б",
                      dishes: [Dish(name: "example",
                                    img: [],
                                    coomposition: "exampleComp",
                                    ccal: 10,
                                    weight: 10,
                                    price: 10,
                                    kitchenType: .russian,
                                    dishType: .breakfasts) : 1],
                      status: .delivered,
                      accountID: mockAccountClient.id)
