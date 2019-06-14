//
//  PunkRepository.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift

protocol PunkRepository {
    func getBeers(components: BeerFilterComponents, page: Int?, perPage: Int?) -> Single<[Beer]>
    func getSingleBeer(id: String) -> Single<[Beer]>
    func getRandomBeer() -> Single<[Beer]>
}
