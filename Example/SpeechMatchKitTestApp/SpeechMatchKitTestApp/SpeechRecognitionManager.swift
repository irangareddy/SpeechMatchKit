//
//  SpeechRecognitionManager.swift
//  SpeechMatchKitTestApp
//
//  Created by Ranga Reddy on 11/16/24.
//

import Foundation
import Speech
import AVFoundation
import SpeechMatchKit

import Foundation
import Speech
import AVFoundation

public class SpeechRecognitionManager {
    private let speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    public init() {}

    public func startListening(for participant: Participant, onSpeechDetected: @escaping (String) -> Void) {
        // Ensure the speech recognizer is available
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("Speech recognizer not available")
            return
        }

        // Create a recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let request = recognitionRequest else { return }

        // Configure the audio session
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        // Attach the audio input to the request
        let inputNode = audioEngine.inputNode
        request.shouldReportPartialResults = true
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            request.append(buffer)
        }

        // Start the audio engine
        try? audioEngine.start()

        // Start speech recognition
        recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                // Process only the most recent result and reset state
                let latestTranscription = result.bestTranscription.segments.last?.substring ?? ""
                print("Transcribed: \(latestTranscription)")
                onSpeechDetected(latestTranscription)
            }

            if error != nil {
                self.stopListening(for: participant)
            }
        }
    }

    public func stopListening(for participant: Participant) {
        print("Stopping speech recognition for \(participant.name).")
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
