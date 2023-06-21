//
//  PreparePitchView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 20/06/23.
//

import SwiftUI

struct PreparePitchView: View {
    var body: some View {
        #if os(tvOS)
        tvOSPreparePitchView()
        #endif
    }
}

struct PreparePitchView_Previews: PreviewProvider {
    static var previews: some View {
        PreparePitchView()
    }
}
