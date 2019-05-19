import Foundation
/*:
 # Iterator
 - - - - - - - - - -
 ![Iterator Diagram](Iterator_Diagram.png)
 
 The Iterator Pattern provides a standard way to loop through a collection. This pattern involves two types:
 
 1. The Swift `Iterable` protocol defines a type that can be iterated using a `for in` loop.
 
 2. A **custom object** you want to make iterable. Instead of conforming to `Iterable` directly, however, you can conform to `Sequence`, which itself conforms to `Iterable`. By doing so, you'll get many higher-order functions, including `map`, `filter` and more, implemented for free for you.
 
 */
/*:
 ## Iterator Object
 */

//Queue that define array of Any Type
public struct Queue<T> {
  
  private var array: [T?] = []
  
  //2. the head of the queue will be the index of the first element in the array
  private var head = 0
  
  //3. check if the queue empty or not
  public var isEmpty: Bool {
    return count == 0
  }
  
  //4. give Queue a count
  public var count: Int {
    return array.count - head
  }
  
  //5. adding element to the queue
  public mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  //6 remove first element of the queue
  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }
    
    array[head] = nil
    head += 1
    
    let percentage = Double(head)/Double(array.count)
    if array.count > 50, percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }
    return element
  }
}


public struct Ticket {
  var description: String
  var priority: PriorityType
  
  enum PriorityType {
    case low
    case medium
    case high
  }
  
  init(description: String, priority: PriorityType) {
    self.description = description
    self.priority = priority
  }
}

/*:
 ## Example
 */

var queue = Queue<Ticket>()
queue.enqueue(Ticket(description: "Wireframe Tinder for dogs app", priority: .low))
queue.enqueue(Ticket(description: "Set up 4k monitor for Josh", priority: .medium))
queue.enqueue(Ticket(description: "There is smoke coming out of my laptop", priority: .high))
queue.enqueue(Ticket(description: "Put googly eyes on the Roomba", priority: .low))
queue.dequeue()
queue.count
queue.isEmpty



/*:
 ## Iterator Protocol
 */

extension Queue: Sequence {
  public func makeIterator() -> IndexingIterator<ArraySlice<T?>> {
    let notEmptyValue = array[head..<array.count]
    return notEmptyValue.makeIterator()
  }
}

print("List of the Tickets in queue:")
for ticket in queue {
  print(ticket?.description ?? "No Description")
}

extension Ticket {
  var sortIndex: Int {
    switch self.priority {
    case .low:
      return 0
    case .medium:
      return 1
    case .high:
      return 2
    }
  }
}

/*:
 ## Example
 */

let sortedTickets = queue.sorted { $0!.sortIndex > ($1?.sortIndex)!}
var sortedQueue = Queue<Ticket>()

for ticket in sortedTickets {
  sortedQueue.enqueue(ticket!)
}

print("\n")
print("Tickets sorted by priority:")
for ticket in sortedQueue {
  print("\(ticket!.priority) : \(ticket!.description)" )
}

