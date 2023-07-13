//
//  IOSReviewItemView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 25/06/23.
//

#if os(iOS)
import SwiftUI

struct IOSReviewItemView: View {
    var body: some View {
        ZStack{
            Image("GhostBackground")
                .resizable()
                .scaledToFill()
                .background(Color("ReviewItemBackground"))
                .ignoresSafeArea(.all)
            
            Text("Item are being reveal on TV!")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .navigationBarBackButtonHidden(true)
        }
    }
}
#endif
