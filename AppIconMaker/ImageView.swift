//
//  ImageView.swift
//  AppIconMaker
//
//  Created by uhimania on 2025/10/22.
//

import SwiftUI

struct ImageView: View {
    @Binding var image: NSImage?
    @State private var showImporter: Bool = false
    
    let maxWidth: CGFloat = 300
    let maxHeight: CGFloat = 300
    
    var body: some View {
        Group {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                    .onTapGesture {
                        showImporter = true
                    }
            } else {
                Button {
                    showImporter = true
                } label: {
                    VStack {
                        Image(systemName: "plus.square.dashed")
                            .font(.largeTitle)
                        Text("画像ファイルを選択")
                            .font(.caption)
                    }
                }
                .buttonStyle(.borderless)
                .frame(width: maxWidth, height: maxHeight)
            }
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.png, .jpeg], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    guard url.startAccessingSecurityScopedResource() else { return }
                    image = NSImage(contentsOf: url)
                    url.stopAccessingSecurityScopedResource()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

#Preview {
    @Previewable @State var image: NSImage?
    ImageView(image: $image)
}
