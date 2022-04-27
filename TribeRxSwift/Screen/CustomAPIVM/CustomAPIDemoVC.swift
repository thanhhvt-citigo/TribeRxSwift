//
//  CustomAPIDemoVC.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import UIKit
import SVProgressHUD

class CustomAPIDemoVC: Controller<CustomAPIDemoVM> {
    @IBOutlet private var tableView: UITableView!
    
    override func setup() {
        super.setup()
        setupTableView()
        setupRx()
    }
    
    private func setupTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 40
        tableView.sectionHeaderTopPadding = 0
    }
    
    private func setupRx() {
        vm.outputs.rx.isLoading
            .drive(onNext: { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
        
        vm.outputs.rx.error
            .emit(with: self, onNext: { vc, error in
                vc.showError(error as? ErrorResponse)
            })
            .disposed(by: disposeBag)
        
        vm.outputs.rx.berries
            .drive(tableView.rx.items) { tableView, row, item in
                let cell = UITableViewCell()
                cell.textLabel?.text = item.name
                return cell
            }
            .disposed(by: disposeBag)
    }
    
}
