//
//  Coordinator.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/24/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import UIKit

class Coordinator {
    
    let navigationController: UINavigationController
    //Can make this a dictionary of repositories later. When memory is tight, I can ask the coordinator to dump a repo?
    let categoryRepository = CategoryRepository()
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = CategoriesViewController(viewModel: CategoriesViewModel(repository: categoryRepository), coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }
    
}
