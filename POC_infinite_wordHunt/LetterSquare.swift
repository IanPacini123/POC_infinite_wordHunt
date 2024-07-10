//
//  LetterSquare.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 04/07/24.
//

import SwiftUI

struct LetterSquare: View {
    @State var wordViewModel: WordViewModel
    @State var letterSquare: LetterSquareModel
    
    
    var body: some View {
        Rectangle()
            .stroke()
            .frame(width: 50, height: 50)
            .background {
                if !letterSquare.isSelected {
                    Color.clear
                } else {
                    Color.blue
                }
            }
            .overlay {
                Text(letterSquare.letter)
                    .bold()
            }
            .onTapGesture {
                letterSquare.isSelected.toggle()
                
                wordViewModel.clickLetterSquare(letterSquare: letterSquare)
            }
    }
    
}

struct LetterSquareModel: Identifiable {
    var id: UUID = UUID()
    var letter: String
    var isSelected: Bool
    var isEnabled: Bool
}

#Preview {
    LetterSquare(wordViewModel: .init(), letterSquare: .init(letter: "", isSelected: false, isEnabled: false))
}
