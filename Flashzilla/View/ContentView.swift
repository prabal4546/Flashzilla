//
//  ContentView.swift
//  Flashzilla
//
//  Created by PRABALJIT WALIA     on 09/02/21.
//

import SwiftUI

struct ContentView: View {
    @State private var cards = [Card]()
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    @State private var showingEditScreen = false
    @State private var showingAlert = false
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isActive = true
    var body: some View {
        ZStack{
            Image(decorative:"background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                            Text("Time: \(timeRemaining)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(Color.black)
                                        .opacity(0.75)
                                )
             
                ZStack{
                    ForEach(0..<cards.count,id:\.self){
                        index in
                        CardView(card: self.cards[index]){
                                withAnimation{
                                    self.removeCard(at: index)
                                }
                        }
                        .stacked(at: index, in: self.cards.count)
                        .allowsHitTesting(index == self.cards.count-1)
                        .accessibility(hidden: index < self.cards.count - 1)
                        
                    }
                }
                .allowsHitTesting(timeRemaining>0)
                if cards.isEmpty{
                    Button("Start Again", action: resetCards )
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            VStack{
                HStack{
                    Spacer()
                    Button(action:{
                        self.showingEditScreen = true
                    }){
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
         
           
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()

                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer){time in
            guard self.isActive else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            if self.timeRemaining == 0{
                self.showingAlert = true
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Game Over"), message: Text("Time's Up"), dismissButton:Alert.Button.default(Text("Start Again")){
                self.resetCards()
            })
                }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
            self.isActive = false
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            
            if self.cards.isEmpty == false{
            self.isActive = true
            
           }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards){
            EditCards()
        }.onAppear(perform: resetCards)
        
    }
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    func resetCards(){
        isActive = true
        timeRemaining = 100
        loadData()
    }
    func loadData(){
        if let data = UserDefaults.standard.data(forKey: "Cards"){
            if let decoded = try? JSONDecoder().decode([Card].self, from: data){
                self.cards = decoded
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension View{
    func stacked(at position:Int, in total:Int)-> some View{
        
        let offset = CGFloat(total-position)
        return self.offset(CGSize(width: 0, height: offset*10))
        
    }
}
