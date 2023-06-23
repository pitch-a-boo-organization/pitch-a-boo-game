//
//  EntryScreenViewModel.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 20/06/23.
//

import Foundation
import CoreImage.CIFilterBuiltins
import UIKit

class EntryScreenViewModel: ObservableObject {
    @Published var context = CIContext()
    @Published var filter = CIFilter.qrCodeGenerator()
    @Published private(set) var string: String = "Connection label"

    @Published private(set) var players: [String] = ["wilson", "cicero","thiago","lucas"]

    public func generateQRCode() -> UIImage? {

        filter.message = Data(self.string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
}

