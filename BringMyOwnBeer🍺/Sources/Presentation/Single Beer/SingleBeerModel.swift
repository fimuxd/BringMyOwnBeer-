//
//  SingleBeerModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 14/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift

struct SingleBeerModel {
    let punkService: PunkService
    
    init(punkService: PunkService = PunkServiceImpl(punkRepo: PunkRepositoryImpl())) {
        self.punkService = punkService
    }
    
    func getSingleBeer(id: String) -> Single<Result<[Beer], PunkServiceError>> {
        return punkService.getSingleBeer(id: id)
    }
    
    func parseData(value: [Beer]) -> BeerListCell.Data? {
        guard let value = value.first else {
            return nil
        }
        
        return (id: value.id ?? 0, name: value.name ?? "", description: value.description ?? "", imageURL: value.imageURL ?? "")
    }
}
