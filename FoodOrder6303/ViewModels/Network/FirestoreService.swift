//
//  FirestoreService.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 10.03.2025.
//


import Firebase
import FirebaseFirestore
import FirebaseStorage

class FirestoreService: ObservableObject {
    static let shared = FirestoreService()
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    @Published var isLoad: Bool = false 
    
    private init() {}
    
    // Функция для загрузки изображений и записи блюда в Firestore
    func uploadDish(_ dish: Dish, images: [UIImage], completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            self.isLoad = true
        }
        var uploadedImages: [ImageDish] = []
        let dispatchGroup = DispatchGroup()
        
//        for image in images {
        for i in 0..<images.count {
            let image = images[i]
            dispatchGroup.enter()
            DropBoxSevice.shared.uploadImageToDropbox(image, nameImg: "\(dish.id.uuidString)_\(UUID().uuidString)") { result in
                switch result {
                case .success(let url):
                    uploadedImages.append(ImageDish(imgUrl: url))
                case .failure(let error):
                    print("Ошибка загрузки изображения: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            var updatedDish = dish
            updatedDish.img = uploadedImages
            self.isLoad = false
            do {
                let encodedDish = try Firestore.Encoder().encode(updatedDish)
                self.db.collection("dishes").document(dish.id.uuidString).setData(encodedDish) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    
    func fetchDish(by id: UUID, completion: @escaping (Result<Dish, Error>) -> Void) {
        let docRef = db.collection("dishes").document(id.uuidString)
        
        docRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let dish = try Firestore.Decoder().decode(Dish.self, from: data)
                completion(.success(dish))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchAllDishes(completion: @escaping (Result<[Dish], Error>) -> Void) {
        let dishesRef = db.collection("dishes")
        
        dishesRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: nil)))
                return
            }
            
            do {
                // Преобразуем каждый документ в объект типа Dish
                let dishes: [Dish] = try snapshot.documents.compactMap { document in
                    // Получаем данные из документа
                    let data = document.data()
                    
                    // Декодируем в объект типа Dish
                    let dish = try Firestore.Decoder().decode(Dish.self, from: data)
                    return dish
                }
                
                completion(.success(dishes))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
