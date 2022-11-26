//
//  SignUpViewController.swift
//  entrance_test
//
//  Created by Thiện on 26/11/2022.
//

import UIKit

class SignUpViewController: BaseViewController<SignUpViewModel> {

    // MARK: - Init
    class func instance(viewModel: SignUpViewModel) -> SignUpViewController {
        let controller = instance(storyboardName: "Main") as! SignUpViewController
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Outlets
    @IBOutlet weak var lblAdventure: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblAgree: UILabel!
    @IBOutlet weak var lblPolicyTerm: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblHaveAccount: UILabel!
    @IBOutlet weak var lblSignin: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    
    // MARK: - Properties
    
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindToViewModel()
    }

    // MARK: - Actions
    @IBAction func didTapBtnCheck(_ sender: Any) {
        viewModel.isAgreePolicyTerm = !viewModel.isAgreePolicyTerm
    }
    
    @IBAction func didTapBtnSignUp(_ sender: Any) {
        
    }
    
    @IBAction func didTapBtnSocial(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Social login", message: "This function is applying. Please check it again later!!!!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertVC, animated: true)
    }
    
    @objc private func didTapLblPolicyTerm() {
        let alertVC = UIAlertController(title: "Privacy policy & Term", message: "This function is applying. Please check it again later!!!!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertVC, animated: true)
    }
    
    @objc private func didTapLblSignIn() {
        
    }
}

// MARK: - Helper methods
extension SignUpViewController {
    private func initUI() {
        lblAdventure.font = UIFont.montserratMedium(size: 18)
        lblAdventure.textColor = UIColor.AppColor.lightDark
        
        lblSubtitle.font = UIFont.montserratRegular(size: 14)
        lblSubtitle.textColor = UIColor.AppColor.textGray
        
        lblAgree.font = UIFont.montserratRegular(size: 14)
        lblAgree.textColor = UIColor.AppColor.textGray
        
        lblPolicyTerm.font = UIFont.montserratRegular(size: 14)
        lblPolicyTerm.textColor = UIColor.AppColor.lightPurple
        lblPolicyTerm.isUserInteractionEnabled = true
        lblPolicyTerm.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLblPolicyTerm)))
        
        lblHaveAccount.font = UIFont.montserratRegular(size: 14)
        lblHaveAccount.textColor = UIColor.AppColor.textGray
        
        lblSignin.font = UIFont.montserratRegular(size: 14)
        lblSignin.textColor = UIColor.AppColor.lightPurple
        lblSignin.isUserInteractionEnabled = true
        lblSignin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLblSignIn)))
        
        lblOr.font = UIFont.montserratRegular(size: 14)
        lblOr.textColor = UIColor.AppColor.textGray
        
        btnSignUp.layer.cornerRadius = 5
        let btnAttributedText = NSAttributedString(string: "Sign Up",
                                                   attributes: [
                                                    .font: UIFont.montserratMedium(size: 14),
                                                    .foregroundColor: UIColor.white
                                                   ])
        btnSignUp.titleLabel?.attributedText = btnAttributedText
        
        btnCheck.layer.borderColor = UIColor(hex: 0xD8D6DE).cgColor
        btnCheck.layer.borderWidth = 1
        btnCheck.layer.cornerRadius = 3
    }
    
    private func bindToViewModel() {
        viewModel.$isAgreePolicyTerm
            .sink { [weak self] isAgree in
                guard let `self` = self else { return }
                if isAgree {
                    self.btnCheck.layer.borderWidth = 0
                    self.btnCheck.backgroundColor = .AppColor.lightPurple
                } else {
                    self.btnCheck.layer.borderWidth = 1
                    self.btnCheck.backgroundColor = .clear
                }
            }
            .store(in: &viewModel.subscriptions)
    }
}
