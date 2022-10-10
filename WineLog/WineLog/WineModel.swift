//
//  WineModel.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/05.
//

import UIKit

enum WineType: Codable{
    case white
    case red
    case rose
    
    var wineType: String {
        switch self {
        case .white:
            return "white"
        case .red:
            return "red"
        case .rose:
            return "rose"
        }
    }
    
    var wineColor: UIColor {
        switch self {
        case .white:
            return UIColor.whiteWineColor
        case .red:
            return UIColor.redWineColor
        case .rose:
            return UIColor.roseWineColor
        }
    }
    
    var wineTextColor: UIColor {
        switch self {
        case .white, .rose:
            return UIColor.myGreen!
        case .red:
            return UIColor.white
        }
    }
}

struct WineInformation: Codable{
    var id: Int  //수정 및 삭제시 필요
    var type: WineType
    var profileData: Data  //이미지 Data
    var name: String
    var manufacturingDate: String?  //제조일
    var manufacturingContry: String?  //제조국
    var boughtPlace: String?  //구매처
    var price: Int?  //가격
//    var totalStar: Double  //총평
//    var sugarStar: Double  //당도
//    var acidityStar: Double  //산도
//    var bodyStar: Double  //바디감
    var drinkDate: String?  //시음일
    var totalStar: Int  //총평
    var sugarStar: Int  //당도
    var acidityStar: Int  //산도
    var bodyStar: Int  //바디감
    var comment: String?  //한줄평
}
