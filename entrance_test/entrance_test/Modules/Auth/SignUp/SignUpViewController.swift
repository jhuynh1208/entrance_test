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
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var lblFirstNameError: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var lblLastNameError: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var lblPasswordError: UILabel!
    
    // MARK: - Properties
    
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindToViewModel()
    }

    // MARK: - Actions
    @IBAction func didTapBtnCheck(_ sender: Any) {
        self.view.endEditing(true)
        viewModel.isAgreePolicyTerm = !viewModel.isAgreePolicyTerm
    }
    
    @IBAction func didTapBtnSignUp(_ sender: Any) {
        self.handleSignUp()
    }
    
    @IBAction func didTapBtnSocial(_ sender: UIButton) {
        self.view.endEditing(true)
        let alertVC = UIAlertController(title: "Social login", message: "This function is applying. Please check it again later!!!!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertVC, animated: true)
    }
    
    @objc private func didTapLblPolicyTerm() {
        self.view.endEditing(true)
        let alertVC = UIAlertController(title: "Privacy policy & Term", message: "This function is applying. Please check it again later!!!!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertVC, animated: true)
    }
    
    @objc private func didTapLblSignIn() {
        self.view.endEditing(true)
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
        btnSignUp.setAttributedTitle(btnAttributedText, for: .normal)
        
        btnCheck.layer.borderColor = UIColor(hex: 0xD8D6DE).cgColor
        btnCheck.layer.borderWidth = 1
        btnCheck.layer.cornerRadius = 3
        
        initInputField()
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
        
        self.textFieldFirstName.textChangedPublisher()
            .assign(to: \.firstName, on: viewModel)
            .store(in: &viewModel.subscriptions)
        self.textFieldLastName.textChangedPublisher()
            .assign(to: \.lastName, on: viewModel)
            .store(in: &viewModel.subscriptions)
        self.textFieldEmail.textChangedPublisher()
            .assign(to: \.email, on: viewModel)
            .store(in: &viewModel.subscriptions)
        self.textFieldPassword.textChangedPublisher()
            .assign(to: \.password, on: viewModel)
            .store(in: &viewModel.subscriptions)
    }
    
    private func initInputField() {
        lblFirstNameError.isHidden = true
        lblEmailError.isHidden = true
        lblLastNameError.isHidden = true
        lblPasswordError.isHidden = true
        
        self.setAttributedRequired(for: lblFirstName, with: "First Name")
        self.setAttributedRequired(for: lblLastName, with: "Last Name")
        self.setAttributedRequired(for: lblEmail, with: "Email")
        self.setAttributedRequired(for: lblPassword, with: "Password")
        
        textFieldEmail.delegate = self
        textFieldFirstName.delegate = self
        textFieldLastName.delegate = self
        textFieldPassword.delegate = self
    }
    
    private func setAttributedRequired(for label: UILabel, with title: String) {
        let attributedRequiredDot = NSAttributedString(string: "*",
                                                       attributes: [
                                                        .foregroundColor: UIColor.AppColor.error,
                                                        .font: UIFont.montserratRegular(size: 12)
                                                       ])
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.AppColor.textGray,
            .font: UIFont.montserratRegular(size: 12)
        ]
        let attributedTitle = NSMutableAttributedString(string: title,
                                                        attributes: attributes)
        attributedTitle.append(attributedRequiredDot)
        label.attributedText = attributedTitle
    }
    
    private func handleSignUp() {
        let errors = viewModel.validate()
        if !errors.isEmpty {
            for error in errors {
                switch error.type {
                case .firstName:
                    lblFirstNameError.text = error.message
                    lblFirstNameError.isHidden = false
                case .lastName:
                    lblLastNameError.text = error.message
                    lblLastNameError.isHidden = false
                case .email:
                    lblEmailError.text = error.message
                    lblEmailError.isHidden = false
                case .password:
                    lblPasswordError.text = error.message
                    lblPasswordError.isHidden = false
                }
            }
        } else {
            
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case let x where x == self.textFieldFirstName:
            lblFirstNameError.isHidden = true
        case let x where x == self.textFieldEmail:
            lblEmailError.isHidden = true
        case let x where x == self.textFieldLastName:
            lblLastNameError.isHidden = true
        case let x where x == self.textFieldPassword:
            lblPasswordError.isHidden = true
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case let x where x == self.textFieldFirstName:
            textFieldLastName.becomeFirstResponder()
            return true
        case let x where x == self.textFieldLastName:
            textFieldEmail.becomeFirstResponder()
            return true
        case let x where x == self.textFieldEmail:
            textFieldPassword.becomeFirstResponder()
            return true
        case let x where x == self.textFieldPassword:
            self.view.endEditing(true)
            self.handleSignUp()
            return true
        default:
            return true
        }
    }
}
