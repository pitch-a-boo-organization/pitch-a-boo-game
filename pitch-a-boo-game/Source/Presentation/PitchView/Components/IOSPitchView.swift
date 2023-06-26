//
//  IOSPitchView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 24/06/23.
//

#if os(iOS)
import SwiftUI

struct IOSPitchView: View {
    @EnvironmentObject var iosPitchViewModel: IOSViewModel
    @State var confirmationDialog: Bool = false
    @State var bidSended: Bool = false
    @State var goToReviewItemView: Bool = false
    
    var body: some View {
        Group {
            if iosPitchViewModel.amIChosen {
                Text("Look to TV to know the remaing time of your apresentation!")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
            } else {
                VStack {
                    if !bidSended {
                        Text("Pay attention in presentation of player: \(iosPitchViewModel.chosenPlayer.player.name) \n Feel free to bid any value during the player's presentation")
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        BidView(
                            bidValue: iosPitchViewModel.playerBidValue,
                            plusTapped: iosPitchViewModel.plusBidValue,
                            minusTapped: iosPitchViewModel.minusBidValue,
                            sendBidTapped: { confirmationDialog = true }
                        )
                    } else {
                        Text("You have sended a bid for the presentation! Wait for inning result on TV")
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                    }
                }
            }
        }
        .onAppear { bindViewModel() }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToReviewItemView) {
            IOSReviewItemView()
        }
        .alert(isPresented: $confirmationDialog) {
            Alert(
                title: Text(
                "Are you sure you want to send the value of \(iosPitchViewModel.playerBidValue) to player \(iosPitchViewModel.chosenPlayer.player.name)?"
                ),
                primaryButton: .cancel(),
                secondaryButton: .default(
                    Text("Send"),
                    action: {
                        iosPitchViewModel.sendBid()
                        bidSended = true
                    }
              )
            )
        
        }
    }
    
    func bindViewModel() {
        iosPitchViewModel.$currentStage.sink { value in
            if value == 34 {
                if !bidSended && !iosPitchViewModel.amIChosen { iosPitchViewModel.sendBid() }
                goToReviewItemView = true
                iosPitchViewModel.cancellable.forEach { cancelable in
                    cancelable.cancel()
                }
            }
        }
        .store(in: &iosPitchViewModel.cancellable)
    }
}
#endif
