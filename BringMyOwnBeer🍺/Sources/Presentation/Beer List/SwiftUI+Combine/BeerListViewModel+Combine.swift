//
//  BeerListViewModel+Combine.swift
//  BringMyOwnBeer🍺
//
//  Created by Bo-Young PARK on 2019/10/14.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import SwiftUI
import Combine

class BeerListViewModelWithCombine: ObservableObject {
    @Published var beers: [Beer] = []
    
    private let punkService: PunkService
    private var disposables = Set<AnyCancellable>()
    
    init(
        punkService: PunkService,
        scheduler: DispatchQueue = DispatchQueue(label: "BeerListViewModel")
    ) {
        self.punkService = punkService
    }
    
    func getBeers() {
        punkService.getBeers()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else {
                        return
                    }
                    switch value {
                    case .failure:
                        self.beers = []
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] beers in
                    guard let self = self else {
                        return
                    }
                    self.beers = beers
                }
            )
            .store(in: &disposables)
    }
}
