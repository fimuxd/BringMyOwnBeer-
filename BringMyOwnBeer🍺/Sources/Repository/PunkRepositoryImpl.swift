//
//  PunkRepositoryImpl.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class PunkRepositoryImpl: PunkRepository {
    let provider = MoyaProvider<PunkAPI>()
    
    func getBeers(components: BeerFilterComponents, page: Int?, perPage: Int?) -> Single<[Beer]> {
        return self.provider.rx
            .request(
                .getBeers(
                    components: components,
                    page: page,
                    perPage: perPage
                )
            )
            .filterSuccessfulStatusCodes()
            .map([Beer].self)
    }
    
    func getSingleBeer(id: String) -> Single<[Beer]> {
        return self.provider.rx
            .request(.getSingleBeer(id: id))
            .filterSuccessfulStatusCodes()
            .map([Beer].self)
    }
    
    func getRandomBeer() -> Single<[Beer]> {
        return self.provider.rx
            .request(.getRandomBeer)
            .filterSuccessfulStatusCodes()
            .map([Beer].self)
    }
}
