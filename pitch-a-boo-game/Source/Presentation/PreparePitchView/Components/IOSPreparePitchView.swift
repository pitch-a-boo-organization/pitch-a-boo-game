//
//  IOSPreparePitchView.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import SwiftUI

struct IOSPreparePitchView: View {
    @EnvironmentObject var prepareViewModel: IOSViewModel
    
    var body: some View {
        if prepareViewModel.amIChosen == true {
            Text("Cara fui escolhido")
        } else {
            Text("Fui nada Lek")
        }
    }
}

struct IOSPreparePitchView_Previews: PreviewProvider {
    static var previews: some View {
        IOSPreparePitchView()
    }
}
