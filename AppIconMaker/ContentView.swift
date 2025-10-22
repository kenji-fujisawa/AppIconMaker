//
//  ContentView.swift
//  AppIconMaker
//
//  Created by uhimania on 2025/10/21.
//

import SwiftUI

struct ContentView: View {
    private enum Platform: String, CaseIterable {
        case ios = "iOS"
        case android = "Android"
        case mac = "macOS"
    }
    
    @State private var image: NSImage? = nil
    @State private var showImporter: Bool = false
    @State private var showExporter: Bool = false
    @State private var platform: Platform = .ios
    
    let maxWidth: CGFloat = 300
    let maxHeight: CGFloat = 300
    
    var body: some View {
        VStack {
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
            
            HStack {
                Picker("Platform", selection: $platform) {
                    ForEach(Platform.allCases, id: \.self) { platform in
                        Text(platform.rawValue)
                    }
                }
                
                Button("save") {
                    showExporter = true
                }
                .fileImporter(isPresented: $showExporter, allowedContentTypes: [.directory]) { result in
                    switch result {
                    case .success(let url):
                        exportIcons(url: url)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        .padding()
    }
    
    private func exportIcons(url: URL) {
        switch platform {
        case .ios: exportIosIcons(url: url)
        case .android: exportAndroidIcons(url: url)
        case .mac: exportMacosIcons(url: url)
        }
    }
    
    private func exportIosIcons(url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        
        do {
            try image?.cgImage?.resize(size: 40)?.data?.write(to: url.appendingPathComponent("Icon-20@2x.png"))
            try image?.cgImage?.resize(size: 60)?.data?.write(to: url.appendingPathComponent("Icon-20@3x.png"))
            try image?.cgImage?.resize(size: 58)?.data?.write(to: url.appendingPathComponent("Icon-29@2x.png"))
            try image?.cgImage?.resize(size: 87)?.data?.write(to: url.appendingPathComponent("Icon-29@3x.png"))
            try image?.cgImage?.resize(size: 76)?.data?.write(to: url.appendingPathComponent("Icon-38@2x.png"))
            try image?.cgImage?.resize(size: 114)?.data?.write(to: url.appendingPathComponent("Icon-38@3x.png"))
            try image?.cgImage?.resize(size: 80)?.data?.write(to: url.appendingPathComponent("Icon-40@2x.png"))
            try image?.cgImage?.resize(size: 120)?.data?.write(to: url.appendingPathComponent("Icon-40@3x.png"))
            try image?.cgImage?.resize(size: 120)?.data?.write(to: url.appendingPathComponent("Icon-60@2x.png"))
            try image?.cgImage?.resize(size: 180)?.data?.write(to: url.appendingPathComponent("Icon-60@3x.png"))
            try image?.cgImage?.resize(size: 128)?.data?.write(to: url.appendingPathComponent("Icon-64@2x.png"))
            try image?.cgImage?.resize(size: 192)?.data?.write(to: url.appendingPathComponent("Icon-64@3x.png"))
            try image?.cgImage?.resize(size: 136)?.data?.write(to: url.appendingPathComponent("Icon-68@2x.png"))
            try image?.cgImage?.resize(size: 152)?.data?.write(to: url.appendingPathComponent("Icon-76@2x.png"))
            try image?.cgImage?.resize(size: 167)?.data?.write(to: url.appendingPathComponent("Icon-83.5@2x.png"))
            try image?.cgImage?.resize(size: 1024)?.data?.write(to: url.appendingPathComponent("iTunesArtwork@2x.png"))
        } catch {
            print(error)
        }
        
        url.stopAccessingSecurityScopedResource()
    }
    
    private func exportAndroidIcons(url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        
        do {
            try FileManager.default.createDirectory(at: url.appendingPathComponent("mipmap-mdpi", isDirectory: true), withIntermediateDirectories: true)
            try image?.cgImage?.resize(size: 48)?.data?.write(to: url.appendingPathComponent("mipmap-mdpi/ic_launcher.png"))
            try image?.cgImage?.resize(size: 48)?.data?.write(to: url.appendingPathComponent("mipmap-mdpi/ic_launcher_round.png"))
            try image?.cgImage?.resize(size: 48)?.data?.write(to: url.appendingPathComponent("mipmap-mdpi/ic_launcher_foreground.png"))
            
            try FileManager.default.createDirectory(at: url.appendingPathComponent("mipmap-hdpi", isDirectory: true), withIntermediateDirectories: true)
            try image?.cgImage?.resize(size: 72)?.data?.write(to: url.appendingPathComponent("mipmap-hdpi/ic_launcher.png"))
            try image?.cgImage?.resize(size: 72)?.data?.write(to: url.appendingPathComponent("mipmap-hdpi/ic_launcher_round.png"))
            try image?.cgImage?.resize(size: 72)?.data?.write(to: url.appendingPathComponent("mipmap-hdpi/ic_launcher_foreground.png"))
            
            try FileManager.default.createDirectory(at: url.appendingPathComponent("mipmap-xhdpi", isDirectory: true), withIntermediateDirectories: true)
            try image?.cgImage?.resize(size: 96)?.data?.write(to: url.appendingPathComponent("mipmap-xhdpi/ic_launcher.png"))
            try image?.cgImage?.resize(size: 96)?.data?.write(to: url.appendingPathComponent("mipmap-xhdpi/ic_launcher_round.png"))
            try image?.cgImage?.resize(size: 96)?.data?.write(to: url.appendingPathComponent("mipmap-xhdpi/ic_launcher_foreground.png"))
            
            try FileManager.default.createDirectory(at: url.appendingPathComponent("mipmap-xxhdpi", isDirectory: true), withIntermediateDirectories: true)
            try image?.cgImage?.resize(size: 144)?.data?.write(to: url.appendingPathComponent("mipmap-xxhdpi/ic_launcher.png"))
            try image?.cgImage?.resize(size: 144)?.data?.write(to: url.appendingPathComponent("mipmap-xxhdpi/ic_launcher_round.png"))
            try image?.cgImage?.resize(size: 144)?.data?.write(to: url.appendingPathComponent("mipmap-xxhdpi/ic_launcher_foreground.png"))
            
            try FileManager.default.createDirectory(at: url.appendingPathComponent("mipmap-xxxhdpi", isDirectory: true), withIntermediateDirectories: true)
            try image?.cgImage?.resize(size: 192)?.data?.write(to: url.appendingPathComponent("mipmap-xxxhdpi/ic_launcher.png"))
            try image?.cgImage?.resize(size: 192)?.data?.write(to: url.appendingPathComponent("mipmap-xxxhdpi/ic_launcher_round.png"))
            try image?.cgImage?.resize(size: 192)?.data?.write(to: url.appendingPathComponent("mipmap-xxxhdpi/ic_launcher_foreground.png"))
            
            try image?.cgImage?.resize(size: 512)?.data?.write(to: url.appendingPathComponent("ic_launcher-playstore.png"))
        } catch {
            print(error)
        }
        
        url.stopAccessingSecurityScopedResource()
    }
    
    private func exportMacosIcons(url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        
        do {
            try image?.cgImage?.resize(size: 16)?.data?.write(to: url.appendingPathComponent("Icon-16.png"))
            try image?.cgImage?.resize(size: 32)?.data?.write(to: url.appendingPathComponent("Icon-16@2x.png"))
            try image?.cgImage?.resize(size: 32)?.data?.write(to: url.appendingPathComponent("Icon-32.png"))
            try image?.cgImage?.resize(size: 64)?.data?.write(to: url.appendingPathComponent("Icon-32@2x.png"))
            try image?.cgImage?.resize(size: 128)?.data?.write(to: url.appendingPathComponent("Icon-128.png"))
            try image?.cgImage?.resize(size: 256)?.data?.write(to: url.appendingPathComponent("Icon-128@2x.png"))
            try image?.cgImage?.resize(size: 256)?.data?.write(to: url.appendingPathComponent("Icon-256.png"))
            try image?.cgImage?.resize(size: 512)?.data?.write(to: url.appendingPathComponent("Icon-256@2x.png"))
            try image?.cgImage?.resize(size: 512)?.data?.write(to: url.appendingPathComponent("Icon-512.png"))
            try image?.cgImage?.resize(size: 1024)?.data?.write(to: url.appendingPathComponent("Icon-512@2x.png"))
        } catch {
            print(error)
        }
        
        url.stopAccessingSecurityScopedResource()
    }
}

extension NSImage {
    var cgImage: CGImage? {
        guard let imageData = self.tiffRepresentation else { return nil }
        guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
    }
}

extension CGImage {
    var data: Data? {
        let rep = NSBitmapImageRep(cgImage: self)
        return rep.representation(using: .png, properties: [:])
    }
    
    func resize(size: CGFloat) -> CGImage? {
        let originalWidth = CGFloat(self.width)
        let originalHeight = CGFloat(self.height)
        let scale = min(size / originalWidth, size / originalHeight)
        let newWidth = originalWidth * scale
        let newHeight = originalHeight * scale
        let offsetX = (size - newWidth) / 2
        let offsetY = (size - newHeight) / 2
        
        guard let context = CGContext(data: nil, width: Int(size), height: Int(size), bitsPerComponent: self.bitsPerComponent, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        context.interpolationQuality = .high
        context.clear(CGRect(x: 0, y: 0, width: size, height: size))
        context.draw(self, in: CGRect(x: offsetX, y: offsetY, width: newWidth, height: newHeight))
        
        return context.makeImage()
    }
}

#Preview {
    ContentView()
}
