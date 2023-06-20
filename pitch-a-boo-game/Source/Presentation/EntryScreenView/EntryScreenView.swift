//
//  EntryScreenView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 20/06/23.
//

import SwiftUI

struct EntryScreenView: View {
    @ObservedObject var entryViewModel = EntryScreenViewModel()
    var body: some View {
        Group {
            #if os(tvOS)
            tvOSEntryScreenView()
            #endif
        }.environmentObject(entryViewModel)
    }
}


