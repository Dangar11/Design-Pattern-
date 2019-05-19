

public protocol Coordinator: class {
    
  /* declare relationship properties for children and router.
  You’ll use theseproperties to provide default implementations within an extension on Coordinator next.*/
  
    var children: [Coordinator] { get set }
    var router: Router { get }
    
    //: You also declare required methods for present, dismiss and presentChild.
    func present(animated: Bool, onDismissed: (() -> Void)?)
    func dismiss(animated: Bool)
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)?)
}


extension Coordinator {
    
    
    public func dismiss(animated: Bool) {
        router.dismiss(animated: true)
    }
    
  
    public func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)? = nil) {
        children.append(child)
        child.present(animated: animated, onDismissed: { [weak self, weak child] in
            guard let self = self, let child = child else { return }
            self.removeChild(child)
            onDismissed?()
        })
    }
    
    private func removeChild(_ child: Coordinator) {
        guard let index = children.firstIndex(where: { $0 === child })
            else { return }
        children.remove(at: index)
    }
}
