//
//  WordViewModel.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 04/07/24.
//

import SwiftUI

fileprivate let letters = ["A", "A", "A",
                           "B",
                           "C",
                           "D",
                           "E", "E", "E",
                           "F",
                           "G",
                           "H",
                           "I", "I", "I",
                           "J",
                           "K",
                           "L",
                           "M", 
                           "N",
                           "O", "O", "O",
                           "P",
                           "Q",
                           "R",
                           "S",
                           "T", 
                           "U", "U", "U",
                           "V",
                           "W",
                           "X",
                           "Y", 
                           "Z"]

@Observable
class WordViewModel {
    var currentLetters: [DoubleLinkedList]
    
    private var words: Set<String>
    private var selectedLetters: [LetterSquareModel]
    private var currentWord: [String]
    
    private let game_width: Int
    private let game_height: Int
    
    init() {
        let game_width = 5
        let game_height = 5
        
        if let filepath = Bundle.main.path(forResource: "words", ofType: "txt") {
            let wordLoader = WordsLoader(filePath: filepath)
            
            self.words = Set(wordLoader.getWords())
        } else {
            self.words = []
        }
        
        self.currentLetters = []
        self.selectedLetters = []
        self.currentWord = []
        
        self.game_width = game_width
        self.game_height = game_height
        
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
    
    func checkWord(currentPoints: Binding<Int>) -> Bool {
        let word = currentWord.joined().uppercased()
        
        if words.contains(word) {
            sumPoints(currentPoints: currentPoints, word: word)
            randomizeRowAndColumn()
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
    
    func randomizeColumn() {
        for list in currentLetters {
            selectedLetters.forEach({
                if list.hasValue(value: $0) {
                    guard let index = currentLetters.firstIndex(where: {$0.id == list.id}) else {
                        return
                    }
                    
                    currentLetters[index] = createNewColumn()
                }
            })
        }
    }
    
    func randomizeRowAndColumn() {
        for list in currentLetters {
            selectedLetters.forEach({
                if list.hasValue(value: $0) {
                    do {
                        let index = try list.findValueIndex(value: $0)
                        
                        randomizeColumn()
                        
                        currentLetters.forEach({
                            $0.changeAtIndex(to: .init(letter: letters.randomElement()!, isSelected: false), atIndex: index)
                        })
                    } catch {
                        return
                    }
                }
            })
        }
    }
    
    func createNewColumn() -> DoubleLinkedList {
        let newColumn = DoubleLinkedList(rootValue: .init(letter: letters.randomElement()!, isSelected: false))
        
        for _ in 1..<game_height {
            newColumn.addValueStart(value: .init(letter: letters.randomElement()!, isSelected: false))
        }
        
        return newColumn
    }
    
    func addNewLetters() {
        for list in currentLetters {
            while list.count() < game_height {
                list.addValueStart(value: .init(letter: letters.randomElement()!, isSelected: false))
            }
        }
    }
    
    func sumPoints(currentPoints: Binding<Int>, word: String) {
        currentPoints.wrappedValue += word.count * 10
    }
}

