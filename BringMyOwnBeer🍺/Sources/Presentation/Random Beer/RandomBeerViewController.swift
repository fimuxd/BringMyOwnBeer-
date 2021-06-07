//
//  RandomBeerViewController.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

typealias BeerData = BeerListCell.Data

protocol RandomBeerViewBindable {
    var randomButtonTapped: PublishRelay<Void> { get }
    var selectedBeerData: Signal<BeerData> { get }
    var errorMessage: Signal<String> { get }
}

class RandomBeerViewController: ViewController<RandomBeerViewBindable> {
    let beerImageView = UIImageView()
    let idLabel = UILabel()
    let beerNameLabel = UILabel()
    let beerDescriptionLabel = UILabel()
    let randomButton = UIButton()

    override func bind(_ viewModel: RandomBeerViewBindable) {
        self.disposeBag = DisposeBag()

        randomButton.rx.tap
            .bind(to: viewModel.randomButtonTapped)
            .disposed(by: disposeBag)

        viewModel.selectedBeerData
            .emit(to: self.rx.setData)
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .emit(to: self.rx.toast())
            .disposed(by: disposeBag)
    }

    override func attribute() {
        title = "아무거나 검색"
        view.backgroundColor = .white

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

        randomButton.do {
            $0.setTitle("I'm Feeling Lucky", for: .normal)
            $0.backgroundColor = self.view.tintColor
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
        }
    }

    override func layout() {
        view.addSubview(beerImageView)
        view.addSubview(idLabel)
        view.addSubview(beerNameLabel)
        view.addSubview(beerDescriptionLabel)
        view.addSubview(randomButton)

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

        randomButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
}

extension Reactive where Base: RandomBeerViewController {
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
