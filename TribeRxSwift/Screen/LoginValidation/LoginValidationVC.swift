//
//  LoginValidationVC.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import UIKit
import SVProgressHUD
import RxSwift

class LoginValidationVC: Controller<LoginValidationVM> {
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    
    override func setup() {
        super.setup()
        setupButton()
        setupRx()
    }
    
    private func setupButton() {
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
    }
    
    private func setupRx() {
        usernameTextField.rx.text.orEmpty
            .subscribe(onNext: { username in
                print("username1 = \(username)")
            })
            .disposed(by: disposeBag)
        
        usernameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { username in
                print("username2 = \(username)")
            })
            .disposed(by: disposeBag)
        
        usernameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: vm.inputs.rx.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: vm.inputs.rx.password)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .do(onNext: { [weak self] in
                self?.view.endEditing(true)
            })
            .bind(to: vm.inputs.rx.loginButtonTapped)
            .disposed(by: disposeBag)
        
        vm.outputs.rx.isLoading
            .drive(with: self, onNext: { vc, isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
        
        vm.outputs.rx.message
            .emit(with: self, onNext: { vc, message in
                let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                vc.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(usernameTextField.rx.text.orEmpty,
                                 passwordTextField.rx.text.orEmpty)
            .map { username, password in
                return !username.isEmpty && !password.isEmpty
            }
            .subscribe(with: self, onNext: { vc, isEnabled in
                vc.loginButton.isEnabled = isEnabled
                vc.loginButton.alpha = isEnabled ? 1 : 0.5
            })
            .disposed(by: disposeBag)
    }
}
