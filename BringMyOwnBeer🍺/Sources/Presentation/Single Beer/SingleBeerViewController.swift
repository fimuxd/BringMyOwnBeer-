//
//  SingleBeerViewController.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import RxCocoa
import RxSwift
import SDWebImage
import UIKit

protocol SingleBeerViewBindable {
    var idValueChanged: PublishRelay<String?> { get }
    var beerData: Signal<BeerListCell.Data> { get }
}

class SingleBeerViewController: UIViewController {
    var disposeBag = DisposeBag()

    let searchController = UISearchController(searchResultsController: nil)
    let beerImageView = UIImageView()
    let idLabel = UILabel()
    let beerNameLabel = UILabel()
    let beerDescriptionLabel = UILabel()

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

    func bind(_ viewModel: SingleBeerViewBindable) {
        self.disposeBag = DisposeBag()

        searchController.searchBar.rx.searchButtonClicked
            .map { [weak self] _ in
                self?.searchController.searchBar.text
            }
            .do(onNext: { _ in
                self.searchController.dismiss(animated: true, completion: nil)
            })
            .bind(to: viewModel.idValueChanged)
            .disposed(by: disposeBag)

        viewModel.beerData
            .emit(to: self.rx.setData)
            .disposed(by: disposeBag)
    }

    func attribute() {
        title = "ID 검색"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController

        searchController.searchBar.do {
            $0.keyboardType = .numbersAndPunctuation
        }

        idLabel.do {
            $0.font = .systemFont(ofSize: 14, weight: .light)
            $0.textColor = .brown
        }

        beerNameLabel.do {
            $0.font = .systemFont(ofSize: 18, weight: .black)
            $0.textColor = .darkGray
            $0.numberOfLines = 0
        }

        beerDescriptionLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .light)
            $0.textColor = .gray
            $0.numberOfLines = 0
        }

        beerImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFit
        }
    }

    func layout() {
        view.addSubview(beerImageView)
        view.addSubview(idLabel)
        view.addSubview(beerNameLabel)
        view.addSubview(beerDescriptionLabel)

        beerImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(240)
        }

        idLabel.snp.makeConstraints {
            $0.top.equalTo(beerImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        beerNameLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }

        beerDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(beerNameLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
        }
    }
}

extension Reactive where Base: SingleBeerViewController {
    var setData: Binder<BeerListCell.Data> {
        Binder(base) { base, data in
            base.beerImageView.sd_setImage(with: URL(string: data.imageURL))
            base.beerImageView.snp.remakeConstraints {
                $0.top.equalTo(base.view.safeAreaLayoutGuide.snp.top).offset(20)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(240)
            }

            base.idLabel.text = "\(data.id)"
            base.beerNameLabel.text = data.name
            base.beerDescriptionLabel.text = data.description
        }
    }
}
