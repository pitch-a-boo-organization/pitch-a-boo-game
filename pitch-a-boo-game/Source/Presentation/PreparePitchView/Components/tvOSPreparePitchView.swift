//
//  tvOSPreparePitchView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct tvOSPreparePitchView: View {
    @State var player: Int = 01

    @State var navigateToView = false
    var body: some View {
            VStack(spacing: 50) {
                Counter(countdown: 2,
                    timersUp: {
                        navigateToView = true
                        print(navigateToView)
                    }
                )

                .navigationDestination(isPresented: $navigateToView) {
                    PitchView()
                }
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
