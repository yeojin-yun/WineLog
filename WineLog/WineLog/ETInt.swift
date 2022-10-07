//
//  ETInt.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/06.
//

import Foundation
import UIKit

extension Int{
    func toDecimalFormat()-> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let price = formatter.string(for: self)else{
            return "Formatter Error"
        }
        return price
    }
}


//
//switch Singleton.shared.myWines[indexPath.item].type{
//case .red
//    imageView.image = UIImage(named: "redIcon")
//case .white
//case .rose
//case .none:
//    
//}
