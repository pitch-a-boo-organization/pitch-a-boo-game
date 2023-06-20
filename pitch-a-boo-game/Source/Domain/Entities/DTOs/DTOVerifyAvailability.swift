//
//  DTOVerifyAvailability.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct DTOVerifyAvailability: Codable {
    let stage: Int
    let available: Bool
}
















struct Player: Codable {
    let id: Int
    let name: String
}

struct Item: Codable {
    let id: Int
    let name: String
}

struct SaleResult: Codable {
    let winner: Player
    let price: Double
}

