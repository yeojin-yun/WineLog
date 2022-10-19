//
//  WineListCell.swift
//  WineLog
//
//  Created by 서은지 on 2022/10/04.
//

import UIKit

class WineListCell: UICollectionViewCell {

    static let identifier = "CustomListCVCell"

    var nameLabel = UILabel()
    var priceLabel = UILabel()
    var scoreLabel = UILabel()
    var typeLabel = CustomLabel(title: "", padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))

    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension WineListCell {
    func setTypeLabel(type: WineType) {
        typeLabel.textColor = type.wineTextColor
        typeLabel.backgroundColor = type.wineColor
        typeLabel.text = type.wineType
    }
    
    func setUI() {
        setAttributes()
        setLayout()
    }
    
    func setAttributes() {
        imageView.image = UIImage(named: "wineTest")
        imageView.backgroundColor = .myGreen?.withAlphaComponent(0.4)
        imageView.layer.cornerRadius = 10

        nameLabel.font = .boldSystemFont(ofSize: 17)

        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 13
        
        [priceLabel, scoreLabel].forEach {
//            $0.adjustsFontSizeToFitWidth = true
            $0.textColor = .darkGray
            $0.font = UIFont.systemFont(ofSize: 13)
        }
    }
    
    func setLayout() {
        let topStackView = UIStackView(arrangedSubviews: [typeLabel, nameLabel])
        topStackView.axis = .horizontal
        topStackView.spacing = 4
        
        let bottomStackView = UIStackView(arrangedSubviews: [priceLabel, scoreLabel])
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 2

        [topStackView, bottomStackView, imageView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }


        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            topStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 8),
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
//            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
//            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
//            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
////            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
//
////            scoreLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
//            scoreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
//            scoreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

        ])
    }
}



