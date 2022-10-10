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
        text = ""
        font = UIFont(name: "GowunBatang-Regular", size: 15)
        backgroundColor = .lightGray.withAlphaComponent(0.2)
        numberOfLines = 0
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
