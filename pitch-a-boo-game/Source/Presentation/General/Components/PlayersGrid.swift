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
    @State var scaleValue = 0

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 36) {
            ForEach(0..<players.count, id: \.self) { index in
                if index == players.count - 1 {
                    EntryPlayers()
                        .scaleEffect(isVisible ? 1 : 0)
                        .onAppear {
                            isVisible = false
                            withAnimation {
                                if !isVisible {
                                    isVisible.toggle()
                                }
                            }
                        }
                } else {
                    EntryPlayers()
                }

            }
        }
        .padding()
    }
}
#endif
