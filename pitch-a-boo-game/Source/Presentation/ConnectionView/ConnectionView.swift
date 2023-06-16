//
//  ConnectionView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 15/06/23.
//

import Foundation
import SwiftUI

struct ConnectionView: View {
    @ObservedObject var viewModel = ConnectionViewModel()
    
    var body: some View {
        Group {
            #if os(macOS)
                TvOSConnectionView()
            #else
                iOSConnectionView()
            #endif
        }
        .environmentObject(viewModel)
    }
}
