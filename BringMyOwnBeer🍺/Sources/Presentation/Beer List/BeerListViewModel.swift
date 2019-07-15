//
//  BeerListViewModel.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

struct BeerListViewModel: BeerListViewBindable {
    let disposeBag = DisposeBag()
    
    let viewWillAppear = PublishSubject<Void>()
    let cellData: Driver<[BeerListCell.Data]>
    let itemSelected = PublishRelay<Int>()
    let willDisplayCell = PublishRelay<IndexPath>()
    let reloadList: Signal<Void>
    let errorMessage: Signal<String>
    
    private var cells = BehaviorRelay<[Beer]>(value: [])
    
    init(model: BeerListModel = BeerListModel()) {
        let beerListResult = viewWillAppear
            .flatMapLatest(model.getBeerList)
            .asObservable()
            .share()
        
        let beerListValue = beerListResult
            .map { result -> [Beer]? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value
            }
            .filterNil()
        
        let beerListError = beerListResult
            .map { result -> String? in
                guard case .failure(let error) = result else {
                    return nil
                }
                return error.message
            }
            .filterNil()
        
        let shouldMoreFatch = Observable
            .combineLatest(
                willDisplayCell,
                cells
            ) { (indexPath: $0, list: $1) }
            .map { data -> Int? in
                guard data.list.count > 24 else {
                    return nil
                }
                
                let lastCellCount = data.list.count
                if lastCellCount - 1 == data.indexPath.row {
                    return data.indexPath.row
                }
             
                return nil
            }
            .filterNil()
        
        let fetchedResult = shouldMoreFatch
            .distinctUntilChanged()
            .filter { $0 < 324 }
            .flatMapLatest(model.fetchMoreData)
            .asObservable()
            .share()
        
        let fetchedList = fetchedResult
            .map { result -> [Beer]? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value
            }
            .filterNil()
        
        let fetchedError = fetchedResult
            .map { result -> String? in
                guard case .failure(let error) = result else {
                    return nil
                }
                return error.message
            }
            .filterNil()
        
        Observable
            .merge(
                beerListValue,
                fetchedList
            )
            .scan([]){ prev, newList in
                return newList.isEmpty ? [] : prev + newList
            }
            .bind(to: cells)
        
        self.cellData = cells
            .map(model.parseData)
            .asDriver(onErrorDriveWith: .empty())
        
        self.reloadList = Observable
            .zip(
                beerListValue,
                fetchedList
            )
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())
        
        self.errorMessage = Observable
            .merge(
                beerListError,
                fetchedError
            )
            .asSignal(onErrorJustReturn: PunkNetworkError.defaultError.message ?? "")
    }
}
