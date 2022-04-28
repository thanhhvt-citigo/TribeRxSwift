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
    }
}

extension Reactive where Base: Outputs<DemoListVM> {
    var items: Driver<[DemoItem]> {
        return base.vm.demoItems.asDriver()
    }
}
