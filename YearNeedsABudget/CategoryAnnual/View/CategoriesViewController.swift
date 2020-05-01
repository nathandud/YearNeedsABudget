//
//  ViewController.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/9/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import UIKit
import os.log

class CategoriesViewController: UIViewController {
    
    let viewModel: CategoriesViewModel
    weak var coordinator: Coordinator?
    
    init(viewModel: CategoriesViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        viewModel.refreshData(onCompletion: { success in
            guard success else { return }
            DispatchQueue.main.async {
                self.categoryTableView.reloadData()
            }
        })
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CategoryTableViewCell else { return UITableViewCell () }
        cell.configure(with: viewModel.tableViewModels[indexPath.row])
        return cell
    }
    
}
