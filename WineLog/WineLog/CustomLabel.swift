//
//  CustomLabel.swift
//  WineLog
//
//  Created by 순진이 on 2022/10/07.
//

import UIKit

class CustomLabel: UILabel {
    private var padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    init() {
        super.init(frame: .zero)
        text = "저녁 때 돌아갈 집이 있다는 것\n힘들 때 마음 속으로 생각 할 사람이 있다는 것\n외로울 때 혼자서 부를 노래 있다는 것"
        font = UIFont(name: "GowunBatang-Regular", size: 15)
        backgroundColor = .lightGray.withAlphaComponent(0.2)
        numberOfLines = 0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
