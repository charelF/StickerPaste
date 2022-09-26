//
//  ContentView2.swift
//  StickerPaste
//
//  Created by Charel Felten on 25/09/2022.
//

import SwiftUI

struct ContentView2: View {
    
    @State private var stickers : [UIImage] = []
    
    @State private var backgroundColor: Color = Color.white
    
    func pasteSticker() {
        if let image = UIPasteboard.general.image {
            stickers.append(image)
        } else {
            stickers.append(UIImage(systemName: "questionmark")!)
        }
    }
    
    func changeBackgroundColor() {
        
    }
    
    func deleteSticker(_ id: UUID) {
        
        //        for i in 0..<stickers.count {
        //            if stickers[i].id == id {
        //                stickers.remove(at: i)
        //                break
        //            }
        //        }
        
    }
    
    var mainMenu: some View {
        Group {
            Button {
                pasteSticker()
            } label: {
                Label("Paste Sticker", systemImage: "photo")
            }
            Button {
                deleteSticker(UUID())
            } label: {
                Label("Save Collage", systemImage: "square.and.arrow.down.on.square")
            }
            Menu("Background Color") {
                Picker(selection: $backgroundColor, label: Text("Background Color")) {
                    Text("White").tag(Color.white)
                    Text("Black").tag(Color.black)
                    Text("Red").tag(Color.red)
                    Text("Yellow").tag(Color.yellow)
                    Text("Green").tag(Color.green)
                    Text("Blue").tag(Color.blue)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView() {
            ZStack {
                backgroundColor
                ForEach(stickers, id: \.self) { sticker in
                    StickerView2(deleteSticker: deleteSticker, sticker: sticker)
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu(content: {
                        mainMenu
                    }, label: {
                        Label("Add", systemImage: "plus").foregroundColor(Color.black)
                    })
                }
            }
            .contextMenu {
                mainMenu
            }
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
