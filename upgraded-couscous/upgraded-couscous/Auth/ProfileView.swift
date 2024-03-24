//
//  ProfileView.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/11/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var user: User?
    @State private var logout: Bool = false
    @State private var chat: Bool = false
    @ObservedObject var auth = FireAuth(status: false, response: "")
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                VStack {
                    Text(user?.uid ?? "Ooops something went wrong!")
                    Text(user?.email ?? "Logout to start over.")
                    HStack {
                        Button(action: {
                            auth.SignOut()
                            logout = true
                        }, label: {
                            Text("Logout")
                        }).navigationDestination(isPresented: $logout, destination: { LoginView().navigationBarBackButtonHidden(true) })
                        
                        Button(action: {
                            chat = true
                        }, label: {
                            Text("Chat")
                        }).navigationDestination(isPresented: $chat, destination: { ChatView().navigationBarBackButtonHidden(true) })
                    }.padding()
                }.onAppear {
                    user = auth.GetCurrentUser()
                }
            }
        }
    }
    }