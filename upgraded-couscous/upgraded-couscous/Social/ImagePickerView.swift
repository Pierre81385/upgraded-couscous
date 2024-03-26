//
//  ImageView.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/23/24.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseAuth


struct ImagePickerView: View {
    @State private var user: User?
    @State private var profile: Bool = false
    @State private var selectToggle: Bool = true
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @ObservedObject private var storage: FireStore = FireStore(imageUpload: ImageUpload(uploader: "", url: ""), status: false, response: "")
    @State private var auth = FireAuth(status: false, response: "")
    
    var body: some View {
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
                Spacer()
                if let selectedImageData,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                   
                }
                Spacer()
                if (selectToggle) {
                    PhotosPicker(
                        selection: $selectedImage,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Image(systemName: "camera.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }.onChange(of: selectedImage, perform: {
                        newItem in
                        Task {
                            // Retrieve selected asset in the form of Data
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                                selectToggle = false
                            }
                        }
                    })
                    
                } else {
                    VStack {
                        Text("Image saved at: \(storage.response)")
                        HStack {
                            Button(action: {
                                selectToggle = true
                            }, label: { Text("Cancel")})
                            Button(action: {
                                let uiImage = UIImage(data: selectedImageData!)
                                storage.uploadImage(uiImage: uiImage!, user: user!)
                            }, label: {
                                Text("Save")
                            })
                        }
                    }
                }
                        
            }
        }.onAppear {
            user = auth.GetCurrentUser()
        }
    }
}

#Preview {
    ImagePickerView()
}
