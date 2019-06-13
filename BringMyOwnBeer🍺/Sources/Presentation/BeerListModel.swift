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
    let punkService: PunkService
    
    init(punkService: PunkService = PunkServiceImpl(punkRepo: PunkRepositoryImpl())) {
        self.punkService = punkService
    }
    
    func getBeerList() -> Single<Result<[Beer], PunkServiceError>> {
        return punkService.getBeers(components: BeerFilterComponents(), page: nil, perPage: nil)
    }
}
