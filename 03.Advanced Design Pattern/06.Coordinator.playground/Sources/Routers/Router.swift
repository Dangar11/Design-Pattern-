

import UIKit

public protocol Router: class {
    
    //Declare two present methods
    func present(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?)
    
    //dismiss entire router.
    func dismiss(animated: Bool)
}

extension Router {
    
    public func present(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, onDismissed: nil)
    }
}
