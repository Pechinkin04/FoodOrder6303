//
//  ClientMenuView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct ClientMenuView: View {
    @StateObject var menuVM: MenuVM
    
    @Binding var adresses: [Adress]
    
    private var fsSerivce = FirestoreService.shared
    
    @State private var dishPick: Dish?
    
    init(adresses: Binding<[Adress]>, fsSerivce: FirestoreService = FirestoreService.shared, dishPick: Dish? = nil) {
        self._adresses = adresses // передаём Binding правильно через _

        self.fsSerivce = fsSerivce
        self.dishPick = dishPick

        _menuVM = StateObject(wrappedValue: MenuVM(adresses: adresses.wrappedValue))
    }

    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    info
                        .animation(.default, value: menuVM.dishes.count)
                    
                    orderShow
                }
                
                    .navigationTitle("Delvel")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                menuVM.showFilter.toggle()
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            }
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
                        ClientPickedDishView(dish: dish)
                            .environmentObject(menuVM)
                            .navigationBarBackButtonHidden()
                    })
                
                    .searchable(text: $menuVM.searchDish, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск блюда")
            }
            
            .alert(item: $menuVM.alertItem) { alertItem in
                Alert(title:         alertItem.title,
                      message:       alertItem.message,
                      dismissButton: alertItem.btns)
            }
            
            if menuVM.showFilter {
                ClientMenuFilterView()
                    .environmentObject(menuVM)
            }
            
            LoadProgressView()
                .opacity(menuVM.isLoad ? 1 : 0)
        }
        .animation(.spring, value: menuVM.isLoad)
        .animation(.default, value: menuVM.showFilter)
        .animation(.default, value: menuVM.dishFilter.count)
        .animation(.default, value: menuVM.dishFilter.first)
        
        .onChange(of: adresses) { newValue in
            menuVM.adresses = newValue
        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(menuVM.dishFilter) { dish in
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
            .animation(.default, value: menuVM.dishes.count)
        }
    }
    
    var orderShow: some View {
        NavigationLink {
            ClientOrderView()
                .environmentObject(menuVM)
                .navigationBarBackButtonHidden()
        } label: {
            Image(systemName: "cart.fill")
                .foregroundStyle(.bgMain)
                .frame(width: 42, height: 42)
                .background(
                    Circle()
                        .fill(Color.prime)
                )
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .opacity(menuVM.order.dishes.count > 0 ? 1 : 0)
    }
}

#Preview {
    ClientMenuView(adresses: .constant([Adress(name: "example")]))
}
