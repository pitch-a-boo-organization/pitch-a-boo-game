//
//  SaleResult.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct SaleResult: Codable {
    let item: Item
    let soldValue: Int
    let seller: Player
    let buyer: Player
}
