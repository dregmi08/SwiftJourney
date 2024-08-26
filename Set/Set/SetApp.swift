//
//  SetApp.swift
//  Set
//
//  Created by Drishti Regmi on 8/5/24.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: SwiftViewModel())
        }
    }
}
