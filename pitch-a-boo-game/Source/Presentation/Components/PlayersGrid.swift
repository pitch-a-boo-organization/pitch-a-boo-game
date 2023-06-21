//
//  PlayersGrid.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct PlayersGrid: View {

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 206) {
            ForEach(0..<4) { index in
                EntryPlayers(index: index)
            }
        }
        .padding()
    }
}

struct PlayersGrid_Previews: PreviewProvider {
    static var previews: some View {
        PlayersGrid()
    }
}
