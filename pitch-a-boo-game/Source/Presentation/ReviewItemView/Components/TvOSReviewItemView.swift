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
    @State private(set) var degrees:Double = 180
    @State var colorCard = "ColorCard"
    @State var backColorCard = "ColorCard"
    @State var alpha:Double = 1
    @State var alpha2:Double = 0

    var body: some View {
        VStack {
            HStack{
                Circle().frame(width: 100, height: 100)
                Spacer()
                Circle().frame(width: 100, height: 100)
            }
            ZStack {
                NavigationLink(destination: ScoreView(), label: {
                    ZStack {
                        CardItem()
                            .opacity(alpha2)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(backColorCard)
                                .opacity(alpha))
                            .frame(width: 321.49, height: 523.57)
                    }
                }).buttonStyle(.card)
            }
            .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
            .onTapGesture {
                withAnimation(.easeInOut(duration: 2)) {
                    degrees = 360
                    withAnimation(.easeOut(duration: 5)) {
                        alpha = 0
                        alpha2 = 1
                    }
                }
            }
        }
    }
}
#endif