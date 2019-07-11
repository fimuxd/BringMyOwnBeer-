//
//  Observable+Optional.swift
//  BringMyOwnBeer🍺
//
//  Created by iOS_BoyoungPARK on 11/07/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func filterNilValue<Value>(_ transform: @escaping (E) -> Value?) -> Observable<Value> {
        return map(transform).filterNil()
    }
}

public extension SharedSequenceConvertibleType {
    func filterNilValue<Value>(_ transform: @escaping (E) -> Value?) -> SharedSequence<SharingStrategy, Value> {
        return map(transform).filterNil()
    }
}
