//
//  ErrorHandlingVC.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import UIKit
import SVProgressHUD

class ErrorHandlingVC: Controller<ErrorHandlingDemoVM> {
    @IBOutlet private var resultLabel: UILabel!
    @IBOutlet private var requestButton: UIButton!
    @IBOutlet private var request2Button: UIButton!
    @IBOutlet private var request3Button: UIButton!
    @IBOutlet private var request4Button: UIButton!
    
    override func setup() {
        super.setup()
        setupRx()
    }
    
    private func setupRx() {
        vm.outputs.rx.error
            .emit(with: self, onNext: { vc, error in
                vc.showError(error as? ErrorResponse)
            })
            .disposed(by: disposeBag)
        
        vm.outputs.rx.isLoading
            .drive(onNext: { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
        
        requestButton.rx.tap
            .bind(to: vm.inputs.rx.buttonTapped)
            .disposed(by: disposeBag)
        
        request2Button.rx.tap
            .bind(to: vm.inputs.rx.button2Tapped)
            .disposed(by: disposeBag)
        
        request3Button.rx.tap
            .bind(to: vm.inputs.rx.button3Tapped)
            .disposed(by: disposeBag)
        
        request4Button.rx.tap
            .bind(to: vm.inputs.rx.button4Tapped)
            .disposed(by: disposeBag)
        
        vm.outputs.rx.result
            .map { "\($0)" }
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
