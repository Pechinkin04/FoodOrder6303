//
//  LoadProgressView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 12.03.2025.
//

import SwiftUI

struct LoadProgressView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.4) // Масштабируем спиннер
                    .frame(width: 64, height: 64)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.4))
                    )
                    .tint(.white)
            }
        }
    }
}

#Preview {
    LoadProgressView()
}
