
import Foundation

public class GuessManager {
    public init() {}
    
    public func matchGuess(input: String, secretWord: String) -> Bool {
        return input.lowercased() == secretWord.lowercased()
    }
}
