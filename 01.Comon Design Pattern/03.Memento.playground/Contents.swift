import Foundation

/*:
 
 # Memento
 - - - - - - - - - -
 ![Memento Diagram](Memento_Diagram.png)
 
 The memento pattern allows an object to be saved and restored. It involves three parts:
 
 (1) The **originator** is the object to be saved or restored.
 
 (2) The **memento** is a stored state.
 
 (3) The **caretaker** requests a save from the originator, and it receives a memento in response. The care taker is responsible for persisting the memento, so later on, the care taker can provide the memento back to the originator to request the originator restore its state.
 */
/*:
 ## Originator -> Game State(level, health, number of lives)
 */
public class Game: Codable {
  
  public class State: Codable {
    public var attemptsRemaining: Int = 3
    public var level: Int = 1
    public var score: Int = 0
  }
  
  public var state = State()
  
  public func rackUpMassivePoints() {
    state.score += 9002
  }
  
  public func monsterEatPlayer() {
    state.attemptsRemaining -= 1
  }
}

/*:
 ## Momento -> Saved Data
 */

typealias GameMemento = Data

/*:
 ## CareTaker -> Game System
 */

public class GameSystem {
  
  // decoder to decode Games from Data
  // encoder to encode Games to Data
  // persist Data to disk
  //if the app is re-launched, saved Game data will still be available
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  private let userDefaults = UserDefaults.standard
  
  //encode the passed-in game
  //the operation may throw an error, you must prefix it with try
  //save the results data under given title with userDefaults
  public func save(_ game: Game, title: String) throws {
    let data = try encoder.encode(game)
    userDefaults.set(data, forKey: title)
  }
  
  //decode the Game from the data
  //if either operation fails, throw custom error for Error.gameNotFound
  //if both succed return the resulting game.
  public func load(title: String) throws -> Game {
    guard let data = userDefaults.data(forKey: title),
      let game = try? decoder.decode(Game.self, from: data) else { throw Error.gameNotFound }
    return game
  }
  
  public enum Error: String, Swift.Error {
    case gameNotFound
  }
}

/*:
 ## Example
 */

var game = Game()
game.monsterEatPlayer()
game.rackUpMassivePoints()

//Save Game
let gameSystem = GameSystem()
try gameSystem.save(game, title: "Tanya Score")
print("Tanya Game Score: \(game.state.score)")

//New Game
game = Game()
game.rackUpMassivePoints()
game.rackUpMassivePoints()
//Save
try gameSystem.save(game, title: "Igor score")
print("New Game Score Igor: \(game.state.score)")

//Load Game
game = try! gameSystem.load(title: "Tanya Score")
print("Loaded Game Score Tanya: \(game.state.score)")
game = try! gameSystem.load(title: "Igor score")
print("Loaded Game Score Igor: \(game.state.score)")
