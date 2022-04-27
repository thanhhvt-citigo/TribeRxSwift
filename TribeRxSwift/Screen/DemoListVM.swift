//
//  DemoListVM.swift
//  TribeRxSwift
//
//  Created by thanh on 27/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

class DemoListVM: ViewModel {
    fileprivate let demoItems = BehaviorRelay<[DemoItem]>(value: DemoItem.allCases)
    
    override init() {
        super.init()
        
        let a = ReplaySubject<Int>.create(bufferSize: 3)
        
        a.onNext(1)
        a.onNext(2)
        a.onNext(3)
        
        a.subscribe(onNext: { value in
            print("value = \(value)")
        })
        .disposed(by: disposeBag)
    }
}

extension Reactive where Base: Outputs<DemoListVM> {
    var items: Driver<[DemoItem]> {
        return base.vm.demoItems.asDriver()
    }
}
