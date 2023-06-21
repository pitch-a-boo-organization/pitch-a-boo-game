//
//  PlayerScore.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct PlayerScore: View {
    let name = "Zumbi"
    var body: some View {
        VStack {
            Text("\(name)")
                .font(.title3)
            Image("whiteTombstone")
                .resizable()
                .frame(width: 87,height: 87)
            HStack(spacing: 6) {
                Image("BoneCoin")
                    .resizable()
                    .frame(width: 58.25, height: 53.67)
                Text("5")
                    .bold()
                    .font(.title3)
            }
        }
    }
}

struct PlayerScore_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScore()
    }
}
