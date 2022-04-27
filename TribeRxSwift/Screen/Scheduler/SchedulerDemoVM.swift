//
//  SchedulerDemoVM.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

class SchedulerDemoVM: ViewModel {
    fileprivate let observeOnPosition = PublishRelay<Void>()
    fileprivate let subscribeOnPosition = PublishRelay<Void>()
    fileprivate let consecutiveObserveOn = PublishRelay<Void>()
    fileprivate let consecutiveSubscribeOn = PublishRelay<Void>()
    fileprivate let observeOnOverriden = PublishRelay<Void>()

    
    override init() {
        super.init()
        setupRx()
    }
    
    private func setupRx() {
        observeOnPosition
            .subscribe(with: self, onNext: { vc, _ in
                vc.executeObserveOnPosition()
            })
            .disposed(by: disposeBag)
        
        subscribeOnPosition
            .subscribe(with: self, onNext: { vc, _ in
                vc.executeSubscribeOnPosition()
            })
            .disposed(by: disposeBag)
        
        consecutiveObserveOn
            .subscribe(with: self, onNext: { vc, _ in
                vc.executeConsecutiveObserveOn()
            })
            .disposed(by: disposeBag)
        
        consecutiveSubscribeOn
            .subscribe(with: self, onNext: { vc, _ in
                vc.executeConsecutiveSubscribeOn()
            })
            .disposed(by: disposeBag)
        
        observeOnOverriden
            .subscribe(with: self, onNext: { vc, _ in
                vc.executeObserveOnOverriden()
            })
            .disposed(by: disposeBag)
    }
    
    private func executeObserveOnPosition() {
        Observable<Int>
            .create { observer in
                observer.onNext(1)
                sleep(1)
                observer.onNext(2)
                return Disposables.create()
            }
            .map { value -> Int in
                print("\n\n 😀 Queue: \(Thread.current.threadName )")
                return value * 2
            }
            .observe(on: SerialDispatchQueueScheduler(qos: .background))
            .map { value -> Int in
                print(" 😀 Queue: \(Thread.current.threadName)")
                return value * 3
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { element in
                print(" 😀 Queue: \(element) \(Thread.current.threadName)")
            })
            .disposed(by: disposeBag)
    }
    
    private func executeSubscribeOnPosition() {
        Observable<Int>
            .create { observer in
                observer.onNext(1)
                sleep(1)
                observer.onNext(2)
                return Disposables.create()
            }
            .map { value -> Int in
                print("\n\n 😀 Queue: \(Thread.current.threadName)")
                return value * 2
            }
            .subscribe(on: SerialDispatchQueueScheduler(qos: .background))
            .map { value -> Int in
                print(" 😀 Queue: \(Thread.current.threadName)")
                return value * 3
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { element in
                print(" 😀 Queue: \(element) \(Thread.current.threadName)")
            })
            .disposed(by: disposeBag)
    }
    
    private func executeConsecutiveObserveOn() {
        Observable<Int>
            .create { observer in
                observer.onNext(1)
                sleep(1)
                observer.onNext(2)
                return Disposables.create()
            }
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { value -> Int in
                print("\n\n 😀 Queue: \(Thread.current.threadName)")
                return value * 2
            }
            .observe(on: SerialDispatchQueueScheduler(qos: .background))
            .map { value -> Int in
                print(" 😀 Queue: \(Thread.current.threadName)")
                return value * 3
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { element in
                print(" 😀 Queue: \(element) \(Thread.current.threadName)")
            })
            .disposed(by: disposeBag)
    }
    
    private func executeConsecutiveSubscribeOn() {
        Observable<Int>
            .create { observer in
                observer.onNext(1)
                sleep(1)
                observer.onNext(2)
                return Disposables.create()
            }
            .subscribe(on: SerialDispatchQueueScheduler(qos: .background))
            .map { value -> Int in
                print("\n\n 😀 Queue: \(Thread.current.threadName)")
                return value * 2
            }
            .subscribe(on: MainScheduler.instance)
            .map { value -> Int in
                print(" 😀 Queue: \(Thread.current.threadName)")
                return value * 3
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { element in
                print(" 😀 Queue: \(element) \(Thread.current.threadName)")
            })
            .disposed(by: disposeBag)
    }
    
    private func executeObserveOnOverriden() {
        Observable<Int>
            .create { observer in
                observer.onNext(1)
                sleep(1)
                observer.onNext(2)
                return Disposables.create()
            }
            .observe(on: SerialDispatchQueueScheduler(qos: .background))
            .map { value -> Int in
                print("\n\n 😀 Queue: \(Thread.current.threadName)")
                return value * 2
            }
            .subscribe(on: MainScheduler.instance)
            .map { value -> Int in
                print(" 😀 Queue: \(Thread.current.threadName)")
                return value * 3
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { element in
                print(" 😀 Queue: \(element) \(Thread.current.threadName)")
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: Inputs<SchedulerDemoVM> {
    var observeOnPosition: AnyObserver<Void> {
        return base.vm.observeOnPosition.asObserver()
    }
    
    var subscribeOnPosition: AnyObserver<Void> {
        return base.vm.subscribeOnPosition.asObserver()
    }
    
    var consecutiveObserveOn: AnyObserver<Void> {
        return base.vm.consecutiveObserveOn.asObserver()
    }
    
    var consecutiveSubscribeOn: AnyObserver<Void> {
        return base.vm.consecutiveSubscribeOn.asObserver()
    }
    
    var observeOnOverriden: AnyObserver<Void> {
        return base.vm.observeOnOverriden.asObserver()
    }
}
