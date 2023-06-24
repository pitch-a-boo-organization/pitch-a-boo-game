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
    
    @State var navigateToView = false
    var body: some View {
        ZStack {
            Image("GhostBackground")
                .resizable()
                .scaledToFill()
                .background(Color("PitchBackground"))
                .ignoresSafeArea(.all)
            
            VStack(spacing: 50) {
                Counter(countdown: 4500,
                    timersUp: {
                        navigateToView = true
                    }
                )
                .navigationDestination(isPresented: $navigateToView) {
                    ReviewItemView()
                }
                Spacer()
                
                    Text("Player Fulano is presenting...")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                
//                if let player = pitchViewModel.sellingPlayer {
//                    Text("Player \(player.name) is presenting...")
//                        .font(.title)
//                }
                Spacer()
            }
            
            
        }
    }
}
#endif
