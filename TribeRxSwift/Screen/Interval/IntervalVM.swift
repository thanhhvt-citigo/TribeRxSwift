//
//  IntervalDemoVM.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

class IntervalDemoVM: ViewModel {
    fileprivate let times = BehaviorRelay<Int>(value: 0)
    
    override init() {
        super.init()
        setupRx()
    }
    
    private func setupRx() {
        Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(times)
            .map { $0 + 1 }
            .bind(to: times)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: Outputs<IntervalDemoVM> {
    var times: Driver<Int> {
        return base.vm.times.asDriver()
    }
}
