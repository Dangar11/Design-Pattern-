
//Concreate Router

import UIKit

//Declare ConcreateRouter as a subclass of NSObject. This is required because you’ll later make this conform to UINavigationControllerDelegate.
public class ConcreateRouter: NSObject {
  
    private let navigationController: UINavigationController // push and pop view controllers
    private let routerRootController: UIViewController? // will be set the last view controller
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:] //mapping from UIViewController to on-dismiss closures
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.routerRootController = navigationController.viewControllers.first
        super.init()
        navigationController.delegate = self
    }
}

//MARK: - Router

extension ConcreateRouter: Router {
    
  //Set the onDismissed closure for the given viewController and then push the view controller onto the navigationController to show it.
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismissed
        navigationController.pushViewController(viewController, animated: animated)
    }
    
  /*verify that routerRootController is set. If not, you simply call popToRootViewController(animated:) on the navigationController.
  Otherwise, you call performOnDismissed(for:) to perform the on-dismiss action
  and then pass the routerRootController into popToViewController(_:animated:)
  on the navigationController.*/
  
    public func dismiss(animated: Bool) {
        guard let routerRootController = routerRootController else {
            navigationController.popToRootViewController(animated: animated)
            return
        }
        performOnDismissed(for: routerRootController)
        navigationController.popToViewController(routerRootController, animated: animated)
    }
    
  //guard that there’s an onDismiss for the givenviewController. If not, you simply return early. Otherwise, you call onDismiss and remove it from onDismissForViewController.
    private func performOnDismissed(for viewController: UIViewController) {
        
        guard let onDismiss = onDismissForViewController[viewController] else { return }
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}


//MARK: - UINavigationControllerDelegate
extension ConcreateRouter: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(dismissedViewController) else { return }
        
        performOnDismissed(for: dismissedViewController)
    }
}
