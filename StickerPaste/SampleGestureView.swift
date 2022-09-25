//
//  SampleGestureView.swift
//  StickerPaste
//
//  Created by Charel Felten on 25/09/2022.
//

import SwiftUI

struct SampleGestureView: View {
    
    @State var previousScale: CGFloat = 1
    @State var newScale: CGFloat = 1
    @State var previousAngle: Angle = Angle(degrees: 0.0)
    @State var newAngle: Angle = Angle(degrees: 0.0)
    @State var previousPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State var newPosition: CGPoint = CGPoint(x: 0, y: 0)
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
    
    
    
    var body: some View {
        VStack {
            Text("newScale \(newScale)")
            Text("newAngle \(newAngle.degrees)")
            Text("newPosition \(newPosition.x), \(newPosition.y)")
            Spacer()
            Rectangle()
                .fill(Color.red)
                .rotationEffect(newAngle)  // needs to be before scaleEffect
                .scaleEffect(newScale)
                .position(newPosition)
                .gesture(
                    rotationGesture
                        .simultaneously(with: magnificationGesture)
                        .simultaneously(with: dragGesture)
                )
            Spacer()
        }
        .background(Color.blue)
    }
}

struct SampleGestureView_Previews: PreviewProvider {
    static var previews: some View {
        SampleGestureView()
    }
}
