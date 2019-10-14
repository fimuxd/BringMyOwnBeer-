//
//  PunkNetwork+Combine.swift
//  BringMyOwnBeer🍺
//
//  Created by Bo-Young PARK on 2019/10/14.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import Combine

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, PunkNetworkError> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    
    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            .defaultError
        }
        .eraseToAnyPublisher()
}

protocol PunkService {
    func getBeers() -> AnyPublisher<[Beer], PunkNetworkError>
    func getBeer(id: String) -> AnyPublisher<Beer, PunkNetworkError>
    func getRandomBeer() -> AnyPublisher<Beer, PunkNetworkError>
}

class PuckServiceImpl: PunkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getBeers() -> AnyPublisher<[Beer], PunkNetworkError> {
        guard let url = makeGetBeersComponents().url else {
            let error = PunkNetworkError.error("유효하지 않은 URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                PunkNetworkError.error("getBeers API 에러")
            }
            .flatMap(maxPublishers: .max(1)) { data in
                decode(data.data)
            }
            .eraseToAnyPublisher()
    }
    
    func getBeer(id: String) -> AnyPublisher<Beer, PunkNetworkError> {
        guard let url = makeGetBeerComponents(id: id).url else {
            let error = PunkNetworkError.error("유효하지 않은 URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                PunkNetworkError.error("getBeer API 에러")
            }
            .flatMap(maxPublishers: .max(1)) { data in
                decode(data.data)
            }
            .eraseToAnyPublisher()
    }
    
    func getRandomBeer() -> AnyPublisher<Beer, PunkNetworkError> {
        guard let url = makeGetRandomBeerComponents().url else {
            let error = PunkNetworkError.error("유효하지 않은 URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                PunkNetworkError.error("getRandomBeer API 에러")
            }
            .flatMap(maxPublishers: .max(1)) { data in
                decode(data.data)
            }
            .eraseToAnyPublisher()
    }
}

private extension PuckServiceImpl {
    struct PunkAPI {
        static let scheme = "https"
        static let host = "api.punkapi.com"
        static let path = "/v2/beers"
    }
    
    func makeGetBeersComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = PunkAPI.scheme
        components.host = PunkAPI.host
        components.path = PunkAPI.path
        
        return components
    }
    
    func makeGetBeerComponents(id: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = PunkAPI.scheme
        components.host = PunkAPI.host
        components.path = PunkAPI.path + "/\(id)"
        
        return components
    }
    
    func makeGetRandomBeerComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = PunkAPI.scheme
        components.host = PunkAPI.host
        components.path = PunkAPI.path + "/random"
        
        return components
    }
}
