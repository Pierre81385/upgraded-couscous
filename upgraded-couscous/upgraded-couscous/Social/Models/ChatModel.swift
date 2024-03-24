//
//  ChatModel.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/15/24.
//

import Foundation
import FirebaseFirestore


struct Chat: Codable, Equatable {
    @DocumentID var id: String? = UUID().uuidString
    var participants: [String]
    var messages: [Message]
    var isPrivate: Bool
}

class ChatModel: ObservableObject {
    @Published var chat: Chat
    @Published var chats = [Chat]()
    @Published var status: Bool
    @Published var response: String
    
    private var db = Firestore.firestore()

    init(chat: Chat, chats: [Chat] = [Chat](), status: Bool, response: String) {
        self.chat = chat
        self.chats = chats
        self.status = status
        self.response = response
    }
    
    func createChat() {
        let docRef = db.collection("chats").document()
        self.chat.id = docRef.documentID
        do {
            try docRef.setData(from: self.chat)
            self.response = "Success!"
            self.status = true
        }
        catch {
            self.response = "Error: \(error.localizedDescription)"
            self.status = false
        }
    }
    
    func getChat(id: String) {
        let docRef = db.collection("chats").document(id)
        docRef.getDocument(as: Chat.self) { result in
          switch result {
          case .success(let chat):
            self.chat = chat
              self.response = "Success!"
              self.status = true
          case .failure(let error):
              self.response = "Error: \(error.localizedDescription)"
              self.status = false
          }
        }
    }
    
    func snapshotAllChats(){
         db.collection("chats")
             .addSnapshotListener { querySnapshot, error in
                 guard let documents = querySnapshot?.documents else {
                     self.response = "Error: \(error!.localizedDescription)"
                     self.status = false
                     return
                 }
                 self.chats = documents.compactMap { queryDocumentSnapshot -> Chat? in
                     return try? queryDocumentSnapshot.data(as: Chat.self)
                 }
                 self.response = "Success!"
                 self.status = true
             }
     }
    
    func updateChat(id: String) {
        let docRef = db.collection("chats").document(id)
        do {
            try docRef.setData(from: self.chat)
            self.response = "Success!"
            self.status = true
        }
        catch {
            self.response = "Error: \(error.localizedDescription)"
            self.status = false
        }
    }
    
    func deleteChat(id: String) async {
        let docRef = db.collection("chats").document(id)
        do {
            try await docRef.delete()
            self.response = "Success!"
            self.status = true
        } catch {
            self.response = "Error: \(error.localizedDescription)"
            self.status = false
        }
      }
    
    func addParticipant(id: String){
        let docRef = db.collection("chats").document(id)
            docRef.updateData([
                "participants": FieldValue.arrayUnion([id])
            ])
    }
    
    func removeParticipant(id: String) {
        let docRef = db.collection("chats").document(id)
        docRef.updateData([
                    "participants": FieldValue.arrayRemove([id])
                  ])
    }
    
    func addMessage(id: String, message: Message) {
        let docRef = db.collection("chats").document(id)
        docRef.updateData([
                  "messages": FieldValue.arrayUnion([message])
                ])
    }
    
    func removeMessage(id: String, message: Message) {
        let docRef = db.collection("chats").document(id)
        docRef.updateData([
                    "messages": FieldValue.arrayRemove([message])
                  ])
    }
    
}



