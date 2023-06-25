//
//  BidView.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 24/06/23.
//
#if os(iOS)
import SwiftUI

struct BidView: View {
    var bidValue: Int
    var plusTapped: (() -> Void)?
    var minusTapped: (() -> Void)?
    var sendBidTapped: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 100) {
            Text("\(bidValue)")
              .font(
                Font.custom("SF Pro", size: 96)
                  .weight(.semibold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .frame(width: 62, height: 67, alignment: .center)
            
            HStack(spacing: 30) {
                Button {
                    minusTapped?()
                } label: {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .frame(width: 50, height: 50)
                        .background(Color("ColorCard"))
                        .clipShape(Circle())
                }
                
                Button {
                    plusTapped?()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .frame(width: 50, height: 50)
                        .background(Color("ColorCard"))
                        .clipShape(Circle())
                }
            }
            
            Button {
                sendBidTapped?()
            } label: {
                Text("Send Bid")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(height: 60)
                    .background(Color("ColorCard"))
                    .cornerRadius(10)
            }
        }
    }
}
#endif
