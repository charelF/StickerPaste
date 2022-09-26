//
//  ContentView.swift
//  StickerPaste
//
//  Created by Charel Felten on 25/09/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var backgroundColor: Color = Color.white
    @State var stickerViews: [StickerView] = []
    @State var viewSize: CGSize = CGSize(width: 0, height: 0)
    
    func pasteSticker() {
        let image = UIPasteboard.general.image ?? UIImage(named: "BaseImage") ?? UIImage(systemName: "questionmark")!
        let stickerView = StickerView(deleteSticker: deleteSticker, moveSticker: moveSticker, sticker: image)
        stickerViews.append(stickerView)
    }
    
    func deleteSticker(_ stickerView: StickerView) {
        if let index = stickerViews.firstIndex(of: stickerView) {
            stickerViews.remove(at: index)
        }
    }
    
    func clearCollage() {
        stickerViews = []
    }
    
    func moveSticker(_ stickerView: StickerView, to zIndexMove: ZIndexMove) {
        // not implemented
    }
    
    func saveCollage() {
        // not implemented
    }
    
    var mainMenu: some View {
        Group {
            Button {
                pasteSticker()
            } label: {
                Label("Paste Sticker", systemImage: "doc.on.clipboard")
            }
            Button {
                clearCollage()
            } label: {
                Label("Clear Collage", systemImage: "eraser")
            }
//            Button {
//                saveCollage()
//            } label: {
//                Label("Save Collage", systemImage: "square.and.arrow.down.on.square")
//            }
            Menu("Background Color") {
                Picker(selection: $backgroundColor, label: Label("Background Color", systemImage: "photo")) {
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
    
    var collageView: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            ForEach(stickerViews, id: \.self) { stickerView in
                stickerView
            }
        }
    }
    
    var body: some View {
        NavigationView() {
            collageView
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu(content: {
                        mainMenu
                    }, label: {
                        ZStack {
                            Label("Add", systemImage: "plus.circle").foregroundColor((backgroundColor == Color.black) ? Color.white : Color.black)
                        }
                    })
                }
            }
            .contextMenu {
                mainMenu
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
