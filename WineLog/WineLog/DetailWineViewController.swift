//
//  DetailWineViewController.swift
//  WineLog
//
//  Created by 순진이 on 2022/10/04.
//

import UIKit


final class DetailWineViewController: UIViewController {
    let fileManager = FileManager.default
//    let detailWineView = DetailWineView()
    let detailWineView = DetailWineInfoView()
    lazy var rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app.fill"), style: .plain, target: nil, action: nil)

    override func loadView() {
        super.loadView()
        view = detailWineView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.myGreen
    }

}
//MARK: -UI
extension DetailWineViewController {
    private func configureUI() {
        setAttributes()
        addTarget()
        setConstraints()
    }
    
    private func setAttributes() {
        
    }
    
    private func addTarget() {
        
    }
    
    private func setConstraints() {
        
    }
    
//    사용된 Struct : struct Sample: Codable
//
//    func saveToJson(){
//        var isDirectory: ObjCBool = true
//        if fileManager.fileExists(atPath: getFolderPath().path, isDirectory: &isDirectory){ //폴더 존재
//            //덮어쓰기
//            let jsonEncoder = JSONEncoder()
//            do{
//                let encodedData = try jsonEncoder.encode(saveData)
//                do{
//                    try encodedData.write(to: getFilePath())
//                    print("encoded")
//                }catch{
//                    print(error.localizedDescription)
//                }
//            }catch{
//                print(error.localizedDescription)
//            }
//        }else{  //폴더 없음
//            do{
//                try fileManager.createDirectory(atPath: getFolderPath().path, withIntermediateDirectories: false)
//                print("폴더 생성됨")
//                saveToJson()
//            }catch{
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    func loadFromJson(){
//        let jsonDecoder = JSONDecoder()
//        do{
//            let data = try Data(contentsOf: getFilePath(), options: .mappedIfSafe)
//            let received = try jsonDecoder.decode([Sample].self, from: data)
//            loadData = received
//            print(loadData)
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
//
//    func getDirectoryPath()-> URL{
//        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//    }
//
//    func getFolderPath()->URL{
//        let directoryPath = getDirectoryPath()
//        let folderPath = directoryPath.appendingPathComponent("MyJSON", isDirectory: true)
//        return folderPath
//    }
//
//    func getFilePath()->URL{
//        let folderPath = getFolderPath()
//        let filePath = folderPath.appendingPathComponent("myWineList.json")
//        return filePath
//    }
}

