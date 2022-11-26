//
//  BaseViewModel.swift
//  entrance_test
//
//  Created by Huỳnh Thiện on 12/11/2022.
//

import Foundation
import Combine

class BaseViewModel {
    let dependency: AppDependency
    var subscriptions: Set<AnyCancellable> = Set()
    
    // MARK: - Initialization

    init(dependency: AppDependency) {
        self.dependency = dependency
    }
}
