//
//  IOSScoreView.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 25/06/23.
//

#if os(iOS)
import SwiftUI

struct IOSScoreView: View {
    var body: some View {
        ZStack{
            Image("GhostBackground")
                .resizable()
                .scaledToFill()
                .background(Color("ScoreBackground"))
                .ignoresSafeArea(.all)

            Text("Check your score on tv!")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .navigationBarBackButtonHidden(true)
        }
    }
}
#endif
