//
//  ErrorHandlingDemoVM.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

class ErrorHandlingDemoVM: ViewModel {
    fileprivate let error = PublishRelay<Error>()
    fileprivate let result = BehaviorRelay<Int>(value: -1)
    fileprivate let isLoading = BehaviorRelay<Bool>(value: false)
    fileprivate let buttonTapped = PublishRelay<Void>()
    fileprivate let button2Tapped = PublishRelay<Void>()
    fileprivate let button3Tapped = PublishRelay<Void>()
    fileprivate let button4Tapped = PublishRelay<Void>()
    
    override init() {
        super.init()
        setupRx()
    }
    
    private func setupRx() {
        buttonTapped
            .withUnretained(self)
            .do(onNext: { vm, _ in
                vm.isLoading.accept(true)
            })
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap { vm, _ -> Observable<Int> in
                return vm.getData()
            }
            .subscribe(with: self, onNext: { vm, result in
                vm.isLoading.accept(false)
                vm.result.accept(result)
            }, onError: { vm, error in
                vm.isLoading.accept(false)
                vm.error.accept(error)
            })
            .disposed(by: disposeBag)
        
        button2Tapped
            .withUnretained(self)
            .do(onNext: { vm, _ in
                vm.isLoading.accept(true)
            })
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap { vm, _ -> Observable<Int> in
                return vm.getData().catchAndReturn(0)
            }
            .subscribe(with: self, onNext: { vm, result in
                vm.isLoading.accept(false)
                vm.result.accept(result)
            }, onError: { vm, error in
                vm.isLoading.accept(false)
                vm.error.accept(error)
            })
            .disposed(by: disposeBag)
        
        button3Tapped
            .withUnretained(self)
            .do(onNext: { vm, _ in
                vm.isLoading.accept(true)
            })
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap { vm, _ -> Observable<Event<Int>> in
                return vm.getData().materialize()
            }
            .subscribe(with: self, onNext: { vm, event in
                vm.isLoading.accept(false)
                switch event {
                case .next(let result):
                    vm.result.accept(result)
                case .error(let error):
                    vm.error.accept(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        button4Tapped
            .do(onNext: { [weak self] in
                self?.isLoading.accept(true)
            })
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { vm, _ in
                vm.getData()
                    .subscribe(with: vm, onNext: { viewModel, result in
                        viewModel.isLoading.accept(false)
                        viewModel.result.accept(result)
                    }, onError: { viewModel, error in
                        viewModel.isLoading.accept(false)
                        viewModel.error.accept(error)
                    })
                    .disposed(by: vm.disposeBag)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func getData() -> Observable<Int> {
        let int = Int.random(in: 0...10)
        if int % 2 == 0 {
            return .just(1)
        } else {
            return .error(ErrorResponse(message: "failed"))
        }
    }
}

extension Reactive where Base: Inputs<ErrorHandlingDemoVM> {
    var buttonTapped: AnyObserver<Void> {
        return base.vm.buttonTapped.asObserver()
    }
    
    var button2Tapped: AnyObserver<Void> {
        return base.vm.button2Tapped.asObserver()
    }
    
    var button3Tapped: AnyObserver<Void> {
        return base.vm.button3Tapped.asObserver()
    }
    
    var button4Tapped: AnyObserver<Void> {
        return base.vm.button4Tapped.asObserver()
    }
}

extension Reactive where Base: Outputs<ErrorHandlingDemoVM> {
    var error: Signal<Error> {
        return base.vm.error.asSignal()
    }
    
    var result: Driver<Int> {
        return base.vm.result.asDriver()
    }
    
    var isLoading: Driver<Bool> {
        return base.vm.isLoading.asDriver()
    }
}
