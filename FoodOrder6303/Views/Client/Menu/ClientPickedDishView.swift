//
//  ClientPickedDishView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct ClientPickedDishView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var menuVM: MenuVM
    
    var dish: Dish
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            info
            addBtn
        }
        
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
            VStack(alignment: .leading, spacing: 18) {
                imgs
            
                Text(dish.name)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textMain)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(dish.dishType.name + dish.dishType.emoji)
                    Text(dish.kitchenType.name + dish.kitchenType.emoji)
                    
                    Text("Вес: \(dish.weight) гр")
                    Text("Калорийность: \(dish.ccal) кал")
                }
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.textMain)
                
                Text(dish.coomposition)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.bottom, 70)
        }
    }
    
    private let wImg = UIScreen.main.bounds.width - 32
    private let hImg: CGFloat = 211
    
    var imgs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                // Отображение уже имеющихся на сервере
                ForEach(dish.img) { img in
                    AppetizerRemoteImage(urlString: img.imgUrl)
                        .frame(width: wImg, height: hImg)
                        .frame(width: wImg, height: hImg)
                        .background(Color.bgMain)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .textMain.opacity(0.12), radius: 8, y: 2)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
        .frame(height: 211)
    }
    
    var addBtn: some View {
        Button {
            menuVM.order.dishes[dish] = (menuVM.order.dishes[dish] ?? 0) + 1
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("\(dish.price)")
                .font(.system(size: 15, weight: .semibold))
                .embedInButton(cornRadius: 12)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

#Preview {
    NavigationStack {
        ClientPickedDishView(dish: Dish())
            .environmentObject(MenuVM())
            .navigationBarBackButtonHidden()
    }
}
