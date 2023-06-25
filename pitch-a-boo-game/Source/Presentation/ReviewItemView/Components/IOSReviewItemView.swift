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

    var body: some View {
        Text("Round results are being shown on TV!")
            .font(.title2)
            .bold()
        
    }
}
#endif
