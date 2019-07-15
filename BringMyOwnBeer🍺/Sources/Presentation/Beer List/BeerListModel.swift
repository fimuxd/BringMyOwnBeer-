//
//  BeerListModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift

struct BeerListModel {
    let punkNetwork: PunkNetwork
    
    init(punkNetwork: PunkNetwork = PunkNetworkImpl()) {
        self.punkNetwork = punkNetwork
    }
    
    func getBeerList() -> Single<Result<[Beer], PunkNetworkError>> {
        return punkNetwork.getBeers(components: BeerFilterComponents(), page: nil, perPage: nil)
    }
    
    func parseData(value: [Beer]) -> [BeerListCell.Data] {
        return value.map {
            (id: $0.id ?? 0, name: $0.name ?? "", description: $0.description ?? "", imageURL: $0.imageURL ?? "")
        }
    }
    
    func fetchMoreData(from: Int) -> Single<Result<[Beer], PunkNetworkError>> {
        // 총 325개
        let page = (from + 1)/25 + 1
        return punkNetwork.getBeers(components: BeerFilterComponents(), page: page, perPage: 25)
    }
}
