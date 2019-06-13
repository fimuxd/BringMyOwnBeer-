//
//  PunkErrorData.swift
//  BringMyOwnBeer🍺
//
//  Created by Boyoung Park on 13/06/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation

struct PunkErrorData: Codable {
    let statusCode: Int
    let error: String
    let message: String
}
