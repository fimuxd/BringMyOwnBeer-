//
//  SingleBeerModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift

struct SingleBeerModel {
    let punkNetwork: PunkNetwork

    init(punkNetwork: PunkNetwork = PunkNetworkImpl()) {
        self.punkNetwork = punkNetwork
    }

    func getSingleBeer(id: String) -> Observable<Result<[Beer], PunkNetworkError>> {
        punkNetwork.getBeer(id: id)
    }

    func parseData(value: Beer) -> BeerListCell.Data? {
        (id: value.id ?? 0, name: value.name ?? "", description: value.description ?? "", imageURL: value.imageURL ?? "")
    }
}
