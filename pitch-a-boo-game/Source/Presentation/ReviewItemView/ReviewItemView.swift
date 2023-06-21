//
//  ReviewItemView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct ReviewItemView: View {
    @ObservedObject var reviewItemViewModel = ReviewItemViewModel()
    var body: some View {
        Group {
            #if os(tvOS)
            tvOSReviewItemView()
            #endif
        }.environmentObject(reviewItemViewModel)
    }
}

struct ReviewItemView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewItemView()
    }
}
