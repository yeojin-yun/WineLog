//
//  DetailWineInfoView.swift
//  WineLog
//
//  Created by 순진이 on 2022/10/04.
//

import UIKit

class DetailWineInfoView: UIView {
    
    let firstBackView = UIView()
    let secondBackView = UIView()
    
    var wineImage = UIImageView()
    // 와인이름
    let wineNameLabel = UILabel()
    // 와인종류
    let wineTypeLabel = CustomLabel(padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
    // 산지
    let manufacturingContryLabel = UILabel()
    // 제조일
    let manufacturingDateLabel = UILabel()
    
    // 시음 날짜
    let boughtDateLabel = CustomLabelView(title: "시음일", info: "2022.10.22")
    // 별점 (당도, 산도, 바디)
    var sugarStarLabel = CustomGradeView(title: "당도")
    var acidityStarLabel = CustomGradeView(title: "산도")
    var bodyStarLabel = CustomGradeView(title: "바디감")
    let totalStarLabel = CustomGradeView(title: "별점")
    // 구매처
    let boughtPlaceLabel = CustomLabelView(title: "구매처", info: "보틀벙커")
    // 가격
    let priceOfWineLabel = CustomLabelView(title: "가격", info: "33,000원")
    // 한줄평
    let commentOfWineLabel = CustomLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setFirstUI()
        setSecondUI()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setAttributes() {
        firstBackView.backgroundColor = .myGreen?.withAlphaComponent(0.3)
        firstBackView.layer.cornerRadius = 25
        
        wineImage.image = UIImage(named: "wine_example")
        wineImage.contentMode = .scaleAspectFit
        wineImage.layer.cornerRadius = 10
        wineImage.layer.masksToBounds = true
        wineImage.clipsToBounds = true
        
        [wineNameLabel].forEach {
            $0.text = "KIMCROWFORD"
            $0.font = UIFont.boldSystemFont(ofSize: 23)
//            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        
        [wineTypeLabel].forEach {
            $0.font = .boldSystemFont(ofSize: 14)
            $0.textAlignment = .center
            $0.text = "red"
            $0.backgroundColor = .red
            $0.textColor = .white
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
        
        [manufacturingContryLabel, manufacturingDateLabel].forEach {
            $0.font = .systemFont(ofSize: 14)
            $0.textAlignment = .center
            $0.textColor = .darkGray
            manufacturingContryLabel.text = "미국"
            manufacturingDateLabel.text = "2020"
        }
    }
    
    func setFirstUI() {
        manufacturingContryLabel.textAlignment = .right
        
        let labelStackView = UIStackView(arrangedSubviews: [manufacturingContryLabel, wineTypeLabel, manufacturingDateLabel])
        labelStackView.axis = .horizontal
//        labelStackView.distribution = .fillEqually
        labelStackView.spacing = 5
        
        [wineImage, wineNameLabel, labelStackView, totalStarLabel].forEach {
            firstBackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
      
        addSubview(firstBackView)
        firstBackView.translatesAutoresizingMaskIntoConstraints = false
        
        totalStarLabel.titleLabel.text = ""
        
        if UIScreen.main.bounds.height < 700 {
            NSLayoutConstraint.activate([
                firstBackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
                firstBackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
                firstBackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
                firstBackView.heightAnchor.constraint(equalToConstant: 330),
                
                totalStarLabel.topAnchor.constraint(equalTo: wineNameLabel.bottomAnchor, constant: 10),
                totalStarLabel.centerXAnchor.constraint(equalTo: wineNameLabel.centerXAnchor, constant: -100),
                
                wineImage.leadingAnchor.constraint(equalTo: firstBackView.leadingAnchor, constant: 30),
                wineImage.topAnchor.constraint(equalTo: firstBackView.topAnchor, constant: 20),
                wineImage.trailingAnchor.constraint(equalTo: firstBackView.trailingAnchor, constant: -30),
                wineImage.heightAnchor.constraint(equalToConstant: 200),
                
                labelStackView.topAnchor.constraint(equalTo: wineImage.bottomAnchor, constant: 15),
                labelStackView.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),
                wineNameLabel.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 10),
                wineNameLabel.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),          
            ])
        } else {
            NSLayoutConstraint.activate([
                firstBackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
                firstBackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
                firstBackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
                firstBackView.heightAnchor.constraint(equalToConstant: 370),
                
                totalStarLabel.topAnchor.constraint(equalTo: wineNameLabel.bottomAnchor, constant: 20),
                totalStarLabel.centerXAnchor.constraint(equalTo: wineNameLabel.centerXAnchor, constant: -100),
                
                wineImage.leadingAnchor.constraint(equalTo: firstBackView.leadingAnchor, constant: 30),
                wineImage.topAnchor.constraint(equalTo: firstBackView.topAnchor, constant: 30),
                wineImage.trailingAnchor.constraint(equalTo: firstBackView.trailingAnchor, constant: -30),
                wineImage.heightAnchor.constraint(equalToConstant: 200),
                
                labelStackView.topAnchor.constraint(equalTo: wineImage.bottomAnchor, constant: 30),
                labelStackView.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),
                wineNameLabel.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 10),
                wineNameLabel.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),
                
                
            ])
        }

    }
    
    func setSecondUI() {
        [secondBackView].forEach{
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let labelStack = UIStackView(arrangedSubviews: [boughtDateLabel, boughtPlaceLabel, priceOfWineLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fillEqually
        labelStack.spacing = 8
        
        let starStackView = UIStackView(arrangedSubviews: [sugarStarLabel, acidityStarLabel, bodyStarLabel])
        starStackView.axis = .vertical
        starStackView.distribution = .fillEqually
        starStackView.spacing = 8
        
        [labelStack, starStackView, commentOfWineLabel].forEach {
            secondBackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        commentOfWineLabel.text = "저녁 때 돌아갈 집이 있다는 것\n힘들 때 마음 속으로 생각 할 사람이 있다는 것\n외로울 때 혼자서 부를 노래 있다는 것"
        commentOfWineLabel.font = UIFont(name: "GowunBatang-Regular", size: 15)
        commentOfWineLabel.backgroundColor = .lightGray.withAlphaComponent(0.2)
        commentOfWineLabel.numberOfLines = 0
        commentOfWineLabel.layer.cornerRadius = 10
        commentOfWineLabel.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            secondBackView.topAnchor.constraint(equalTo: firstBackView.bottomAnchor, constant: 0),
            secondBackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            secondBackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            secondBackView.bottomAnchor.constraint(equalTo: starStackView.bottomAnchor, constant: 20),
            
            labelStack.leadingAnchor.constraint(equalTo: secondBackView.leadingAnchor),
            labelStack.topAnchor.constraint(equalTo: secondBackView.topAnchor, constant: 10),
            boughtDateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            starStackView.leadingAnchor.constraint(equalTo: labelStack.trailingAnchor, constant: 10),
            starStackView.topAnchor.constraint(equalTo: labelStack.topAnchor, constant: 10),
            sugarStarLabel.heightAnchor.constraint(equalToConstant: 20),
            
            commentOfWineLabel.topAnchor.constraint(equalTo: starStackView.bottomAnchor, constant: 20),
            commentOfWineLabel.leadingAnchor.constraint(equalTo: secondBackView.leadingAnchor),
            commentOfWineLabel.trailingAnchor.constraint(equalTo: secondBackView.trailingAnchor),
//            commentOfWineLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -130)
        ])
    }
    
    
    func setStarImage(body: Int, sugar: Int, acid: Int, total: Int) {
        bodyStarLabel.setStarStack(body, bodyStarLabel.starArray)
        sugarStarLabel.setStarStack(sugar, sugarStarLabel.starArray)
        acidityStarLabel.setStarStack(acid, acidityStarLabel.starArray)
        totalStarLabel.setStarStack(total, totalStarLabel.starArray)
    }
    
    func setTypeLabel(_ type: WineType) {
        wineTypeLabel.text = type.wineType
        wineTypeLabel.backgroundColor = type.wineColor
        wineTypeLabel.textColor = type.wineTextColor
    }
}
