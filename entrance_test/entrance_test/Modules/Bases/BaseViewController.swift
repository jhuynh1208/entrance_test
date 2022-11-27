//
//  BaseViewController.swift
//  entrance_test
//
//  Created by Huỳnh Thiện on 12/11/2022.
//

import UIKit

class BaseViewController<ViewModel: BaseViewModel>: UIViewController {

    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Alert Helper Methods
extension BaseViewController {
    func showAlert(title: String? = nil, message: String? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
