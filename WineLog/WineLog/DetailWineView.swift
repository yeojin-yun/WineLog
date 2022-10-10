//
//  DetailWineView.swift
//  WineLog
//
//  Created by 순진이 on 2022/10/04.
//

import UIKit

class DetailWineView: UIView {
    
    var wineImage = UIImageView()
    // 와인이름
    let wineNameLabel = UILabel()
    let wineNameTextField = UITextField()
    // 와인종류
    let kindOfWineLabel = UILabel()
    let kindOfWineTextField = UITextField()
    // 산지
    let countryOfOriginLabel = UILabel()
    let countryOfOriginTextField = UITextField()
    // 제조일
    let yearOfMakingLabel = UILabel()
    let yearOfMakingTextField = UITextField()
    // 시음 날짜
    let dateToDrinkLabel = UILabel()
    let dateToDrinkTextField = UITextField()
    // 별점 (당도, 산도, 바디)
    let gradeOfWineLabel = UILabel()
    let gradeOfWineTextField = UITextField()
    // 구매처
    let storeToBuyLabel = UILabel()
    let storeToBuyTextField = UITextField()
    // 가격
    let priceOfWineLabel = UILabel()
    let priceOfWineTextField = UITextField()
    // 한줄평
    let reviewOfWineLabel = UILabel()
    let reviewOfWineTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setUI()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttributes() {
        wineImage.backgroundColor = .yellow
        
        wineNameLabel.text = "와인 이름"
        wineNameTextField.text = "wineNameTextField"
        
        kindOfWineLabel.text = "와인 종류"
        kindOfWineTextField.text = "kindOfWineTextField"
        
        countryOfOriginLabel.text = "원산지"
        countryOfOriginTextField.text = "countryOfOriginTextField"
        
        yearOfMakingLabel.text = "제조연도"
        yearOfMakingTextField.text = "yearOfMakingTextField"
        
        dateToDrinkLabel.text = "마신 날짜"
        dateToDrinkTextField.text = "dateToDrinkTextField"
        
        gradeOfWineLabel.text = "별점"
        gradeOfWineTextField.text = "gradeOfWineTextField"
        
        storeToBuyLabel.text = "구매처"
        storeToBuyTextField.text = "storeToBuyTextField"
        
        priceOfWineLabel.text = "구매가격"
        priceOfWineTextField.text = "priceOfWineTextField"
        
        reviewOfWineLabel.text = "한줄평"
        reviewOfWineTextField.text = "reviewOfWineTextField"
    }
    
    func setUI() {
        let labelStackView = UIStackView(arrangedSubviews: [wineNameLabel, kindOfWineLabel, countryOfOriginLabel, yearOfMakingLabel, dateToDrinkLabel, gradeOfWineLabel, storeToBuyLabel, priceOfWineLabel, reviewOfWineLabel])
        
        let textFieldStackView = UIStackView(arrangedSubviews: [wineNameTextField, kindOfWineTextField, countryOfOriginTextField, yearOfMakingTextField, dateToDrinkTextField, gradeOfWineTextField, storeToBuyTextField, priceOfWineTextField, reviewOfWineTextField])
        
        [labelStackView, textFieldStackView].forEach {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 1
        }
        
        let totalStackView = UIStackView(arrangedSubviews: [labelStackView, textFieldStackView])
        totalStackView.axis = .horizontal
        totalStackView.distribution = .fillEqually
        totalStackView.spacing = 5
        
        addSubview(totalStackView)
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            totalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
