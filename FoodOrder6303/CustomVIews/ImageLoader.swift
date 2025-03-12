//
//  ImageLoader.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 10.03.2025.
//


import SwiftUI

final class ImageLoader: ObservableObject {
    
    @Published var image: Image? = nil
    
    func load(fromURLString urlString: String) {
        guard !urlString.isEmpty else {
            image = nil
            return
        }
        
        NetworkManager.shared.downloadImage(fromURLString: urlString) { uiImage in
            guard let uiImage else { return }
            DispatchQueue.main.async {
//                print("download from \(urlString)")
                self.image = Image(uiImage: uiImage)
            }
        }
    }
}


struct RemoteImage: View {
    
    var image: Image?
    
    var body: some View {
        //        image?.resizable() ?? Image("food-placeholder").resizable()
        ZStack {
            if let img = image {
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("food-placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .animation(.default, value: image)
    }
}


struct AppetizerRemoteImage: View {
    
    @StateObject private var imageLoader = ImageLoader()
    let urlString: String
    
    var body: some View {
        RemoteImage(image: imageLoader.image)
            .onAppear { imageLoader.load(fromURLString: urlString) }
            .onChange(of: urlString) {
                imageLoader.load(fromURLString: urlString)
            }
    }
}
