//
//  PunkService.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift

enum PunkServiceError: Error {
    case error(String)
    case defaultError
    
    var message: String? {
        switch self {
        case let .error(msg):
            return msg
        case .defaultError:
            return "잠시 후에 다시 시도해주세요."
        }
    }
}

protocol PunkService {
    typealias BeerResult<T> = Result<T, PunkServiceError>
    
    func getBeers(components: BeerFilterComponents, page: Int?, perPage: Int?) -> Single<BeerResult<[Beer]>>
    func getSingleBeer(id: String) -> Single<BeerResult<[Beer]>>
    func getRandomBeer() -> Single<BeerResult<[Beer]>>
}
