//
//  GameViewModel.swift
//  SpeechMatchKitTestApp
//
//  Created by Ranga Reddy on 11/16/24.
//

import SwiftUI
import DVWordKit
import SpeechMatchKit
import GroupActivities

class GameViewModel: ObservableObject {
    private let gameController: WordGameController
    private let speechManager: SpeechRecognitionManager
    
    @Published var currentWord: Word?
    @Published var currentHint: String = ""
    @Published var guessLog: [String] = []
    @Published var isListening: Bool = false
    
    init(apiKey: String) {
        self.gameController = WordGameController(apiKey: apiKey)
        self.speechManager = SpeechRecognitionManager()
    }
    
    func getNextWord(category: WordCategory) async {
        currentWord = await gameController.nextWord(category: category)
        if let word = currentWord {
            currentHint = gameController.getHint(for: word)
        }
    }
    
    func resetGame() async {
        await gameController.resetUsedWords()
        guessLog.removeAll()
        currentWord = nil
        currentHint = ""
    }
    
    func startListening() {
        guard let word = currentWord else {
            guessLog.append("No word available. Generate a word first.")
            return
        }
        
        isListening = true
        speechManager.startListening(for: Participant(id: UUID(), name: "Player")) { [weak self] spokenInput in
            guard let self = self else { return }
            
            self.guessLog.append("Received input: \(spokenInput)")
            
            if spokenInput.lowercased() == word.value.lowercased() {
                self.guessLog.append("Correct! The word was \(word.value).")
                self.speechManager.stopListening(for: Participant(id: UUID(), name: "Player"))
                self.isListening = false
            } else {
                self.guessLog.append("Incorrect guess.")
            }
        }
    }
    
    func stopListening() {
        speechManager.stopListening(for: Participant(id: UUID(), name: "Player"))
        isListening = false
    }
}


