//
//  SheetView.swift
//  StickerPaste
//
//  Created by Charel Felten on 26/09/2022.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.dismiss) var dismiss

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
                            
                            Text("Developed by Charel Felten")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.bottom)
                    
                    Group {
                        
                        Text("This App is a simple collage where you can paste stickers or images and combine multiple stickers into a collage. ")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom)
                        Text("To copy an image, go to the Photos app, find an image that contains a detectable object such as a Person, then long press the object and you should be able to copy it. Copy it, and then paste it into StickerPaste. To share the finished collage, take a screenshot!")
                            .padding(.bottom)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("I developed this App in my free time - If you want to support me, buy the Pro version or offer me an iOS Developer position 😁 (More info: [cfx.lu](https://cfx.lu))")
                            .padding(.bottom)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    //
                    
                    Group {
                        Text("StickerPaste Pro").font(.title2).fontWeight(.bold)
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
                        .padding(.bottom)
                    }
                    
                    Group {
                        Text("StickerPaste Donation").font(.title2).fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 5)
                        Text("Additional donation to support the developer.\n**This does NOT unlock the Pro features!**")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button("Donation - 4.99$") {
                            // not implemented
                        }.buttonStyle(.bordered)
                            .padding(.bottom)
                    }
                    
                    Spacer()
                    
                    
                }
                .padding()
            }
            
//            Button("Close") {
//                dismiss()
//            }
//            .padding()
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView()
    }
}
