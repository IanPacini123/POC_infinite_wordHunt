//
//  HomeView.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 10/07/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                
                Text("Welcome to")
                    .font(.title)
                
                Text("Infinite WordHunt")
                    .font(.system(size: 58))
                    .fontWidth(.expanded)
                    .bold()
                
                Spacer()
                
                NavigationLink(destination: ContentView(gameStyle: .timeAttack)) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 200, height: 80)
                        .overlay {
                            Text("Ataque de tempo")
                                .foregroundStyle(.white)
                                .font(.title)
                                .bold()
                        }
                }
                
                NavigationLink(destination: ContentView(gameStyle: .endless)) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 200, height: 80)
                        .overlay {
                            Text("Sem fim")
                                .foregroundStyle(.white)
                                .font(.title)
                                .bold()
                        }
                }
                
                Spacer()
            }
            .padding()
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: HighScoresView()) {
                        Text("Placar")
                    }
                }
            })
        }
    }
}

#Preview {
    HomeView()
}
