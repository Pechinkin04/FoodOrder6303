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
        }
    }
    
    func deleteDish(_ dish: Dish) async throws {
        do {
            // Удаление документа из Firestore
            try await db.collection("dishes").document(dish.id.uuidString).delete()
            
            // (Необязательно) Удаление изображений из Dropbox
            for image in dish.img {
                let successMessage = try await DropBoxSevice.shared.deleteFileFromDropboxUsingLink(sharedLink: image.imgUrl)
            }
        } catch {
            throw APError.deleteDishError
        }
    }

    
    func fetchClientAccount(login: String, password: String) async throws -> Client {
        let querySnapshot = try await db.collection("accounts")
            .whereField("login", isEqualTo: login)
            .whereField("password", isEqualTo: password)
            .getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            throw APError.invalidCredentials
        }
        
        do {
            let data = document.data()
            let client = try Firestore.Decoder().decode(Client.self, from: data)
            return client
        } catch {
            throw APError.invalidData
        }
    }

    func createClientAccount(_ client: Client) async throws {
        do {
            let encodedClient = try Firestore.Encoder().encode(client)
            try await db.collection("accounts").document(client.id.uuidString).setData(encodedClient)
        } catch {
            throw APError.accountCreationError
        }
    }

    func updateClientAccount(_ client: Client) async throws {
        do {
            let encodedClient = try Firestore.Encoder().encode(client)
            try await db.collection("accounts").document(client.id.uuidString).setData(encodedClient, merge: false)
        } catch {
            throw APError.accountUpdateError
        }
    }
    
    func deleteClientAccount(_ client: Client) async throws {
        do {
            try await db.collection("accounts").document(client.id.uuidString).delete()
        } catch {
            throw APError.accountDeletionError
        }
    }

}
