//
//  RegistrationView.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/11/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    
    @State private var toLogin: Bool = false
    @State private var toProfile: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var verifyPassword: String = ""
        
    @ObservedObject var auth = FireAuth(status: false, response: "")
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("REGISTER")
                        .font(.largeTitle)
                    TextField("email address", text: $email)
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
                            toLogin = true
                        }).navigationDestination(isPresented: $toLogin, destination: { RegistrationView().navigationBarBackButtonHidden(true) }) //change to login view
                        Button("SUBMIT", action: {
                            auth.CreateUser(email: email, password: password)
                            Auth.auth().addStateDidChangeListener { (auth, user) in
                                switch user {
                                case .none:
                                    print("USER NOT FOUND IN CHECK AUTH STATE")
                                case .some(let user):
                                    print("USER FOUND WITH ID: \(user.uid)")
                                    toProfile = true
                                }
                            }
                        }).navigationDestination(isPresented: $toProfile, destination: { ProfileView().navigationBarBackButtonHidden(true) }) //change to profile view
                    }
                }
            }
        }
    }
}

#Preview(body: {
    RegistrationView()
})
