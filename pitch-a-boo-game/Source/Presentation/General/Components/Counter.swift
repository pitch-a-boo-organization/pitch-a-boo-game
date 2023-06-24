//
//  Counter.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 21/06/23.
//

import SwiftUI

struct Counter: View {

    @State var countdown: Int

    @State var timer: Timer? = nil
    var timersUp: (() -> Void)?

    var timeString: String {
        let minutes = countdown / 60
        let seconds = countdown % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startCountDown() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if countdown > 0 {
                    countdown -= 1
                } else {
                    timersUp?()
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
    }

    var body: some View {

        HStack {
            Image("TimeIcon")
                .resizable()
                .frame(maxWidth: 96.6, maxHeight: 153.04)
            VStack(alignment: .trailing) {
                Text("\(timeString)")
                    .bold()
                    .font(.system(size: 146.45))
            }
        }
        .onAppear{
            startCountDown()
        }

    }
}

struct Counter_Previews: PreviewProvider {
    static var previews: some View {
        var count = 1
        Counter(countdown: 1)
    }
}
