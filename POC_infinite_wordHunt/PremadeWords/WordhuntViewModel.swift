////
////  WordhuntViewModel.swift
////  POC_infinite_wordHunt
////
////  Created by Ian Pacini on 15/07/24.
////
//
//import SwiftUI
//
//fileprivate let letters = ["A", "A", "A",
//                           "B",
//                           "C",
//                           "D",
//                           "E", "E", "E",
//                           "F",
//                           "G",
//                           "H",
//                           "I", "I", "I",
//                           "J",
//                           "K",
//                           "L",
//                           "M",
//                           "N",
//                           "O", "O", "O",
//                           "P",
//                           "Q",
//                           "R",
//                           "S",
//                           "T",
//                           "U", "U", "U",
//                           "V",
//                           "W",
//                           "X",
//                           "Y",
//                           "Z"]
//
//@Observable
//class WordhuntViewModel {
//    var matrix: [[String]]
//    
//    let words: Set<String>
//    
//    private let game_width: Int
//    private let game_height: Int
//    
//    init() {
//        let game_width = 6
//        let game_height = 6
//        
//        self.game_width = game_width
//        self.game_height = game_height
//        
//        if let filepath = Bundle.main.path(forResource: "words_pt", ofType: "txt") {
//            let wordLoader = WordsLoader(filePath: filepath)
//            
//            self.words = Set(wordLoader.getWords())
//        } else {
//            self.words = []
//        }
//        
//        var newMatrix: [[String]] = []
//        for _ in 0..<game_width {
//            var newLine: [String] = []
//            for _ in 0..<game_height {
//                newLine.append("")
//            }
//            newMatrix.append(newLine)
//        }
//        
//        self.matrix = newMatrix
//    }
//    
//    enum Orientation {
//        case vertical, horizontal, diagonal
//        
//        static var randomElement: Orientation {
//            return [.vertical, .horizontal, .diagonal].randomElement()!
//        }
//    }
//    
//    enum VerticalDirection {
//        case up, down
//        
//        static var randomElement: VerticalDirection {
//            return [.up, .down].randomElement()!
//        }
//    }
//
//    
//    func getRandomWord(maxSize: Int) -> String {
//        
//        var word = words.randomElement()!
//        
//        while word.count > maxSize {
//            word = words.randomElement()!
//        }
//        
//        return word
//    }
//    
//    func placeWord() -> [[String]] {
//        var newMatrix = self.matrix
//        
//        let position = ["width": (0..<game_width).randomElement()!, "height": (0..<game_height).randomElement()!]
//        
//        let orientation = Orientation.randomElement
//        
//        switch orientation {
//        case .vertical:
//            
//            let direction = VerticalDirection.randomElement
//            let maxSize: Int
//            
//            switch direction {
//            case .up:
//                maxSize = position["height"]! - game_height
//            case .down:
//                maxSize = position["height"]! - game_height
//            }
//            
//            
//            
//        case .horizontal:
//            <#code#>
//        case .diagonal:
//            <#code#>
//        }
//    }
//}
