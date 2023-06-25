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
                EmptyView()
            }
    }
}
#endif
