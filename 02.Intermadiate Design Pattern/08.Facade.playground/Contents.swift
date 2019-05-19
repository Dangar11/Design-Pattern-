import Foundation
/*:
 
 # Facade
 - - - - - - - - - -
 ![Multicast Delegate Diagram](Facade_Diagram.png)
 
 The facade pattern is a structural pattern that provides a simple interface to a complex system. It involves two types:
 
 1. The **facade** provides simple methods to interact with the system. This allows consumers to use the facade instead of knowing about and interacting with multiple classes in the system.
 
 2. The **dependencies** are objects owned by the facade. Each dependency performs a small part of a complex task.
 
 */
/*:
 ## Dependencies A
 */

public struct Customer {
  public let identifier: String
  public var address: String
  public var name: String
}

extension Customer: Hashable {
  
  public static func ==(lhs: Customer, rhs: Customer) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}

/*:
 ## Dependencies B
 */

public struct Product {
  public let identifier: String
  public var name: String
  public var cost: Double
}

extension Product: Hashable {
  
  public static func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}



//Stores available inventory
public class InventoryDatabase {
  public var inventory: [Product: Int] = [:]
  
  public init(inventory: [Product: Int]) {
    self.inventory = inventory
  }
}


public class ShippingDatabase {
  public var pendingShipments: [Customer: [Product]] = [:]
}

/*:
 ## Facade
 */

public class OrderFacade {
  public let inventoryDatabase: InventoryDatabase
  public let shippingDatabase: ShippingDatabase
  
  
  public init(inventoryDatabase: InventoryDatabase,
              shippingDatabase: ShippingDatabase) {
    self.inventoryDatabase = inventoryDatabase
    self.shippingDatabase = shippingDatabase
  }
  
  
  public func placeOrder(for product: Product,
                         by customer: Customer) {
    
    //Product name and customer name print to console
    print("Place order for '\(product.name)' by '\(customer.name)'")
    
    //If there isn’t any, you print that the product is out of stock.
    let count = inventoryDatabase.inventory[product, default: 0]
    guard count > 0 else {
      print("\(product.name) is out of stock")
      return
    }
    
    //if one product available -> fullfill the order.
    inventoryDatabase.inventory[product] = count - 1
    
    //add the product ot hte shippingDatabase.pendingShipments for the given customer
    var shipments = shippingDatabase.pendingShipments[customer, default: []]
    shipments.append(product)
    shippingDatabase.pendingShipments[customer] = shipments
    
    //print order successfully placed
    print("Order, placed for \(product.name) " + "by \(customer.name)")
  }
}

/*:
 ## Example
 */

//Set up two products
let iphoneXR = Product(identifier: "product-001",
                       name: "iPhone XR 128GB",
                       cost: 750)

let iphoneXSMax = Product(identifier: "product-002",
                          name: "iPhone XS MAX 512GB",
                          cost: 1200)

//Available products
let inventoryDatabase = InventoryDatabase(inventory: [iphoneXR : 50, iphoneXSMax : 1])



let orderFacade = OrderFacade(inventoryDatabase: inventoryDatabase, shippingDatabase: ShippingDatabase())

//Create customer! Order for iPhone XR.
let customer = Customer(identifier: "customer-001",
                        address: "1600 Pennsylvania Ave, Washington, DC 20006",
                        name: "Igor Tkach")

orderFacade.placeOrder(for: iphoneXR, by: customer)


let customer2 = Customer(identifier: "customer-002",
                         address: "29017 Khmelnitsky, Ukraine",
                         name: "Dmitriy Tkach")

orderFacade.placeOrder(for: iphoneXSMax, by: customer2)
