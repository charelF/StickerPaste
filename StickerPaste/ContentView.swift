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
    
    private func pasteSticker() {
        if let image = UIPasteboard.general.image {
            stickers.append(image)
        } else {
            stickers.append(UIImage(systemName: "questionmark")!)
        }
    }
    
    private func deleteSticker(_ stickerID: UUID) {
        
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
//                            .on
                            .contextMenu {
                                Button {
                                    pasteSticker()
                                } label: {
                                    Label("Paste Sticker", systemImage: "photo")
                                }
                                Button {
                                    saveImage()
                                } label: {
                                    Label("Save Collage", systemImage: "square.and.arrow.down.on.square")
                                }
                                Button {
//                                    deleteSticker(sticker.id)
                                } label: {
                                    Label("Remove Sticker", systemImage: "trash")
                                }
                            }
//                            .zIndex(<#T##value: Double##Double#>)
                    }
                }
                
            }
            .contextMenu {
                Button {
                    pasteSticker()
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
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
    }
}

struct StickerView: View {
    
    @State var position: CGPoint
    @State var startLocation: CGPoint
    @State var initialDifference: CGPoint
    @State var isDraging: Bool = false
    @State var width: CGFloat
    @State var height: CGFloat
    @State var scale: CGFloat = 1
    @State var angle = Angle(degrees: 0.0)
    @State var zindex = 1
    
    private var sticker: UIImage
    var id: String
    
    init(sticker: UIImage) {
        self.sticker = sticker
        self.id = UUID().uuidString
        self.scale = sticker.scale
        self.position = CGPoint(x: 0, y: 0)
        self.startLocation = CGPoint(x: 0, y: 0)
        self.initialDifference = CGPoint(x: 0, y: 0)
        self.width = 200
        self.height = 200
    }
    
    var rotationGesture: some Gesture {
        RotationGesture()
            .onChanged { angle in
                print("RotationGesture \(angle)")
                self.angle = angle
            }
    }
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { scale in
                print("MagnificationGesture \(scale)")
                self.scale = scale
            }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                print("DragGesture START \(value)")
//                print(self.startLocation)
//                print(value.location)
//                print(value.startLocation)
                
                if !self.isDraging {
                    initialDifference.x = value.startLocation.x - self.position.x
                    initialDifference.y = value.startLocation.y - self.position.y
                    self.isDraging = true
                }
                
                self.position.x = value.location.x - initialDifference.x
                self.position.y = value.location.y - initialDifference.y
                
                print("initial difference \(self.initialDifference)")
                print("gesture start location \(value.startLocation)")
                print("position \(self.position)")
                
//                var touchToCenterDiff: CGPoint
//                touchToCenterDiff.x = value.startLocation.x - self.startLocation.x
//                touchToCenterDiff.y = value.startLocation.y - self.startLocation.y
//
//                var newPosition: CGPoint
//                newPosition.x = value.location -
                
                
                
                
//                self.position.x = self.position.x + value.location.x - value.startLocation.x
//                self.position.y = self.position.y + value.location.y - value.startLocation.y
//                value.startLocation
                
                
//                var diff: CGPoint
//                diff.x = = value.startLocation.first - self.startLocation.first
                
//                self.position = value.location
            }
            .onEnded { value in
                print("DragGesture END \(value)")
                self.startLocation = position
                self.isDraging = false
            }
    }
    
    var body: some View {
//            Image(uiImage: sticker)
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.1))
            Image(uiImage: sticker)
        }
//            .resizable()
                .position(position)
//                .frame(width: self.width, height: self.height, alignment: .center)
                .rotationEffect(self.angle)
                .scaleEffect(self.scale)
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
