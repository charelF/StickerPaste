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
    }
//        stickerView.zIndex += 1
        
//        print("stickerview argument \(stickerView.zIndex)")
        
//        if let index = stickerViews.firstIndex(of: stickerView) {
////            print("stickerviews index \(stickerViews[index].zIndex)")
//            stickerViews[index].zIndex += 1
////            print("stickerviews index after \(stickerViews[index].zIndex)")
//
//            var sV = stickerViews[index]
//            sV.zIndex += 1
//            stickerViews[index] = sV
//
//            print(sV.zIndex)
//        }
//
////        findElements(for: stickerView, in: stickerViews)
//
//        for sv in stickerViews {
//            print("sv index \(sv.zIndex)")
//        }
//
//    }
    
    
    private func findElements(for tsv: StickerView, in svs: [StickerView]) {
        for sv in svs.sorted(by: {sv1, sv2 in return sv1.zIndex > sv2.zIndex}) {
            print(sv.zIndex)
        }
    }
    
    func saveCollage() {
        let controller = UIHostingController(rootView: collageView)
        let view = controller.view
        view?.backgroundColor = .clear
        let renderer = UIGraphicsImageRenderer(size: viewSize)
//        view?.bounds = CGRect(origin: .zero, size: viewSize)
        view?.bounds = CGRect(x: viewSize.width/2, y: viewSize.height/2, width: viewSize.width, height: viewSize.height)
//        view?.boudns = CGRect(origin: ., size: <#T##CGSize#>)
        var image = renderer.image { _ in
//            view?.snapshotView(afterScreenUpdates: true)
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
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
        }
    }
    
    @State var viewSize: CGSize = CGSize(width: 0, height: 0)
    
    var collageView: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            ForEach(stickerViews, id: \.self) { stickerView in
                stickerView
            }
            GeometryReader { geo in
                
            }
        }
//        .readSize { newSize in
//          print("The new child size is: \(newSize)")
//            viewSize = newSize
//        }
        .coordinateSpace(name: "collageCoordinateSpace")
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
//          geometryProxy.origin
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
