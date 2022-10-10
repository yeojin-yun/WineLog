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
    var typeImageView = UIImageView()

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
    func setUI() {
        imageView.image = UIImage(named: "이미지테스트")
        imageView.layer.cornerRadius = 10

        nameLabel.font = .boldSystemFont(ofSize: 17)
        
        layer.masksToBounds = true
        contentView.backgroundColor = #colorLiteral(red: 0.7447593808, green: 0.8098963499, blue: 0.7396327853, alpha: 1)
        layer.cornerRadius = 13
        
        [nameLabel, priceLabel,scoreLabel,imageView,typeImageView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [nameLabel, priceLabel,scoreLabel].forEach {
            $0.adjustsFontSizeToFitWidth = true
            
        }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            
            scoreLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            scoreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            typeImageView.topAnchor.constraint(equalTo: imageView.topAnchor,constant: -8),
            typeImageView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,constant: -8),
            typeImageView.heightAnchor.constraint(equalToConstant: 30),
            typeImageView.widthAnchor.constraint(equalTo: typeImageView.heightAnchor)

        ])
    }
}



