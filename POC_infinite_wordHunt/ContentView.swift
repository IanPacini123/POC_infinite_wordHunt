//
//  ContentView.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 04/07/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var wordViewModel: WordViewModel = .init()
    @State var selected: [String] = []
    
    @State var currentPoints = 0

    var body: some View {
        VStack {
            Text("Pontuação: \(currentPoints)")
                .font(.title)
                .bold()
            
            HStack {
                ForEach(wordViewModel.currentLetters) { column in
                    Grid {
                        ForEach(column.getAllValues(), id: \.id) { letterSquare in
                            LetterSquare(wordViewModel: wordViewModel,
                                         letterSquare: letterSquare)
                        }
                    }
                }
            }
            
            Button {
                if wordViewModel.checkWord(currentPoints: $currentPoints) {
                    print("Found word: \(wordViewModel.getWord())")
                } else {
                    print(wordViewModel.getWord())
                }
                
            } label: {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 200, height: 70)
                    .overlay {
                        Text("Send !")
                            .foregroundStyle(.white)
                            .font(.title)
                            .bold()
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
