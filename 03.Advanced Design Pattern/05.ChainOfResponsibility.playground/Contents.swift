import Foundation
/*:
 
 # Chain Of Responsibility
 - - - - - - - - - -
 ![Chain Of Responsibility Diagram](ChainOfResponsibility_Diagram.png)
 
 The chain of responsibility pattern is a behavioral design pattern that allows an event to be processed by one of many handlers. It involves three types:
 
 1. The **client** accepts and passes events to an instance of a handler protocol.
 
 2. The **handler protocol** defines required properties and methods that concrete handlers must implement.
 
 3. The first **concrete handler** implements the handler protocol and is stored directly by the client. It first attempts to handle the event that's passed to it. If it's not able to do so, it passes the event onto its **next** concrete handler, which it holds as a strong property.
 
 */


/*:
 ## Model for coins
 */
public class Coin {
  
  //diameter of the coin
  public class var standardDiameter: Double {
    return 0
  }
  // weight of the coin
  public class var standardWeight: Double {
    return 0
  }
  
  //computed properties
  public var centValue: Int { return 0 }
  public final var dollarValue: Double { return Double(centValue) / 100 }
  
  //stored properties
  public final let diameter: Double
  public final let weight: Double
  
  // diameter and weight initializer
  public required init(diameter: Double, weight: Double) {
    self.diameter = diameter
    self.weight = weight
  }
  // You lastly create a convenience initializer. This creates a standard coin using type(of: self) to get the standardDiameter and standardWeight. This way, you won’t have to override this initializer for each specific coin subclass.
  public convenience init() {
    let diameter = type(of: self).standardDiameter
    let weight = type(of: self).standardWeight
    self.init(diameter: diameter, weight: weight)
  }
}


extension Coin: CustomStringConvertible {
  public var description: String {
    return String(format: "%@ {diameter: %0.3f, dollarValue: $%0.2f, weight: %0.3f}",
                  "\(type(of: self))", diameter, dollarValue, weight)
  }
}


/*:
 ## Coin types
 */
public class Penny: Coin {
  
  public override class var standardDiameter: Double {
    return 0.75
  }
  public override class var standardWeight: Double {
    return 2.5
  }
  public override var centValue: Int { return 1 }
}

//Nickel
public class Nickel: Coin {
  
  public override class var standardDiameter: Double {
    return 0.835
  }
  public override class var standardWeight: Double {
    return 5.0
  }
  public override var centValue: Int { return 5 }
}

//Dime
public class Dime: Coin {
  public override class var standardDiameter: Double {
    return 0.705
  }
  
  public override class var standardWeight: Double {
    return 2.268
  }
  public override var centValue: Int { return 10 }
}

//Quarter
public class Quarter: Coin {
  public override class var standardDiameter: Double {
    return 0.955
  }
  
  public override class var standardWeight: Double {
    return 5.670
  }
  public override var centValue: Int { return 25 }
}

/*:
 ## HandlerProtocol
 */
public protocol CoinHandlerProtocol {
  var next: CoinHandlerProtocol? { get }
  func handleCoinValidation(_ uknownCoin: Coin) -> Coin?
}

/*:
 ## Concreate Handler
 */
public class CoinHandler {
  
  
  
  
  //next will hold onto the next CoinHandler
  public var next: CoinHandlerProtocol?
  //instance we create coinType
  public let coinType: Coin.Type
  //valid range to a specific coin
  public let diameterRange: ClosedRange<Double>
  public let weightRange: ClosedRange<Double>
  
  //
  public init(coinType: Coin.Type,
              diameterVariation: Double = 0.01,
              weightVariation: Double = 0.05) {
    self.coinType = coinType
    
    let standardDiameter = coinType.standardDiameter
    self.diameterRange = (1-diameterVariation)*standardDiameter ...
      (1+diameterVariation) * standardDiameter
    
    let stantardWeight = coinType.standardWeight
    self.weightRange = (1-weightVariation) * stantardWeight ...
      (1+weightVariation) * stantardWeight
  }
}


extension CoinHandler: CoinHandlerProtocol {
  
  //first attempt to create a Coin via createCoin(from:) that is defined after this method. If you can’t create a Coin, you give the next handler a chance to attempt to create one.
  public func handleCoinValidation(_ uknownCoin: Coin) -> Coin? {
    guard let coin = createCoin(from: uknownCoin) else {
      return next?.handleCoinValidation(uknownCoin) }
    return coin
  }
  
  //validate that the passed-in uknownCoin actually meets the requirements to create
  //the specific coin give by coinType.
  //
  private func createCoin(from uknownCoin: Coin) -> Coin? {
    print("Attempt to create \(coinType)")
    guard diameterRange.contains(uknownCoin.diameter) else { print("Invalid diameter")
      return nil
    }
    guard weightRange.contains(uknownCoin.weight) else {
      print("Invalid weight")
      return nil
    }
    let coin = coinType.init(diameter: uknownCoin.diameter, weight: uknownCoin.weight)
    print("Created \(coin)")
    return coin
  }
}
/*:
 ## Client
 */
public class VendingMachine {
  
  //VendingMachine doesn’t need to know that its coinHandler is actually a chain of handlers, but instead it simply treats this as a single object. You’ll use coins to hold onto all of the valid, accepted coins.
  
  public let coinHandler: CoinHandler
  public var coins: [Coin] = []
  
  public init(coinHandler: CoinHandler) {
    self.coinHandler = coinHandler
  }
  
  public func insertCoin(_ uknownCoin: Coin) {
    guard let coin = coinHandler.handleCoinValidation(uknownCoin)
      else {
        print("Coin rejected: \(uknownCoin)")
        return
    }
    print("Coin Accepted: \(coin)")
    coins.append(coin)
    
    let dollarValue = coins.reduce(0, { $0 + $1.dollarValue })
    print("Coins Total Value: $\(dollarValue)")
    
    let weight = coins.reduce(0, { $0 + $1.weight })
    print("Coins Total Weight: \(weight) g")
    print("")
  }
}
/*:
 ## Example
 */
//01. Before you can instantiate a VendingMachine, you must first set up the coinHandler
//objects for it.
let pennyHandler = CoinHandler(coinType: Penny.self)
let nickleHandler = CoinHandler(coinType: Nickel.self)
let dimeHandler = CoinHandler(coinType: Dime.self)
let quearterHandler = CoinHandler(coinType: Quarter.self)

//02. next properties for the handlers. In this case, pennyHandler will be the first handler, followed by nickleHandler, dimeHandler and lastly quarterHandler in the chain. Since there aren’t any other handlers after quarterHandler, you leave its next set to nil.
pennyHandler.next = nickleHandler
nickleHandler.next = dimeHandler
dimeHandler.next = quearterHandler

//03. lastly create vendingMachine by passing pennyHandler as the coinHandler.
let vendingMachine = VendingMachine(coinHandler: pennyHandler)


let penny = Penny()
vendingMachine.insertCoin(penny)

let quarter = Coin(diameter: Quarter.standardDiameter, weight: Quarter.standardWeight)
vendingMachine.insertCoin(quarter)

//reject the coin because it's weight is from Dime coin
let invalidDime = Coin(diameter: Quarter.standardDiameter, weight: Dime.standardWeight)
vendingMachine.insertCoin(invalidDime)

