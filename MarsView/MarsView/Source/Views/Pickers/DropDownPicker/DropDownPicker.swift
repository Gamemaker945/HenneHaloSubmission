//
//  DropDownPicker.swift
//  MarsView
//
//  Created by Christian Henne on 4/17/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol DropDownPickerDelegate {
    
    func dropDownPicker(_ pickerView: DropDownPicker, titleForRow row: Int) -> String?
    
    func dropDownPicker(_ pickerView: DropDownPicker, didSelectRow row: Int)
}

protocol DropDownDataSource {
        
    func numberOfRowsIn(_ pickerView: DropDownPicker) -> Int
    
}

class DropDownPicker: UIView {
    
    struct Constants {
        static let rowHeight = CGFloat(50)
    }
    
    // MARK: - Private Variables
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var headerContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var arrow: UIImageView = {
        let img = UIImageView(frame: .zero)
        let image = UIImage(cgImage: UIImage(named: "arrow")!.cgImage!, scale: CGFloat(1.0), orientation: .down)
        img.image = image
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .white
        label.text = ""
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var table: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(DropDownPickerCell.self, forCellReuseIdentifier: DropDownPickerCell.identifier)
        table.separatorStyle = .none
        table.tableHeaderView = UIView(frame: .zero)
        table.tableFooterView = UIView(frame: .zero)
        table.backgroundColor = .clear
        return table
    }()
    
    public var dataSource: DropDownDataSource?
    public var delegate: DropDownPickerDelegate?
    
    var value: String {
        let row = selectedRow
        let string = delegate?.dropDownPicker(self, titleForRow: row) ?? ""
        return string
    }
    
    var selectedRow: Int = 0
    
    var isOpen: Bool = false
    
    var title: String  = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Lifecycle Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        valueLabel.text = value
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        headerContainerView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadAllComponents() {
        table.reloadData()
        selectedRow = 0
        valueLabel.text = value
    }
    
    @objc
    func viewTapped() {
        isOpen = !isOpen
        isOpen ? openTable() : closeTable()
    }
    
    
}

extension DropDownPicker: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRowsIn(self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownPickerCell.identifier, for: indexPath) as? DropDownPickerCell else {
            fatalError("DropDownPicker configured incorrectly for reuse ID \(DropDownPickerCell.identifier)")
        }
        
        cell.setValue(delegate?.dropDownPicker(self, titleForRow: indexPath.row) ?? "")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        valueLabel.text = value
        delegate?.dropDownPicker(self, didSelectRow: selectedRow)
        closeTable()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}

private extension DropDownPicker {
    
    private func setup() {
        addComponents()
        setupConstraints()
    }
    
    private func addComponents() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(headerContainerView)
        stackView.addArrangedSubview(table)
        
        headerContainerView.addSubview(titleLabel)
        headerContainerView.addSubview(valueLabel)
        headerContainerView.addSubview(arrow)
    }
    
    private func setupConstraints() {
        
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        headerContainerView.snp.makeConstraints{
            $0.height.equalTo(40)
        }
        
        arrow.snp.makeConstraints{
            $0.height.width.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-13)
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.60)
        }
        
        valueLabel.snp.makeConstraints{
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalTo(arrow.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        table.snp.makeConstraints{
            $0.height.equalTo(0).priority(.high)
        }
    }
    
    private func getMaxTableHeight() -> CGFloat {
        if !isOpen { return CGFloat(0) }
        guard let dataSource = dataSource, dataSource.numberOfRowsIn(self) > 0 else { return CGFloat(0) }
        let numRows = dataSource.numberOfRowsIn(self)
        if numRows > 4 {
            return Constants.rowHeight * CGFloat(4.5)
        } else {
            return Constants.rowHeight * CGFloat(numRows) + Constants.rowHeight / CGFloat(2.0)
        }
    }
    
    private func openTable() {
        arrow.image = UIImage(cgImage: UIImage(named: "arrow")!.cgImage!, scale: CGFloat(1.0), orientation: .up)
        table.snp.remakeConstraints{
            $0.height.equalTo(getMaxTableHeight()).priority(.high)
        }
    }
    
    private func closeTable() {
        arrow.image = UIImage(cgImage: UIImage(named: "arrow")!.cgImage!, scale: CGFloat(1.0), orientation: .down)
        table.snp.remakeConstraints{
            $0.height.equalTo(0).priority(.high)
        }
    }
}
