import Foundation

/*:
 
 # Builder
 - - - - - - - - - -
 ![Builder Diagram](Builder_Diagram.png)
 
 The builder pattern allows complex objects to be created step-by-step instead of all-at-once via a large initializer.
 
 The builder pattern involves three parts:
 
 (1) The **product** is the complex object to be created.
 
 (2) The **builder** accepts inputs step-by-step and ultimately creates the product.
 
 (3) The **director** supplies the builder with step-by-step inputs and requests the builder create the product once everything has been provided.
 */
/*:
 ## Products
 */

public struct Hamburger {
  public let meat: Meat
  public let sauce: Sauces
  public let toppings: Toppings
}


extension Hamburger: CustomStringConvertible {
  public var description: String {
    return meat.rawValue + " burger"
  }
  
}


public enum Meat: String {
  case beef
  case chicken
  case kitten
  case tofu
}

//You define Sauces as an OptionSet. This will allow you to combine multiple sauces together.
//My personal favorite is ketchup-mayonnaise-secret sauce
public struct Sauces: OptionSet {
  public static let mayonnaise = Sauces(rawValue: 1 << 0)
  public static let mustard = Sauces(rawValue: 1 << 1)
  public static let ketchup = Sauces(rawValue: 1 << 2)
  public static let secret = Sauces(rawValue: 1 << 3)
  
  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}

public struct Toppings: OptionSet {
  public static let cheese = Toppings(rawValue: 1 << 0)
  public static let lettuce = Toppings(rawValue: 1 << 1)
  public static let pickles = Toppings(rawValue: 1 << 2)
  public static let tomatoes = Toppings(rawValue: 1 << 3)
  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}


/*:
 ## Builder
 */

public class HumbergerBuilder {
  
  
  public private(set) var meat: Meat = .beef
  public private(set) var sauces: Sauces = []
  public private(set) var toppings: Toppings = []
  private var soldOutMeats: [Meat] = [.kitten]
  
  //2
  public func addSauces(_ sauce: Sauces) {
    sauces.insert(sauce)
  }
  
  public func removeSauces(_ sauce: Sauces) {
    sauces.remove(sauce)
  }
  
  public func addToppings(_ topping: Toppings) {
    toppings.insert(topping)
  }
  
  public func removeToppings(_ topping: Toppings) {
    toppings.remove(topping)
  }
  
  //Check if the meat isAvailable
  public func isAvailable(_ meat: Meat) -> Bool {
    return !soldOutMeats.contains(meat)
  }
  
  public func setMeat(_ meat: Meat) throws {
    guard isAvailable(meat) else { throw Error.soldOut}
    self.meat = meat
  }
  
  public enum Error: Swift.Error {
    case soldOut
  }
  
  //create Hamburger from selections
  public func build() -> Hamburger {
    return Hamburger(meat: meat, sauce: sauces, toppings: toppings)
  }
}


/*:
 ## Director
 */

public class Employee {
  
  public func createCombo1() throws -> Hamburger {
    let builder = HumbergerBuilder()
    try builder.setMeat(.beef)
    builder.addSauces(.secret)
    builder.addToppings([.lettuce, .tomatoes, .pickles])
    return builder.build()
  }
  
  public func createCombo2() throws -> Hamburger {
    let builder = HumbergerBuilder()
    try builder.setMeat(.chicken)
    builder.addSauces([ .ketchup, .mustard, .mayonnaise])
    builder.addToppings([.lettuce, .tomatoes])
    return builder.build()
  }
  
  public func createKittenSpecial() throws -> Hamburger {
    let builder = HumbergerBuilder()
    try builder.setMeat(.kitten)
    builder.addSauces(.mustard)
    builder.addToppings([.lettuce, .tomatoes])
    return builder.build()
  }
}

/*:
 ## EXAMPLE
 */
let burgerFlipper = Employee()

if let combo1 = try? burgerFlipper.createCombo1() {
  print("Nom nom " + combo1.description)
}

if let combo2 = try? burgerFlipper.createCombo2() {
  print("Yummy yummy " + combo2.description)
}

if let kittenBurger = try? burgerFlipper.createKittenSpecial() {
  print("Nom non nom " + kittenBurger.description)
} else {
  print("Sorry, no kitten burgers here...:[")
}
