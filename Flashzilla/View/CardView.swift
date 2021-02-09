//
//  CardView.swift
//  Flashzilla
//
//  Created by PRABALJIT WALIA     on 09/02/21.
//

import SwiftUI

struct CardView: View {
    let card:Card
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25,style: .continuous)
                .fill(Color(.white))
                .shadow(radius: 10)
            VStack{
                Text(card.prompt)
                    .font(.title)
                    .foregroundColor(.black)
                Text(card.answer)
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
