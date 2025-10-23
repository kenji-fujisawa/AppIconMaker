//
//  AppIconMakerApp.swift
//  AppIconMaker
//
//  Created by uhimania on 2025/10/21.
//

import SwiftUI

@main
struct AppIconMakerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(idealWidth: 100, idealHeight: 100)
                .onDisappear() {
                    NSApplication.shared.terminate(nil)
                }
        }
    }
}
