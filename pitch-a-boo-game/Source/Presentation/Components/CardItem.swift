//
//  CardItem.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct CardItem: View {

    @State var colorCard = "ColorCard"
    @State var colorFont = "ColorCard"
    @State var imageItem = "Pumpkin"
    @State var nameItem = "Name of item"
    @State var coinImageName = "BoneCoin"
    @State var numberOfCoins = "5"
    @State private var degrees = 180.0

    var body: some View {
        ZStack {

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(colorCard))

            VStack(spacing: 26) {
                HStack {
                    Spacer()
                    HStack (spacing: 1){
                        Text(numberOfCoins)
                            .bold()
                            .foregroundColor(.white)
                        Image(coinImageName)
                            .resizable()
                            .frame(width: 34.14, height: 32)
                    }.frame(maxWidth: 59.14, maxHeight: 32)
                        .padding(10)
                }
                    Text(nameItem)
                    .bold()
                    .padding(.horizontal, 30)
                    .foregroundColor(Color(colorFont))
                    .background() {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    }

                Circle()
                    .fill(.white)
                    .overlay {
                        Image(imageItem)
                            .resizable()
                            .frame(maxWidth: 150 ,maxHeight: 160)
                    }
                    .frame(width: 235.76, height: 235.75)
                Spacer()
                HStack {

                }
            }

        }
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
        .frame(width: 321.49, height: 523.57)
        .onAppear{
            withAnimation {
                withAnimation(Animation.linear(duration: 5)) {
                    degrees = 360
                }
            }
        }
    }
}

struct CardItem_Previews: PreviewProvider {
    static var previews: some View {
        CardItem()
    }
}
