//
//  CustomAPIDemoVM.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

class CustomAPIDemoVM: ViewModel {
    fileprivate let berries = BehaviorRelay<[Berry]>(value: [])
    fileprivate let isLoading = BehaviorRelay<Bool>(value: false)
    fileprivate let error = PublishRelay<Error>()
    
    override init() {
        super.init()
        setupRx()
    }
    
    private func setupRx() {
        lifeCycle.filter { $0 == .willAppear }
            .take(1)
            .withUnretained(self)
            .do(onNext: { vm, _ in
                vm.isLoading.accept(true)
            })
            .flatMap { vm, _ in
                return vm.getData()
            }
            .subscribe(with: self, onNext: { vm, berries in
                vm.isLoading.accept(false)
                vm.berries.accept(berries)
            }, onError: { vm, error in
                vm.isLoading.accept(false)
                vm.error.accept(error)
            }, onCompleted: { _ in
                // completed
            }, onDisposed: { _ in
                // disposed
            })
            .disposed(by: disposeBag)
    }
    
    private func getData() -> Observable<[Berry]> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: URL(string: "https://pokeapi.co/api/v2/berry-flavor/1/")!) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let berryResponse = try JSONDecoder().decode(BerryResponse.self, from: data)
                        observer.onNext(berryResponse.berries.map { $0.berry })
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

extension Reactive where Base: Outputs<CustomAPIDemoVM> {
    var berries: Driver<[Berry]> {
        return base.vm.berries.asDriver()
    }
    
    var isLoading: Driver<Bool> {
        return base.vm.isLoading.asDriver()
    }
    
    var error: Signal<Error> {
        return base.vm.error.asSignal()
    }
}
