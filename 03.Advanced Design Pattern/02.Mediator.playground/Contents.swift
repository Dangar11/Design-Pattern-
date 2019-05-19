/*:
 
 # Mediator
 - - - - - - - - - -
 ![Mediator Diagram](Mediator_Diagram.png)
 
 The mediator pattern is a behavioral design pattern that encapsulates how objects communicate with one another. It involves four types:
 
 1. The **colleagues** are the objects that want to communicate with each other. They implement the colleague protocol.
 
 2. The **colleague protocol** defines methods and properties that each colleague must implement.
 
 3. The **mediator** is the object that controls the communication of the colleagues. It implements the mediator protocol.
 
 4. The **mediator protocol** defines methods and properties that the mediator must implement.
 
 */
/*:
 ## Colleague Protocol
 */
public protocol Colleague: class {
  func colleague(_ colleague: Colleague?, didSendMessage message: String)
}
/*:
 ## MediatorProtocol
 */
public protocol MediatorProtocol: class {
  func addColleague(_ colleague: Colleague)
  func sendMessage(_ message: String, by colleague: Colleague)
}
/*:
 ## Colleague
 */
public class Musketeer {
  
  
  public var name: String
  public weak var mediator: MediatorProtocol?
  
  //register this colleague, conform to Colleague next
  public init(mediator: MediatorProtocol, name: String) {
    self.mediator = mediator
    self.name = name
    mediator.addColleague(self)
  }
  
  //Ideally, the mediator should then forward this message onto all of the other colleagues.
  public func sendMessage(_ message: String) {
    print("\(name) sent: \(message)")
    mediator?.sendMessage(message, by: self)
  }
}


extension Musketeer: Colleague {
  public func colleague(_ colleague: Colleague?, didSendMessage message: String) {
    print("\(name) received \(message)")
  }
}



//MARK: - Mediator

// 1. You create MusketeerMediator as a subclass of Mediator<Colleague>, and you make this conform to MediatorProtocol via an extension.
public class MusketeerMediator: Mediator<Colleague> {
  
}

extension MusketeerMediator: MediatorProtocol {
  
  // 2. Within addColleague(_:), you call its super class’ method for adding a colleague, addColleague(_:strongReference:).
  public func addColleague(_ colleague: Colleague) {
    self.addColleague(colleague, strongReference: true)
  }
  
  // Within sendMessage(_:by:), you call its super class’ methodinvoke Colleagues(by:) to send the passed-in message to all colleagues except for the matching passed-in colleague.
  public func sendMessage(_ message: String, by colleague: Colleague) {
    invokeColleagues(by: colleague) {
      $0.colleague(colleague, didSendMessage: message)
    }
  }
  
}
/*:
 ## Example
 */
let mediator = MusketeerMediator()
let athos = Musketeer(mediator: mediator, name: "Athos")
let porthos = Musketeer(mediator: mediator, name: "Porthos")
let aramis = Musketeer(mediator: mediator, name: "Aramis")

athos.sendMessage("One for all...!")
print("")

porthos.sendMessage("and all for one...!")
print("")

aramis.sendMessage("Unus pro omnibus, omnes pro uno")

mediator.invokeColleagues() {
  $0.colleague(nil, didSendMessage: "Charge!")
  
  
}
