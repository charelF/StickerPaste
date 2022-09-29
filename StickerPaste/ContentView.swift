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
    @State var showingSheet = false
    @State var takingScreenshot = false
    @StateObject var storeManager: StoreManager
    @State var screenshotMaker: ScreenshotMaker?
    
    var uiColor: Color { (backgroundColor == Color.black) ? Color.white : Color.black }
    var uiColorScheme: ColorScheme { (backgroundColor == Color.black) ? ColorScheme.dark : ColorScheme.light }
    
    func pasteSticker(stickerType: StickerType) {
        var isPro: Bool = false
        if let product = storeManager.myProducts.first {
            isPro = UserDefaults.standard.bool(forKey: product.productIdentifier)
        }
        guard (stickerViews.count <= 8) || isPro else {
            // user not allowed to post anymore stickers
            showingSheet = true
            return
        }
        let image = UIPasteboard.general.image ?? UIImage(named: "BaseImage") ?? UIImage(systemName: "questionmark")!
        let stickerView = StickerView(deleteSticker: deleteSticker, sticker: image, stickerType: stickerType)
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
    
    func saveCollage() {
        Task {
            takingScreenshot = true
            try? await Task.sleep(nanoseconds: 200_000_000)
            if let screenshotMaker {
                if let image = screenshotMaker.screenshot() {
                    print("save screenshot")
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            }
            takingScreenshot = false
        }
    }
    
    var mainMenu: some View {
        Group {
            Button {
                pasteSticker(stickerType: .imageSticker)
            } label: {
                Label("Paste Sticker", systemImage: "doc.on.clipboard")
            }
            Button {
                pasteSticker(stickerType: .textSticker)
            } label: {
                Label("Enter Text", systemImage: "character.cursor.ibeam")
            }
            Button {
                clearCollage()
            } label: {
                Label("Clear Collage", systemImage: "eraser")
            }
            Button {
                saveCollage()
            } label: {
                Label("Save Collage", systemImage: "square.and.arrow.down.on.square")
            }
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
            Button {
                showingSheet.toggle()
            } label: {
                Label("Info", systemImage: "info.circle")
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
                        if !takingScreenshot {
                            Menu(content: { mainMenu }, label: {
                                Label("Add", systemImage: "plus").foregroundColor(uiColor)
                            })
                        }
                    }
                }
                .contextMenu { mainMenu }
                .sheet(isPresented: $showingSheet) { SheetView(storeManager: storeManager) }
        }
        .preferredColorScheme(uiColorScheme)
        .screenshotView { screenshotMaker in
            self.screenshotMaker = screenshotMaker
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(storeManager: StoreManager())
    }
}
