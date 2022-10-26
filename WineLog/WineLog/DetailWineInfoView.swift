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
    let commentScrollView = UIScrollView()
    let commentContentView = UIView()
    let commentOfWineLabel = CustomLabel()
    
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
        
        [commentOfWineLabel].forEach {
            $0.text = "저녁 때 돌아갈 집이 있다는 것\n힘들 때 마음 속으로 생각 할 사람이 있다는 것\n외로울 때 혼자서 부를 노래 있다는 것"
            $0.font = UIFont(name: "GowunBatang-Regular", size: 15)
            $0.backgroundColor = .lightGray.withAlphaComponent(0.2)
            $0.numberOfLines = 0
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        
        totalStarLabel.titleLabel.text = ""
        manufacturingContryLabel.textAlignment = .right
    }
    
    func setUI() {
        let labelStackView = UIStackView(arrangedSubviews: [manufacturingContryLabel, wineTypeLabel, manufacturingDateLabel])
        labelStackView.axis = .horizontal
        labelStackView.spacing = 5
        
        [wineImage, wineNameLabel, labelStackView, totalStarLabel].forEach {
            firstBackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let bottomLabelStackView = UIStackView(arrangedSubviews: [boughtDateLabel, boughtPlaceLabel, priceOfWineLabel])
        bottomLabelStackView.axis = .vertical
        bottomLabelStackView.distribution = .fillEqually
        bottomLabelStackView.spacing = 8
        
        let starStackView = UIStackView(arrangedSubviews: [sugarStarLabel, acidityStarLabel, bodyStarLabel])
        starStackView.axis = .vertical
        starStackView.distribution = .fillEqually
        starStackView.spacing = 8
        
        [firstBackView, bottomLabelStackView, starStackView, commentScrollView].forEach{
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        commentScrollView.addSubview(commentContentView)
        commentContentView.translatesAutoresizingMaskIntoConstraints = false
        commentContentView.addSubview(commentOfWineLabel)
        commentOfWineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            firstBackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            firstBackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            UIScreen.main.bounds.height < 700 ? firstBackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10) : firstBackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            UIScreen.main.bounds.height < 700 ? firstBackView.heightAnchor.constraint(equalToConstant: 330) : firstBackView.heightAnchor.constraint(equalToConstant: 370),
            
            UIScreen.main.bounds.height < 700 ? totalStarLabel.topAnchor.constraint(equalTo: wineNameLabel.bottomAnchor, constant: 10) : totalStarLabel.topAnchor.constraint(equalTo: wineNameLabel.bottomAnchor, constant: 20),
            totalStarLabel.centerXAnchor.constraint(equalTo: wineNameLabel.centerXAnchor, constant: -100),
            
            wineImage.leadingAnchor.constraint(equalTo: firstBackView.leadingAnchor, constant: 30),
            UIScreen.main.bounds.height < 700 ? wineImage.topAnchor.constraint(equalTo: firstBackView.topAnchor, constant: 20) : wineImage.topAnchor.constraint(equalTo: firstBackView.topAnchor, constant: 30),
            wineImage.trailingAnchor.constraint(equalTo: firstBackView.trailingAnchor, constant: -30),
            wineImage.heightAnchor.constraint(equalToConstant: 200),
            
            UIScreen.main.bounds.height < 700 ? labelStackView.topAnchor.constraint(equalTo: wineImage.bottomAnchor, constant: 15) : labelStackView.topAnchor.constraint(equalTo: wineImage.bottomAnchor, constant: 30),
            labelStackView.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),
            wineNameLabel.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 10),
            wineNameLabel.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),          
        ])
        
        
        NSLayoutConstraint.activate([
            bottomLabelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bottomLabelStackView.topAnchor.constraint(equalTo: firstBackView.bottomAnchor, constant: 10),
            boughtDateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            starStackView.leadingAnchor.constraint(equalTo: bottomLabelStackView.trailingAnchor, constant: 10),
            starStackView.centerYAnchor.constraint(equalTo: bottomLabelStackView.centerYAnchor, constant: 10),
            sugarStarLabel.heightAnchor.constraint(equalToConstant: 20),
            
            commentScrollView.topAnchor.constraint(equalTo: starStackView.bottomAnchor, constant: 20),
            commentScrollView.leadingAnchor.constraint(equalTo: bottomLabelStackView.leadingAnchor),
            commentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            commentScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            commentContentView.topAnchor.constraint(equalTo: commentScrollView.topAnchor),
            commentContentView.widthAnchor.constraint(equalTo: commentScrollView.widthAnchor),
            commentContentView.bottomAnchor.constraint(equalTo: commentScrollView.bottomAnchor),
            
            commentOfWineLabel.topAnchor.constraint(equalTo: commentContentView.topAnchor),
            commentOfWineLabel.widthAnchor.constraint(equalTo: commentContentView.widthAnchor),
            commentOfWineLabel.bottomAnchor.constraint(equalTo: commentContentView.bottomAnchor),
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
