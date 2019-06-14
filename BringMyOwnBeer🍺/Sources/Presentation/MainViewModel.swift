//
//  MainViewModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel: MainViewBindable {
    let beerListViewModel = BeerListViewModel()
    
    var currentTab = PublishSubject<Tab>()
//    let tabChanged =  PublishSubject<Tab?> { get }
    let presentTab: Signal<Tab>
    
    init() {
        self.presentTab = currentTab
            .startWith(.beerList)
            .asSignal(onErrorSignalWith: .empty())
    }
}
