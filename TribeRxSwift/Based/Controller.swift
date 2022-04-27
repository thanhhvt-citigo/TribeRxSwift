//
//  Controller.swift
//  TribeRxSwift
//
//  Created by thanh on 27/04/2022.
//

import Foundation
import UIKit
import RxSwift

class Controller<VM: ViewModel>: UIViewController {
    private let viewModel: VM!

    var vm: VM {
        return viewModel
    }

    let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    required init(vm: VM, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        viewModel = vm
        let resourceName = nibNameOrNil ?? String(describing: Self.self)
        if Bundle.main.path(forResource: resourceName, ofType: "xib") == nil {
            super.init(nibName: nil, bundle: nil)
        } else {
            super.init(nibName: resourceName, bundle: nibBundleOrNil)
        }
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        Observable.merge(
            rx.viewDidLoad.map { _ in .didLoad },
            rx.viewWillAppear.map { _ in .willAppear },
            rx.viewDidAppear.map { _  in .didAppear },
            rx.viewWillDisappear.map { _ in .willDisappear },
            rx.viewDidDisappear.map { _ in .didDisappear }
        )
        .bind(to: vm.lifeCycle)
        .disposed(by: disposeBag)
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
    func showError(_ error: ErrorResponse?) {
        let alertController = UIAlertController(title: "Đã có lỗi xảy ra", message: error?.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }

    deinit {
        print("\(String(describing: self)) deinit")
    }
}
