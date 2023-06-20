//
//  TransferMessage.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation

struct TransferMessage: Codable {
    let type: MessageType
    let message: String
}
