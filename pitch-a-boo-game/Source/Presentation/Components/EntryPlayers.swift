//
//  EntryPlayers.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct EntryPlayers: View {
    @State private var imageStates: [Bool] = [false, true, true, false]
    var index:Int

    func toggleImageState(_ index: Int) {
        imageStates[index].toggle()
    }
    var body: some View {
        Image(imageStates[index] ? "whiteTombstone" : "tombstone")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 87, height: 86)
    }
}

struct EntryPlayers_Previews: PreviewProvider {
    static var previews: some View {
        EntryPlayers(index: 1).previewLayout(.sizeThatFits)
    }
}
