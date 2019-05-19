import Foundation

//Declare new generic class
public class Observable<Type> {
    
    //MARK: - Callback
    //observer is a weak property, so it's required to be a class
    //denote it as AnyObject.
    //automatically remover observers that become nil
    fileprivate class Callback {
        fileprivate weak var observer: AnyObject?
        fileprivate let options: [ObservableOptions]
        fileprivate let closure: (Type, ObservableOptions) -> Void
        
        fileprivate init(
            observer: AnyObject,
            options: [ObservableOptions],
            closure: @escaping (Type, ObservableOptions) -> Void) {
            self.observer = observer
            self.options = options
            self.closure = closure
        }
    }
    
    //MARK: - Properties of generic Type
    public var value: Type {
        //call whenever value has been changed
        didSet {
            //remove anyCallbaks that have an observer to nil
            //This prevents calling a closure related to an observer that's already been released from memory
            removeNilObservingCallbacks()
            //passing oldValue and .old and the .new filter callbacks mathching the given option and calls
            //closures on each
            notifyCallbacks(value: oldValue, option: .old)
            notifyCallbacks(value: value, option: .new)
        }
    }
    
    private func removeNilObservingCallbacks() {
        callbacks = callbacks.filter { $0.observer != nil }
    }
    
    private func notifyCallbacks(value: Type, option: ObservableOptions) {
        let callbacksToNotify = callbacks.filter {
            $0.options.contains(option)
        }
        callbacksToNotify.forEach { $0.closure(value, option) }
    }
    
    //MARK: - Object Lifecycle
    public init(_ value: Type) {
        self.value = value
    }
    
    //Managing Observers
    //hold registered Callback instances
    private var callbacks: [Callback] = []
    
    //register an observer for the given options and closure
    public func addObserver(_ observer: AnyObject,
                            removerIfExtists: Bool = true,
                            options: [ObservableOptions] = [.new],
                            closure: @escaping (Type, ObservableOptions) -> Void) {
        //if true remove existing callbaks for the observer.
        
        if removerIfExtists {
            removeObserver(observer)
        }
        
        //create new callback and append this to observers
        let callback = Callback(observer: observer,
                                options: options,
                                closure: closure)
        callbacks.append(callback)
        
        //if options include initial, immediately call the callback closure
        if options.contains(.initial) {
            closure(value, .initial)
        }
    }
    
    //unregister an observer and remove all related closures
    public func removeObserver(_ observer: AnyObject) {
        //Set observers by filtering out existin objects that don't match the passed-in observer to be removed
        callbacks = callbacks.filter { $0.observer !== observer }
    }
}

//MARK: - ObservableOptions
//
public struct ObservableOptions: OptionSet {
    
    public static let initial = ObservableOptions(rawValue: 1 << 0)
    public static let old = ObservableOptions(rawValue: 1 << 1)
    public static let new = ObservableOptions(rawValue: 1 << 2)
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

