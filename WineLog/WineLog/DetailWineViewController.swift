//
//  DetailWineViewController.swift
//  WineLog
//
//  Created by 순진이 on 2022/10/04.
//


import UIKit


final class DetailWineViewController: UIViewController {
    let sigleton = Singleton.shared.myWines
    
    let detailWineView = DetailWineInfoView()
    lazy var rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "wineEdit"), style: .plain, target: self, action: #selector(didTapEditBtn(_:)))

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
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.myGreen
        self.navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -60)
    }
    
    private func setAttributes() {
    }
    
    private func addTarget() {
    }
    
    private func setConstraints() {
        
    }
}
