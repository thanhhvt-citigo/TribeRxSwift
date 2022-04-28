//
//  LoginValidationVM.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

class LoginValidationVM: ViewModel {
    fileprivate let username = BehaviorRelay<String>(value: "")
    fileprivate let password = BehaviorRelay<String>(value: "")
    fileprivate let loginButtonTapped = PublishRelay<Void>()
    fileprivate let message = PublishRelay<String>()
    fileprivate let isLoading = BehaviorRelay<Bool>(value: false)
    fileprivate let data = BehaviorRelay<Void>(value: ())
    
    override init() {
        super.init()
        setupRx()
    }
    
    private func setupRx() {
        loginButtonTapped
            .withLatestFrom(Observable.combineLatest(username, password))
            .filter { [weak self] username, password in
                guard let self = self else {
                    return false
                }
                if username.count < 6 {
                    self.message.accept("Username must be 6 or more characters")
                    return false
                }
                if password.count < 6 {
                    self.message.accept("Password must be 6 or more characters")
                    return false
                }
                return true
            }
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(true)
            })
            .withUnretained(self)
            .flatMap { vm, _ -> Observable<Void> in
                return vm.getData()
            }
            .bind(to: data)
            .disposed(by: disposeBag)
    }
    
    private func getData() -> Observable<Void> {
        return .just(())
            .delay(.seconds(2), scheduler: MainScheduler.instance)
    }
}

extension Reactive where Base: Inputs<LoginValidationVM> {
    var username: AnyObserver<String> {
        return base.vm.username.asObserver()
    }
    
    var password: AnyObserver<String> {
        return base.vm.password.asObserver()
    }
    
    var loginButtonTapped: AnyObserver<Void> {
        return base.vm.loginButtonTapped.asObserver()
    }
}

extension Reactive where Base: Outputs<LoginValidationVM> {
    var message: Signal<String> {
        return base.vm.message.asSignal()
    }
    
    var isLoading: Driver<Bool> {
        return base.vm.isLoading.asDriver()
    }
}
