//
//  PlayersGrid.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct PlayersGrid: View {

    var players: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 206) {
            ForEach(0..<players.count) { index in
                EntryPlayers(index: index)
            }
        }
        .padding()
    }
}

struct PlayersGrid_Previews: PreviewProvider {
    static var previews: some View {
        let players = ["teste", "teste"]
        PlayersGrid(players: players)
    }
}