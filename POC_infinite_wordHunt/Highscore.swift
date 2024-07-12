//
//  Highscore.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 11/07/24.
//

import Foundation
import SwiftData

@Model class Highscore {
    let name: String
    let score: Int
    let gameStyle: String
    
    init(name: String, score: Int, gameStyle: GameStyle) {
        self.name = name
        self.score = score
        self.gameStyle = gameStyle.rawValue
    }
}
