//
//  tvOSReviewItemView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct tvOSReviewItemView: View {
    var body: some View {
        VStack {
            HStack{
                Circle().frame(width: 100, height: 100)
                Spacer()
                Circle().frame(width: 100, height: 100)
            }
            NavigationLink(destination: ScoreView(), label: {
                CardItem()
            }).buttonStyle(.card)
        }
    }
}

struct tvOSReviewItemView_Previews: PreviewProvider {
    static var previews: some View {
        tvOSReviewItemView()
    }
}
