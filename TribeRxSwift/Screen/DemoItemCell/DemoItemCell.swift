//
//  DemoItemCell.swift
//  TribeRxSwift
//
//  Created by thanh on 27/04/2022.
//

import UIKit
import RxSwift

class DemoItemCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func binding(vm: DemoItemCellVM) {
        vm.outputs.rx.item
            .map { $0.rawValue }
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
