//
//  DemoListVC.swift
//  TribeRxSwift
//
//  Created by thanh on 27/04/2022.
//

import UIKit

class DemoListVC: Controller<DemoListVM> {
    @IBOutlet private var tableView: UITableView!
    
    private var isFirstShow = true
    
    override func setup() {
        super.setup()
        setupNavigationBar()
        setupTableView()
        setupRx()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "RxSwift Demo"
    }
    
    private func setupTableView() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.sectionHeaderTopPadding = 0
        tableView.register(UINib(nibName: "DemoItemCell", bundle: nil), forCellReuseIdentifier: "DemoItemCell")
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFirstShow {
            doSomethingWhenFirstLaunch()
            isFirstShow = false
        }
    }
    
    private func doSomethingWhenFirstLaunch() {
        // do some thing
    }
    
    private func setupRx() {
        rx.viewDidAppear
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.doSomethingWhenFirstLaunch()
            })
            .disposed(by: disposeBag)
        
        rx.viewDidLayoutSubviews
            .subscribe(with: self, onNext: { vc, _ in
                vc.tableView.contentInset.bottom = vc.view.safeAreaInsets.bottom
            })
            .disposed(by: disposeBag)
        
        vm.outputs.rx.items
            .drive(tableView.rx.items) { tableView, row, item in
                let cellVM = DemoItemCellVM(item: item)
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DemoItemCell", for: indexPath) as? DemoItemCell else {
                    return UITableViewCell()
                }
                
                cell.binding(vm: cellVM)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(with: self, onNext: { vc, indexPath in
                vc.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(DemoItem.self)
            .subscribe(with: self, onNext: { vc, item in
                vc.handleSelectedItem(item: item)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleSelectedItem(item: DemoItem) {
        switch item {
        case .interval:
            showIntervalDemo()
        case .errorHandling:
            showErrorHandlingDemo()
        case .scheduler:
            showSchedulerDemo()
        case .customAPI:
            showCustomAPIDemo()
        case .loginValidation:
            showLoginValidationDemo()
        case .multipleAPIRequest:
            showMultipleRequestDemo()
        }
    }
    
    private func showIntervalDemo() {
        let intervalDemoVC = IntervalDemoVC(vm: .init())
        navigationController?.pushViewController(intervalDemoVC, animated: true)
    }
    
    private func showErrorHandlingDemo() {
        let errorHandlingDemoVC = ErrorHandlingVC(vm: .init())
        navigationController?.pushViewController(errorHandlingDemoVC, animated: true)
    }
    
    private func showSchedulerDemo() {
        let schedulerDemoVC = SchedulerVC(vm: .init())
        navigationController?.pushViewController(schedulerDemoVC, animated: true)
    }
    
    private func showCustomAPIDemo() {
        let customAPIDemoVC = CustomAPIDemoVC(vm: .init())
        navigationController?.pushViewController(customAPIDemoVC, animated: true)
    }
    
    private func showLoginValidationDemo() {
        let loginValidationVC = LoginValidationVC(vm: .init())
        navigationController?.pushViewController(loginValidationVC, animated: true)
    }
    
    private func showMultipleRequestDemo() {
        let multipleRequestDemoVC = MultiAPIRequestVC(vm: .init())
        navigationController?.pushViewController(multipleRequestDemoVC, animated: true)
    }
}

extension DemoListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
