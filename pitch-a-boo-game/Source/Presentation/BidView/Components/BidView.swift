//
//  BidView.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 24/06/23.
//

import SwiftUI

struct BidView: View {
    @EnvironmentObject var bidViewModel: IOSViewModel
    
    var body: some View {
        VStack(spacing: 100) {
            Text("0")
              .font(
                Font.custom("SF Pro", size: 96)
                  .weight(.semibold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .frame(width: 62, height: 67, alignment: .center)
            
            HStack(spacing: 30) {
                Button {
                    bidViewModel.plusBidValue()
                } label: {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .frame(width: 60, height: 60)
                        .background(Color("ColorCard"))
                        .clipShape(Circle())
                }
                Button {
                    bidViewModel.minusBidValue()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .frame(width: 60, height: 60)
                        .background(Color("ColorCard"))
                        .clipShape(Circle())
                }
            }
           
        }
    }
}

struct BidView_Previews: PreviewProvider {
    static var previews: some View {
        BidView()
    }
}
