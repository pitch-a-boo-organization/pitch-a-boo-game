//
//  TransferMessage.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct TransferMessage: Codable {
    let code: CommandCode
    let device: Device
    let message: Data
    
    func encodeToTransfer() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

enum Device: Int, Codable {
    case iOS = 1
    case tvOS = 2
    case coreOS = 3
}
