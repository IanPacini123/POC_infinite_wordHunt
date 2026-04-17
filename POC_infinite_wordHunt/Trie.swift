//
//  Trie.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 22/08/25.
//

import SwiftUI

private let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

@Observable
class TrieNode {
    static func == (lhs: TrieNode, rhs: TrieNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID = UUID()
    let letter: String
    var count: Int
    var nextTrieNodes: [String: TrieNode]
    var isEnd: Bool
    
    init(letter: String = "*",
         count: Int = 1,
         isEnd: Bool = false) {
        self.letter = letter
        self.count = count
        self.nextTrieNodes = [:]
        self.isEnd = isEnd
    }
}

@Observable
class Trie {
    var trieNodes: [TrieNode]
    
    init() {
        self.trieNodes = []
        
        letters.forEach({ letter in
            self.trieNodes.append(TrieNode(letter: letter))
        })
    }
    
    func addWord(word: String) {
        guard let firstLetter = word.first else {
            // TODO: throw
            print("error 1")
            return
        }
        
        var currentTrieNode = self.trieNodes.first(where: {$0.letter == firstLetter.uppercased()})
        
        if currentTrieNode == nil {
            // TODO: throw
            print("error 2")
            return
        }
        
        for letterIndex in 1..<word.count {
            var searchIndex = word.index(word.startIndex, offsetBy: letterIndex)
            
            if let searchTrieNode = currentTrieNode?.nextTrieNodes[word[searchIndex].uppercased()] {
                currentTrieNode = searchTrieNode
            } else {
                let newTrieNode = TrieNode(letter: word[searchIndex].uppercased())
                currentTrieNode?.nextTrieNodes[word[searchIndex].uppercased()] = newTrieNode
                currentTrieNode = newTrieNode
            }
        }
        
        currentTrieNode?.count += 1
        currentTrieNode?.isEnd = true
    }
    
    func checkWordExists(word: String) -> Bool {
        guard let firstLetter = word.first else {
            // TODO: throw
            print("error 3")
            return false
        }
        
        var currentTrieNode = self.trieNodes.first(where: {$0.letter == firstLetter.uppercased()})
        
        if currentTrieNode == nil {
            // TODO: throw
            print("error 4")
            return false
        }
        
        for letterIndex in 1..<word.count {
            let searchIndex = word.index(word.startIndex, offsetBy: letterIndex)
            
            if let searchTrieNode = currentTrieNode!.nextTrieNodes[word[searchIndex].uppercased()] {
                currentTrieNode = searchTrieNode
            } else {
                return false
            }
        }
        
        return currentTrieNode!.isEnd
    }
}
