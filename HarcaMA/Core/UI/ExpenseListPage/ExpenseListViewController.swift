//
//  ExpenseListViewController.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//

import UIKit
import CoreData
class ExpenseListViewController: UIViewController {
    
    let viewModel: ExpenseListViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    init(context: NSManagedObjectContext) {
        self.viewModel = ExpenseListViewModel(context: context)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExpenseListTableViewCell.self, forCellReuseIdentifier: ExpenseListTableViewCell.identifier)
        configureNavigationBar()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureNavigationBar(){
        self.title = "Expenses"
        let titleTextAttrs = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttrs
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddExpense))
    }
    @objc private func didTapAddExpense(){
        let vc = AddUpdateExpenseViewController(mode: .add, expense: nil)
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}


extension ExpenseListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.expenseList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseListTableViewCell.identifier, for: indexPath) as? ExpenseListTableViewCell else { return UITableViewCell() }
        cell.expense = viewModel.expenseList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemGray
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        let tailStackView = UIStackView()
        tailStackView.spacing = 100
        let dateLabel = UILabel()
        dateLabel.text = "Date"
        let priceLabel = UILabel()
        priceLabel.text = "Price"
        stackView.addArrangedSubview(titleLabel)
        tailStackView.addArrangedSubview(dateLabel)
        tailStackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(tailStackView)
        return stackView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlertSheet(for: viewModel.expenseList[indexPath.row])
        
    }
    
    private func showAlertSheet(for expense: Expense){
        let alert = UIAlertController(title: "What to do with this expense?", message: expense.title, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {[weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.deleteExpense(id: expense.id) {
                strongSelf.tableView.reloadData()
            }
        }
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            let vc = AddUpdateExpenseViewController(mode: .update, expense: expense)
            vc.delegate = strongSelf
            strongSelf.present(UINavigationController(rootViewController: vc), animated: true)
        }
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        present(alert, animated: true) 
    }
}

extension ExpenseListViewController: AddUpdateExpanseDelegate {
    func updateExpanse(with expense: Expense) {
        viewModel.updateExpense(with: expense) {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func addNewExpanse(title: String, date: Date, price: Double) {
        viewModel.addExpense(title: title, date: date, price: price) {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
}
