//
//  SheetView.swift
//  StickerPaste
//
//  Created by Charel Felten on 26/09/2022.
//

let description = """
StickerPaste is a simple collage app which supports the new iOS 16 stickers. To copy a sticker, go to the Photos app, find a photo with a supported subject (such as a Person, animal, food or distinctive object) and long press it to copy it. Alternatively, you can also copy the whole Photo, or copy a sticker sent to you in Messages or another app.

Head over to StickerPaste, and long press the background or press the + button in the top right corner to paste your sticker. You can paste multiple stickers, move them, rotate them, scale them and assemble your collage. You can also add text to your collage. Once you are ready to share your work, take a Screenshot, crop the collage to your desired dimension, additionally add more text using the Screenshot tool and share your work with your friends and family!

StickerPaste is intentionally minimal in design and features to let users focus on their creativity and to serve as a proof of concept of what can be done with the new iOS 16 stickers. Future updates may include features such as advanced sticker modifications (background, outline, …), improved collage sharing, more extensive text editing and different sticker types.

The release schedule and content of future updates depends on the reception of the app. Please consider purchasing the Pro version if you like to support my work. (and want to use more stickers!)
""".components(separatedBy: "\n")

import SwiftUI

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack {
            ScrollView {
                
                VStack {
                    HStack {
                        Image(uiImage: UIImage(named: "HighResIcon") ?? UIImage())
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .padding(.trailing, 10)
                        
                        VStack {
                            Text("StickerPaste").font(.largeTitle).fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Developed by Charel Felten\nMore info at [cfx.lu](https://cfx.lu)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.bottom)
                    
                    ZStack {
                        Color.yellow.opacity( (colorScheme == .dark) ? 0.15 : 0.05)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
                            )
                            .shadow(color: Color.yellow.opacity(1), radius: 20)
                        VStack {
                            Text("✨StickerPaste Pro ✨").font(.title2).fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 5)
                            Text("The Pro version allows to paste more than 8 stickers and supports the developer.")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button("Buy Pro - 1.99$") {
                                // not implemented
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Restore purchases") {
                                // not implemented
                            }
                        }
                        .padding()
                    }
                    .padding(.bottom)
                    
                    
                    
                    ForEach(description, id: \.self) { substring in
                        Text(substring)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 5)
                    }
                }
                .padding()
            }
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView()
    }
}
