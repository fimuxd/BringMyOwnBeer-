//
//  PunkNetworkImpl.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class PunkNetworkImpl: PunkNetwork {
    let provider = MoyaProvider<PunkAPI>()
    
    func getBeers(components: BeerFilterComponents, page: Int?, perPage: Int?) -> Single<BeerResult<[Beer]>> {
        return provider.rx.request(
                .getBeers(components: components, page: page, perPage: perPage)
            )
            .filterSuccessfulStatusCodes()
            .map { res in
                try JSONDecoder().decode([Beer].self, from: res.data)
            }
            .map { .success($0) }
            .catchError {
                guard case MoyaError.statusCode(let res) = $0,
                    let errorData = try? res.map(PunkErrorData.self) else {
                    return .just(.failure(.defaultError))
                }
                return .just(.failure(.error(errorData.message)))
            }
    }
    
    func getBeer(id: String) -> Single<BeerResult<Beer>> {
        return provider.rx.request(.getBeer(id: id))
            .filterSuccessfulStatusCodes()
            .map { try JSONDecoder().decode([Beer].self, from: $0.data) }
            .map { beers in
                guard let beer = beers.first else {
                    return .failure(.defaultError)
                }
                return .success(beer)
            }
            .catchError {
                guard case MoyaError.statusCode(let res) = $0,
                    let errorData = try? res.map(PunkErrorData.self) else {
                        return .just(.failure(.defaultError))
                }
                return .just(.failure(.error(errorData.message)))
            }
    }
    
    func getRandomBeer() -> Single<BeerResult<Beer>> {
        return provider.rx.request(.getRandomBeer)
            .filterSuccessfulStatusCodes()
            .map { try JSONDecoder().decode([Beer].self, from: $0.data) }
            .map { beers in
                guard let beer = beers.first else {
                    return .failure(.defaultError)
                }
                return .success(beer)
            }
            .catchError {
                guard case MoyaError.statusCode(let res) = $0,
                    let errorData = try? res.map(PunkErrorData.self) else {
                        return .just(.failure(.defaultError))
                }
                return .just(.failure(.error(errorData.message)))
            }
    }
}
