//
//  PitchView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct PitchView: View {
    @ObservedObject var pitchViewModel = PitchViewModel()
    var body: some View {
        Group {
            #if os(tvOS)
            tvOSPitchView()
            #endif
        }.environmentObject(pitchViewModel)
    }
}

struct PitchView_Previews: PreviewProvider {
    static var previews: some View {
        PitchView()
    }
}
