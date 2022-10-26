//
//  DetailWineViewController.swift
//  WineLog
//
//  Created by 순진이 on 2022/10/04.
//


import UIKit

protocol WineRemoveDelegate: AnyObject {
    func removeWine()
}


class DetailWineViewController: UIViewController {
    weak var delegate: WineRemoveDelegate?
    
    var singleton = Singleton.shared.myWines
    
    let detailWineView = DetailWineInfoView()

    var wineModel: WineInformation 
    
    override func loadView() {
        super.loadView()
        view = detailWineView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function, wineModel.name)
        configureUI()
    }

    init(wineModel: WineInformation) {
        self.wineModel = wineModel
        super.init(nibName: nil, bundle: nil)
        print(#function, wineModel.id)
        setData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension DetailWineViewController: EditDelegate {
    func getData(_ data: WineInformation) {
        wineModel = data
        setData()
    }
    
    private func setData() {
//        guard let wineModel = wineModel else { return }
        detailWineView.manufacturingContryLabel.text = wineModel.manufacturingContry
        detailWineView.setTypeLabel(wineModel.type)
        detailWineView.wineImage.image = UIImage(data: wineModel.profileData)
        detailWineView.manufacturingDateLabel.text = wineModel.manufacturingDate
        detailWineView.wineNameLabel.text = wineModel.name
        detailWineView.boughtDateLabel.infoLabel.text = wineModel.drinkDate == "" ? "-" : wineModel.drinkDate
        detailWineView.boughtPlaceLabel.infoLabel.text = wineModel.boughtPlace ?? "-"
        let winePrice = wineModel.price?.toDecimalFormat() ?? ""
        detailWineView.priceOfWineLabel.infoLabel.text = winePrice == "" ? "-" : winePrice + "원"
        detailWineView.setStarImage(body: wineModel.bodyStar, sugar: wineModel.sugarStar, acid: wineModel.acidityStar, total: wineModel.totalStar)
        detailWineView.commentOfWineLabel.text = wineModel.comment ?? "한줄평"

    }
    
    @objc func didTapEditBtn(_ sender: UIBarButtonItem){
        let nextVC = EditWineInfomationVC()
//        guard let wineModel = wineModel else { return }
        nextVC.isAddWine = false
        nextVC.wineId = wineModel.id
        nextVC.wineType = wineModel.type
        nextVC.delegate = self
        print(#function)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func didTapDeleteBtn(_ sender: UIBarButtonItem) {
        let selectedWine = self.singleton.firstIndex(of: self.wineModel) ?? 0
        print("확인1", selectedWine, "count:", self.singleton.count)
        let attributedString = NSMutableAttributedString(string: wineModel.name)
        let alertFont = UIFont(name: "GowunBatang-Bold", size: 17)
        attributedString.addAttribute(.font, value: alertFont!, range: (wineModel.name as NSString).range(of: "\(wineModel.name)"))

        let alert = UIAlertController(title: wineModel.name, message: "이 와인을 삭제할까요?", preferredStyle: .alert)
        alert.setValue(attributedString, forKey: "attributedTitle")
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
            let selectedWine = self.singleton.firstIndex(of: self.wineModel) ?? 0
            self.singleton.remove(at: selectedWine)
            print("확인2", self.singleton.count)
            self.saveToJson(self.singleton)
            self.delegate?.removeWine()
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    //MARK: FileManager
    func saveToJson(_ saveData: [WineInformation]){
        var isDirectory: ObjCBool = true
        if FileManager.default.fileExists(atPath: Singleton.shared.getFolderPath().path, isDirectory: &isDirectory){ //폴더 존재
            //덮어쓰기
            let jsonEncoder = JSONEncoder()
            do{
                let encodedData = try jsonEncoder.encode(saveData)
                do{
                    try encodedData.write(to: Singleton.shared.getFilePath())
                    
                    print("encoded", encodedData)
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
//MARK: -UI
extension DetailWineViewController {
    private func configureUI() {
        setNavigationBar()
        setAttributes()
        addTarget()
        setConstraints()
    }
    
    private func setNavigationBar() {
        let titleView = UIView()
        let imageView = UIImageView(image: UIImage(named: "titleLogo4"))
        imageView.contentMode = .scaleAspectFit
        titleView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 80),
        ])
        navigationItem.titleView = imageView
        
        let button = UIButton()
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.setImage(UIImage(named: "wineEdit"), for: .normal)
        button.addTarget(self, action: #selector(didTapEditBtn(_:)), for: .touchUpInside)
        let editBarButtonItem = UIBarButtonItem(customView: button)
        let deleteBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(didTapDeleteBtn(_:)))
        deleteBarButtonItem.tintColor = .myGreen
        self.navigationItem.rightBarButtonItems = [editBarButtonItem, deleteBarButtonItem]


    }
    
    private func setAttributes() {
    }
    
    private func addTarget() {
    }
    
    private func setConstraints() {
        
    }
}


extension WineInformation: Equatable {
    static func == (lhs: WineInformation, rhs: WineInformation) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
