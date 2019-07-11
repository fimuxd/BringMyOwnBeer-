//
//  PunkNetworkStub.swift
//  BringMyOwnBeer🍺Tests
//
//  Created by iOS_BoyoungPARK on 11/07/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift

@testable import BringMyOwnBeer_

struct PunkNetworkStub: PunkNetwork {
    private func getStubBeers() -> Single<BeerResult<[Beer]>> {
        let beerData = BeersDummyData.beersJSONString.data(using: .utf8)!
        do {
            let beers = try JSONDecoder().decode([Beer].self, from: beerData)
            return .just(.success(beers))
        } catch {
            return .just(.failure(.defaultError))
        }
    }
    
    func getBeers(components: BeerFilterComponents, page: Int?, perPage: Int?) -> Single<BeerResult<[Beer]>> {
        return getStubBeers()
    }
    
    func getBeer(id: String) -> Single<BeerResult<Beer>> {
        return getStubBeers()
            .map {
                $0.flatMap { beers in
                    guard let beer = beers.first else {
                        return .failure(.defaultError)
                    }
                    return .success(beer)
                }
            }
    }
    
    func getRandomBeer() -> Single<BeerResult<Beer>> {
        return getStubBeers()
            .map {
                $0.flatMap { beers in
                    guard let beer = beers.randomElement() else {
                        return .failure(.defaultError)
                    }
                    return .success(beer)
                }
            }
    }
}
