//
//  WordsLoader.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 04/07/24.
//

import Foundation

class WordsLoader {
    private var words: Set<String> = []
    
    init(filePath: String) {
        self.words = readTextFile(atPath: filePath) ?? []
    }
    
    func readTextFile(atPath filePath: String) -> Set<String>? {
        do {
            // Read the contents of the file
            let content = try String(contentsOfFile: filePath, encoding: .utf8).uppercased()
            
            // Split the content by new lines
            let lines = content.components(separatedBy: .newlines)
            
            // Remove any empty lines
            let nonEmptyLines = lines.filter { !$0.isEmpty }
            
            // Convert to a set
            return Set(nonEmptyLines)
        } catch {
            print("Error reading file: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getWords() -> Set<String> {
        return self.words
    }
}

