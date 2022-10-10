//
//  SortCustomCell.swift
//  WineLog
//
//  Created by 서은지 on 2022/10/04.
//

import UIKit

class SortCustomCell: UICollectionViewCell {
    
    static let identifier = "CustomSortCVCell"
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SortCustomCell {
    func setUI() {

        label.text = "test"

        contentView.addSubview((label))
        layer.masksToBounds = true
        layer.cornerRadius = 20

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        ])
    }
}

