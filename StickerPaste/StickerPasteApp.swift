//
//  StickerPasteApp.swift
//  StickerPaste
//
//  Created by Charel Felten on 24/09/2022.
//

import SwiftUI
import StoreKit

@main
struct StickerPasteApp: App {
    
    @StateObject var storeManager = StoreManager()
    
    let productIDs = [
            "lu.cfx.StickerPaste.IAP.proversion"
        ]
    
    var body: some Scene {
        WindowGroup {
            ContentView(storeManager: storeManager)
                .onAppear(perform: {
                    SKPaymentQueue.default().add(storeManager)
                    storeManager.getProducts(productIDs: productIDs)
                })
        }
    }
}
