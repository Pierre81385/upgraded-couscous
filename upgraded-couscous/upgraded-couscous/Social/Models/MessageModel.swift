//
//  MessageModel.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/15/24.
//

import Foundation
import FirebaseFirestore

struct Message: Codable, Equatable {
    var sender: String
    var text: String
    var timestamp: Double = Date().timeIntervalSince1970
}

class MessageModel: ObservableObject {
    @Published var message: Message
    @Published var messages = [Message]()
    @Published var status: Bool
    @Published var response: String
    
    init(message: Message, messages: [Message] = [Message](), status: Bool, response: String) {
        self.message = message
        self.messages = messages
        self.status = status
        self.response = response
    }
    
    private var db = Firestore.firestore()
    
    func createMessage() {
        let docRef = db.collection("messages").document()
        do {
            try docRef.setData(from: self.message)
            self.response = "Success!"
            self.status = true
        }
        catch {
            self.response = "Error: \(error.localizedDescription)"
            self.status = false
        }
    }
    
    func snapshotAllMessages(){
         db.collection("messages").order(by: "timestamp", descending: true)
             .addSnapshotListener { querySnapshot, error in
                 guard let documents = querySnapshot?.documents else {
                     self.response = "Error: \(error!.localizedDescription)"
                     self.status = false
                     return
                 }
                 self.messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                     return try? queryDocumentSnapshot.data(as: Message.self)
                 }
                 self.response = "Success!"
                 self.status = true
             }
     }
}
