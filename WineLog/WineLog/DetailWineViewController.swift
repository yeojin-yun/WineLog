//
//  DetailWineViewController.swift
//  WineLog
//
//  Created by 순진이 on 2022/10/04.
//


import UIKit


final class DetailWineViewController: UIViewController {
    var singleton = Singleton.shared.myWines
    
    let detailWineView = DetailWineInfoView()
    

//    var wineModel: WineInformation?

    var wineModel: WineInformation {
        didSet {
            
        }
    }
    
    override func loadView() {
        super.loadView()
        view = detailWineView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        configureUI()
    }

    init(wineModel: WineInformation) {
        self.wineModel = wineModel
        super.init(nibName: nil, bundle: nil)
        print(#function)
        setData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension DetailWineViewController: EditDelegate {
    func getData(_ data: WineInformation) {
        print(#function, data.totalStar)
        wineModel = data
        setData()
    }
    
    private func setData() {
//        guard let wineModel = wineModel else { return }
        print(#function, wineModel.totalStar)
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
        let alert = UIAlertController(title: wineModel.name, message: "이 와인을 삭제할까요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "확인", style: .default) { action in
            let selectedWine = self.singleton.firstIndex(of: self.wineModel) ?? 0
            print(selectedWine)
            print(type(of: selectedWine))
            self.singleton.remove(at: selectedWine)
            dump(self.singleton)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true)
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

        let editBarButtonItem = UIBarButtonItem(image: UIImage(named: "wineEdit"), style: .done, target: self, action: #selector(didTapEditBtn(_:)))
        let deleteBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(didTapDeleteBtn(_:)))
        self.navigationItem.rightBarButtonItems = [editBarButtonItem, deleteBarButtonItem]
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.myGreen
//        self.navigationItem.rightBarButtonItems?[0].imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -60)
//        self.navigationItem.rightBarButtonItems?[1].imageInsets = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
//        self.navigationItem.rightBarButtonItems[0].inset//UIImage(named: "wineEdit")
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
