//
//  SheetView.swift
//  StickerPaste
//
//  Created by Charel Felten on 26/09/2022.
//

import SwiftUI

struct SheetView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject var storeManager: StoreManager
    
    let description = """
    StickerPaste is a minimal collage app which supports the new iOS 16 stickers. To copy a sticker, go to the Photos app, find a photo with a supported subject (such as a Person, animal, food or distinctive object) and long-press it to copy it. Alternatively, you can also copy a sticker sent to you in Messages or another app.
    
    Next, switch over to StickerPaste, and open the menu by taping the + button or long-pressing the background. Click on Paste Sticker to paste your sticker, or Enter text to enter text. You can paste multiple stickers, move them, rotate them, scale them and assemble your collage. Long-press a sticker to bring them forward or backward or delete them. Long-press a text sticker to edit the text. Share your work by opening the menu and clicking on Save Collage, or simply take a Screenshot.
    """.components(separatedBy: "\n")
    
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
                            
                            Text("Developed by [cfx.lu](https://cfx.lu)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.bottom)
                    
                    ZStack {
                        Color.yellow.opacity(0.05)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
                            )
                            .shadow(color: Color.yellow.opacity(1), radius: 20)
                        
                        VStack {
                            Text("✨ StickerPaste Pro ✨").font(.title2).fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 5)
                            Text("The Pro version allows to paste more than 5 stickers and supports the developer")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if let product = storeManager.myProducts.first {
                                if UserDefaults.standard.bool(forKey: product.productIdentifier) {
                                    Text("Purchased - Thank you!")
                                        .foregroundColor(.green)
                                        .padding(6)
                                } else {
                                    Button("Buy for \(product.price)") {
                                        print("clicked buy button")
                                        storeManager.purchaseProduct(product: product)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                            Button("Restore purchase") {
                                storeManager.restoreProducts()
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
                    Button("Close") {
                        dismiss()
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(storeManager: StoreManager())
    }
}
