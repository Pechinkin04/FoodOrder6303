//
//  FileMan.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 10.03.2025.
//


import Foundation
import UIKit

class FileMan {
    
    static let instance = FileMan()
    
    func saveImageToFileManager(image: UIImage) -> String? {
        // Преобразуем изображение в Data
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            // Получаем URL директории документов
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // Создаем уникальное имя файла с расширением .jpg
            let fileName = "\(image)_\(UUID().uuidString).jpg"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            do {
                // Сохраняем изображение в файл
                try imageData.write(to: fileURL)
                print("Изображение сохранено по пути: \(fileURL.path)")
                return fileName // Возвращаем имя файла
            } catch {
                print("Ошибка при сохранении изображения: \(error)")
                return nil
            }
        }
        return nil
    }
    
    func saveImageToFileManager(image: UIImage, withName: String) {
        // Преобразуем изображение в Data
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            // Получаем URL директории документов
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // Создаем уникальное имя файла с расширением .jpg
//            let fileName = "\(image)_\(UUID().uuidString).jpg"
            let fileName = withName
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            do {
                // Сохраняем изображение в файл
                try imageData.write(to: fileURL)
                print("Изображение сохранено по пути: \(fileURL.path)")
//                return fileName // Возвращаем имя файла
            } catch {
                print("Ошибка при сохранении изображения: \(error)")
//                return nil
            }
        }
//        return nil
    }
    
    func loadImageFromFileManager(fileName: String) -> UIImage? {
        // Получаем URL директории документов
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // Создаем полный путь к файлу
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // Проверяем, существует ли файл
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // Загружаем изображение из файла
            if let imageData = try? Data(contentsOf: fileURL) {
                return UIImage(data: imageData)
            }
        } else {
            print("Файл не найден: \(fileURL.path)")
        }
        return nil
    }
    
    func downloadImage(from urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            // Сохраняем изображение и вызываем completion с именем файла
            let fileName = self.saveImageToFileManager(image: image)
            DispatchQueue.main.async {
                completion(fileName)
            }
        }.resume()
    }

}
