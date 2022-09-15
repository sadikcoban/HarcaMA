//
//  ExpenseListTableViewCell.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//


import UIKit
import SnapKit
class ExpenseListTableViewCell: UITableViewCell {
    static let identifier = "ExpenseListTableViewCell"
    
    var expense: Expense? {
        didSet {
            self.configure()
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var tailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 50
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private func configure(){
        self.titleLabel.text = expense?.title.shorted(to: 15)
        self.dateLabel.text = expense?.formattedDate
        let price = expense?.price ?? 0
        self.priceLabel.text = "$ \(price)"
        setupConsts()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConsts(){
        tailStackView.addArrangedSubview(dateLabel)
        tailStackView.addArrangedSubview(priceLabel)
        priceLabel.snp.makeConstraints { $0.width.equalTo(70) }
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(tailStackView)
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

