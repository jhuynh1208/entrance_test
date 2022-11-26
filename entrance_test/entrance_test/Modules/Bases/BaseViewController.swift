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
