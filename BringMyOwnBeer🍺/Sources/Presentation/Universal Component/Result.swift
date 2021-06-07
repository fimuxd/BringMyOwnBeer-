//
//  Result.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 11/07/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation

extension Result {
    var value: Success? {
        guard case .success(let value) = self else {
            return nil
        }
        return value
    }

    var error: Failure? {
        guard case .failure(let error) = self else {
            return nil
        }
        return error
    }

    var isSuccess: Bool {
        value != nil
    }
}
