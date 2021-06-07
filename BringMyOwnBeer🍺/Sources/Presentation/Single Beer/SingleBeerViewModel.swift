//
//  SingleBeerViewModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct SingleBeerViewModel: SingleBeerViewBindable {
    let idValueChanged = PublishRelay<String?>()
    let beerData: Signal<BeerListCell.Data>

    init(model: SingleBeerModel = SingleBeerModel()) {
        let beerResult = idValueChanged
            .compactMap { $0 }
            .flatMapLatest(model.getSingleBeer)
            .asObservable()
            .share()

        let beerValue = beerResult
            .map { result -> Beer? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value.first
            }
            .compactMap { $0 }

        self.beerData = beerValue
            .map(model.parseData)
            .compactMap { $0 }
            .asSignal(onErrorSignalWith: .empty())
    }
}
