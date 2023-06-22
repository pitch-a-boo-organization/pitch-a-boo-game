//
//  tvOSScoreView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct tvOSScoreView: View {
    var players: [String] = [" "," "," "," "," "," "," "]

    func createGrid() -> [GridItem] {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        return columns
    }

    var body: some View {
        VStack(alignment: .center) {
            LazyVGrid(columns: createGrid()) {
                ForEach(0..<players.count) { index in
                    if index < 4 {
                           PlayerScore()
                       } else {
                           LazyVStack(alignment: .center) {
                               Spacer()
                               PlayerScore()
                               Spacer()
                           }
                    }
                }
            }
        }
    }
}

struct tvOSScoreView_Previews: PreviewProvider {
    static var previews: some View {
        let players:[String] = []
        tvOSScoreView(players: players)
    }
}
