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
                
                NavigationLink(destination: ContentView()) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 200, height: 80)
                        .overlay {
                            Text("Jogar!")
                                .foregroundStyle(.white)
                                .font(.title)
                                .bold()
                        }
                }
                
//                NavigationLink(destination: ContentView()) {
//                    RoundedRectangle(cornerRadius: 20)
//                        .frame(width: 200, height: 80)
//                        .overlay {
//                            Text("Jogar!")
//                                .foregroundStyle(.white)
//                                .font(.title)
//                                .bold()
//                        }
//                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
