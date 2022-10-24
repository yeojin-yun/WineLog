//
//  IntroduceVC.swift
//  WineLog
//
//  Created by 서은지 on 2022/10/18.
//

import UIKit

class IntroduceVC: UIViewController {

    let firstLabel = UILabel()
    let secondLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myYellow
        setUI()
        layout()
    }
}

extension IntroduceVC {
    func setUI() {
        [firstLabel, secondLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        firstLabel.text = "와인로그는"
        firstLabel.font = UIFont(name: "PoorStory-Regular", size: 22)
        secondLabel.font = UIFont(name: "PoorStory-Regular", size: 17)
        secondLabel.text = "레드, 화이트, 로제의 와인종류를 선택하고\n언제 어떤 와인을 마셨는지를 기록할 수 있어요.\n\n남기고싶은 사진도 올려요.\n와인도좋고 함께했던 사람과의 사진도 좋아요.\n\n와인에 대한 나만의 평가도 남길 수 있어요.\n내가 원하는 카테고리만 고를 수 있고\n 언제든지 삭제도 할 수있어요.\n\n\n자신만의 와인로그를 만들어보세요"
        secondLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: secondLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        secondLabel.attributedText = attrString

    }
    
    func layout() {
        NSLayoutConstraint.activate([
        firstLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
        firstLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
        
        secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 30),
        secondLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
        secondLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
])
    }
}
