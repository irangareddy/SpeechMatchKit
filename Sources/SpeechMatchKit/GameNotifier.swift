
import Foundation

public class GameNotifier {
    public init() {}
    
    public func notifyCorrectGuess(for participant: Participant) {
        print("Correct guess by \(participant.name)! Notifying game logic...")
    }
}
