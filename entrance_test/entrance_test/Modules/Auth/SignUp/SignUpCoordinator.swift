//
//  SignUpCoordinator.swift
//  entrance_test
//
//  Created by Thiện on 26/11/2022.
//

import Foundation

class SignUpCoordinator: NavigationCoordinator {
    
    init(with router: NavigationRouter, viewModel: SignUpViewModel) {
        super.init(with: router, dependency: viewModel.dependency)
        
        let controller = SignUpViewController.instance(viewModel: viewModel)
        
        router.setRootModule(controller, hideBar: true)
    }
}
