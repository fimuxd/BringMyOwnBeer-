//
//  PunkNetworkImpl.swift
//  BringMyOwnBeer🍺
//
//  Created by Bo-Young PARK on 2019/10/29.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift

class PunkNetworkImpl: PunkNetwork {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getBeers(page: Int?) -> Observable<Result<[Beer], PunkNetworkError>> {
        guard let url = makeGetBeersComponents(page: page).url else {
            let error = PunkNetworkError.error("유효하지 않은 URL")
            return .just(.failure(error))
        }

        return session.rx.data(request: URLRequest(url: url))
            .map { data in
                do {
                    let beers = try JSONDecoder().decode([Beer].self, from: data)
                    return .success(beers)
                } catch {
                    return .failure(.error("getBeers API 에러"))
                }
            }
    }

    func getBeer(id: String) -> Observable<Result<[Beer], PunkNetworkError>> {
        guard let url = makeGetBeerComponents(id: id).url else {
            let error = PunkNetworkError.error("유효하지 않은 URL")
            return .just(.failure(error))
        }

        return session.rx.data(request: URLRequest(url: url))
            .map { data in
                do {
                    let beers = try JSONDecoder().decode([Beer].self, from: data)
                    return .success(beers)
                } catch {
                    return .failure(.error("getBeer API 에러"))
                }
            }
    }

    func getRandomBeer() -> Observable<Result<[Beer], PunkNetworkError>> {
        guard let url = makeGetRandomBeerComponents().url else {
            let error = PunkNetworkError.error("유효하지 않은 URL")
            return .just(.failure(error))
        }

        return session.rx.data(request: URLRequest(url: url))
            .map { data in
                do {
                    let beers = try JSONDecoder().decode([Beer].self, from: data)
                    return .success(beers)
                } catch {
                    return .failure(.error("getRandomBeer API 에러"))
                }
            }
    }
}

private extension PunkNetworkImpl {
    enum PunkAPI {
        static let scheme = "https"
        static let host = "api.punkapi.com"
        static let path = "/v2/beers"
    }

    func makeGetBeersComponents(page: Int?) -> URLComponents {
        var components = URLComponents()
        components.scheme = PunkAPI.scheme
        components.host = PunkAPI.host
        components.path = PunkAPI.path
        if let page = page {
            components.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "80")
            ]
        } else {
            components.queryItems = [
                URLQueryItem(name: "per_page", value: "80")
            ]
        }

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
