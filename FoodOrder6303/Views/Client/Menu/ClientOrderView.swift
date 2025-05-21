//
//  ClientOrderView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct ClientOrderView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var menuVM: MenuVM
    
    var isNew: Bool = true
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            info
            btn
            
            if menuVM.isLoad {
                LoadProgressView()
            }
        }
        .animation(.default, value: menuVM.dishes.count)
        .animation(.default, value: menuVM.isLoad)
        .onChange(of: menuVM.order.id) { newValue in
            self.presentationMode.wrappedValue.dismiss()
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
                ForEach(Array(menuVM.order.dishes.enumerated()), id: \.element.key) { (index, element) in
                    let (dish, count) = element
                    DishOrderCard(
                        dish: dish,
                        count: Binding(
                            get: { menuVM.order.dishes[dish] ?? 0 },
                            set: { menuVM.order.dishes[dish] = $0 }
                        )
                    )
                    .onChange(of: count) {
                        if count == 0 {
                            menuVM.order.dishes[dish] = nil
                        }
                    }
                }
                
                if menuVM.adresses.isEmpty {
                    
                } else {
                    Menu {
                        ForEach(menuVM.adresses) { adress in
                            Button {
                                menuVM.order.adress = adress.name
                            } label: {
                                Text(adress.name)
                            }
                        }
                    } label: {
                        Text(menuVM.order.adress.isEmpty ? "Адрес" : menuVM.order.adress)
                            .foregroundStyle(menuVM.order.adress.isEmpty ? .textMain.opacity(0.5) : .textMain)
                    }
                    .embedInTextField(title: "Адрес")
                }
                
                DatePicker("Дата поставки", selection: $menuVM.order.date, displayedComponents: .date)
                DatePicker("Время поставки", selection: $menuVM.order.date, displayedComponents: .hourAndMinute)
                
                HStack {
                    Text("Сумма заказа:")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.textMain)
                    Spacer()
                    Text("\(menuVM.order.price)")
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
            if isNew {
                menuVM.createOrder(menuVM.order)
            }
        } label: {
            Text(isNew ? "Создать заказ" : "Повторить заказ")
                .font(.system(size: 15, weight: .semibold))
                .embedInButton(cornRadius: 12)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

#Preview {
    NavigationStack {
        ClientOrderView()
            .environmentObject(MenuVM())
            .navigationBarBackButtonHidden()
    }
}

struct DishOrderCard: View {
    var dish: Dish
    @Binding var count: Int
    var showCountPicker: Bool = true
    
    var body: some View {
        HStack(spacing: 14) {
            AppetizerRemoteImage(urlString: dish.img.first?.imgUrl ?? "")
                .frame(width: 106, height: 106)
                .clipShape(.rect(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(dish.name)
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(1)
                    .frame(height: 18)
                
                Text("\(dish.price * count)")
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)
                    .frame(height: 19)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack {
                    Text("\(count) шт")
                        .font(.system(size: 16, weight: .bold))
                        .lineLimit(1)
                        .frame(height: 19)
                    Spacer()
                    if showCountPicker {
                        Stepper("", value: $count, in: 0...10)
                    }
                }
            }
            .padding(.vertical, 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
        .shadow(color: .black.opacity(0.05), radius: 30)
    }
}
