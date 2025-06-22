//
//  EATFLUENCEiPadApp.swift
//  EATFLUENCEiPad
//
//  Created by Pasindu Jayasinghe on 6/21/25.
//

import SwiftUI

@main
struct EATFLUENCEiPadApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainSplitView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }

    }
}
