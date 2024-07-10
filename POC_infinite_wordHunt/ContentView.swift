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
    
    @State var timerManager = TimerManager(initialTime: 30)
    @State var currentPoints = 0

    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    Text("Pontuação: \(currentPoints)")
                    
                    Spacer()
                    
                    VStack(alignment: .trailing){
                        Text("Tempo restante:")
                        Text("\(timerManager.timeRemaining.formatted(.number))")
                    }
                }
                .font(.title3)
                .bold()
                .padding(.horizontal, 10)
                
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
                .padding(.bottom)
                
                Button {
                    wordViewModel.checkWord(currentPoints: $currentPoints, currentTime: $timerManager.timeRemaining)
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
                
                Button {
                    wordViewModel.clear()
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 200, height: 70)
                        .overlay {
                            Text("Clear")
                                .foregroundStyle(.white)
                                .font(.title)
                                .bold()
                        }
                }
            }
            .onAppear(perform: {
                timerManager.startTimer()
            })
            
            if !timerManager.timeRemaining.isZero {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .overlay {
                        VStack(spacing: 12) {
                            Group {
                                Text("Your score:")
                                Text("\(currentPoints)")
                            }
                                .font(.title)
                                .bold()
                            
                            NavigationLink {
                                HomeView()
                            } label: {
                                Text("Go home")
                            }

                        }
                        .onAppear {
                            UserDefaults.standard.ad
                        }
                        
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .padding(-40)
                                .foregroundStyle(.white)
                        }
                    }
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
