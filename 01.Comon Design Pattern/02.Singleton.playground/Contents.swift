/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Singleton
 - - - - - - - - - -
 ![Singleton Diagram](Singleton_Diagram.png)
 
 The singleton pattern restricts a class to have only _one_ instance.
 
 The "singleton plus" pattern is also common, which provides a "shared" singleton instance, but it also allows other instances to be created too.

 */

/*:
 
 ## SINGLETON
 ### private init()
 
 */

import UIKit

//MARK: - Singleton
let app = UIApplication.shared
//let app2 = UIApplication() Singleton one instance only


public class MySingleton {
  //singleton instance
  static let shared = MySingleton()
  //prevent the creation of additional instances
  private init() { }
}

let mySingleton = MySingleton.shared
//Error only one shared instance
//let mySingleton2 = MySingleton()

/*:
 
 ## SINGLETON PLUS
 ### public init()
 
 */
//MARK: - Singleton Plus
let defaultFileManager = FileManager.default
let customFileManager = FileManager()

public class MySingletonPlus {
  
  
  static let shared = MySingletonPlus()
  
  //public
  public init() { }
}

//get singleton instance
let singletonPlus = MySingletonPlus.shared

//create new instances
let singletonPlus2 = MySingletonPlus()
