//
//  DashboardViewController.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import UIKit
import SideMenu

class DashboardViewController: BaseViewController<DashboardViewModel> {

    // MARK: - Init
    class func instance(viewModel: DashboardViewModel) -> DashboardViewController {
        let controller = instance(storyboardName: "Main") as! DashboardViewController
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Outlets
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var imgViewAvatar: UIImageView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblCopyright: UILabel!
    
    var onLogout: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    @IBAction func didTapBtnMenu(_ sender: Any) {
        let sideMenuVC = SideMenuViewController.instance(viewModel: SideMenuViewModel(dependency: viewModel.dependency))
        
        sideMenuVC.onLogout = { [weak self] in
            self?.handleLogout()
        }
        
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: sideMenuVC)
        leftMenuNavigationController.leftSide = true
        present(leftMenuNavigationController, animated: true)
    }
}

// MARK: - Helper Methods
extension DashboardViewController {
    private func initUI() {
        lblName.textColor = .AppColor.textGray
        lblName.text = self.viewModel.userProfile?.displayName
        lblAvailable.textColor = UIColor(red: 0.431, green: 0.42, blue: 0.482, alpha: 1)
        lblAvailable.text = "Available"
        lblWelcome.textColor = .AppColor.lightDark
        lblCopyright.textColor = .AppColor.textGray
    }
    
    private func handleLogout() {
        self.viewModel.logout { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Logout Error", message: "\(error.localizedDescription)")
            } else {
                self?.onLogout?()
            }
        }
    }
}
