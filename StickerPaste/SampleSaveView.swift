//
//  SampleSaveView.swift
//  StickerPaste
//
//  Created by Charel Felten on 28/09/2022.
//

import SwiftUI

struct SampleSaveView: View {
    
    @State var screenshotMaker: ScreenshotMaker?
    
//    var saveView: some View {
//        ZStack() {
//            Color.clear
//            Rectangle()
//                .fill(Color.yellow)
//                .border(Color.green)
//                .frame(width: 40, height: 40)
//                .dr
//        }
//        .border(Color.red, width: 20)
////        .edgesIgnoringSafeArea(.all)
//    }
    
    var saveView: some View {
        SampleGestureView()
    }

        var body: some View {
            VStack {
                saveView
                .screenshotView { screenshotMaker in
                    self.screenshotMaker = screenshotMaker
                }
                Button("Save to image") {
                    if let screenshotMaker {
                        if let image = screenshotMaker.screenshot() {
                            print("save screenshot")
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    }
                    
                }
            }
        }
}

typealias ScreenshotMakerClosure = (ScreenshotMaker) -> Void

struct ScreenshotMakerView: UIViewRepresentable {
    let closure: ScreenshotMakerClosure

    init(_ closure: @escaping ScreenshotMakerClosure) {
        self.closure = closure
    }

    func makeUIView(context: Context) -> ScreenshotMaker {
        let view = ScreenshotMaker(frame: CGRect.zero)
        return view
    }

    func updateUIView(_ uiView: ScreenshotMaker, context: Context) {
        DispatchQueue.main.async {
            closure(uiView)
        }
    }
}

class ScreenshotMaker: UIView {
    /// Takes the screenshot of the superview of this superview
    /// - Returns: The UIImage with the screenshot of the view
    func screenshot() -> UIImage? {
        guard let containerView = self.superview?.superview,
              let containerSuperview = containerView.superview else { return nil }
        let renderer = UIGraphicsImageRenderer(bounds: containerView.frame)
        return renderer.image { (context) in
            containerSuperview.layer.render(in: context.cgContext)
        }
    }
}

extension View {
    func screenshotView(_ closure: @escaping ScreenshotMakerClosure) -> some View {
        let screenshotView = ScreenshotMakerView(closure)
        return overlay(screenshotView.allowsHitTesting(false))
    }
}



struct SampleSaveView_Previews: PreviewProvider {
    static var previews: some View {
        SampleSaveView()
    }
}


