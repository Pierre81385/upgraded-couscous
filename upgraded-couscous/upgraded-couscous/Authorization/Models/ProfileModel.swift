//
//  ProfileModel.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/11/24.
//

import Foundation
import FirebaseFirestore

enum Role {
    case Operator, Admin, User, Viewer, none
}

extension Role: Codable {}

struct Profile: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var firstName: String
    var lastname: String
    var email: String
    var phone: Int
    var address: String
    var role: Role
    var isActive: Bool
}

class UserProfile: ObservableObject {
    @Published var userProfile: Profile
    @Published var userProfiles = [Profile]()
    @Published var status: Bool
    @Published var response: String
    
    private var db = Firestore.firestore()
    
    init(userProfile: Profile, userProfiles: [Profile] = [Profile](), status: Bool, response: String) {
        self.userProfile = userProfile
        self.userProfiles = userProfiles
        self.status = status
        self.response = response
    }
    
    func creatUserProfile() {
        let collectionRef = db.collection("users")
      do {
          let newDocReference = try collectionRef.addDocument(from: self.userProfile)
          self.response = "Success!"
          self.status = true
      }
      catch {
          self.response = "Error: \(error.localizedDescription)"
          self.status = false
      }
    }
    
    func getUserProfile(){
        if let id = self.userProfile.id {
            let docRef = db.collection("users").document(id)
            docRef.getDocument { document, error in
                if let error = error as NSError? {
                    self.response = "Error: \(error.localizedDescription)"
                    self.status = false
                }
                else {
                    if let document = document {
                        do {
                            self.userProfile = try document.data(as: Profile.self)
                            self.response = "Success!"
                            self.status = true
                        }
                        catch {
                            self.response = "Error: \(error.localizedDescription)"
                            self.status = false
                        }
                    }
                }
            }
        }

        }
    
    func snapshotAllUserProfiless(){
         db.collection("users")
             .addSnapshotListener { querySnapshot, error in
                 guard let documents = querySnapshot?.documents else {
                     self.response = "Error: \(error!.localizedDescription)"
                     self.status = false
                     return
                 }
                 self.userProfiles = documents.compactMap { queryDocumentSnapshot -> Profile? in
                     return try? queryDocumentSnapshot.data(as: Profile.self)
                 }
                 self.response = "Success!"
                 self.status = true
             }
     }
    
    func updateUserProfile() {
        if let id = self.userProfile.id {
        let docRef = db.collection("users").document(id)
        do {
            try docRef.setData(from: self.userProfile)
            self.response = "Success!"
            self.status = true
        }
        catch {
            self.response = "Error: \(error.localizedDescription)"
            self.status = false
        }
      }
    }
    
    func deleteUserProfile() async {
        if let id = self.userProfile.id {
        let docRef = db.collection("users").document(id)
        
        do {
            try await docRef.delete()
            self.response = "Success!"
            self.status = true
            print("Document successfully removed!")
        } catch {
            self.response = "Error: \(error.localizedDescription)"
            self.status = false
        }
      }
    }
        
}
