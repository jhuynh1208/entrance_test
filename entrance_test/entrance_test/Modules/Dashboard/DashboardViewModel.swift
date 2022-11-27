//
//  DashboardViewModel.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import UIKit

class DashboardViewModel: BaseViewModel {
    
    var userProfile: UserProfile?
    
    private lazy var apiManager = AuthAPIManager(token: dependency.tokenable)
    
    init(dependency: AppDependency, userProfile: UserProfile) {
        super.init(dependency: dependency)
        self.userProfile = userProfile
    }
}

// MARK: - APIs
extension DashboardViewModel {
    func logout(completion: @escaping (APIError?) -> Void) {
        apiManager.logout()
            .sink { incomplete in
                switch incomplete {
                case .finished: break
                case .failure(let error):
                    completion(error)
                }
            } receiveValue: { [weak self] _ in
                self?.dependency.tokenable = Session(token: nil)
                self?.dependency.profile = nil
                completion(nil)
            }
            .store(in: &subscriptions)

        
    }
}
