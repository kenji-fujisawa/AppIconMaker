//
//  SFSymbolView.swift
//  AppIconMaker
//
//  Created by uhimania on 2025/10/22.
//

import SwiftUI

class SFSymbolViewModel: ObservableObject {
    @Published var selected: String
    @Published var filter: String
    @Published var monochrome: Bool
    @Published var palette1: Color
    @Published var palette2: Color
    @Published var palette3: Color
    @Published var background: Color
    
    init(selected: String = "", filter: String = "", monochrome: Bool = true, palette1: Color = .black, palette2: Color = .black, palette3: Color = .black, background: Color = .clear) {
        self.selected = selected
        self.filter = filter
        self.monochrome = monochrome
        self.palette1 = palette1
        self.palette2 = palette2
        self.palette3 = palette3
        self.background = background
    }
}

struct SFSymbolView: View {
    @Binding var image: NSImage?
    @ObservedObject var model: SFSymbolViewModel
    private var symbolSource: [String] = []
    @State private var symbolNames: [String] = []
    
    init(image: Binding<NSImage?>, model: SFSymbolViewModel) {
        self._image = image
        self.model = model
        
        if let sfSymbolBundle = Bundle(identifier: "com.apple.SFSymbolsFramework"),
           let bundlePath = sfSymbolBundle.path(forResource: "CoreGlyphs", ofType: "bundle"),
           let bundle = Bundle(path: bundlePath),
           let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
           let dictionary = NSDictionary(contentsOfFile: resourcePath),
           let symbols = dictionary["symbols"] as? [String: String] {
            symbolSource = symbols.keys.sorted()
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                
                Image(systemName: model.selected)
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(model.palette1, model.palette2, model.palette3)
                    .background(model.background)
                    .frame(width: 100, height: 100)
                
                Spacer()
                
                Toggle("単色", isOn: $model.monochrome)
                    .toggleStyle(.switch)
                    .onChange(of: model.monochrome) { _, _ in
                        if model.monochrome {
                            model.palette2 = model.palette1
                            model.palette3 = model.palette1
                        }
                    }
                
                VStack(alignment: .trailing) {
                    ColorPicker("パレット 1", selection: $model.palette1)
                        .onChange(of: model.palette1) { _, _ in
                            updateImage()
                            if model.monochrome {
                                model.palette2 = model.palette1
                                model.palette3 = model.palette1
                            }
                        }
                    ColorPicker("パレット 2", selection: $model.palette2)
                        .onChange(of: model.palette2) { _, _ in
                            updateImage()
                            if model.monochrome {
                                model.palette1 = model.palette2
                                model.palette3 = model.palette2
                            }
                        }
                    ColorPicker("パレット 3", selection: $model.palette3)
                        .onChange(of: model.palette3) { _, _ in
                            updateImage()
                            if model.monochrome {
                                model.palette1 = model.palette3
                                model.palette2 = model.palette3
                            }
                        }
                    ColorPicker("背景色", selection: $model.background)
                        .onChange(of: model.background) { _, _ in
                            updateImage()
                        }
                }
                
                Button("リセット") {
                    model.monochrome = true
                    model.palette1 = .black
                    model.palette2 = .black
                    model.palette3 = .black
                    model.background = .clear
                }
            }
            
            VStack {
                TextField("Symbols", text: $model.filter)
                    .onChange(of: model.filter) { _, _ in
                        symbolNames = symbolSource.filter { model.filter.isEmpty ? true : $0.contains(model.filter) }
                    }
                
                List(symbolNames, id: \.self, selection: $model.selected) { symbol in
                    HStack {
                        Image(systemName: symbol)
                        Text(symbol)
                    }
                    .tag(symbol)
                }
                .onAppear() {
                    symbolNames = symbolSource.filter { model.filter.isEmpty ? true : $0.contains(model.filter) }
                }
                .onChange(of: model.selected) { _, _ in
                    updateImage()
                }
            }
        }
    }
    
    private func updateImage() {
        var config = NSImage.SymbolConfiguration(pointSize: 1024, weight: .regular)
        config = config.applying(.init(paletteColors: [NSColor(model.palette1), NSColor(model.palette2), NSColor(model.palette3)]))
        let img = NSImage(systemSymbolName: model.selected, accessibilityDescription: nil)
        image = img?.withSymbolConfiguration(config)
    }
}

#Preview {
    @Previewable @State var image: NSImage?
    let model = SFSymbolViewModel()
    SFSymbolView(image: $image, model: model)
}
