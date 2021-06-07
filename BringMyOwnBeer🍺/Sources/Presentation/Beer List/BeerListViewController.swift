//
//  BeerListViewController.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Toaster
import UIKit

protocol BeerListViewBindable {
    // View -> ViewModel
    var viewWillAppear: PublishSubject<Void> { get }
    var willDisplayCell: PublishRelay<IndexPath> { get }

    // ViewModel -> View
    var cellData: Driver<[BeerListCell.Data]> { get }
    var reloadList: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
}

class BeerListViewController: UIViewController {
    var disposeBag = DisposeBag()

    let tableView = UITableView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }

    func bind(_ viewModel: BeerListViewBindable) {
        self.disposeBag = DisposeBag()

        self.rx.viewWillAppear
            .map { _ in Void() }
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)

        tableView.rx.willDisplayCell
            .map { $0.indexPath }
            .bind(to: viewModel.willDisplayCell)
            .disposed(by: disposeBag)

        viewModel.cellData
            .drive(tableView.rx.items(cellIdentifier: String(describing: BeerListCell.self), cellType: BeerListCell.self)) { _, data, cell in
                cell.setData(data: data)
            }
            .disposed(by: disposeBag)

        viewModel.reloadList
            .emit(onNext: { [weak self] _ in
                self?.tableView.reloadData()
                })
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .emit(onNext: { msg in
                Toast(text: msg, delay: 0, duration: 1).show()
            })
            .disposed(by: disposeBag)
    }

    func attribute() {
        title = "맥주리스트"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.do {
            $0.backgroundView = UIView()
            $0.backgroundView?.isHidden = true
            $0.backgroundColor = .white
            $0.register(BeerListCell.self, forCellReuseIdentifier: String(describing: BeerListCell.self))
            $0.separatorStyle = .singleLine
            $0.rowHeight = UITableViewAutomaticDimension
            $0.estimatedRowHeight = 160
        }
    }

    func layout() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
