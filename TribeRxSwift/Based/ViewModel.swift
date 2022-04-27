//
//  ViewModel.swift
//  TribeRxSwift
//
//  Created by thanh on 27/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol InputCompatible {
    associatedtype InputCompatibleType: ViewModel
    var inputs: Inputs<InputCompatibleType> { get }
}

protocol OutputCompatible {
    associatedtype OutputCompatibleType
    var outputs: Outputs<OutputCompatibleType> { get }
}

class ViewModel {
    enum LifeCycle {
        case didAppear
        case willAppear
        case didLoad
        case willDisappear
        case didDisappear
    }

    // handle view controller's state in viewmodel
    let lifeCycle = PublishRelay<LifeCycle>()

    private(set) var disposeBag = DisposeBag()
}

class Inputs<Base>: ReactiveCompatible {
    let vm: Base

    init(_ vm: Base) {
        self.vm = vm
    }
}

class Outputs<Base>: ReactiveCompatible {
    let vm: Base

    init(_ vm: Base) {
        self.vm = vm
    }
}

extension ViewModel: OutputCompatible {
    typealias OutputCompatibleType = ViewModel
}

extension OutputCompatible {
    var outputs: Outputs<Self> { return Outputs(self) }
}

extension ViewModel: InputCompatible {
    typealias InputCompatibleType = ViewModel
}

extension InputCompatible where Self: ViewModel {
    var inputs: Inputs<Self> { return Inputs(self) }
}
