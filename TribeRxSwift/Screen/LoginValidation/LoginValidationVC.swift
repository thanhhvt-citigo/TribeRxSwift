//
//  LoginValidationVC.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import UIKit
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
        
        Observable.combineLatest(usernameTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty)
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
