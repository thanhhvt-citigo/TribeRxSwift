//
//  MultiAPIRequestVM.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MultiAPIRequestVM: ViewModel {
    fileprivate let isLoading = BehaviorRelay<Bool>(value: false)
    fileprivate let requestAllTapped = PublishRelay<Void>()
    fileprivate let requestContinuosly = PublishRelay<Void>()
    fileprivate let error = PublishRelay<Error>()
    fileprivate let berries = BehaviorRelay<[Berry]>(value: [])
    
    override init() {
        super.init()
        setupRx()
    }
    
    private func setupRx() {
        requestAllTapped
            .withUnretained(self)
            .do(onNext: { vm, _ in
                vm.berries.accept([])
                vm.isLoading.accept(true)
            })
            .flatMap { vm, _ in
                return Observable.zip(vm.getAPI1(), vm.getAPI2())
            }
            .subscribe(with: self, onNext: { vm, args in
                let (data1, data2) = args
                vm.isLoading.accept(false)
                vm.berries.accept(data1 + data2)
            }, onError: { vm, error in
                vm.isLoading.accept(false)
                vm.error.accept(error)
            })
            .disposed(by: disposeBag)
        
        requestContinuosly
            .withUnretained(self)
            .do(onNext: { vm, _ in
                vm.berries.accept([])
                vm.isLoading.accept(true)
            })
            .flatMap { vm, _ in
                return vm.getAPI1().catchAndReturn([])
            }
            .withUnretained(self)
            .flatMap { vm, data1 in
                return vm.getAPI2().catchAndReturn([])
                    .map { $0 + data1 }
            }
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(false)
            })
            .bind(to: berries)
            .disposed(by: disposeBag)
    }
    
    private func getAPI1() -> Observable<[Berry]> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: URL(string: "https://pokeapi.co/api/v2/berry-flavor/1/")!) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let berryResponse = try JSONDecoder().decode(BerryResponse.self, from: data)
                        let berries = berryResponse.berries.map { $0.berry }
                        observer.onNext(berries)
                        print("data count = \(berries.count)")
                        observer.onCompleted()
                    } catch let error {
                        observer.onError(error)
                        print(error)
                    }
                } else {
                    observer.onError(ErrorResponse(message: "Unknown error"))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func getAPI2() -> Observable<[Berry]> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: URL(string: "https://pokeapi.co/api/v2/berry-flavor/2/")!) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let berryResponse = try JSONDecoder().decode(BerryResponse.self, from: data)
                        let berries = berryResponse.berries.map { $0.berry }
                        observer.onNext(berries)
                        print("data count = \(berries.count)")
                        observer.onCompleted()
                    } catch let error {
                        observer.onError(error)
                        print(error)
                    }
                } else {
                    observer.onError(ErrorResponse(message: "Unknown error"))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

extension Reactive where Base: Inputs<MultiAPIRequestVM> {
    var requestAllTapped: AnyObserver<Void> {
        return base.vm.requestAllTapped.asObserver()
    }
    
    var requestContinously: AnyObserver<Void> {
        return base.vm.requestContinuosly.asObserver()
    }
}

extension Reactive where Base: Outputs<MultiAPIRequestVM> {
    var isLoading: Driver<Bool> {
        return base.vm.isLoading.asDriver()
    }
    
    var berries: Driver<[Berry]> {
        return base.vm.berries.asDriver()
    }
    
    var error: Signal<Error> {
        return base.vm.error.asSignal()
    }
}
