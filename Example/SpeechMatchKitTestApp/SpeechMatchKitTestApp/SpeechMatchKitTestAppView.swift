//
//  SpeechMatchKitTestAppView.swift
//  SpeechMatchKitTestApp
//
//  Created by Ranga Reddy on 11/16/24.
//

import SwiftUI
import SpeechMatchKit

struct SpeechMatchKitTestAppView: View {
    @State private var secretWord: String = ""
    @State private var isListening: Bool = false
    @State private var log: [String] = []
    private let words = ["Elephant", "Tiger", "Lion", "Giraffe"]
    
    private let speechManager = SpeechRecognitionManager()
    private let guessManager = GuessManager()
    private let notifier = GameNotifier()
    
    var body: some View {
        VStack {
            Text("SpeechMatchKit Test App")
                .font(.largeTitle)
                .padding()
            
            Text("Select a Secret Word")
                .font(.headline)
            
            Picker("Secret Word", selection: $secretWord) {
                ForEach(words, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button(action: {
                isListening.toggle()
                if isListening {
                    startListening()
                } else {
                    stopListening()
                }
            }) {
                Text(isListening ? "Stop Listening" : "Start Listening")
                    .font(.title)
                    .padding()
                    .background(isListening ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text("Log:")
                .font(.headline)
                .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(log, id: \.self) {
                        Text($0)
                            .padding(.vertical, 2)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            secretWord = words.first ?? ""
        }
    }
    
    private func startListening() {
        let participant = Participant(id: UUID(), name: "Player")
        speechManager.startListening(for: participant) { spokenInput in
            log.append("Received input: \(spokenInput)")
            if guessManager.matchGuess(input: spokenInput, secretWord: secretWord) {
                notifier.notifyCorrectGuess(for: participant)
                log.append("Correct guess by \(participant.name)!")
                stopListening()
            } else {
                log.append("Incorrect guess.")
            }
        }
        log.append("Started listening for Player")
    }
    
    private func stopListening() {
        let participant = Participant(id: UUID(), name: "Player")
        speechManager.stopListening(for: participant)
        log.append("Stopped listening for Player")
        isListening = false
    }
}



#Preview {
    SpeechMatchKitTestAppView()
}
