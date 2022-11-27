//
//  LoginViewController.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import UIKit

class LoginViewController: BaseViewController<LoginViewModel> {

    // MARK: - Init
    class func instance(viewModel: LoginViewModel) -> LoginViewController {
        let controller = instance(storyboardName: "Main") as! LoginViewController
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Properties
    var onTapSignUp: (() -> Void)?
    var onLogin: ((UserProfile) -> Void)?
    
    // MARK: - Outlets
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblRemember: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblRegisterAccount: UILabel!
    @IBOutlet weak var lblForgotPass: UILabel!
    @IBOutlet weak var lblSignup: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var lblPasswordError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindToViewModel()
    }

    // MARK: - Actions
    @IBAction func didTapBtnCheck(_ sender: Any) {
        self.view.endEditing(true)
        viewModel.isRemember = !viewModel.isRemember
    }
    
    @IBAction func didTapBtnLogin(_ sender: Any) {
        self.handleLogin()
    }
    
    @IBAction func didTapBtnSocial(_ sender: UIButton) {
        self.view.endEditing(true)
        self.showAlert(title: "Social login", message: "This function is applying. Please check it again later!!!!")
    }
    
    @objc private func didTapLblForgotPass() {
        self.view.endEditing(true)
        self.showAlert(title: "Forgot Password", message: "This function is applying. Please check it again later!!!!")
    }
    
    @objc private func didTapLblSignUp() {
        self.view.endEditing(true)
        onTapSignUp?()
    }
}

// MARK: - Helper methods
extension LoginViewController {
    private func initUI() {
        lblWelcome.font = UIFont.montserratMedium(size: 18)
        lblWelcome.textColor = UIColor.AppColor.lightDark
        
        lblSubtitle.font = UIFont.montserratRegular(size: 14)
        lblSubtitle.textColor = UIColor.AppColor.textGray
        
        lblRemember.font = UIFont.montserratRegular(size: 14)
        lblRemember.textColor = UIColor.AppColor.textGray
        
        lblRegisterAccount.font = UIFont.montserratRegular(size: 14)
        lblRegisterAccount.textColor = UIColor.AppColor.textGray
        
        lblSignup.font = UIFont.montserratRegular(size: 14)
        lblSignup.textColor = UIColor.AppColor.lightPurple
        lblSignup.isUserInteractionEnabled = true
        lblSignup.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLblSignUp)))
        
        lblOr.font = UIFont.montserratRegular(size: 14)
        lblOr.textColor = UIColor.AppColor.textGray
        
        lblForgotPass.textColor = .AppColor.lightPurple
        lblForgotPass.font = .montserratRegular(size: 12)
        lblForgotPass.isUserInteractionEnabled = true
        lblForgotPass.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLblForgotPass)))
        
        btnLogin.layer.cornerRadius = 5
        let btnAttributedText = NSAttributedString(string: "Login",
                                                   attributes: [
                                                    .font: UIFont.montserratMedium(size: 14),
                                                    .foregroundColor: UIColor.white
                                                   ])
        btnLogin.setAttributedTitle(btnAttributedText, for: .normal)
        
        btnCheck.layer.borderColor = UIColor(hex: 0xD8D6DE).cgColor
        btnCheck.layer.borderWidth = 1
        btnCheck.layer.cornerRadius = 3
        
        initInputField()
    }
    
    private func bindToViewModel() {
        viewModel.$isRemember
            .sink { [weak self] isRemember in
                guard let `self` = self else { return }
                if isRemember {
                    self.btnCheck.layer.borderWidth = 0
                    self.btnCheck.backgroundColor = .AppColor.lightPurple
                } else {
                    self.btnCheck.layer.borderWidth = 1
                    self.btnCheck.backgroundColor = .clear
                }
            }
            .store(in: &viewModel.subscriptions)
//
        self.textFieldEmail.textChangedPublisher()
            .assign(to: \.email, on: viewModel)
            .store(in: &viewModel.subscriptions)
        self.textFieldPassword.textChangedPublisher()
            .assign(to: \.password, on: viewModel)
            .store(in: &viewModel.subscriptions)
    }
    
    private func initInputField() {
        lblEmailError.isHidden = true
        lblPasswordError.isHidden = true
        
        self.setAttributedRequired(for: lblEmail, with: "Email")
        self.setAttributedRequired(for: lblPassword, with: "Password")
        
        lblEmailError.font = .montserratRegular(size: 12)
        lblEmailError.textColor = .AppColor.error
        lblPasswordError.font = .montserratRegular(size: 12)
        lblPasswordError.textColor = .AppColor.error
        
        textFieldEmail.delegate = self
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
    
    private func handleLogin() {
        let errors = viewModel.validate()
        if !errors.isEmpty {
            for error in errors {
                switch error.type {
                case .email:
                    lblEmailError.text = error.message
                    lblEmailError.isHidden = false
                case .password:
                    lblPasswordError.text = error.message
                    lblPasswordError.isHidden = false
                default:
                    break
                }
            }
        } else {
            viewModel.login { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.showAlert(title: "Login Error", message: "\(error.localizedDescription)")
                case .success(let profile):
                    self?.onLogin?(profile)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case let x where x == self.textFieldEmail:
            lblEmailError.isHidden = true
        case let x where x == self.textFieldPassword:
            lblPasswordError.isHidden = true
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case let x where x == self.textFieldEmail:
            textFieldPassword.becomeFirstResponder()
            return true
        case let x where x == self.textFieldPassword:
            self.view.endEditing(true)
            self.handleLogin()
            return true
        default:
            return true
        }
    }
}
