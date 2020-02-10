//
//  ViewController.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/9/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import UIKit
import SnapKit

class CategoriesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

