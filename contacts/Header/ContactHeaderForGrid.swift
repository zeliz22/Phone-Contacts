//
//  ContactHeaderForGrid.swift
//  zeliz22-ass4
//
//  Created by zaza elizbarashvili on 16/11/1403 AP.
//

import UIKit

protocol ContactHeaderForGridDelegate: AnyObject {
    func toggleSectionForGrid(_ header: ContactHeaderForGrid, section: Int)
}

class ContactHeaderForGrid: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let collapseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: ContactHeaderForGridDelegate?
    private var section: Int = 0
    private var isCollapsed: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setupViews()
        collapseButton.addTarget(self, action: #selector(toggleCollapse), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(collapseButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collapseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collapseButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with header: ContactHeaderModel, section: Int, isCollapsed: Bool) {
        titleLabel.text = header.title
        self.section = section
        self.isCollapsed = isCollapsed
        updateButtonTitle()
    }
    
    private func updateButtonTitle() {
        let title = isCollapsed ? "Expand" : "Collapse"
        collapseButton.setTitle(title, for: .normal)
    }
    
    @objc private func toggleCollapse() {
        delegate?.toggleSectionForGrid(self, section: section)
    }
}

