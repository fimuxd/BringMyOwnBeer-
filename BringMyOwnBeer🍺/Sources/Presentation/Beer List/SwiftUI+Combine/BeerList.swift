//
//  BeerList.swift
//  BringMyOwnBeer🍺
//
//  Created by Bo-Young PARK on 2019/10/14.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import SwiftUI

struct BeerList: View {
    @ObservedObject var viewModel: BeerListViewModelWithCombine
    
    init(viewModel: BeerListViewModelWithCombine) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.beers, content: BeerRow.init(beer:))
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("맥주리스트")
    }
}
