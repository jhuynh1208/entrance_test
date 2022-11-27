//
//  LoginCoordinator.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import UIKit

class LoginCoordinator: NavigationCoordinator {

    init(with router: NavigationRouter, viewModel: LoginViewModel) {
        super.init(with: router, dependency: viewModel.dependency)
        
        let controller = LoginViewController.instance(viewModel: viewModel)
        
        controller.onTapSignUp = { [weak self] in
            self?.showSignUp()
        }
        
        router.setRootModule(controller, hideBar: true)
    }
}

// MARK: - Routing
extension LoginCoordinator {
    private func showSignUp() {
        let viewModel = SignUpViewModel(dependency: dependency)
        let coordinator = SignUpCoordinator(with: router, viewModel: viewModel)
        
        coordinator.didBackToParent = { [weak self] in
            self?.removeChild(coordinator)
        }
        
        addChild(coordinator)
    }
}
