//
//  AboutUsView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.05.2025.
//

import SwiftUI

struct AboutUsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Сведения о разработчиках")
                        .font(.system(.largeTitle, weight: .black))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Самарский университет")
                        Text("Кафедра программных систем")
                        Text("Курсовой проект по дисциплине \"Программная инженерия\"")
                    }
                    .font(.system(.title2, weight: .medium))
                    
                    Text("Приложение для удаленного создания заказов в системе ресторана и контроля их исполнения")
                        .font(.system(.headline))
                    
                    Text("Разработчики - обучающиеся группы 6303-020302D")
                        .font(.system(.body, weight: .medium))
                    
                    Text("А.Н. Печинкин\nД.С. Старкова\nА.Д. Уланов\nА.В. Фролов")
                        .font(.system(.body, weight: .medium))
                    
                    Text("Самара 2025")
                        .font(.system(.title3, weight: .semibold))
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "xmark")
//                    }
//                }
//            }
        }
    }
}

#Preview {
    AboutUsView()
}
