//
//  ImageLoader.swift
//  MeMo
//
//  Created by Irham Naufal on 20/10/23.
//

import SwiftUI

struct ImageLoader: View {
    
    var url: String
    var errorText: String = "Oops.. something went wrong :("
    var iconColor: Color = .purple1
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(4)
            } else if phase.error != nil {
                Color.gray1.opacity(0.3)
                    .overlay {
                        VStack(spacing: 18) {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(iconColor.opacity(0.5))
                                .frame(maxHeight: 90)
                                .overlay(alignment: .topTrailing) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 28, weight: .black))
                                        .foregroundColor(.red)
                                        .offset(x: 6, y: -6)
                                }
                            
                            Text(errorText)
                                .font(.robotoBody)
                                .foregroundColor(.black1)
                        }
                        .padding()
                    }
                    .frame(maxHeight: 250)
                    .cornerRadius(4)
            } else {
                Color.gray1.opacity(0.3)
                    .overlay {
                        ProgressView {
                            Text("Loading..")
                                .font(.robotoBody)
                                .foregroundColor(.black1)
                                .padding(4)
                        }
                        .padding()
                    }
                    .frame(maxHeight: 250)
                    .cornerRadius(4)
            }
        }
    }
}

#Preview {
    ImageLoader(url: "https://encrypted-tbn2.gstatic.com/licensed-image?q=tbn:ANd9GcQECcofBqRP28mn0enkKaT_F5diXcGAJwNIHIEWfDXjdaAf3VGaFu1HUX16GEcoH1st6b7arwTfjtfU3ak")
        .padding()
}
