//
//  FirestoreService.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 10.03.2025.
//


import Firebase
import FirebaseFirestore
import FirebaseStorage

class FirestoreService {
    static let shared = FirestoreService()
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private init() {}
    
    // Функция для загрузки изображений и записи блюда в Firestore
    func uploadDish(_ dish: Dish, images: [UIImage]) async throws {
        var uploadedImages: [ImageDish] = []
        
        for image in images {
            let url = try await DropBoxSevice.shared.uploadImageToDropbox(image, nameImg: "\(dish.id.uuidString)_\(UUID().uuidString)")
            uploadedImages.append(ImageDish(imgUrl: url))
        }
        
        var updatedDish = dish
        for uplImg in uploadedImages {
            updatedDish.img.append(uplImg)
        }
        
        do {
            let encodedDish = try Firestore.Encoder().encode(updatedDish)
            try await self.db.collection("dishes").document(dish.id.uuidString).setData(encodedDish)
        } catch {
            throw APError.uploadDishError
//            throw APError.requestFailed(error)
        }
    }
}
