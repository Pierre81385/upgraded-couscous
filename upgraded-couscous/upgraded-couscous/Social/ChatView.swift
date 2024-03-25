//
//  ChatView.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/15/24.
//

import Foundation
import SwiftUI
import FirebaseAuth


struct ChatView: View {
    @State private var text: String = ""
    @State private var user: User?
    @State private var profile: Bool = false
    @State private var auth = FireAuth(status: false, response: "")
    @ObservedObject var messages = MessageModel(message: Message(sender: "", text: ""), messages: [], status: false, response: "")
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            profile = true
                        }, label: {
                            Text("Back")
                        }).navigationDestination(isPresented: $profile, destination: { ProfileView().navigationBarBackButtonHidden(true) })
                        Spacer()
                    }.padding()
                    List(messages.messages, id: \.timestamp) {
                        message in
                        if (message.sender == user?.email) {
                            SenderMessage(message: message)
                        } else {
                            MessageFeed(message: message)
                        }
                    }
                    .rotationEffect(.radians(.pi))
                    .scaleEffect(x: -1, y: 1, anchor: .center)
                    HStack {
                        TextField("...", text: $text)
                                            .accentColor(.black)
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled(true)
                        Button(action: {
                            messages.message.sender = (user?.email)!
                            messages.message.text = text
                            messages.createMessage()
                            text = ""
                        }, label: {
                            Text("SEND")
                        })
                    }.padding()
                }.onAppear{
                    messages.snapshotAllMessages()
                    user = auth.GetCurrentUser()
                }
            }
        }
    }
}


struct MessageFeed: View {
    var message: Message
    var body: some View {
            HStack {
                VStack.init(alignment: .leading) {
                    Text(message.sender).font(.headline)
                    Text(message.text)
                }.rotationEffect(.radians(.pi))
                    .scaleEffect(x: -1, y: 1, anchor: .center)
                Spacer()
            }.onAppear{
                //get sender information
            }
        }
}

struct SenderMessage: View {
    var message: Message
    var body: some View {
        HStack {
            Spacer()
            VStack.init(alignment: .trailing) {
                Text(message.sender).font(.headline)
                Text(message.text)
            }
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
        }.onAppear{
            //get sender information
        }
    }
}
