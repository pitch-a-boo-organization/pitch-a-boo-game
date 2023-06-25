//
//  PlayersGrid.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI
import PitchABooServer

#if os(tvOS)
struct PlayersGrid: View {
    var players: [PitchABooServer.Player]
    @State private(set) var isVisible = false

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 36) {
            ForEach(0..<players.count, id: \.self) { index in
                EntryPlayers()
                    .scaleEffect(isVisible ? 1 : 0)
                    .onAppear {
                        withAnimation {
                            if !isVisible {
                                isVisible.toggle()
                            }
                        }
                    }
            }
        }
        .padding()
    }
}
#endif
