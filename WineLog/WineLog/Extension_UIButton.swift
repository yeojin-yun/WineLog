//
//  Extensio_UIButton.swift
//  WineLog
//
//  Created by 순진이 on 2022/10/10.
//


import UIKit

extension UIButton.Configuration {
    static func setWineButtonStyle(_ title: String, image: UIImage) -> UIButton.Configuration {
        var configuration = self.plain()
        var titleAttributed = AttributedString.init(title)
        titleAttributed.font = UIFont(name: "GowunBatang-Regular", size: 18)
        titleAttributed.foregroundColor = .darkGray
        configuration.title = title
        configuration.titleAlignment = .center
        configuration.image = image
//        configuration.baseForegroundColor = .darkGray
//        configuration.baseBackgroundColor = .myGreen
        configuration.imagePlacement = .top
        configuration.imagePadding = 8
        configuration.attributedTitle = titleAttributed
        return configuration
    }
}
