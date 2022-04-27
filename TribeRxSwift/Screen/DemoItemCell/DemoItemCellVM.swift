//
//  DemoItemCellVM.swift
//  TribeRxSwift
//
//  Created by thanh on 27/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

class DemoItemCellVM: ViewModel {
    fileprivate let item: BehaviorRelay<DemoItem>
    
    init(item: DemoItem) {
        self.item = .init(value: item)
        super.init()
    }
}

extension Reactive where Base: Outputs<DemoItemCellVM> {
    var item: Driver<DemoItem> {
        return base.vm.item.asDriver()
    }
}
