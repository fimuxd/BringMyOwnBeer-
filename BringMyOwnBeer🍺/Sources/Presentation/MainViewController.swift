//
//  MainViewController.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Then

protocol MainViewBindable {
    typealias Tab = MainViewController.Tab
    var beerListViewModel: BeerListViewModel { get }
    
    var currentTab: PublishSubject<Tab> { get }
//    var tabChanged: PublishSubject<Tab?> { get }
    var presentTab: Signal<Tab> { get }
}

class MainViewController: UITabBarController {
    var disposeBag = DisposeBag()

    enum Tab: Int {
        case beerList
    }
    
    let beerListViewController = BeerListViewController()
    
    let tabBarItems: [Tab: UITabBarItem] = [
        .beerList: UITabBarItem(
            title: "맥주리스트",
            image: #imageLiteral(resourceName: "Multiple Beers"),
            selectedImage: #imageLiteral(resourceName: "Multiple Beers")
        )
    ]
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
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
        
        viewModel.presentTab
            .emit(onNext: { [weak self] tab in
                guard let self = self,
                    let item = self.tabBarItems[tab],
                    self.tabBar.selectedItem != item
                else {
                    return
                }
                self.selectedIndex = tab.rawValue
            })
            .disposed(by: disposeBag)
        
    }
    
    func attribute() {
        self.do {
            beerListViewController.tabBarItem = tabBarItems[.beerList]
            $0.viewControllers = [UINavigationController(rootViewController: beerListViewController)]
        }
        
        view.do {
            $0.backgroundColor = .white
        }
    }
}
