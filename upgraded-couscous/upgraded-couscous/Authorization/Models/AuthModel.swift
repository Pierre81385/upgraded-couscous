//
//  AuthModel.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/11/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FireAuth: ObservableObject {
    @Published var status: Bool
    @Published var response: String
    
    init(status: Bool, response: String) {
        self.status = status
        self.response = response
    }
    
    func CreateUser(email: String, password: String) {
          Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
              if error != nil {
                  self.status = false
                  self.response = error?.localizedDescription ?? ""
              } else {
                  self.status = true
                  self.response = "Successfully signed in!"
              }
          }
        }
    
    
    func GetCurrentUser() -> User {
        if Auth.auth().currentUser != nil {
            self.status = true
            self.response = "Found user uid: \(String(describing: Auth.auth().currentUser?.uid))"
            return Auth.auth().currentUser!
        } else {
            self.status = false
            self.response = "User not found!"
            return Auth.auth().currentUser!
        }
    }
    
    func SignInWithEmailAndPassword(email: String, password: String) {
        
               Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                   if error != nil {
                       self.status = false
                       self.response = error?.localizedDescription ?? ""
                   } else {
                       self.status = true
                       self.response = "Successfully signed in!"
                   }
               }
           
    }
    
    func SendEmailVerfication(){
        Auth.auth().currentUser?.sendEmailVerification { error in
            if error != nil {
                self.status = false
                self.response = error?.localizedDescription ?? ""
            } else {
                self.status = true
                self.response = "Email verification sent!"
            }
        }
    }
    
    func UpdateEmail(email: String) {
        Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email) { error in
            if error != nil {
                self.status = false
                self.response = error?.localizedDescription ?? ""
            } else {
                self.status = true
                self.response = "Email updated!"
            }
        }
    }
    
    func UpdatePassword(password: String) {
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            if error != nil {
                self.status = false
                self.response = error?.localizedDescription ?? ""
            } else {
                self.status = true
                self.response = "Password updated!"
            }
        }
    }
    
    func SendPasswordReset(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                self.status = false
                self.response = error?.localizedDescription ?? ""
            } else {
                self.status = true
                self.response = "Password reset sent to \(email)!"
            }
        }
    }
    
    func DeleteCurrentUser() {
        let user = Auth.auth().currentUser

        user?.delete { error in
            if error != nil {
                self.status = false
                self.response = error?.localizedDescription ?? ""
            } else {
                self.status = true
                self.response = "User deleted!"
            }
        }
    }
    
    func SignOut(){
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.status = true
            self.response = "Signed out!"
        } catch let signOutError as NSError {
            self.status = false
            self.response = signOutError.description
        }
    }
}
