//
//  IOSScoreView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 25/06/23.
//

#if os(iOS)
import SwiftUI

struct IOSScoreView: View {
    @EnvironmentObject var iosScoreView: IOSViewModel
    @State var startNewRound = false
    
    var body: some View {
        Text("Check your score on tv!")
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
            .navigationDestination(isPresented: $startNewRound) {
                IOSPreparePitchView()
            }
            .onAppear {
               bindViewModel()
            }
    }
    
    func bindViewModel() {
        iosScoreView.$currentStage.sink { value in
            if value == 31 {
                startNewRound = true
                iosScoreView.cancellable.forEach { cancelable in
                    cancelable.cancel()
                }
            }
        }
        .store(in: &iosScoreView.cancellable)
    }
}
#endif
