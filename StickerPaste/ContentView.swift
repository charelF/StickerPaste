//
//  ContentView.swift
//  StickerPaste
//
//  Created by Charel Felten on 24/09/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var stickers : [UIImage] = []
//    @State private var stickerZ: [Int]
    
    private func pasteImage() {
        if let image = UIPasteboard.general.image {
            stickers.append(image)
        } else {
            stickers.append(UIImage(systemName: "questionmark")!)
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
//                            .zIndex(<#T##value: Double##Double#>)
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
    
    @State var scale: CGFloat = 1
    
    @State var angle = Angle(degrees: 0.0)
    
    @State var zindex = 1
    
    init(sticker: UIImage) {
        self.sticker = sticker
        self.scale = sticker.scale
    }
    
    var rotationGesture: some Gesture {
        RotationGesture()
            .onChanged { angle in
                self.angle = angle
            }
    }
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { scale in
                print("zoom")
                self.scale = scale
            }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged({ (gesture) in
                print("drag")
                self.position = gesture.location
            })
    }
    
    var body: some View {
            Image(uiImage: sticker)
                .resizable()
                .position(position)
                .frame(alignment: .center)
                .hoverEffect()
                .rotationEffect(self.angle)
                .scaleEffect(scale)
                .frame(width: sticker.size.width/5, height: sticker.size.height/5)
                .gesture(
                    dragGesture
                    .simultaneously(with: rotationGesture)
                    .simultaneously(with: magnificationGesture)
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
