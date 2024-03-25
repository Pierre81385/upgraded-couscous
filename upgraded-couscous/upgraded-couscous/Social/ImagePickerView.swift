//
//  ImageView.swift
//  upgraded-couscous
//
//  Created by m1_air on 3/23/24.
//

import Foundation
import SwiftUI
import PhotosUI


struct ImagePickerView: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        ZStack {
            VStack {
                if let selectedImageData,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                }
                
                PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()
                ) {
                    Image(systemName: "camera.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }.onChange(of: selectedItem, perform: {
                                newItem in
                                    Task {
                                        // Retrieve selected asset in the form of Data
                                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                            selectedImageData = data
                                            }
                                        }
                                    })
                            

                        
            }
        }
    }
}

#Preview {
    ImagePickerView()
}
