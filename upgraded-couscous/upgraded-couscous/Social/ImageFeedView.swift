//
//  ImageFeedView.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/25/24.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseAuth

struct ImageFeedView: View {
    @State var profile: Bool = false
    @Environment(\.displayScale) var scale
    @ObservedObject private var storage: FireStore = FireStore(imageUpload: ImageUpload(uploader: "", url: ""), imageUploads: [], status: false, response: "")
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                    }, label: {
                        Text("Back")
                    }).navigationDestination(isPresented: $profile, destination: { ProfileView().navigationBarBackButtonHidden(true) })
                    Spacer()
                }.padding()
                List(storage.imageUploads, id: \.url) {
                    image in
                    AsyncImage(url: URL(string: image.url), scale: scale)
                }
                
            }
        }.onAppear{
            storage.snapshotAllImages()
        }
    }
}

#Preview {
    ImageFeedView()
}
