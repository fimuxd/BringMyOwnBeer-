//
//  PunkAPI.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import RxSwift
import Moya

enum PunkAPI {
    case getBeers(components: BeerFilterComponents, page: Int?, perPage: Int?)
    case getBeer(id: String)
    case getRandomBeer
}

extension PunkAPI: TargetType {
    var baseURL: URL {
        return URL(string: URLs.API.gateway)!
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getBeers:
            return "/v2/beers"
        case let .getBeer(id):
            return "/v2/beers/\(id)"
        case .getRandomBeer:
            return "/v2/beers/random"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .getBeers(components, page, perPage):
            guard let page = page,
                let perPage = perPage else {
                return nil
            }
            
            return [
//                "abv_gt": abvGT,
//                "abv_lt": abvLT,
//                "ibu_gt": components.ibuGreaterThanSuppliedNumber,
//                "ibu_lt": components.ibuLessThanSUppliedNumber,
//                "ebc_gt": components.ebcGreaterThanSuppliedNumber,
//                "ebc_lt": components.ebcLessThanSUppliedNumber,
//                "beer_name": components.name,
//                "yeast": components.yeast,
//                "brewed_before": components.brewedBefore?.toFormat("MM-yyyy"),
//                "brewed_after": components.brewedAfter?.toFormat("MM-yyyy"),
//                "hops": components.hops,
//                "malt": components.malt,
//                "food": components.food,
//                "ids": components.ids,
                "page": page,
                "per_page": perPage
            ]
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestParameters(
            parameters: self.parameters ?? [:],
            encoding: URLEncoding.default
        )
    }
}
