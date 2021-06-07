//
//  MainViewController.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Then

protocol MainViewBindable {
    typealias Tab = MainViewController.Tab

    var beerListViewModel: BeerListViewBindable { get }
    var singleBeerViewModel: SingleBeerViewBindable { get }
    var randomBeerViewModel: RandomBeerViewBindable { get }
}

class MainViewController: UITabBarController {
    var disposeBag = DisposeBag()

    enum Tab: Int {
        case beerList
        case singleBeer
        case randomBeer
    }

    let beerListViewController = BeerListViewController()
    let singleBeerViewController = SingleBeerViewController()
    let randomBeerViewController = RandomBeerViewController()

    let tabBarItems: [Tab: UITabBarItem] = [
        .beerList: UITabBarItem(
            title: "맥주리스트",
            image: #imageLiteral(resourceName: "Multiple Beers"),
            selectedImage: #imageLiteral(resourceName: "Multiple Beers")
        ),
        .singleBeer: UITabBarItem(
            title: "ID 검색",
            image: #imageLiteral(resourceName: "Single Beer"),
            selectedImage: #imageLiteral(resourceName: "Single Beer")
        ),
        .randomBeer: UITabBarItem(
            title: "아무거나 검색",
            image: #imageLiteral(resourceName: "Single Beer with bubble"),
            selectedImage: #imageLiteral(resourceName: "Single Beer with bubble")
        )
    ]

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
    }

    func bind(_ viewModel: MainViewBindable) {
        self.disposeBag = DisposeBag()

        beerListViewController.bind(viewModel.beerListViewModel)
        singleBeerViewController.bind(viewModel.singleBeerViewModel)
        randomBeerViewController.bind(viewModel.randomBeerViewModel)
    }

    func attribute() {
        self.do {
            beerListViewController.tabBarItem = tabBarItems[.beerList]
            singleBeerViewController.tabBarItem = tabBarItems[.singleBeer]
            randomBeerViewController.tabBarItem = tabBarItems[.randomBeer]
            $0.viewControllers = [
                UINavigationController(rootViewController: beerListViewController),
                UINavigationController(rootViewController: singleBeerViewController),
                UINavigationController(rootViewController: randomBeerViewController)
            ]
        }

        view.do {
            $0.backgroundColor = .white
        }
    }
}
