

 // Multicast Delegate



//You define MulticastDelegate as a generic class that accepts any ProtocolType as the generic type.
public class MulticastDelegate<ProtocolType> {
    
    //MARK: - DelegateWrapper
  
    //inner class weak delegate
    private class DelegateWrapper {
        weak var delegate: AnyObject?
        
        init(_ delegate: AnyObject) {
            self.delegate = delegate
        }
    }
    
    //MARK: - Instance Properties
    //
    private var delegateWrappers: [DelegateWrapper]
    
  //Add a computed property for delegates. This filters out delegates from delegateWrappers that have already been released and then returns an array of definitely non-nil delegates.
    public var delegates: [ProtocolType] {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }
        return delegateWrappers.map { $0.delegate! } as! [ProtocolType]
    }
    
    //MARK: - Object Lifecycle
  
    //lastly create an initializer that accepts an array of delegates and maps these to create delegateWrappers.
    public init(delegates: [ProtocolType] = []) {
        delegateWrappers = delegates.map { DelegateWrapper($0 as AnyObject)}
    }
  
  
    //MARK: - Delegate Management
  
  //As its name implies, you’ll use addDelegate to add a delegate instance, which creates a DelegateWrapper and appends it to the delegateWrappers.
    public func addDelegate(_ delegate: ProtocolType) {
        let wrapper = DelegateWrapper(delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }
    
    //2
    public func removeDelegate(_ delegate: ProtocolType) {
      guard let index = delegateWrappers.firstIndex(where: { $0.delegate === (delegate as AnyObject)}) else {
            return
        }
        delegateWrappers.remove(at: index)
    }
  
  //You iterate through delegates, the computed property you defined before that automatically filters out nil instances, and call the passed-in closure on each delegate instance.
  public func invokeDelegates(_ closure: (ProtocolType) -> ()) {
    delegates.forEach { closure($0) }
  }
    
}
