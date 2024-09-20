//
//  MemorizeFromScratchApp.swift
//  MemorizeFromScratch
//
//  Created by Drishti Regmi on 6/26/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var store = ThemeStore(name: "main")

    var body: some Scene {
        WindowGroup {
            ThemeStoreView()
                .environmentObject(store)
        }
    }
}
