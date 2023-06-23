//
//  PlayersGrid.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

#if os(tvOS)
struct PlayersGrid: View {
    var players: [Player]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 206) {
            ForEach(0..<players.count, id: \.self) { index in
                EntryPlayers(index: index)
            }
        }
        .padding()
    }
}
#endif
