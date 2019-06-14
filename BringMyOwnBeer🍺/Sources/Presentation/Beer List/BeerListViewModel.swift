//
//  BeerListViewModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct BeerListViewModel: BeerListViewBindable {
    let testButtonTapped = PublishRelay<Void>()
    let result: Signal<[Beer]?>
    
    init(model: BeerListModel = BeerListModel()) {
        let beerListResult = testButtonTapped
            .flatMapLatest(model.getBeerList)
            .debug("xxx2")
            .asObservable()
            .share()
        
        let beerListValue = beerListResult
            .map { result -> [Beer]? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value
            }
            .filter { $0 != nil }
        
        let beerListError = beerListResult
            .map { result -> String? in
                guard case .failure(let error) = result else {
                    return nil
                }
                return error.message
            }
            .filter { $0 != nil }
        
        self.result = beerListValue
            .asSignal(onErrorSignalWith: .empty())
    }
}
