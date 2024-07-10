//
//  WordViewModel.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 04/07/24.
//

import SwiftUI

fileprivate let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

@Observable
class WordViewModel {
    var currentLetters: [DoubleLinkedList]
    
    private var words: Set<String>
    private var selectedLetters: [LetterSquareModel]
    private var currentWord: [String]
    
    init() {
        let game_width = 5
        let game_height = 5
        
        if let filepath = Bundle.main.path(forResource: "newFileFiltered", ofType: "txt") {
            let wordLoader = WordsLoader(filePath: filepath)
            
            self.words = Set(wordLoader.getWords())
        } else {
            self.words = []
        }
        
        self.currentLetters = []
        self.selectedLetters = []
        self.currentWord = []
        
        
        for _ in 0..<game_width {
            let newColumn = DoubleLinkedList(rootValue: .init(letter: letters.randomElement()!, isSelected: false))
            
            for _ in 1..<game_height {
                newColumn.addValueStart(value: .init(letter: letters.randomElement()!, isSelected: false))
            }
            
            self.currentLetters.append(newColumn)
        }
    }
    
    func clickLetterSquare(letterSquare: LetterSquareModel) {
        if letterSquare.isSelected {
            self.selectedLetters.append(letterSquare)
        } else {
            self.selectedLetters.removeAll(where: {$0.id == letterSquare.id})
        }
        
        updateWord()
    }
    
    private func updateWord() {
        self.currentWord = self.selectedLetters.map({$0.letter})
    }
    
    func resetSelection() {
        self.selectedLetters = []
    }
    
    func resetWord() {
        self.currentWord = []
    }
    
    func getWord() -> [String] {
        return self.currentWord
    }
    
    func checkWord() -> Bool {
        let word = currentWord.joined().uppercased()
        
        if words.contains(word) {
            removeLetters()
            addNewLetters()
            resetSelection()
            resetWord()
        }
        
        return words.contains(word)
    }
    
    func removeLetters() {
        
        for list in currentLetters {
            selectedLetters.forEach({
                list.removeValue(value: $0)
            })
        }
    }
    
    func addNewLetters() {
        for list in currentLetters {
            while list.count() <= 4 {
                list.addValueStart(value: .init(letter: letters.randomElement()!, isSelected: false))
            }
        }
    }
}

