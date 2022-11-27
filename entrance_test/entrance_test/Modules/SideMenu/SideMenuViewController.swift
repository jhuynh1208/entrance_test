//
//  SideMenuViewController.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import UIKit

class SideMenuViewController: BaseViewController<SideMenuViewModel> {
    
    // MARK: - Init
    class func instance(viewModel: SideMenuViewModel) -> SideMenuViewController {
        let controller = instance(storyboardName: "Main") as! SideMenuViewController
        controller.viewModel = viewModel
        return controller
    }
    
    var onLogout: (() -> Void)?
    
    // MARK: - Outlets
    @IBOutlet weak var btnLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initUI()
    }
    
    @IBAction func didTapBtnLogout(_ sender: Any) {
        self.dismiss(animated: true)
        self.onLogout?()
    }
}
