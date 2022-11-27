//
//  SignUpCoordinator.swift
//  entrance_test
//
//  Created by Thiện on 26/11/2022.
//

import Foundation

class SignUpCoordinator: NavigationCoordinator {
    
    var didBackToParent: (() -> Void)?
    
    init(with router: NavigationRouter, viewModel: SignUpViewModel) {
        super.init(with: router, dependency: viewModel.dependency)
        
        let controller = SignUpViewController.instance(viewModel: viewModel)
        
        controller.onTapSignIn = { [weak self] in
            self?.router.popModule()
            self?.didBackToParent?()
        }
        
        
        router.push(controller)
    }
}
