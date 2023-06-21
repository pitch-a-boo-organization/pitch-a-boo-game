//
//  ScoreView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct ScoreView: View {
    @ObservedObject var scoreViewModel = ScoreViewModel()
    var body: some View {
        Group {
            #if os(tvOS)
            tvOSScoreView()
            #endif
        }.environmentObject(scoreViewModel)
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
