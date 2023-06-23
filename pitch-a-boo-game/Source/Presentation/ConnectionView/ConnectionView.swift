//
//  ConnectionView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 15/06/23.
//

import SwiftUI

struct ConnectionView: View {
    @ObservedObject var tvOSViewModel = TvOSViewModel()
    @ObservedObject var iOSViewModel = IOSViewModel()
    
    var body: some View {
        Group {
            #if os(tvOS)
                TvOSConnectionView()
            #else
                iOSConnectionView()
            #endif
        }
        .environmentObject(iOSViewModel)
        .environmentObject(tvOSViewModel)
    }
}
