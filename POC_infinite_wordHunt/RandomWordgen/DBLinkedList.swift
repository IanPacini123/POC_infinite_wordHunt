//
//  DBLinkedList.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 09/07/24.
//

import SwiftUI

enum ListError: Error {
    case indexNotAccessible(String)
}

@Observable
class DoubleLinkedList: Identifiable {
    let id: UUID = UUID()
    
    var root: Node
    var tail: Node
    
    init(rootValue: LetterSquareModel) {
        let rootNode = Node(value: rootValue)
        
        self.root = rootNode
        self.tail = rootNode
    }
    
    func addValueEnd(value: LetterSquareModel) {
        let newNode = Node(value: value)
        self.tail.nextNode = newNode
        newNode.previousNode = self.tail
        self.tail = newNode
    }
    
    func addValueStart(value: LetterSquareModel) {
        let newNode = Node(value: value)
        self.root.previousNode = newNode
        newNode.nextNode = self.root
        self.root = newNode
    }
    
    func removeValue(value: LetterSquareModel) {
        if root.value.id == value.id {
            guard let nextNode = root.nextNode else {
                return
            }
            root = nextNode
            root.previousNode = nil
            
            return
        }
        
        if tail.value.id == value.id {
            guard let previousNode = tail.previousNode else {
                return
            }
            
            tail = previousNode
            tail.nextNode = nil
            
            return
        }
        
        var currentNode: Node? = self.root.nextNode
        
        while currentNode?.nextNode != nil {
            if currentNode?.value.id == value.id {
                currentNode?.previousNode?.nextNode = currentNode?.nextNode
                currentNode?.nextNode?.previousNode = currentNode?.previousNode
                
                currentNode = nil
                return
            }
            
            currentNode = currentNode?.nextNode
        }
        
        return
    }
    
    func getAllValues() -> [LetterSquareModel]{
        var listValues: [LetterSquareModel] = []
        
        var currentNode: Node = root
        
        while currentNode.nextNode != nil{
            listValues.append(currentNode.value)
            
            guard let loopNode = currentNode.nextNode else {
                return listValues
            }
            
            currentNode = loopNode
        }
        
        listValues.append(currentNode.value)
        return listValues
    }
    
    func count() -> Int {
        var currentNode = root
        var count = 0
        
        while currentNode.nextNode != nil {
            guard let loopNode = currentNode.nextNode else {
                break
            }
            count += 1
            
            currentNode = loopNode
        }
        count += 1
        return count
    }
    
    func hasValue(value: LetterSquareModel) -> Bool {
        var currentNode = root
        
        while currentNode.value.id != value.id {
            guard let loopNode = currentNode.nextNode else {
                return false
            }
            currentNode = loopNode
        }
        return true
    }
    
    func findValueIndex(value: LetterSquareModel) throws -> Int {
        var index = 0
        
        var currentNode = root
        
        while currentNode.value.id != value.id {
            index += 1
            guard let loopNode = currentNode.nextNode else {
                throw ListError.indexNotAccessible("Index out of range")
            }
            currentNode = loopNode
        }
        
        return index
    }
    
    func forEachValue(closure: @escaping (_: inout LetterSquareModel) -> Void ) {
        var currentNode = root
        
        while currentNode.nextNode != nil {
            closure(&currentNode.value)
            
            guard let loopNode = currentNode.nextNode else {
                break
            }
            currentNode = loopNode
        }
        
        closure(&currentNode.value)
    }
    
    func valueAtIndex(_ index: Int) -> LetterSquareModel {
        var currentIndex = 0
        
        var currentNode = root
        
        while currentIndex < index {
            guard let loopNode = currentNode.nextNode else {
                return currentNode.value
            }
            currentIndex += 1
            currentNode = loopNode
        }
        
        return currentNode.value
    }
    
    func changeAtIndex(to newValue: LetterSquareModel, atIndex: Int) {
        var index = 0
        
        var currentNode = root
        
        while index < atIndex {
            guard let loopNode = currentNode.nextNode else {
                return
            }
            index += 1
            currentNode = loopNode
        }
        
        currentNode.value = newValue
    }
    
    func printList() {
        var currentNode = root
        
        while currentNode.nextNode != nil {
            print(currentNode.value.letter)
            guard let loopNode = currentNode.nextNode else {
                break
            }
            currentNode = loopNode
        }
        print(currentNode.value.letter)
    }
}

@Observable
class Node: Identifiable {
    let id: UUID = UUID()
    
    var value: LetterSquareModel
    
    var previousNode: Node?
    var nextNode: Node?
    
    init(value: LetterSquareModel, previousNode: Node? = nil, nextNode: Node? = nil) {
        self.value = value
        self.previousNode = previousNode
        self.nextNode = nextNode
    }
    
    deinit {
        print("deinit worked")
    }
}
