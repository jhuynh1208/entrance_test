import UIKit

public protocol RouterType: AnyObject, Presentable {
    func setRootModule(_ module: Presentable)
}

public protocol PresentationRouterType: RouterType {
    func present(_ module: Presentable)
    func present(_ module: Presentable,
                 modalPresentationStyle: UIModalPresentationStyle,
                 animated: Bool)
    func present(_ module: Presentable,
                 transitioningDelegate: UIViewControllerTransitioningDelegate,
                 animated: Bool)
    func dismissModule()
    func dismissModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
}

public extension PresentationRouterType {
    func present(_ module: Presentable) {
        present(module, animated: true)
    }

    func present(_ module: Presentable,
				 modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
                 animated: Bool) {
        let controller = module.toPresentable()
        controller.modalPresentationStyle = modalPresentationStyle
        toPresentable().present(controller, animated: animated, completion: nil)
    }

    func present(_ module: Presentable,
                 transitioningDelegate: UIViewControllerTransitioningDelegate,
                 animated: Bool) {
        let controller = module.toPresentable()
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = transitioningDelegate
        toPresentable().present(controller, animated: animated, completion: nil)
    }

    func dismissModule() {
        dismissModule(animated: true)
    }

    func dismissModule(animated: Bool) {
        dismissModule(animated: animated, completion: nil)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        toPresentable().dismiss(animated: animated, completion: completion)
    }
}

public protocol NavigationRouterType: PresentationRouterType {
    typealias FinishHandler = () -> Void

    func push(_ module: Presentable)
    func push(_ module: Presentable, animated: Bool)
    func push(_ module: Presentable, animated: Bool, finishHandler: (() -> Void)?)
    func popModule()
    func popModule(animated: Bool)
    func setRootModule(_ module: Presentable, hideBar: Bool)
    func popToRootModule()
    func popToRootModule(animated: Bool)
    func setControllers(viewControllers: [UIViewController], animated: Bool)
}
