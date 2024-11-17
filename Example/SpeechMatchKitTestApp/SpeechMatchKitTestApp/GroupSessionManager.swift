//
//  GroupSessionManager.swift
//  SpeechMatchKitTestApp
//
//  Created by Ranga Reddy on 11/16/24.
//

import GroupActivities
import Foundation
import Combine

class GroupSessionManager: ObservableObject {
    @Published var isSharing: Bool = false
    private var subscriptions = Set<AnyCancellable>()

    func startGroupActivity() async {
        let activity = WordGuessActivity() // Define a GroupActivity for your app
        switch await activity.prepareForActivation() {
        case .activationPreferred:
            _ = try? await activity.activate()
            DispatchQueue.main.async {
                self.isSharing = true
            }
        case .activationDisabled:
            print("SharePlay is not available")
        case .cancelled:
            print("Cancelled activation")
        default:
            break
        }
    }

    func monitorSessions() async {
        for await session in WordGuessActivity.sessions() {
            isSharing = true
            session.join() // Automatically join the session
            session.$state
                .sink { state in
                    print("Session state: \(state)")
                }
                .store(in: &subscriptions)
        }
    }
}

// Define the GroupActivity
struct WordGuessActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var meta = GroupActivityMetadata()
        meta.title = "Word Guess Game"
        meta.type = .generic
        return meta
    }
}

