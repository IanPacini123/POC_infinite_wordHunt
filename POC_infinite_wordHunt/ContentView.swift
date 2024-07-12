//
//  ContentView.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 04/07/24.
//

import SwiftUI
import SwiftData

enum GameStyle: String, CaseIterable {
    case timeAttack = "Ataque de tempo"
    case endless = "Sem fim"
}

struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var wordViewModel: WordViewModel = .init()
    
    @State var timerManager = TimerManager(initialTime: 30)
    @State var currentPoints = 0
    
    @State var newHighscoreSheet: Bool = false
    
    let gameStyle: GameStyle

    var body: some View {
        ZStack {
            
            VStack {
                Text(wordViewModel.getWord().isEmpty ? " " : wordViewModel.getWord().joined())
                    .foregroundStyle(.black)
                    .underline()
                    .font(.title)
                    .bold()
                
                HStack {
                    Text("Pontuação: \(currentPoints)")
                    
                    Spacer()
                    
                    if gameStyle == .timeAttack {
                        VStack(alignment: .trailing){
                            Text("Tempo restante:")
                            Text("\(timerManager.timeRemaining.formatted(.number))")
                        }
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
                            Text("Enviar !")
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
                            Text("Limpar")
                                .foregroundStyle(.white)
                                .font(.title)
                                .bold()
                        }
                }
            }
            .onAppear(perform: {
                if gameStyle == .timeAttack {
                    timerManager = TimerManager(initialTime: 30)
                    timerManager.startTimer()
                }
            })
            
            if timerManager.timeRemaining.isZero {
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
                            
                            Button {
                                $newHighscoreSheet.wrappedValue = true
                            } label: {
                                Text("Salvar pontuação")
                            }
                            .padding(.vertical, 20)
                            
                            Button {
                                dismiss()
                            } label: {
                                Text("Voltar ao inicio")
                            }
                        }
                        
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .padding(-40)
                                .foregroundStyle(.white)
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden(timerManager.timeRemaining.isZero)
        .sheet(isPresented: $newHighscoreSheet) {
            NewHighscoreForm(gameStyle: gameStyle,
                             playerPoint: $currentPoints,
                             isPresented: $newHighscoreSheet)
                .presentationDetents([.fraction(0.3)])
        }
    }
}

private struct NewHighscoreForm: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var highscores: [Highscore]
    
    @State var playerName: String = ""
    @State var gameStyle: GameStyle
    @Binding var playerPoint: Int
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Section {
                TextField("Nome para o placar:", text: $playerName)
                    .textFieldStyle(.roundedBorder)
            } header: {
                Text("Seu nome:")
                    .font(.title)
                    .bold()
            }
            .padding(.horizontal, 20)
            
            Button {
                let newHighscore = Highscore(name: playerName,
                                             score: playerPoint,
                                             gameStyle: gameStyle)
                
                modelContext.insert(newHighscore)
                
                isPresented.toggle()
            } label: {
                Text("Salvar pontuação!")
                    .foregroundStyle(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .padding(-20)
                            .foregroundStyle(.blue)
                    }
            }
            .padding(.top, 40)
        }
    }
}

#Preview {
    ContentView(gameStyle: .endless)
}
