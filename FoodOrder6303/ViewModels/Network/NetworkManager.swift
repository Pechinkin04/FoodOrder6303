//
//  NetworkManager.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 10.03.2025.
//


import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    static let baseURL = "https://seanallen-course-backend.herokuapp.com/swiftui-fundamentals/"
    private let appetizerURL = baseURL + "appetizers"
    
    private init() {}
    
//    func getAppetizers() async throws -> [Appetizer] {
//        guard let url = URL(string: appetizerURL) else {
//            throw APError.invalidURL
//        }
//        
//        let (data, _) = try await URLSession.shared.data(from: url)
//        
//        do {
//            let decoder = JSONDecoder()
//            return try decoder.decode(AppetizerResponse.self, from: data).request
//        } catch {
//            throw APError.invalidData
//        }
//    }
    
    
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void ) {
        
        var cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        
        if let url = URL(string: urlString) {
            let fileNameWithoutExtension = url.deletingPathExtension().lastPathComponent
            cacheKey = NSString(string: fileNameWithoutExtension)
            cacheKey = NSString(string: url.lastPathComponent)
//            print(cacheKey)
            if let image = cache.object(forKey: cacheKey) {
//                print("image found: \(cacheKey)")
                completed(image)
                return
            }
        }

        if let img = FileMan.instance.loadImageFromFileManager(fileName: cacheKey as String) {
            completed(img)
            return
        }
        
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            guard let data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
//            self.saveImageToDisk(image: image, key: cacheKey as String) // Сохраняем на диск
            FileMan.instance.saveImageToFileManager(image: image, withName: cacheKey as String)
            
            completed(image)
        }
        
        task.resume()
    }
}
