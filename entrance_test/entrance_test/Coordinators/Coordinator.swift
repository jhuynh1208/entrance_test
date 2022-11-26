import UIKit

public protocol CoordinatorType: AnyObject, Presentable {
    associatedtype DeepLinkType
    associatedtype DependencyType
    associatedtype Router: RouterType

    var router: Router { get }

    func start()
    func start(with deeplink: DeepLinkType?)
}

public class Coordinator<DeepLinkType, DependencyType, Router: RouterType>: NSObject, CoordinatorType {
    public let router: Router
    public var dependency: DependencyType
    public var childCoordinators: [Coordinator<DeepLinkType, DependencyType, NavigationRouter>] = []

    public init(with router: Router, dependency: DependencyType) {
        self.router = router
        self.dependency = dependency
        super.init()
    }

    public func start() {
        start(with: nil)
    }

    public func start(with deeplink: DeepLinkType?) {}

    public func addChild(_ coordinator: Coordinator<DeepLinkType, DependencyType, NavigationRouter>) {
        childCoordinators.append(coordinator)
    }

    public func removeChild(_ coordinator: Coordinator<DeepLinkType, DependencyType, NavigationRouter>?) {
        guard let coordinator = coordinator, let index = childCoordinators.firstIndex(where: { $0 === coordinator }) else {
            return
        }

        childCoordinators.remove(at: index)
    }

    public func toPresentable() -> UIViewController {
        return router.toPresentable()
    }
}

extension Coordinator {
    var currentSceneDelegate: SceneDelegate {
        return router.toPresentable().view.window!.windowScene!.delegate as! SceneDelegate
    }
}

typealias RootCoordinator = Coordinator<DeepLink, AppDependency, AppRouter>
typealias NavigationCoordinator = Coordinator<DeepLink, AppDependency, NavigationRouter>
