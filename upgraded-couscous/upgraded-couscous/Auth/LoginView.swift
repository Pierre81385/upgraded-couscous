//
//  LoginView.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/11/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var toRegistration: Bool = false
    @State private var toProfile: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    
    @ObservedObject var auth = FireAuth(status: false, response: "")
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("LOGIN")
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
                    HStack {
                        Button("REGISTER", action: {
                            toRegistration = true
                        }).navigationDestination(isPresented: $toRegistration, destination: { RegistrationView().navigationBarBackButtonHidden(true) }) //change to login view
                        Button("SUBMIT", action: {
                            auth.SignInWithEmailAndPassword(email: email, password: password)
                            Auth.auth().addStateDidChangeListener { (auth, user) in
                                switch user {
                                case .none:
                                    print("USER NOT FOUND IN CHECK AUTH STATE")
                                case .some(let user):
                                    print("USER FOUND WITH ID: \(user.uid)")
                                    toProfile = true
                                }
                            }
                        }).navigationDestination(isPresented: $toProfile, destination: { ProfileView().navigationBarBackButtonHidden(true) }) 
                    }
                }
            }.onAppear{
                auth.SignOut()
            }
        }
    }
}
