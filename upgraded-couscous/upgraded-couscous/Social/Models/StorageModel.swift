//
//  UploadModel.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/25/24.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import PhotosUI

struct ImageUpload: Codable, Equatable {
    var uploader: String
    var url: String
}

class FireStore: ObservableObject {
    @Published var imageUpload: ImageUpload
    @Published var imageUploads = [ImageUpload]()
    @Published var status: Bool
    @Published var response: String
    
    init(imageUpload: ImageUpload, imageUploads: [ImageUpload] = [ImageUpload](), status: Bool, response: String) {
        self.imageUpload = imageUpload
        self.imageUploads = imageUploads
        self.status = status
        self.response = response
    }
    
    let storage = Storage.storage()
    private var db = Firestore.firestore()
    
    func uploadImage(uiImage: UIImage, user: User) {
        let storageRef = storage.reference().child("images/\(uiImage.hash)")
        let data = uiImage.jpegData(compressionQuality: 0.8)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        if let data = data {
            storageRef.putData(data, metadata: metadata) {
                (metadata, error) in
                    if let error = error {
                        self.response = String(describing: error.localizedDescription)
                        self.status = false
                    }
                
                if let metadata = metadata {
                    //self.response = String(describing: metadata)
                    self.status = true
                }
                
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                      // Uh-oh, an error occurred!
                      return
                    }
                    self.imageUpload.url = downloadURL.absoluteString
                    self.imageUpload.uploader = user.uid
                    self.saveImageURL()
                    self.response = downloadURL.absoluteString
                  }
                
            }
        }
        
    }
    
    func saveImageURL() {
        let docRef = db.collection("images").document()
        do {
            try docRef.setData(from: self.imageUpload)
            self.response = "Success!"
            self.status = true
        }
        catch {
            self.response = "Error: \(error.localizedDescription)"
            self.status = false
        }
    }
    
    func snapshotAllImages() {
         db.collection("images")
            .addSnapshotListener { querySnapshot, error in
                 guard let documents = querySnapshot?.documents else {
                     self.response = "Error: \(error!.localizedDescription)"
                     self.status = false
                     return
                 }
                 self.imageUploads = documents.compactMap { queryDocumentSnapshot -> ImageUpload? in
                     return try? queryDocumentSnapshot.data(as: ImageUpload.self)
                 }
                 self.response = "Success!"
                 self.status = true
             }
     }
    
}
