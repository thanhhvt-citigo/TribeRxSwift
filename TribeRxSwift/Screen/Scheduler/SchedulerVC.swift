//
//  SchedulerVC.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SchedulerVC: Controller<SchedulerDemoVM> {
    @IBOutlet private var subscribeOnPosition: UIButton!
    @IBOutlet private var observeOnPosition: UIButton!
    @IBOutlet private var consecutiveObserveOn: UIButton!
    @IBOutlet private var consecutiveSubscribeOn: UIButton!
    @IBOutlet private var observeOnOverriden: UIButton!
    
    override func setup() {
        super.setup()
        setupRx()
    }
    
    private func setupRx() {
        observeOnOverriden.rx.tap
            .bind(to: vm.inputs.rx.observeOnOverriden)
            .disposed(by: disposeBag)
        
        observeOnPosition.rx.tap
            .bind(to: vm.inputs.rx.observeOnPosition)
            .disposed(by: disposeBag)
        
        subscribeOnPosition.rx.tap
            .bind(to: vm.inputs.rx.subscribeOnPosition)
            .disposed(by: disposeBag)
        
        consecutiveSubscribeOn.rx.tap
            .bind(to: vm.inputs.rx.consecutiveSubscribeOn)
            .disposed(by: disposeBag)
        
        consecutiveObserveOn.rx.tap
            .bind(to: vm.inputs.rx.consecutiveObserveOn)
            .disposed(by: disposeBag)
    }
}
