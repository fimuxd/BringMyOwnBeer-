//
//  RandomBeerModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import RxSwift

struct RandomBeerModel {
    let punkNetwork: PunkNetwork

    init(
        punkNetwork: PunkNetwork = PunkNetworkImpl()
    ) {
        self.punkNetwork = punkNetwork
    }

    func getRandomBeer() -> Observable<Result<[Beer], PunkNetworkError>> {
        punkNetwork.getRandomBeer()
    }

    func parseData(value: Beer) -> BeerListCell.Data? {
        (
            id: value.id ?? 0,
            name: value.name ?? "",
            description: value.description ?? "",
            imageURL: value.imageURL ?? ""
        )
    }
}
