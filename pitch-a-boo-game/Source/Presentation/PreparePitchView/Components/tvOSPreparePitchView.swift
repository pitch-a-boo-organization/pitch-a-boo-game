//
//  tvOSPreparePitchView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

#if os(tvOS)
import SwiftUI

struct tvOSPreparePitchView: View {
    @EnvironmentObject var prepareViewModel: TvOSViewModel
    @State var player: Int = 01
    @State var navigateToView = false
    
    var body: some View {
            VStack(spacing: 50) {
                Counter(countdown: 15,
                    timersUp: {
                        navigateToView = true
                    }
                )

                .navigationDestination(isPresented: $navigateToView) {
                    PitchView()
                }
                Spacer()
                if let name = prepareViewModel.sellingPlayer?.name {
                    Text("Player \(name) is preparing their apresentation...")
                        .font(.title)
                }
                Spacer()
            }
    }
}

struct tvOSPreparePitchView_Previews: PreviewProvider {
    static var previews: some View {
        tvOSPreparePitchView()
    }
}
#endif
