//
//  BeerRow.swift
//  BringMyOwnBeer🍺
//
//  Created by Bo-Young PARK on 2019/10/14.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import SwiftUI

struct BeerRow: View {
    var beer: Beer
    
    init(beer: Beer) {
        self.beer = beer
    }
    
    var body: some View {
        VStack {
            Text("\(beer.id ?? 0)")
            Text(beer.name ?? "unknown beer")
            Text(beer.description ?? "")
        }
    }
}
