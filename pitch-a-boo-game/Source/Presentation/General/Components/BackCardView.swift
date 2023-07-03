//
//  BackCardView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 25/06/23.
//

import SwiftUI

struct BackCardView: View {
    @State var colorCard = "ColorCard"
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(colorCard))
            Image("LogoNegative")
                .resizable()
                .frame(width: 321, height: 283.11)
                .scaleEffect(x: 0.5, y: 0.5)
        }
        .frame(width: 321.49, height: 523.57)
    }
}
