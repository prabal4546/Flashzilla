//
//  CardView.swift
//  Flashzilla
//
//  Created by PRABALJIT WALIA     on 09/02/21.
//

import SwiftUI

struct CardView: View {
    
    @State private var offset = CGSize.zero
    @State private var isShowingAnswer = false
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

    var removal: (() -> Void)? = nil
    let card:Card
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25,style: .continuous)
                .fill(
                    differentiateWithoutColor ? Color.white:Color.white
                    .opacity(1 - Double(abs(offset.width / 50)))
                )
                .shadow(radius: 10)
                .background(
                    differentiateWithoutColor ? nil:
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width>0 ? Color.green:Color.red)
                )
            VStack{
                Text(card.prompt)
                    .font(.title)
                    .foregroundColor(.black)
                if isShowingAnswer{
                    Text(card.answer)
                    .font(.title)
                    .foregroundColor(.gray)
}            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width/5)))
        .offset(x:offset.width*5,y:0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
        DragGesture()
            .onChanged {gesture in
                self.offset = gesture.translation
                
            }
            .onEnded{_ in
                if abs(self.offset.width) > 100 {
                    // remove the card
                    self.removal?()
                } else {
                    self.offset = .zero
                }
            }
        )
        .onTapGesture {
            self.isShowingAnswer.toggle()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
