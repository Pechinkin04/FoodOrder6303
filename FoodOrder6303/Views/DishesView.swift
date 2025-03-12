//
//  DishesView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 10.03.2025.
//

import SwiftUI

struct DishesView: View {
    @StateObject var dishVM = DishesVM()
    @State private var dishes: [Dish] = []
    
    @EnvironmentObject private var fsSerivce: FirestoreService
    
    var body: some View {
        NavigationStack {
            ZStack {
                info
                    .animation(.default, value: dishVM.dishes.count)
                
                    .navigationTitle("Delvel")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                AddEditDishView()
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
                
                LoadProgressView()
                    .opacity(fsSerivce.isLoad ? 1 : 0)
                    .animation(.spring, value: fsSerivce.isLoad)
            }
        }
        .onAppear {
            dishVM.fetchDishes()
        }
//        .refreshable {
//            fetchDishes()
//        }
//        .onAppear {
//            fetchDishes()
//        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(dishVM.dishes) { dish in
                    NavigationLink {
                        AddEditDishView(dish: dish, isNew: false)
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
                                
                                HStack(spacing: -4) {
                                    Image(systemName: "rublesign")
                                        .font(.system(size: 12, weight: .semibold))
                                        .frame(width: 24, height: 24)
                                    Text("\(dish.price)")
                                        .font(.system(size: 16, weight: .bold))
                                    
                                    Spacer()
                                }
                                .foregroundStyle(Color.textMain)
                            }
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
        }
    }
    
    private func fetchDishes() {
        DispatchQueue.main.async {
//            let fsService = FirestoreService()
            
            FirestoreService.shared.fetchAllDishes { result in
                switch result {
                    case .success(let dishes):
                        print("Получено \(dishes.count) блюд")
                        //                for dish in dishes {
                        //                    print(dish.name)  // Выводим имя каждого блюда
                        //                }
                        DispatchQueue.main.async {
                            self.dishes = dishes
                        }
                    case .failure(let error):
                        print("Ошибка при загрузке блюд: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    DishesView()
        .environmentObject(FirestoreService.shared)
}
