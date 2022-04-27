//
//  RxRelayExt.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

extension PublishRelay {
    func asObserver() -> AnyObserver<Element> {
        return .init { [weak self] event in
            guard let element = event.element else {
                return
            }
            self?.accept(element)
        }
    }
}

extension BehaviorRelay {
    func asObserver() -> AnyObserver<Element> {
        return .init { [weak self] event in
            guard let element = event.element else {
                return
            }
            self?.accept(element)
        }
    }
}
