//
//  ContentView2.swift
//  StickerPaste
//
//  Created by Charel Felten on 25/09/2022.
//

import SwiftUI

struct ContentView2: View {
    
    @State private var stickers : [UIImage] = []
    
    func pasteSticker() {
        if let image = UIPasteboard.general.image {
            stickers.append(image)
        } else {
            stickers.append(UIImage(systemName: "questionmark")!)
        }
    }
    
    func deleteSticker(_ id: UUID) {
        
//        for i in 0..<stickers.count {
//            if stickers[i].id == id {
//                stickers.remove(at: i)
//                break
//            }
//        }
        
    }
    
    var body: some View {

        ZStack {
            Color.white
            ForEach(stickers, id: \.self) { sticker in
                StickerView2(deleteSticker: deleteSticker, sticker: sticker)
            }
        }
        .contextMenu {
            Button {
                pasteSticker()
            } label: {
                Label("Paste Sticker", systemImage: "photo")
            }
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
