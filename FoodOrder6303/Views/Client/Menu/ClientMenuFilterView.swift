//
//  ClientMenuFilterView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 21.04.2025.
//

import SwiftUI

struct ClientMenuFilterView: View {
    @EnvironmentObject var menuVM: MenuVM
    
    var body: some View {
        ZStack {
//            Color.white.opacity(0.8).ignoresSafeArea()
            info
            closeBtn
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.ultraThinMaterial)
    }
    
    var info: some View {
        VStack(alignment: .leading, spacing: 24) {
            Toggle("Сортировка по возрастанию", isOn: $menuVM.sortByUp)
                .toggleStyle(.switch)
            
            Menu {
                Button {
                    menuVM.kitchType = nil
                } label: {
                    Text("Без фильтра")
                }
                ForEach(KitchenType.allCases) { kitchenType in
                    Button {
                        menuVM.kitchType = kitchenType
                    } label: {
                        Text(kitchenType.name + " " + kitchenType.emoji)
                    }
                }
            } label: {
                ZStack {
                    if let kitchType = menuVM.kitchType {
                        Text(kitchType.emoji + " " + kitchType.name)
                            .foregroundStyle(.textMain)
                    } else {
                        Text("Выберите")
                            .foregroundStyle(.textMain.opacity(0.6))
                    }
                }
                .embedInTextField(title: "Кухня")
            }
            
            Menu {
                Button {
                    menuVM.dishType = nil
                } label: {
                    Text("Без фильтра")
                }
                ForEach(DishType.allCases) { dishType in
                    Button {
                        menuVM.dishType = dishType
                    } label: {
                        Text(dishType.name + " " + dishType.emoji)
                    }
                }
            } label: {
                ZStack {
                    if let dishType = menuVM.dishType {
                        Text(dishType.emoji + " " + dishType.name)
                            .foregroundStyle(.textMain)
                    } else {
                        Text("Выберите")
                            .foregroundStyle(.textMain.opacity(0.6))
                    }
                }
                .embedInTextField(title: "Тип блюда")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    var closeBtn: some View {
        Button {
            menuVM.showFilter = false
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.textMain)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(.white)
                )
                .shadow(color: .textMain.opacity(0.1), radius: 4)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

#Preview {
    ClientMenuFilterView()
        .environmentObject(MenuVM())
}
