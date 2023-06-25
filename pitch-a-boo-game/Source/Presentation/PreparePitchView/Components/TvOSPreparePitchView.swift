//
//  tvOSPreparePitchView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

#if os(tvOS)
import SwiftUI

struct TvOSPreparePitchView: View {
    @EnvironmentObject var prepareViewModel: TvOSViewModel
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
                Counter(countdown: 15,
                        timersUp: {
                    navigateToView = true
                    prepareViewModel.sendStartStage(33)
                }
                )
                .navigationDestination(isPresented: $navigateToView) {
                    TvOSPitchView()
                }
                Spacer()
                if let name = prepareViewModel.sellingPlayer?.name {
                    Text("Player \(name) is preparing their apresentation...")
                        .foregroundColor(.black)
                        .font(.title)
                }
                Spacer()
            }
        }
    }
}
#endif
