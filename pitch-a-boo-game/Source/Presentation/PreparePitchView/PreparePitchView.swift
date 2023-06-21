//
//  PreparePitchView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 20/06/23.
//

import SwiftUI

struct PreparePitchView: View {
    @ObservedObject var prepareViewModel = PreparePitchViewModel()
    var body: some View {
        Group {
            #if os(tvOS)
            tvOSPreparePitchView()
            #endif
        }.environmentObject(prepareViewModel)
    }
}

struct PreparePitchView_Previews: PreviewProvider {
    static var previews: some View {
        PreparePitchView()
    }
}
