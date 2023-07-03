//
//  tvOSReviewItemView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//
#if os(tvOS)
import SwiftUI

struct TvOSReviewItemView: View {
    @EnvironmentObject var tvReviewItemViewModel: TvOSViewModel
    @State var goToScoreView = false
    @State private(set) var frontRotationDegree:Double = 0
    @State private(set) var backRotationDegree:Double = 90
    @State var colorCard = "ColorCard"
    @State var backColorCard = "ColorCard"
    @State var alpha:Double = 1
    @State var alpha2:Double = 0
    @State var isRotated = true

    func flipCard() {
        isRotated.toggle()
        if isRotated {
            withAnimation(.linear(duration: 1.5)) {
                backRotationDegree = 90
            }
            withAnimation(.linear(duration: 1.5).delay(1.5)) {
                frontRotationDegree = 0
            }
        } else {
            withAnimation(.linear(duration: 1.5)) {
                frontRotationDegree = -90
            }
            withAnimation(.linear(duration: 1.5).delay(1.5)) {
                backRotationDegree = 0
            }
        }
    }
    
    var body: some View {
        ZStack {
            Image("GhostBackground")
                .resizable()
                .scaledToFill()
                .background(Color("ReviewItemBackground"))
                .ignoresSafeArea(.all)
            
            VStack {
                ZStack {
                    CardItem(
                        nameItem: tvReviewItemViewModel.sellingPlayer!.sellingItem.name,
                        numberOfCoins: tvReviewItemViewModel.sellingPlayer!.sellingItem.value
                    )
                    .rotation3DEffect(.degrees(backRotationDegree), axis: (0,1,0), perspective: 0.7)

                    BackCardView()
                        .rotation3DEffect(.degrees(frontRotationDegree), axis: (0,1,0), perspective: 0.7)
                        .frame(width: 321.49, height: 523.57)
                }
            }
            .onAppear {

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    flipCard()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    goToScoreView = true
                    tvReviewItemViewModel.sendStartStage(35)
                }
            }
            .navigationDestination(isPresented: $goToScoreView) {
                TvOSScoreView()
            }
        }
    }
}
#endif
