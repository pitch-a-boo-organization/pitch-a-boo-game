//
//  tvOSPreparePitchView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct tvOSPreparePitchView: View {
    @State var player: Int = 01
    var body: some View {
        VStack(spacing: 50) {
            Counter()
            Spacer()
            Text("Player \(player) is thinking...")
                .font(.title)
            Spacer()
        }
    }
}

struct tvOSPreparePitchView_Previews: PreviewProvider {
    static var previews: some View {
        tvOSPreparePitchView()
    }
}
