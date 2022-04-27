//
//  MultiAPIRequestVC.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import UIKit
import SVProgressHUD

class MultiAPIRequestVC: Controller<MultiAPIRequestVM> {
    @IBOutlet private var resultLabel: UILabel!
    @IBOutlet private var requestContinuoslyButton: UIButton!
    @IBOutlet private var requestAllButton: UIButton!
    
    override func setup() {
        super.setup()
        setupRx()
    }
    
    private func setupRx() {
        vm.outputs.rx.isLoading
            .drive(onNext: { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
        
        vm.outputs.rx.error
            .emit(with: self, onNext: { vc, error in
                vc.showError(error as? ErrorResponse)
            })
            .disposed(by: disposeBag)
        
        vm.outputs.rx.berries
            .map { "\($0.count)" }
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        requestAllButton.rx.tap
            .bind(to: vm.inputs.rx.requestAllTapped)
            .disposed(by: disposeBag)
        
        requestContinuoslyButton.rx.tap
            .bind(to: vm.inputs.rx.requestContinously)
            .disposed(by: disposeBag)
    }
    
}
