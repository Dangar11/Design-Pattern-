import Foundation

/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Observer
 - - - - - - - - - -
 ![Observer Diagram](Observer_Diagram.png)
 
 The observer pattern allows "observer" objects to register for and receive updates whenever changes are made to "subject" objects.
 
 This pattern allows us to define "one-to-many" relationships between many observers receiving updates from the same subject.
 
 ## Code Example
 */


//MARK: - KVO
//@objcMember same as @objc
//KVOUser is the NSObject subject we observe
@objcMembers public class KVOUser: NSObject {
  //dynamic - dynamic dispatch system of Objective-C used to call getter and setter.
  //It's means never,ever, static or virtual dispatch be used even from Swift.
  //required for KVO to work
  dynamic var name: String
  
  //simple initilizer that sets the value of name
  public init(name: String) {
    self.name = name
  }
}

print("-- KVO Example --")


let kvoUser = KVOUser(name: "Ray")

//observer object kvoUser.observe this is the KVO magic happens!
var kvoObserver: NSKeyValueObservation? = kvoUser.observe(\.name, options: [.initial, .new]) { (user, change) in
  
  print("User's name is \(user.name)")
}

kvoUser.name = "Rockin' Ray"
kvoObserver = nil
kvoUser.name = "Ray has left the building"


//MARK: - Observable Example
//User Subject
public class User {
  public let name: Observable<String>
  public init(name: String) {
    self.name = Observable(name)
  }
}

public class Observer { }


//1
print("")
print("-- Observable Exaple --")

//User oberving class
let user = User(name: "Madeline")

//create new observer which you then register to observe initial and new values for user.name
var observer: Observer? = Observer()
user.name.addObserver(observer!, options: [.initial, .new]) { (name, change) in
  print("User's name is \(name)")
}

user.name.value = "Amelia"
observer = nil
user.name.value = "Amelia is outta here!"
