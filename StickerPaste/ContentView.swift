//
//  ContentView.swift
//  StickerPaste
//
//  Created by Charel Felten on 24/09/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var stickers : [UIImage] = []
    
    private func pasteImage() {
        if let image = UIPasteboard.general.image {
            stickers.append(image)
        }
    }
    
    private func saveImage() {
        let image = self.body.snapshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    var body: some View {
        ZStack {
            Color.black
            ZStack {
                Color.white
                
                
                ZStack {
                    ForEach(stickers, id: \.self) {sticker in
                        StickerView(sticker: sticker)
                    }
                }
                
            }
            .contextMenu {
                Button {
                    pasteImage()
                } label: {
                    Label("Paste Sticker", systemImage: "photo")
                }
                Button {
                    saveImage()
                } label: {
                    Label("Save Collage", systemImage: "square.and.arrow.down.on.square")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct StickerView: View {
    
    @State private var position:CGPoint = CGPoint(x: 0, y: 0)
    
    private var sticker: UIImage
    
    @State var scale: CGFloat = 1.0
    
    init(sticker: UIImage) {
        self.sticker = sticker
    }
    
    var body: some View {
        Image(uiImage: sticker)
//        Rectangle()
            .resizable()
            .position(position)
            .frame(alignment: .center)
            .hoverEffect()
        
            .onTapGesture(coordinateSpace: .global) { location in
                    print("Tapped at \(location)")
                }
            .gesture(
                DragGesture()
                    .onChanged({ (gesture) in
                        position = gesture.location
                    })
//                    .onEnded({ (gesture) in
//                        position = gesture.location
//                    })
            )
           .scaleEffect(scale)
           .frame(width: 100, height: 100)
           .gesture(MagnificationGesture()
               .onChanged { value in
                   self.scale = value.magnitude
               }
           )
    }
}

extension View {
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
