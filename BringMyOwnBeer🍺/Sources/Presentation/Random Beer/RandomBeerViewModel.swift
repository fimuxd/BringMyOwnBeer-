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
            .filterNilValue { $0.value }
        
        let beerError = beerResult
            .filterNilValue { $0.error?.message }
        
        self.selectedBeerData = beerValue
            .filterNilValue { $0.first }
            .filterNilValue(model.parseData)
            .asSignal(onErrorSignalWith: .empty())
        
        self.errorMessage = beerError
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해 주세요")
    }
}

