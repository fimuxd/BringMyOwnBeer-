//
//  PunkServiceImpl.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class PunkServiceImpl: PunkService {
    let punkRepo: PunkRepository
    
    init(punkRepo: PunkRepository) {
        self.punkRepo = punkRepo
    }
    
    func getBeers(components: BeerFilterComponents, page: Int?, perPage: Int?) -> Single<BeerResult<[Beer]>> {
        return punkRepo
            .getBeers(components: components, page: page, perPage: perPage)
            .map { .success($0) }
            .catchError {
                guard case MoyaError.statusCode(let res) = $0,
                    let errorData = try? res.map(PunkErrorData.self) else {
                    return .just(.failure(.defaultError))
                }
                return .just(.failure(.error(errorData.message)))
            }
    }
    
    func getSingleBeer(id: String) -> Single<BeerResult<[Beer]>> {
        return punkRepo
            .getSingleBeer(id: id)
            .map { .success($0) }
            .catchError {
                guard case MoyaError.statusCode(let res) = $0,
                    let errorData = try? res.map(PunkErrorData.self) else {
                        return .just(.failure(.defaultError))
                }
                return .just(.failure(.error(errorData.message)))
            }
    }
    
    func getRandomBeer() -> Single<BeerResult<[Beer]>> {
        return punkRepo
            .getRandomBeer()
            .map { .success($0) }
            .catchError {
                guard case MoyaError.statusCode(let res) = $0,
                    let errorData = try? res.map(PunkErrorData.self) else {
                        return .just(.failure(.defaultError))
                }
                return .just(.failure(.error(errorData.message)))
            }
    }
}
