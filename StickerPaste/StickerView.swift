//
//  StickerView.swift
//  StickerPaste
//
//  Created by Charel Felten on 25/09/2022.
//

import SwiftUI

struct StickerView: View, Hashable, Equatable {
    
    static func == (lhs: StickerView, rhs: StickerView) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    @State var previousScale: CGFloat = 1
    @State var newScale: CGFloat = 1
    @State var previousAngle: Angle = Angle(degrees: 0.0)
    @State var newAngle: Angle = Angle(degrees: 0.0)
    @State var previousPosition: CGPoint = CGPoint(x: 300, y: 300)
    @State var newPosition: CGPoint = CGPoint(x: 300, y: 300)
    @State var positionDifference: CGPoint = CGPoint(x: 0, y: 0)
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                newScale = previousScale * value
            }
            .onEnded { value in
                previousScale *= value
            }
    }
    
    var rotationGesture: some Gesture {
        RotationGesture()
            .onChanged { value in
                newAngle.degrees = previousAngle.degrees + value.degrees
            }
            .onEnded { value in
                previousAngle.degrees += value.degrees
            }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                positionDifference.x = value.startLocation.x - value.location.x
                positionDifference.y = value.startLocation.y - value.location.y
                newPosition.x = previousPosition.x - positionDifference.x
                newPosition.y = previousPosition.y - positionDifference.y
            }
            .onEnded { value in
                previousPosition = newPosition
            }
    }
    
    var deleteSticker: (StickerView) -> Void
    var moveSticker: (StickerView, ZIndexMove) -> Void
    var sticker: UIImage
    var width: CGFloat
    var height: CGFloat
    var id: UUID
    @State var zIndex: Double = 0
    
    init(deleteSticker: @escaping (StickerView) -> Void, moveSticker: @escaping (StickerView, ZIndexMove) -> Void, sticker: UIImage) {
        self.sticker = sticker
        self.width = sticker.size.width
        self.height = sticker.size.width
        self.deleteSticker = deleteSticker
        self.moveSticker = moveSticker
        self.id = UUID()
    }
    
    var mainMenu: some View {
        Group {
            Button {
                deleteSticker(self)
            } label: {
                Label("Delete Sticker", systemImage: "trash")
            }
            Button {
                self.zIndex += 1
            } label: {
                Label("Move Sticker Up", systemImage: "arrow.up")
            }
            Button {
                self.zIndex = max(self.zIndex - 1, 0)
            } label: {
                Label("Move Sticker Down", systemImage: "arrow.down")
            }
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
            Image(uiImage: sticker)
                .resizable()
            Text("\(zIndex)").foregroundColor(Color.red)
        }
        .frame(width: self.width, height: self.height, alignment: .center)
        .rotationEffect(newAngle)  // needs to be before scaleEffect
        .scaleEffect(newScale)
        .position(newPosition)
        .gesture(
            rotationGesture
                .simultaneously(with: magnificationGesture)
                .simultaneously(with: dragGesture)
        )
        .zIndex(zIndex)
        .contextMenu { mainMenu }
    }
}

enum ZIndexMove {
    case backward
    case forward
    case back
    case front
}

struct StickerView_Previews: PreviewProvider {
    static var previews: some View {
        StickerView(deleteSticker: {_ in ()}, moveSticker: {_,_ in ()}, sticker: UIImage(systemName: "questionmark")!)
    }
}
