//
//  ContactCellForGrid.swift
//  zeliz22-ass4
//
//  Created by zaza elizbarashvili on 16/11/1403 AP.
//

import UIKit

class ContactCellForGrid: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let phoneLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nameLabel.numberOfLines = 1
        
        phoneLabel.textAlignment = .center
        phoneLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        //phoneLabel.textColor = .darkGray
        phoneLabel.numberOfLines = 1
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            phoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            phoneLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with contact: Contact) {
        nameLabel.text = contact.name
        phoneLabel.text = contact.phoneNumber
    }
}
