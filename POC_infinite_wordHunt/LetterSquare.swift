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
        Button {
            
            letterSquare.isSelected.toggle()
            
            wordViewModel.clickLetterSquare(letterSquare: letterSquare)
            
        } label: {
            Rectangle()
                .stroke()
                .frame(width: 50, height: 50)
                .foregroundStyle(.black)
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
                        .foregroundStyle(.black)
                }
                .overlay {
                    if !letterSquare.isEnabled {
                        Color.gray.opacity(0.5)
                    }
                }
        }
        .disabled(!letterSquare.isEnabled)
    }
}

@Observable
class LetterSquareModel: Identifiable {
    var id: UUID
    var letter: String
    var isSelected: Bool
    var isEnabled: Bool
    
    init(letter: String, isSelected: Bool, isEnabled: Bool) {
        self.id = UUID()
        self.letter = letter
        self.isSelected = isSelected
        self.isEnabled = isEnabled
    }
    
    func enable() {
        isEnabled = true
    }
    
    func disable() {
        isEnabled = false
    }
}

#Preview {
    LetterSquare(wordViewModel: .init(), letterSquare: .init(letter: "", isSelected: false, isEnabled: false))
}
