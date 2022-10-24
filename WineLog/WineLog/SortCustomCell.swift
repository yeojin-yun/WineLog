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

        layer.masksToBounds = true
        layer.cornerRadius = 15
        layer.borderColor =  #colorLiteral(red: 0.7447593808, green: 0.8098963499, blue: 0.7396327853, alpha: 1)
        layer.borderWidth = 2
        label.textColor = .myGreen
        label.font = .boldSystemFont(ofSize: 13)
       
        contentView.addSubview((label))
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        ])
    }
}

