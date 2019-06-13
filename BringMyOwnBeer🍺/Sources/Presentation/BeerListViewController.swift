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
import Then
import SnapKit

protocol BeerListViewBindable {
    var testButtonTapped: PublishRelay<Void> { get }
    var result: Signal<[Beer]?> { get }
}

class BeerListViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let testButton = UIButton()
    
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
        
        testButton.rx.tap
            .bind(to: viewModel.testButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.result
            .emit(onNext: { list in
                print("xxxResult: \(list)")
            })
            .disposed(by: disposeBag)
    }
    
    func attribute() {
        view.backgroundColor = .white
        testButton.do {
            $0.setTitle("테스트", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    func layout() {
        view.addSubview(testButton)
        testButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

