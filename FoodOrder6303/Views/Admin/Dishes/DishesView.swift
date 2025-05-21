//
//  DishesView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 10.03.2025.
//

import SwiftUI

struct DishesView: View {
    @StateObject var dishVM = DishesVM()
    
    private var fsSerivce = FirestoreService.shared
    
    @State private var dishPick: Dish?
    
    var body: some View {
        ZStack {
            NavigationStack {
                
                info
                    .animation(.default, value: dishVM.dishes.count)
                
                    .navigationTitle("Delvel")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                dishPick = Dish()
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            .opacity(dishVM.isLoad ? 0 : 1)
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
                
                    .navigationDestination(item: $dishPick, destination: { dish in
                        AddEditDishView(dish: dish, isNew: dish.name.isEmpty)
                            .environmentObject(dishVM)
                    })
                
                    .searchable(text: $dishVM.searchDish, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск блюда")
            }
            .onAppear {
                dishVM.fetchDishes()
            }
            
            .alert(item: $dishVM.alertItem) { alertItem in
                Alert(title:         alertItem.title,
                      message:       alertItem.message,
                      dismissButton: alertItem.btns)
            }
            
            .alert(item: $dishVM.delDishPick) { dish in
                Alert(title: Text("Удалить \(dish.name)?"),
                      primaryButton: .cancel(Text("Отмена")),
                      secondaryButton: .destructive(Text("Удалить"), action: {
                    dishVM.delDish()
                }))
            }
            
            LoadProgressView()
                .opacity(dishVM.isLoad ? 1 : 0)
                .animation(.spring, value: dishVM.isLoad)
        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(dishVM.dishFilter) { dish in
                    Button {
                        dishPick = dish
                    } label: {
                        HStack(spacing: 10) {
                            AppetizerRemoteImage(urlString: dish.img.first?.imgUrl ?? "")
                                .frame(width: 106, height: 106)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(dish.name)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.textMain)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                HStack(spacing: -4) {
                                    Image(systemName: "rublesign")
                                        .font(.system(size: 12, weight: .semibold))
                                        .frame(width: 24, height: 24)
                                    Text("\(dish.price)")
                                        .font(.system(size: 16, weight: .bold))
                                    
                                    Spacer()
                                    
                                    Button {
                                        dishVM.delDishPick = dish
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundStyle(.textMain)
                                            .padding(2)
                                    }
                                }
                                .foregroundStyle(Color.textMain)
                            }
                            .padding(.vertical, 16)
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.bgMain)
                                .shadow(color: .textMain.opacity(0.12), radius: 8, y: 2)
                        )
                    }
                }
            }
            .padding(16)
            .animation(.default, value: dishVM.dishes.count)
        }
    }
    
}

#Preview {
    DishesView()
}
