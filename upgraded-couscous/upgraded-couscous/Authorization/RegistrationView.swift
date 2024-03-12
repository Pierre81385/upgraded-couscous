//
//  RegistrationView.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/11/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RegistrationView: View {
    
    @State private var back: Bool = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""
    @State private var isActive: Bool = false
    @State private var password: String = ""
    @State private var verifyPassword: String = ""
        
    @ObservedObject var auth = FireAuth(status: false, response: "")
    @ObservedObject var userProfile = UserProfile(userProfile: Profile(id: "", firstName: "", lastname: "", email: "", phone: 0, address: "", role: Role.none, isActive: false), status: false, response: "")
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("REGISTER")
                        .font(.largeTitle)
                    TextField("first name", text: $firstName)
                                        .accentColor(.black)
                                        .padding()
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                    TextField("last name", text: $lastName)
                                        .accentColor(.black)
                                        .padding()
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                    TextField("email address", text: $email)
                                        .accentColor(.black)
                                        .padding()
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                    TextField("phone number (numbers only)", text: $phone)
                                        .keyboardType(.numberPad)
                                        .accentColor(.black)
                                        .padding()
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                    TextField("address", text: $address)
                                        .accentColor(.black)
                                        .padding()
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                    SecureField("password", text: $password)
                                        .accentColor(.black)
                                        .padding()
                                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                        .autocorrectionDisabled(true)
                    SecureField("verify password", text: $verifyPassword)
                                        .accentColor(.black)
                                        .padding()
                                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                        .autocorrectionDisabled(true)
                    HStack {
                        Button("CANCEL", action: {
                            back = true
                        }).navigationDestination(isPresented: $back, destination: { RegistrationView().navigationBarBackButtonHidden(true) }) //change to login view
                        Button("SUBMIT", action: {
                            auth.CreateUser(email: email, password: password)
                            Auth.auth().addStateDidChangeListener { (auth, user) in
                                switch user {
                                case .none:
                                    print("USER NOT FOUND IN CHECK AUTH STATE")
                                case .some(let user):
                                    print("USER FOUND WITH ID: \(user.uid)")
                                    userProfile.userProfile.id = user.uid
                                    userProfile.userProfile.firstName = firstName
                                    userProfile.userProfile.lastname = lastName
                                    userProfile.userProfile.phone = Int(phone)!
                                    userProfile.userProfile.address = address.lowercased()
                                    userProfile.userProfile.isActive = true
                                    userProfile.creatUserProfile()
                                }
                            }
                        }).navigationDestination(isPresented: $userProfile.status, destination: { RegistrationView().navigationBarBackButtonHidden(true) }) //change to profile view
                    }
                }
            }
        }
    }
}

#Preview(body: {
    RegistrationView()
})
