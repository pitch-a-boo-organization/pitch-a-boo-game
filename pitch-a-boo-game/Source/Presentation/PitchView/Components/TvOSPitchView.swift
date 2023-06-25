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
    @State private var imageOffsets: [CGPoint] = Array(repeating: CGPoint.zero, count: 0)
    @State var navigateToView = false
    @State var starSplashRange: Int = 0
    
    let screenWidth = UIScreen.main.bounds.width*0.4
    let screenHeight = UIScreen.main.bounds.height*0.7
    
    var body: some View {
        ZStack {
            Image("GhostBackground")
                .resizable()
                .scaledToFill()
                .background(Color("PitchBackground"))
                .ignoresSafeArea(.all)

            HStack {
                Spacer()
                VStack {
                    Spacer()
                    CardBids()
                }
            }

            VStack(spacing: 50) {
                Counter(countdown: 30,
                    timersUp: {
                        navigateToView = true
                        pitchViewModel.sendStartStage(34)
                    }
                )
                .navigationDestination(isPresented: $navigateToView) {
                    TvOSReviewItemView()
                }
                Spacer()
                
                if let player = pitchViewModel.sellingPlayer {
                    Text("Player \(player.name) is presenting...")
                        .foregroundColor(.black)
                        .font(.title)
                }
                Spacer()
            }
            
            
        }.onAppear {
            bindOfBids()
        }
    }
    
    private func bindOfBids() {
        pitchViewModel.$bidPlayersSent.sink { bidPlayers in
            DispatchQueue.main.async {
                self.starSplashRange = bidPlayers.count
                self.imageOffsets =  Array(repeating: CGPoint.zero, count: starSplashRange)
            }
        }.store(in: &pitchViewModel.cancellable)
    }
}
#endif
