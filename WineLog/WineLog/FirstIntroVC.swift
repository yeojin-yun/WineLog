//
//  FirstIntroVC.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/25.
//

import UIKit

class FirstIntroVC: UIViewController {
    let contentView = UIView()
    let firstLabel = UILabel()
    let secondLabel = UILabel()
    let teamImageView = UIImageView()
    let checkBox = UIButton()
    let closeButton = UIButton()
    
    var isChecked = false
    let descTitle = "와인로그는"
    let descContent = """
    레드, 화이트, 로제의 와인종류를 선택하고, 언제 어떤 와인을 마셨는지를 기록할 수 있어요.

    남기고싶은 사진도 올려요.
    와인도좋고 함께했던 사람과의 사진도 좋아요.

    와인에 대한 나만의 평가도 남길 수 있어요.
    내가 원하는 카테고리만 고를 수 있고 언제든지
    삭제도 할 수있어요.

    자신만의 와인로그를 만들어보세요
    """

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        layout()
        loadCheck()
    }
    
}

//MARK: - Func
extension FirstIntroVC{
    @objc func didTapNeverButton(_ sender: UIButton){
        if isChecked{
            checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        }else{
            checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
        isChecked = !isChecked
    }
    
    @objc func didTapCloseButton(_ sender: UIButton){
        if isChecked{
            UserDefaults.standard.set(true, forKey: "firstIntro")
        }else {
            UserDefaults.standard.set(false, forKey: "firstIntro")
        }
        self.dismiss(animated: true)
    }
    func loadCheck(){
        if UserDefaults.standard.bool(forKey: "firstIntro") != nil{
            isChecked = UserDefaults.standard.bool(forKey: "firstIntro")
        }
        
        if !isChecked{
            checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        }else{
            checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
    }
}

//MARK: - UI
extension FirstIntroVC{
    private func setUI(){
        view.backgroundColor = .black.withAlphaComponent(0.2)
        contentView.backgroundColor = .myYellow
        contentView.layer.cornerRadius = 20
        
        [firstLabel].forEach{
            $0.font = UIFont(name: "PoorStory-Regular", size: 22)
            $0.text = descTitle
        }
        
        [secondLabel].forEach{
            $0.font = UIFont(name: "PoorStory-Regular", size: 16)
            $0.numberOfLines = 0
            $0.text = descContent
            $0.sizeToFit()
//            $0.adjustsFontSizeToFitWidth = true
//            $0.minimumScaleFactor = 10
        }
        let attrString = NSMutableAttributedString(string: descContent)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        secondLabel.attributedText = attrString
        
        [teamImageView].forEach{
            $0.image = UIImage(named: "teamProfile")
        }
        
        [checkBox, closeButton].forEach{
            $0.backgroundColor = .white.withAlphaComponent(0.7)
            $0.layer.cornerRadius = 10
            $0.titleLabel?.font = .systemFont(ofSize: 12)
            $0.setTitleColor(.black, for: .normal)
            $0.tintColor = .black
        }
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.setTitle("다시 보지 않기", for: .normal)
        checkBox.addTarget(self, action: #selector(didTapNeverButton(_:)), for: .touchUpInside)
        closeButton.setTitle("닫기", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
    }
    
    private func layout(){
        view.addSubview(contentView)
        contentView.addSubview(firstLabel)
        contentView.addSubview(secondLabel)
        contentView.addSubview(teamImageView)
        view.addSubview(checkBox)
        view.addSubview(closeButton)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        teamImageView.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            
            firstLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            firstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            firstLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            firstLabel.heightAnchor.constraint(equalToConstant: 30),
            
            secondLabel.leadingAnchor.constraint(equalTo: firstLabel.leadingAnchor),
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 10),
            secondLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            teamImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            teamImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            teamImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            teamImageView.heightAnchor.constraint(equalTo: teamImageView.widthAnchor, multiplier: (320/1970)),
            teamImageView.topAnchor.constraint(greaterThanOrEqualTo: secondLabel.bottomAnchor, constant: 0),
            
            closeButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            
            checkBox.topAnchor.constraint(equalTo: closeButton.topAnchor),
            checkBox.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor),
            checkBox.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -15),
            checkBox.widthAnchor.constraint(equalToConstant: 110),
            
        ])
    }
}
