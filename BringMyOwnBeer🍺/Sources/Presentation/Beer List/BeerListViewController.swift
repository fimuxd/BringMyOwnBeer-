//
//  BeerListViewController.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState
import SnapKit
import Toaster

protocol BeerListViewBindable {
    var viewWillAppear: PublishSubject<Void> { get }
    var itemSelected: PublishRelay<Int> { get }
    var willDisplayCell: PublishRelay<IndexPath> { get }
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
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .map { $0.indexPath }
            .bind(to: viewModel.willDisplayCell)
            .disposed(by: disposeBag)
        
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: String(describing: BeerListCell.self), for: index) as! BeerListCell
                cell.setData(data: data)
                return cell
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
