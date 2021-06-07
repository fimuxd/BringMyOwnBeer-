//
//  RandomBeerViewModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import RxCocoa
import RxSwift

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
            .compactMap { $0.value }

        let beerError = beerResult
            .compactMap { $0.error?.message }

        self.selectedBeerData = beerValue
            .compactMap { $0.first }
            .compactMap(model.parseData)
            .asSignal(onErrorSignalWith: .empty())

        self.errorMessage = beerError
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해 주세요")
    }
}
