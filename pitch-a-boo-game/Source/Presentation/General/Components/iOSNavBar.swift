//
//  iOSNavBar.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 26/06/23.
//

import SwiftUI

struct iOSNavBar: View {
    @State var imageName = "Werewolf"
    @State var name = "Teste"
    @State var bones = 5

    var body: some View {
        HStack {
            Image("Werewolf")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                HStack (spacing: 1){
                    Text("Name:")
                        .bold()
                    Text("\(name)")
                        .bold().foregroundColor(.red)

                }
                HStack (spacing: 1){
                    Text("Persona:")
                        .bold()
                    Text("\(imageName)")
                        .bold()
                        .foregroundColor(.red)
                }
                HStack (spacing: 1) {
                    Text("Bones: ")
                        .bold()
                    Text("\(bones) ")
                        .bold()
                }

            }

        }
    }
}

struct iOSNavBar_Previews: PreviewProvider {
    static var previews: some View {
        iOSNavBar()
    }
}
