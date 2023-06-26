//
//  IOSReviewItemView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 25/06/23.
//

#if os(iOS)
import SwiftUI

struct IOSReviewItemView: View {
    @EnvironmentObject var iOSReviewItemViewModel: IOSViewModel
    @State var goToScoreView: Bool = false

    var body: some View {
        Text("Item are being reveal on TV!")
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
            .navigationDestination(isPresented: $goToScoreView) {
                IOSScoreView()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                bindViewModel()
            }
    }
    
    func bindViewModel() {
        iOSReviewItemViewModel.$currentStage.sink { value in
            if value == 35 {
                goToScoreView = true
                iOSReviewItemViewModel.cancellable.forEach { cancelable in
                    cancelable.cancel()
                }
            }
        }
        .store(in: &iOSReviewItemViewModel.cancellable)
    }
}
#endif
