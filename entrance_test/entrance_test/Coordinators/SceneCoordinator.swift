import UIKit
import Combine

class SceneCoordinator: RootCoordinator {
	private var deeplink: DeepLink?
	private var isOnSplashScreen: Bool = true

	override init(with router: AppRouter, dependency: AppDependency) {
		super.init(with: router, dependency: dependency)
        let token = dependency.tokenable
        print("====> token \(token.token)")
        showLogin()
//        self.showSignUp()
	}

	override func start(with deeplink: DeepLink?) {
		self.deeplink = deeplink
	}
}

// MARK: - Routing

extension SceneCoordinator {
    private func showLogin() {
        let viewModel = LoginViewModel(dependency: dependency)
        let coordinator = LoginCoordinator(with: NavigationRouter(), viewModel: viewModel)
        
        childCoordinators.forEach { child in
            removeChild(child)
        }
        
        // Add new child
        addChild(coordinator)
        router.setRootModule(coordinator, transitionOptions: defaultTransitionOptions)
    }
}

private let defaultTransitionOptions = UIWindow.TransitionOptions(direction: .fade, style: .easeIn)
private let toLeftTransitionOptions = UIWindow.TransitionOptions(direction: .toLeft, style: .easeIn)
private let toRightTransitionOptions = UIWindow.TransitionOptions(direction: .toRight, style: .easeIn)
