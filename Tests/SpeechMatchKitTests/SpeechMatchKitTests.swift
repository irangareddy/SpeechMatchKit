
import XCTest
@testable import SpeechMatchKit

final class SpeechMatchKitTests: XCTestCase {
    func testGuessMatching() {
        let guessManager = GuessManager()
        XCTAssertTrue(guessManager.matchGuess(input: "elephant", secretWord: "Elephant"))
        XCTAssertFalse(guessManager.matchGuess(input: "tiger", secretWord: "Elephant"))
    }
}
