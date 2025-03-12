//
//  AddEditDishView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 10.03.2025.
//

import SwiftUI
import PhotosUI

struct AddEditDishView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fsService: FirestoreService
    
    private enum DishEditFocusedState {
        case name
        case composition
        case ccal
        case weight
        case price
    }
    
    @State var dish: Dish = Dish()
    var isNew: Bool = true
    var isDisabled: Bool {
        dish.name.isEmpty           ||
        dish.coomposition.isEmpty   ||
        dish.ccal == 0              ||
        dish.weight == 0            ||
        dish.price == 0
    }
    
    @FocusState private var focusedState: DishEditFocusedState?
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            info
            
            LoadProgressView()
                .opacity(fsService.isLoad ? 1 : 0)
                .animation(.spring, value: fsService.isLoad)
        }
        .onTapGesture {
            hideKeyboard()
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(isNew ? "Добавить блюдо" : "Изменить блюдо")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    upload()
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Сохранить")
                }
            }
        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                TextField("Ввести", text: $dish.name)
                    .embedInTextField(title: "Название", isSelected: focusedState == .name)
                    .focused($focusedState, equals: .name)
                    .onTapGesture { focusedState = .name }
                    .onSubmit { focusedState = .composition }
                
                imgs
                    .animation(.spring, value: dish.img.count)
                
                TextField("Ввести", text: $dish.coomposition, axis: .vertical)
                    .lineLimit(1...5)
                    .embedInTextField(title: "Состав", isSelected: focusedState == .composition)
                    .focused($focusedState, equals: .composition)
                    .onTapGesture { focusedState = .composition }
                    .onSubmit { focusedState = .ccal }
                
                HStack(spacing: 4) {
                    TextField("0", value: $dish.ccal, formatter: amountFormatter)
                    Text("ккал.")
                }
                    .keyboardType(.numbersAndPunctuation)
                    .embedInTextField(title: "Калорийность", isSelected: focusedState == .ccal)
                    .focused($focusedState, equals: .ccal)
                    .onTapGesture { focusedState = .ccal }
                    .onSubmit { focusedState = .weight }
                
                HStack(spacing: 4) {
                    TextField("0", value: $dish.weight, formatter: amountFormatter)
                    Text("гр.")
                }
                    .keyboardType(.numbersAndPunctuation)
                    .embedInTextField(title: "Вес", isSelected: focusedState == .weight)
                    .focused($focusedState, equals: .weight)
                    .onTapGesture { focusedState = .weight }
                    .onSubmit { focusedState = .price }
                
                HStack(spacing: 4) {
                    TextField("0", value: $dish.price, formatter: amountFormatter)
                    Image(systemName: "rublesign")
                }
                    .keyboardType(.numbersAndPunctuation)
                    .embedInTextField(title: "Цена", isSelected: focusedState == .price)
                    .focused($focusedState, equals: .price)
                    .onTapGesture { focusedState = .price }
                    .onSubmit { focusedState = nil }
                
                Menu {
                    ForEach(KitchenType.allCases) { kType in
                        Button {
                            dish.kitchenType = kType
                        } label: {
                            Text("\(kType.name) \(kType.emoji)")
                        }
                    }
                } label: {
                    HStack {
                        Text("\(dish.kitchenType.name) \(dish.kitchenType.emoji)")
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                    }
                    .embedInTextField(title: "Вид кухни")
                }
                
                Menu {
                    ForEach(DishType.allCases) { dType in
                        Button {
                            dish.dishType = dType
                        } label: {
                            Text("\(dType.name) \(dType.emoji)")
                        }
                    }
                } label: {
                    HStack {
                        Text("\(dish.dishType.name) \(dish.dishType.emoji)")
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                    }
                    .embedInTextField(title: "Тип блюда")
                }
            }
            .foregroundStyle(.textMain)
            .padding(16)
        }
    }
    
    
    @State private var newImages: [UIImage] = []
    @State var selectedItem: PhotosPickerItem? = nil
    private let wImg = UIScreen.main.bounds.width - 32
    private let hImg: CGFloat = 211
    
    var imgs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                // Отображение уже имеющихся на сервере
                ForEach(dish.img) { img in
                    ZStack {
                        AppetizerRemoteImage(urlString: img.imgUrl)
                            .frame(width: wImg, height: hImg)
                        
                        Button {
                            withAnimation {
//                                dish.img.removeAll(where: { $0.imgUrl == img.imgUrl })
                                DropBoxSevice.shared.deleteFileFromDropboxUsingLink(sharedLink: img.imgUrl) { result in
                                    switch result {
                                    case .success(let successMessage):
                                        print("✅ \(successMessage)")
                                            dish.img.removeAll(where: { $0.imgUrl == img.imgUrl })
                                            upload()
                                    case .failure(let error):
                                        print("❌ Ошибка удаления: \(error.localizedDescription)")
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(.red)
                                .frame(width: 44, height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.bgMain)
                                )
                                .shadow(color: .textMain.opacity(0.12), radius: 8, y: 2)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    }
                    .frame(width: wImg, height: hImg)
                    .background(Color.bgMain)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .textMain.opacity(0.12), radius: 8, y: 2)
                }
                
                // Отображение выбранных
                ForEach(newImages, id: \.self) { img in
                    ZStack {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: wImg, height: hImg)
                            .background(Color.bgMain)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .textMain.opacity(0.12), radius: 8, y: 2)
                        
                        Button {
                            withAnimation {
//                                dish.img.removeAll(where: { $0.imgUrl == img.imgUrl })
                                newImages.removeAll(where: { $0 == img })
                            }
                        } label: {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(.red)
                                .frame(width: 44, height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.bgMain)
                                )
                                .shadow(color: .textMain.opacity(0.12), radius: 8, y: 2)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    }
                }
                
                // Добавление нового изображения
//                @State var selectedItem: PhotosPickerItem? = nil
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    VStack(spacing: 8) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 22, weight: .medium))
                        Text("Добавить изображение")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundStyle(.bgMain.opacity(0.3))
                    .frame(width: wImg, height: hImg)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.prime)
                    )
                }
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            withAnimation {
                                newImages.append(uiImage)
                                selectedItem = nil
                            }
                        }
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
        .frame(height: 211)
    }
    
    private func upload() {
        fsService.uploadDish(dish, images: newImages) { result in
            switch result {
            case .success:
                print("Блюдо успешно загружено!")
            case .failure(let error):
                print("Ошибка загрузки: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddEditDishView()
            .environmentObject(FirestoreService.shared)
    }
}
