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
    
    var myWines = [WineInformation]() {
        didSet {
            print("와인 변경")
        }
    }
    
    
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
    //FileManager - Save
    func saveToJson(_ saveData: [WineInformation]){
        var isDirectory: ObjCBool = true
        if FileManager.default.fileExists(atPath: Singleton.shared.getFolderPath().path, isDirectory: &isDirectory){ //폴더 존재
            //덮어쓰기
            let jsonEncoder = JSONEncoder()
            do{
                let encodedData = try jsonEncoder.encode(saveData)
                do{
                    try encodedData.write(to: Singleton.shared.getFilePath())
                    print("encoded")
                }catch{
                    print(error.localizedDescription)
                }
            }catch{
                print(error.localizedDescription)
            }
        }else{  //폴더 없음
            do{
                try FileManager.default.createDirectory(atPath: Singleton.shared.getFolderPath().path, withIntermediateDirectories: false)
                print("폴더 생성됨")
                saveToJson(saveData)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}
