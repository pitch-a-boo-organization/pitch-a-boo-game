//
//  tvOSScoreView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

#if os(tvOS)
import SwiftUI
import PitchABooServer

struct TvOSScoreView: View {
    @EnvironmentObject var tvScoreViewModel: TvOSViewModel
    @State var showGameEnded = false
    @State var startNewRound = false
    
    var body: some View {

        ZStack {
            Image("GhostBackground")
                .resizable()
                .scaledToFill()
                .background(Color("ScoreBackground"))
                .ignoresSafeArea(.all)

            VStack(alignment: .center) {
                if showGameEnded {
                    Text("Game Ended!")
                        .font(.title2)
                        .foregroundColor(.black)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(12)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(tvScoreViewModel.players, id: \.id) { player in
                            PersonaScore(player: player)
                        }
                    }
                } else {

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(tvScoreViewModel.players, id: \.id) { player in
                            PlayerScore(player: player)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $startNewRound) {
                TvOSPreparePitchView()
            }
        }
        .onAppear {
            tvScoreViewModel.cleanBidArray()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                showGameEnded = tvScoreViewModel.gameEnded
                tvScoreViewModel.updatePlayers()
                if !tvScoreViewModel.gameEnded {
                    tvScoreViewModel.sendStartStage(31)
                    startNewRound = true
                }
            }
        }
    }
}
#endif
