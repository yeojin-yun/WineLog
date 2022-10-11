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
    
    var myWines = [WineInformation]()
    
    
    //FileManager
    func getDirectoryPath()-> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    func getFolderPath()->URL{
        let directoryPath = getDirectoryPath()
        let folderPath = directoryPath.appendingPathComponent("MyJSON", isDirectory: true)
        return folderPath
    }
    func getFilePath()->URL{
        let folderPath = getFolderPath()
        let filePath = folderPath.appendingPathComponent("test.json")
        return filePath
    }
    //FileManager - Load
    func loadFromJson(){
        let jsonDecoder = JSONDecoder()
        do{
            let data = try Data(contentsOf: getFilePath(), options: .mappedIfSafe)
            let received = try jsonDecoder.decode([WineInformation].self, from: data)
            myWines = received
        }catch{
            print(error.localizedDescription)
        }
    }
}
