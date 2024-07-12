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
        let game_width = 6
        let game_height = 6
        
        if let filepath = Bundle.main.path(forResource: "words_pt", ofType: "txt") {
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
            let newColumn = DoubleLinkedList(rootValue: .init(letter: letters.randomElement()!, isSelected: false, isEnabled: true))
            
            for _ in 1..<game_height {
                newColumn.addValueStart(value: .init(letter: letters.randomElement()!, isSelected: false, isEnabled: true))
            }
            
            self.currentLetters.append(newColumn)
        }
    }
    
    func clickLetterSquare(letterSquare: LetterSquareModel) {
        if letterSquare.isSelected {
            
            self.selectedLetters.append(letterSquare)
            disableAll()
            enableAround()
            
        } else {
            
            self.selectedLetters.removeAll(where: {$0.id == letterSquare.id})
            
            if selectedLetters.isEmpty {
                enableAll()
            } else {
                disableAll()
                enableAround()
            }
            
        }
        
        updateWord()
    }
    
    private func updateWord() {
        self.currentWord = self.selectedLetters.map({$0.letter})
    }
    
    func resetSelection() {
        selectedLetters.forEach({
            $0.isSelected = false
        })
        self.selectedLetters = []
    }
    
    func resetWord() {
        self.currentWord = []
    }
    
    func getWord() -> [String] {
        return self.currentWord
    }
    
    func clear() {
        resetSelection()
        resetWord()
        
        enableAll()
    }
    
    func checkWord(currentPoints: Binding<Int>, currentTime: Binding<TimeInterval>) {
        let word = currentWord.joined().uppercased()
        
        if words.contains(word) {
            sumPoints(currentPoints: currentPoints, word: word)
            sumTime(currentTime: currentTime, word: word)
            randomizeRowAndColumn()
            resetSelection()
            resetWord()
            
            enableAll()
        }
    }
    
    func disableAll() {
        for list in currentLetters {
            list.forEachValue(closure: { letterSquare in
                letterSquare.disable()
            })
        }
    }
    
    func enableAll() {
        for list in currentLetters {
            list.forEachValue(closure: { letterSquare in
                letterSquare.enable()
            })
        }
    }
    
    func enableVertical(letterSquareIndex: Int, inList list: DoubleLinkedList) {
        let currentValue = list.valueAtIndex(letterSquareIndex)
        currentValue.enable()
        
        if letterSquareIndex == 0 {
            
            let nextValue = list.valueAtIndex((letterSquareIndex + 1))
            nextValue.enable()
            
            list.changeAtIndex(to: nextValue, atIndex: (letterSquareIndex + 1))
            
            return
            
        }
        if letterSquareIndex == game_height {
            
            let previousValue = list.valueAtIndex((letterSquareIndex - 1))
            previousValue.enable()
            
            list.changeAtIndex(to: previousValue, atIndex: (letterSquareIndex - 1))
            
            return
            
        }
        
        let previousValue = list.valueAtIndex((letterSquareIndex - 1))
        let nextValue = list.valueAtIndex((letterSquareIndex + 1))
        
        previousValue.enable()
        nextValue.enable()
        
        list.changeAtIndex(to: previousValue, atIndex: (letterSquareIndex - 1))
        list.changeAtIndex(to: nextValue, atIndex: (letterSquareIndex + 1))
        
    }
    
    func enableAround() {
        let currentLetter = selectedLetters.last!
        
        for list in currentLetters {
            do {
                let lastSelectedIndex = try list.findValueIndex(value: currentLetter)
                let lastSelectedListIndex = currentLetters.firstIndex(where: {$0.id == list.id}) ?? 0

                if lastSelectedListIndex == 0 {
                    
                    enableVertical(letterSquareIndex: lastSelectedIndex, inList: list)
                    enableVertical(letterSquareIndex: lastSelectedIndex, inList: currentLetters[1])
                    
                    break
                    
                }
                if lastSelectedListIndex == (game_width - 1) {
                    
                    enableVertical(letterSquareIndex: lastSelectedIndex, inList: list)
                    enableVertical(letterSquareIndex: lastSelectedIndex, inList: currentLetters[(game_width - 2)])
                    
                    break
                    
                }
                
                enableVertical(letterSquareIndex: lastSelectedIndex, inList: list)
                enableVertical(letterSquareIndex: lastSelectedIndex, inList: currentLetters[(lastSelectedListIndex - 1)])
                enableVertical(letterSquareIndex: lastSelectedIndex, inList: currentLetters[(lastSelectedListIndex + 1)])
                
                break
            } catch {
                continue
            }
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
                            $0.changeAtIndex(to: .init(letter: letters.randomElement()!, isSelected: false, isEnabled: true), atIndex: index)
                        })
                    } catch {
                        return
                    }
                }
            })
        }
    }
    
    func createNewColumn() -> DoubleLinkedList {
        let newColumn = DoubleLinkedList(rootValue: .init(letter: letters.randomElement()!, isSelected: false, isEnabled: true))
        
        for _ in 1..<game_height {
            newColumn.addValueStart(value: .init(letter: letters.randomElement()!, isSelected: false, isEnabled: true))
        }
        
        return newColumn
    }
    
    func sumPoints(currentPoints: Binding<Int>, word: String) {
        currentPoints.wrappedValue += word.count * 10
    }
    
    func sumTime(currentTime: Binding<TimeInterval>, word: String) {
        currentTime.wrappedValue += Double(word.count * 2) as Double
    }
}

