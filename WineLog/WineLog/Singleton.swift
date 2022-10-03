//
//  Singleton.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/03.
//

import Foundation

class Singleton{
    static let shared: Singleton = Singleton()
    private init(){}
}
