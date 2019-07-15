//
//  RandomBeerModelTests.swift
//  BringMyOwnBeer🍺Tests
//
//  Created by Boyoung Park on 11/07/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Nimble
import XCTest

@testable import BringMyOwnBeer_

class RandomBeerModelTest: XCTestCase {
    let disposeBag = DisposeBag()
    let networkStub = PunkNetworkStub()
    var viewModel: RandomBeerViewModel!
    var model: RandomBeerModel!
    
    override func setUp() {
        self.model = RandomBeerModel(punkNetwork: networkStub)
        self.viewModel = RandomBeerViewModel(model: model)
    }
    
    // Unit Test
    func testGetRandomBeer() {
        model.getRandomBeer()
            .subscribe(onSuccess: { result in
                let beer = try? result.get()
                assert(beer != nil, "Random Beer Getting Success")
            })
            .disposed(by: disposeBag)
    }
    
    func testParseData() {
        let beersData = BeersDummyData.beersJSONString.data(using: .utf8)!
        let beer = try! JSONDecoder().decode([Beer].self, from: beersData).first!
        let parsedData = model.parseData(value: beer)
        assert(parsedData?.id == 316, "Randome Beer ID Parsing Success")
    }
    
    // ViewModel Test
    func testGetAndParse() {
        viewModel.selectedBeerData.emit(onNext: { data in
            assert(data.id == 316)
        })
        .disposed(by: disposeBag)
        
        viewModel.randomButtonTapped.accept(Void())
    }
}
