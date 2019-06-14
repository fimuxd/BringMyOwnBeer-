//
//  SingleBeerViewModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SingleBeerViewModel: SingleBeerViewBindable {
    let idValueChanged = PublishRelay<String?>()
    let beerData: Signal<BeerListCell.Data>
    
    init(model: SingleBeerModel = SingleBeerModel()) {
        let beerResult = idValueChanged
            .filterNil()
            .flatMapLatest(model.getSingleBeer)
            .asObservable()
            .share()
        
        let beerValue = beerResult
            .map { result -> [Beer]? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value
            }
            .filterNil()
        
        let beerError = beerResult
            .map { result -> String? in
                guard case .failure(let error) = result else {
                    return nil
                }
                return error.message
            }
            .filterNil()
        
        self.beerData = beerValue
            .map(model.parseData)
            .filterNil()
            .asSignal(onErrorSignalWith: .empty())
    }
}
