//
//  DashboardViewModel.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import UIKit

class DashboardViewModel: BaseViewModel {
    
    var userProfile: UserProfile?
    
    init(dependency: AppDependency, userProfile: UserProfile) {
        super.init(dependency: dependency)
        self.userProfile = userProfile
    }
}
