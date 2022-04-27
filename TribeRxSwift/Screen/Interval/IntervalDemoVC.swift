//
//  Interval.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import UIKit

class IntervalDemoVC: Controller<IntervalDemoVM> {
    @IBOutlet private var timeLabel: UILabel!
    
    override func setup() {
        super.setup()
        setupRx()
    }

    private func setupRx() {
        vm.outputs.rx.times
            .map { "\($0)" }
            .drive(timeLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
