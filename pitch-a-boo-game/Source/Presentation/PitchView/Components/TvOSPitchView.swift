//
//  tvOSPitchView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

#if os(tvOS)
import SwiftUI

struct TvOSPitchView: View {
    @EnvironmentObject var pitchViewModel: TvOSViewModel
    @State var player: Int = 01

    @State var navigateToView = false
    var body: some View {
            VStack(spacing: 50) {
                Counter(countdown: 45,
                    timersUp: {
                        navigateToView = true
                    }
                )
                .navigationDestination(isPresented: $navigateToView) {
                    ReviewItemView()
                }
                Spacer()
                if let player = pitchViewModel.sellingPlayer {
                    Text("Player \(player.name) is presenting...")
                        .font(.title)
                }
                Spacer()
            }
    }
}
#endif
