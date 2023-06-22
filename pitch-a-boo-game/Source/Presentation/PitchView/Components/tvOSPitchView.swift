//
//  tvOSPitchView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct tvOSPitchView: View {
    @State var player: Int = 01

    @State var navigateToView = false
    var body: some View {
            VStack(spacing: 50) {
                Counter(countdown: 3,
                    timersUp: {
                        navigateToView = true
                        print(navigateToView)
                    }
                )

                .navigationDestination(isPresented: $navigateToView) {
                    ReviewItemView()
                }
                Spacer()
                Text("Player \(player) turn")
                    .font(.title)
                Spacer()
            }
    }
}

struct tvOSPitchView_Previews: PreviewProvider {
    static var previews: some View {
        tvOSPitchView()
    }
}
