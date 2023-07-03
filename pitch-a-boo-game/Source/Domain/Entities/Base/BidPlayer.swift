//
//  BidPlayer.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 24/06/23.
//

import Foundation

struct BidPlayer: Hashable, Equatable {
    let id: Int
    let namePlayer: String
    let bidSent: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(namePlayer)
        hasher.combine(bidSent)
    }
    
    static func ==(lhs: BidPlayer, rhs: BidPlayer) -> Bool {
        return lhs.id == rhs.id &&
        lhs.namePlayer == rhs.namePlayer &&
        lhs.bidSent == rhs.bidSent
    }
}
