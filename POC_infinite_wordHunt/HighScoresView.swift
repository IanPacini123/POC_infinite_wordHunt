//
//  HighScoresView.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 10/07/24.
//

import SwiftUI
import SwiftData

struct HighScoresView: View {
    @Query private var highscores: [Highscore]
    
    @State var selectedStyle: GameStyle = .timeAttack
    
    var body: some View {
        VStack {
            Picker(selection: $selectedStyle) {
                ForEach(GameStyle.allCases, id: \.self) { style in
                    Text(style.rawValue)
                }
            } label: {
                EmptyView()
            }
            .pickerStyle(.segmented)
            
            ScrollView {
                if selectedStyle == .timeAttack {
                    timeAttackHS
                } else {
                    endlessHS
                }
            }
            
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)

    }
    
    private var timeAttackHS: some View {
        Grid(verticalSpacing: 20) {
            
            Section{
                ForEach(highscores.filter({$0.gameStyle == GameStyle.timeAttack.rawValue}).sorted(by: {$0.score > $1.score})) { score in
                    GridRow {
                        HStack {
                            Text(score.name)
                            
                            Spacer()
                            
                            Text("\(score.score)")
                        }
                    }
                }
                .font(.title2)
                .bold()
            } header: {
                HStack {
                    Spacer()
                    
                    Text("|")
                    
                    Spacer()
                    
                    Text("Jogador")
                    
                    Spacer()
                    
                    Text("|")
                    
                    Spacer()
                    
                    Text("Pontuação")
                    
                    Spacer()
                    
                    Text("|")
                    
                    Spacer()
                }
                .padding(.top, 20)
                .font(.title)
            }
        }
    }
    
    private var endlessHS: some View {
        Grid(verticalSpacing: 20) {
            
            Section{
                ForEach(highscores.filter({$0.gameStyle == GameStyle.endless.rawValue})) { score in
                    GridRow {
                        HStack {
                            Text(score.name)
                            
                            Spacer()
                            
                            Text("\(score.score)")
                        }
                    }
                }
                .font(.title2)
                .bold()
            } header: {
                HStack {
                    Spacer()
                    
                    Text("|")
                    
                    Spacer()
                    
                    Text("Jogador")
                    
                    Spacer()
                    
                    Text("|")
                    
                    Spacer()
                    
                    Text("Pontuação")
                    
                    Spacer()
                    
                    Text("|")
                    
                    Spacer()
                }
                .padding(.top, 20)
                .font(.title)
            }
        }
    }

}

#Preview {
    HighScoresView()
}
