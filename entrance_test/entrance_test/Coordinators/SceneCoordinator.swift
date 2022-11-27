import UIKit
import Combine

class SceneCoordinator: RootCoordinator {
	private var isOnSplashScreen: Bool = true

	override init(with router: AppRouter, dependency: AppDependency) {
		super.init(with: router, dependency: dependency)
        if let profile = dependency.profile {
            showDashboard(profile: profile)
        } else {
            showLogin()
        }
        
	}
}

// MARK: - Routing

extension SceneCoordinator {
    private func showLogin() {
        let viewModel = LoginViewModel(dependency: dependency)
        let coordinator = LoginCoordinator(with: NavigationRouter(), viewModel: viewModel)
        
        coordinator.showDashboard = { [weak self] profile in
            self?.showDashboard(profile: profile)
        }
        
        childCoordinators.forEach { child in
            removeChild(child)
        }
        
        // Add new child
        addChild(coordinator)
        router.setRootModule(coordinator, transitionOptions: defaultTransitionOptions)
    }
    
    private func showDashboard(profile: UserProfile) {
        let viewModel = DashboardViewModel(dependency: dependency, userProfile: profile)
        let controller = DashboardViewController.instance(viewModel: viewModel)
        
        controller.onLogout = { [weak self] in
            self?.showLogin()
        }
        
        router.setRootModule(controller, transitionOptions: defaultTransitionOptions)
    }
}

private let defaultTransitionOptions = UIWindow.TransitionOptions(direction: .fade, style: .easeIn)
private let toLeftTransitionOptions = UIWindow.TransitionOptions(direction: .toLeft, style: .easeIn)
private let toRightTransitionOptions = UIWindow.TransitionOptions(direction: .toRight, style: .easeIn)
