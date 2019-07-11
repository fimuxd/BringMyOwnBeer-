//
//  RandomBeerViewModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

struct RandomBeerViewModel: RandomBeerViewBindable {
    let randomButtonTapped = PublishRelay<Void>()
    let selectedBeerData: Signal<BeerData>
    let errorMessage: Signal<String>
    
    init(
        model: RandomBeerModel = RandomBeerModel()
    ) {
        let beerResult = randomButtonTapped
            .flatMapLatest(model.getRandomBeer)
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
        
        self.selectedBeerData = beerValue
            .map(model.parseData)
            .filterNil()
            .asSignal(onErrorSignalWith: .empty())
        
        self.errorMessage = beerError
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해 주세요")
    }
}
