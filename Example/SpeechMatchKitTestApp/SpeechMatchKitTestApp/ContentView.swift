//
//  ContentView.swift
//  SpeechMatchKitTestApp
//
//  Created by Ranga Reddy on 11/16/24.
//

import SwiftUI
import DVWordKit

struct ContentView: View {
    var body: some View {
        GameView()
    }
}

struct GameView: View {
    @StateObject private var viewModel = GameViewModel(apiKey: "apiKey")
    @State private var selectedCategory: WordCategory = .animals
    
    var body: some View {
        VStack {
            Text("SpeechMatch Word Guessing Game")
                .font(.largeTitle)
                .padding()
            
            Picker("Category", selection: $selectedCategory) {
                ForEach(WordCategory.allCases, id: \.self) { category in
                    Text(category.rawValue.capitalized).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if let word = viewModel.currentWord {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Hint: \(viewModel.currentHint)")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                Text("No word available. Tap 'Next Word' to generate one!")
                    .foregroundColor(.gray)
            }

            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.guessLog, id: \.self) { log in
                        Text(log)
                            .padding(.vertical, 2)
                    }
                }
            }
            .padding()

            HStack {
                Button(action: {
                    Task {
                        await viewModel.getNextWord(category: selectedCategory)
                    }
                }) {
                    Text("Next Word")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    Task {
                        await viewModel.resetGame()
                    }
                }) {
                    Text("Reset Game")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()

            Button(action: {
                viewModel.isListening ? viewModel.stopListening() : viewModel.startListening()
            }) {
                Text(viewModel.isListening ? "Stop Listening" : "Start Listening")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isListening ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

