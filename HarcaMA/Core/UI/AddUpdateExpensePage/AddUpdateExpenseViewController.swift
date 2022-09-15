//
//  AddUpdateExpenseViewController.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//


import UIKit

protocol AddUpdateExpanseDelegate: AnyObject {
    func addNewExpanse(title: String, date: Date, price: Double)
    func updateExpanse(with expense: Expense)
}

public enum AddEditExpenseMode {
    case update
    case add
}

class AddUpdateExpenseViewController: UIViewController {
    private let mode: AddEditExpenseMode
    private let expense: Expense?
    
    weak var delegate: AddUpdateExpanseDelegate?
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Title...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 12
        textField.returnKeyType = .continue
        return textField
    }()
    
    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Amount...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 12
        textField.keyboardType = .decimalPad
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.cornerRadius = 12
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.textColor = .lightGray
        return label
    }()
    
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .dateAndTime
        datePicker.timeZone = TimeZone.current
        return datePicker
    }()
    
    private lazy var addUpdateButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.mode == .add ? "Add Expense" : "Save Changes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    init(mode: AddEditExpenseMode, expense: Expense?) {
        self.mode = mode
        self.expense = expense
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureNavigationBar()
        view.backgroundColor = .systemBackground
        titleTextField.delegate = self
        priceTextField.delegate = self
        titleTextField.becomeFirstResponder()
        addSubviews()
    }
    
    
    private func configureNavigationBar(){
        self.title = self.mode == .add ? "Add Expense" : "Update Expense"
        let titleTextAttrs = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttrs
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func addSubviews(){
        view.addSubview(titleTextField)
        view.addSubview(priceTextField)
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(datePicker)
        view.addSubview(dateStackView)
        view.addSubview(addUpdateButton)
        guard let expense = self.expense, self.mode == .update else { return }
        fillFields(with: expense)
    }
    
    private func fillFields(with expense: Expense){
        self.titleTextField.text = expense.title
        self.priceTextField.text = String(expense.price)
        self.datePicker.date = expense.date
    }
    
    override func viewDidLayoutSubviews() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().inset(50)
            make.height.equalTo(52)
        }
        priceTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleTextField)
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.height.equalTo(52)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleTextField)
            make.top.equalTo(priceTextField.snp.bottom).offset(20)
            make.height.equalTo(52)
        }
        
        addUpdateButton.snp.makeConstraints { make in
            make.trailing.equalTo(titleTextField)
            make.top.equalTo(dateStackView.snp.bottom).offset(20)
        }
    }
    
    @objc private func didTapButton(){
        guard let priceText = priceTextField.text,
              let price = Double(priceText),
              let title = titleTextField.text else { return }
        let date = datePicker.date
        if self.mode == .add {
            delegate?.addNewExpanse(title: title, date: date, price: price)
        } else {
            guard let expense = expense else { return }
            let newExpense = Expense(id: expense.id, title: title, date: date, price: price)
            delegate?.updateExpanse(with: newExpense)
        }
        self.dismiss(animated: true)
    }
    
}
extension AddUpdateExpenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            priceTextField.becomeFirstResponder()
        } else if textField == priceTextField {
            view.endEditing(true)
            
        }
        return true
    }
}
