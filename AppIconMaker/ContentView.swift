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
        case androidStudio = "Android Studio"
        case mac = "macOS"
    }
    
    @State private var image: NSImage? = nil
    @State private var showExporter: Bool = false
    @State private var platform: Platform = .ios
    @StateObject private var symbolModel = SFSymbolViewModel()
    
    var body: some View {
        VStack {
            TabView {
                Tab("画像ファイル", systemImage: "photo") {
                    ImageView(image: $image)
                }
                Tab("SFシンボル", systemImage: "line.3.horizontal.decrease.circle") {
                    SFSymbolView(image: $image, model: symbolModel)
                }
            }
            
            HStack {
                Picker("Platform", selection: $platform) {
                    ForEach(Platform.allCases, id: \.self) { platform in
                        Text(platform.rawValue)
                    }
                }
                
                Button("アイコン作成") {
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
        case .androidStudio: exportAndroidStudioIcons(url: url)
        case .mac: exportMacosIcons(url: url)
        }
    }
    
    private func exportIosIcons(url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        
        do {
            let image = self.image?.fillBackground(NSColor(symbolModel.background)).cgImage
            try image?.resize(size: 40)?.data?.write(to: url.appendingPathComponent("Icon-20@2x.png"))
            try image?.resize(size: 60)?.data?.write(to: url.appendingPathComponent("Icon-20@3x.png"))
            try image?.resize(size: 58)?.data?.write(to: url.appendingPathComponent("Icon-29@2x.png"))
            try image?.resize(size: 87)?.data?.write(to: url.appendingPathComponent("Icon-29@3x.png"))
            try image?.resize(size: 76)?.data?.write(to: url.appendingPathComponent("Icon-38@2x.png"))
            try image?.resize(size: 114)?.data?.write(to: url.appendingPathComponent("Icon-38@3x.png"))
            try image?.resize(size: 80)?.data?.write(to: url.appendingPathComponent("Icon-40@2x.png"))
            try image?.resize(size: 120)?.data?.write(to: url.appendingPathComponent("Icon-40@3x.png"))
            try image?.resize(size: 120)?.data?.write(to: url.appendingPathComponent("Icon-60@2x.png"))
            try image?.resize(size: 180)?.data?.write(to: url.appendingPathComponent("Icon-60@3x.png"))
            try image?.resize(size: 128)?.data?.write(to: url.appendingPathComponent("Icon-64@2x.png"))
            try image?.resize(size: 192)?.data?.write(to: url.appendingPathComponent("Icon-64@3x.png"))
            try image?.resize(size: 136)?.data?.write(to: url.appendingPathComponent("Icon-68@2x.png"))
            try image?.resize(size: 152)?.data?.write(to: url.appendingPathComponent("Icon-76@2x.png"))
            try image?.resize(size: 167)?.data?.write(to: url.appendingPathComponent("Icon-83.5@2x.png"))
            try image?.resize(size: 1024)?.data?.write(to: url.appendingPathComponent("iTunesArtwork@2x.png"))
        } catch {
            print(error)
        }
        
        url.stopAccessingSecurityScopedResource()
    }
    
    private func exportAndroidIcons(url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        
        do {
            let fore = self.image?.cgImage?.resize(symbolSize: 66, imageSize: 108)
            let back = NSImage(size: NSSize(width: 108, height: 108)).fillBackground(NSColor(symbolModel.background)).cgImage
            
            try FileManager.default.createDirectory(at: url.appendingPathComponent("drawable", isDirectory: true), withIntermediateDirectories: true)
            try fore?.data?.write(to: url.appendingPathComponent("drawable/ic_launcher_foreground.png"))
            try back?.data?.write(to: url.appendingPathComponent("drawable/ic_launcher_background.png"))
            
            let image = self.image?.fillBackground(NSColor(symbolModel.background)).cgImage
            
            try FileManager.default.createDirectory(at: url.appendingPathComponent("mipmap-mdpi", isDirectory: true), withIntermediateDirectories: true)
            try image?.resize(size: 48)?.data?.write(to: url.appendingPathComponent("mipmap-mdpi/ic_launcher.png"))
            try image?.resize(size: 48)?.data?.write(to: url.appendingPathComponent("mipmap-mdpi/ic_launcher_round.png"))
            
            try FileManager.default.createDirectory(at: url.appendingPathComponent("mipmap-hdpi", isDirectory: true), withIntermediateDirectories: true)
            try image?.resize(size: 72)?.data?.write(to: url.appendingPathComponent("mipmap-hdpi/ic_launcher.png"))
            try image?.resize(size: 72)?.data?.write(to: url.appendingPathComponent("mipmap-hdpi/ic_launcher_round.png"))
            
            try FileManager.default.createDirectory(at: url.appendingPathComponent("mipmap-xhdpi", isDirectory: true), withIntermediateDirectories: true)
            try image?.resize(size: 96)?.data?.write(to: url.appendingPathComponent("mipmap-xhdpi/ic_launcher.png"))
            try image?.resize(size: 96)?.data?.write(to: url.appendingPathComponent("mipmap-xhdpi/ic_launcher_round.png"))
            
            try FileManager.default.createDirectory(at: url.appendingPathComponent("mipmap-xxhdpi", isDirectory: true), withIntermediateDirectories: true)
            try image?.resize(size: 144)?.data?.write(to: url.appendingPathComponent("mipmap-xxhdpi/ic_launcher.png"))
            try image?.resize(size: 144)?.data?.write(to: url.appendingPathComponent("mipmap-xxhdpi/ic_launcher_round.png"))
            
            try FileManager.default.createDirectory(at: url.appendingPathComponent("mipmap-xxxhdpi", isDirectory: true), withIntermediateDirectories: true)
            try image?.resize(size: 192)?.data?.write(to: url.appendingPathComponent("mipmap-xxxhdpi/ic_launcher.png"))
            try image?.resize(size: 192)?.data?.write(to: url.appendingPathComponent("mipmap-xxxhdpi/ic_launcher_round.png"))
            
            try image?.resize(size: 512)?.data?.write(to: url.appendingPathComponent("ic_launcher-playstore.png"))
        } catch {
            print(error)
        }
        
        url.stopAccessingSecurityScopedResource()
    }
    
    private func exportAndroidStudioIcons(url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        
        do {
            let fore = self.image?.cgImage?.resize(symbolSize: 625, imageSize: 1024)
            let back = NSImage(size: NSSize(width: 1024, height: 1024)).fillBackground(NSColor(symbolModel.background)).cgImage
            
            try fore?.data?.write(to: url.appendingPathComponent("ic_launcher_foreground.png"))
            try back?.data?.write(to: url.appendingPathComponent("ic_launcher_background.png"))
        } catch {
            print(error)
        }
        
        url.stopAccessingSecurityScopedResource()
    }
    
    private func exportMacosIcons(url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        
        do {
            let image = self.image?.fillBackground(NSColor(symbolModel.background)).cgImage
            try image?.resize(size: 16)?.data?.write(to: url.appendingPathComponent("Icon-16.png"))
            try image?.resize(size: 32)?.data?.write(to: url.appendingPathComponent("Icon-16@2x.png"))
            try image?.resize(size: 32)?.data?.write(to: url.appendingPathComponent("Icon-32.png"))
            try image?.resize(size: 64)?.data?.write(to: url.appendingPathComponent("Icon-32@2x.png"))
            try image?.resize(size: 128)?.data?.write(to: url.appendingPathComponent("Icon-128.png"))
            try image?.resize(size: 256)?.data?.write(to: url.appendingPathComponent("Icon-128@2x.png"))
            try image?.resize(size: 256)?.data?.write(to: url.appendingPathComponent("Icon-256.png"))
            try image?.resize(size: 512)?.data?.write(to: url.appendingPathComponent("Icon-256@2x.png"))
            try image?.resize(size: 512)?.data?.write(to: url.appendingPathComponent("Icon-512.png"))
            try image?.resize(size: 1024)?.data?.write(to: url.appendingPathComponent("Icon-512@2x.png"))
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
    
    func fillBackground(_ color: NSColor) -> NSImage {
        let newImage = NSImage(size: self.size)
        newImage.lockFocus()
        
        color.set()
        let rect = NSRect(origin: .zero, size: self.size)
        rect.fill()
        
        self.draw(in: rect)
        
        newImage.unlockFocus()
        return newImage
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
    
    func resize(symbolSize: CGFloat, imageSize: CGFloat) -> CGImage? {
        let originalWidth = CGFloat(self.width)
        let originalHeight = CGFloat(self.height)
        let scale = min(symbolSize / originalWidth, symbolSize / originalHeight)
        let newWidth = originalWidth * scale
        let newHeight = originalHeight * scale
        let offsetX = (imageSize - newWidth) / 2
        let offsetY = (imageSize - newHeight) / 2
        
        guard let context = CGContext(data: nil, width: Int(imageSize), height: Int(imageSize), bitsPerComponent: self.bitsPerComponent, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        context.interpolationQuality = .high
        context.clear(CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        context.draw(self, in: CGRect(x: offsetX, y: offsetY, width: newWidth, height: newHeight))
        
        return context.makeImage()
    }
}

#Preview {
    ContentView()
}
