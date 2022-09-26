//
//  ContentView.swift
//  StickerPaste
//
//  Created by Charel Felten on 25/09/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var stickers : [UIImage] = []
    @State private var backgroundColor: Color = Color.white
    
    func pasteSticker() {
        if let image = UIPasteboard.general.image {
            stickers.append(image)
        } else {
            stickers.append(UIImage(systemName: "questionmark")!)
        }
    }
    
    func clearCollage() {
        stickers = []
    }
    
    func saveCollage() {
        let image = collageView.snapshot(viewSize: viewSize)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
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
    
    @State var viewSize: CGSize = CGSize(width: 0, height: 0)
    
    var collageView: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            ForEach(stickers, id: \.self) { sticker in
                StickerView(deleteSticker: deleteSticker, sticker: sticker)
            }
        }
        .readSize { newSize in
          print("The new child size is: \(newSize)")
            viewSize = newSize
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

extension View {
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image
    func snapshot(viewSize: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

//        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: viewSize)
//        view?.backgroundColor = .clear
        
        let targetSize = viewSize

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
