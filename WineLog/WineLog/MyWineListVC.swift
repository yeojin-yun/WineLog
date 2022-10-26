//
//  ViewController.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/03.
//

import UIKit

class MyWineListVC: UIViewController {
    //sortMember
    var sortsData = ["와인종류","별점","가격순", "되돌리기"]
    var criteria = [0, 0, 0, 0]
    var wineTypeValue: [WineType] = [.white, .red, .rose]
    let typeText = ["ALL", "WHITE", "RED", "ROSE"]
//    let starText = ["ALL", "★★★★☆~★★★★★", "★★☆☆☆~★★★☆☆", "☆☆☆☆☆~★☆☆☆☆"]
    let starText = ["ALL", "별 4 ~ 5", "별 2 ~ 3", "별 0 ~ 1"]
    let priceText = ["가격순", "낮은 가격순", "높은 가격순"]
    
    let flowLayout1 = UICollectionViewFlowLayout()
    lazy var sortCV = UICollectionView(frame: .zero, collectionViewLayout: flowLayout1)
    lazy var listCV = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
    var outputWineList = [WineInformation]()
    
    var selectMode = false
    var selectedList = [Int]()
    let trashModeItem = UIBarButtonItem()
    let removeActionItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setUI()
        layoutUI()
        Singleton.shared.loadFromJson()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        outputWineList = wineListFilter()  //와인종류순
        self.listCV.reloadData()
    }
}

//MARK: UICollectionViewDataSource
extension MyWineListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //갯수전달
        if collectionView == listCV {
            return outputWineList.count
        }
        return sortsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //내용전달
        if collectionView == listCV {
            guard let cell = listCV.dequeueReusableCell(withReuseIdentifier: WineListCell.identifier, for: indexPath) as? WineListCell else{fatalError()}
            
//            switch outputWineList[indexPath.item].type {
//            case .white:
//                cell.typeLabel.text = "white"
//            case .rose:
//                cell.typeLabel.text = "rose"
//            case .red:
//                cell.typeLabel.text = "red"
//            }
            cell.setTypeLabel(type: outputWineList[indexPath.item].type)
            cell.imageView.image = UIImage(data: outputWineList[indexPath.item].profileData)
            cell.nameLabel.text = outputWineList[indexPath.item].name
            if let priceValue: Int = outputWineList[indexPath.item].price {
                cell.priceLabel.text = "가격: " + String(priceValue.toDecimalFormat()) + "원"
            } else {
                cell.priceLabel.text = "가격: -"
            }
            cell.scoreLabel.text = "별점: \(String(format: "%.1f", Double(outputWineList[indexPath.item].totalStar)))"
            
            cell.layer.cornerRadius = 10
            if !selectMode{
                cell.layer.borderWidth = 0
                cell.layer.borderColor = UIColor.clear.cgColor
//                cell.backgroundColor = .clear
                cell.alpha = 1
            }
            
            return cell
        }else{
            guard let cell = sortCV.dequeueReusableCell(withReuseIdentifier: SortCustomCell.identifier, for: indexPath) as? SortCustomCell else { fatalError() }
            if criteria[indexPath.item] == 0{
                cell.label.text = self.sortsData[indexPath.item]
            }else{
                switch indexPath.item{
                case 0:
                    cell.label.text = self.typeText[self.criteria[0]]
                case 1:
                    cell.label.text = self.starText[self.criteria[1]]
                case 2:
                    cell.label.text = self.priceText[self.criteria[2]]
                case 3:
                    cell.label.text = "되돌리기"
                default:
                    print("No More Sort Criteria ")
                }
            }
            return cell
        }
    }
}

//MARK: UICollectionViewDelegate
extension MyWineListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sortCV {
            switch indexPath.item {
            case 0:
                typeActionSheet()
            case 1:
                starActionSheet()
            case 2:
                priceActionSheet()
            case 3:
                criteria[0] = 0
                criteria[1] = 0
                criteria[2] = 0
                self.outputWineList = self.wineListFilter()
                self.listCV.reloadData()
                self.sortCV.reloadData()
            default:
                fatalError()
            }
        } else {
            if selectMode{ //select Mode
                let cell = collectionView.cellForItem(at: indexPath) as? WineListCell
                
                if selectedList.contains(outputWineList[indexPath.item].id){
                    cell?.alpha = 1
//                    cell?.backgroundColor = .clear
                    cell?.layer.borderWidth = 0
                    cell?.layer.borderColor = UIColor.clear.cgColor
                    selectedList.remove(at: selectedList.firstIndex(where: {$0 == outputWineList[indexPath.item].id})!)
                }else{
//                    cell?.backgroundColor = .myGreen?.withAlphaComponent(0.5)
                    cell?.alpha = 0.7
                    cell?.layer.borderWidth = 2
                    cell?.layer.borderColor = UIColor.myGreen?.cgColor
//                    cell?.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                    selectedList.append(outputWineList[indexPath.item].id)
                }
                
                removeActionItem.isEnabled = selectedList.count > 0 ? true : false
            }else{
                let detailWineVC = DetailWineViewController(wineModel: outputWineList[indexPath.item])
                //            detailWineVC.wineModel = outputWineList[indexPath.item]
                detailWineVC.delegate = self
                detailWineVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(detailWineVC, animated: true)
            }
        }
    }
}
extension MyWineListVC: WineRemoveDelegate {
    func removeWine() {
        print(#function)
        Singleton.shared.loadFromJson()
        listCV.reloadData()
    }
}

//MARK: CollectionView Layout - Compositional
extension MyWineListVC {
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            //Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 10, trailing: 7)
            
            //Group (row)  //세로길이: 33% , 그룹당 아이템 개수: 3
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: NSCollectionLayoutDimension.fractionalWidth(2/3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
        return layout
    }
}

//MARK: Function
extension MyWineListVC {
    func wineListFilter() ->[WineInformation] {
        var wineList = [WineInformation]()
        var result = [WineInformation]()
        
        switch criteria[2]{
        case 0:  //생성순
            wineList = Singleton.shared.myWines
        case 1:  //오름차순
            wineList = Singleton.shared.myWines.sorted(by: { $0.price ?? .max < $1.price ?? .max })
        case 2:  //내림차순
            wineList = Singleton.shared.myWines.sorted(by: { $0.price ?? .min > $1.price ?? .min })
        default:
            print("Not Exist price Criteria")
        }
        
        for idx in 0 ..< wineList.count {
            var typeBool = false
            if criteria[0] == 0 {
                typeBool = true
            } else {
                if wineList[idx].type == wineTypeValue[criteria[0] - 1] {
                    typeBool = true
                } else {
                    typeBool = false
                }
            }
            
            var starBool = false
            switch criteria[1]{
            case 0:
                starBool = true
            case 1: //4-5
                if wineList[idx].totalStar > 3{
                    starBool = true
                }
            case 2: //2-3
                if wineList[idx].totalStar > 1 && wineList[idx].totalStar < 4{
                    starBool = true
                }
            case 3: //0-1
                if wineList[idx].totalStar < 2{
                    starBool = true
                }
            default:
                starBool = false
            }
            
            if typeBool && starBool{
                result.append(wineList[idx])
            }
        }
        return result
    }
    
    @objc func didTapTrashMode(_ sender: UIBarButtonItem){
        if selectMode{  //Tap 취소
            trashModeItem.image = UIImage(systemName: "trash")
            trashModeItem.title = nil
            navigationItem.rightBarButtonItems = [trashModeItem]
            selectMode = false
            selectedList.removeAll()
            listCV.reloadData()
        }else{  //Tap TrashMode
            trashModeItem.image = nil
            trashModeItem.title = "취소"
            removeActionItem.isEnabled = false
            navigationItem.rightBarButtonItems = [trashModeItem, removeActionItem]
            selectMode = true
        }
    }
    
    @objc func didTapTrash(_ sender: UIBarButtonItem){
        print(#function)  //삭제 명령
        let warnRemove = UIAlertController(title: "경고", message: "선택한 와인을 목록에서 제거합니다.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive){_ in
            let beforeWines = Singleton.shared.myWines
            Singleton.shared.myWines = beforeWines.filter{ !self.selectedList.contains($0.id) }
            Singleton.shared.saveToJson(Singleton.shared.myWines)
            self.outputWineList = self.wineListFilter()
            
            self.trashModeItem.image = UIImage(systemName: "trash")
            self.trashModeItem.title = nil
            self.navigationItem.rightBarButtonItems = [self.trashModeItem]
            self.selectMode = false
            self.selectedList.removeAll()
            self.listCV.reloadData()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        warnRemove.addAction(deleteAction)
        warnRemove.addAction(cancelAction)
        present(warnRemove, animated: true)
    }
}

//MARK: Alert
extension MyWineListVC {
    func typeActionSheet() { //와인종류순
        let typeSheet = UIAlertController(title: "와인종류", message: nil, preferredStyle: .actionSheet)
        for i in 0 ..< typeText.count{
            let actionItem = UIAlertAction(title: typeText[i], style: .default) { (UIAlertAction) in
                self.criteria[0] = i
                self.outputWineList = self.wineListFilter()
                self.listCV.reloadData()
                self.sortCV.reloadData()
            }
            typeSheet.addAction(actionItem)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        typeSheet.addAction(cancelAction)
        
        typeSheet.view.tintColor = .myGreen
        
        self.present(typeSheet, animated: true, completion: nil)
    }
    
    func starActionSheet() { //별점순=
        let starSheet = UIAlertController(title: "별점", message: nil, preferredStyle: .actionSheet) //★☆
        for i in 0 ..< starText.count{
            let actionItem = UIAlertAction(title: starText[i], style: .default) {(UIAlertAction) in
                self.criteria[1] = i
                self.outputWineList = self.wineListFilter()
                self.listCV.reloadData()
                self.sortCV.reloadData()
            }
            starSheet.addAction(actionItem)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        starSheet.addAction(cancelAction)
        
        starSheet.view.tintColor = .myGreen
        
        self.present(starSheet, animated: true, completion: nil)
    }
    
    func priceActionSheet() { //가격순
        let priceSheet = UIAlertController(title: "가격", message: nil, preferredStyle: .actionSheet)
        let wineType0 = UIAlertAction(title: priceText[0], style: .default) { (UIAlertAction) in
            self.criteria[2] = 0
            self.outputWineList = self.wineListFilter()
            self.listCV.reloadData()
            self.sortCV.reloadData()
        }
        let wineType1 = UIAlertAction(title: priceText[1], style: .default) { (UIAlertAction) in
            self.criteria[2] = 1
            self.outputWineList = self.wineListFilter()
            self.listCV.reloadData()
            self.sortCV.reloadData()
        }
        let wineType2 = UIAlertAction(title: priceText[2], style: .default) { (UIAlertAction) in
            self.criteria[2] = 2
            self.outputWineList = self.wineListFilter()
            self.listCV.reloadData()
            self.sortCV.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        priceSheet.addAction(wineType0)
        priceSheet.addAction(wineType1)
        priceSheet.addAction(wineType2)
        priceSheet.addAction(cancelAction)
        
        priceSheet.view.tintColor = .myGreen
        
        self.present(priceSheet, animated: true, completion: nil)
    }
}

//MARK: - UI
extension MyWineListVC {
    func setNavigation(){
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
        
        [trashModeItem].forEach{
            $0.image = UIImage(systemName: "trash")
            $0.target = self
            $0.action = #selector(didTapTrashMode(_:))
            $0.tintColor = .myGreen
        }
        [removeActionItem].forEach{
            $0.image = UIImage(systemName: "trash")
            $0.target = self
            $0.action = #selector(didTapTrash(_:))
            $0.tintColor = .myGreen
        }
        navigationItem.rightBarButtonItems = [trashModeItem]
    }
    func setUI(){
        let cellWidth = (UIScreen.main.bounds.width - 35) / 4
        flowLayout1.itemSize = CGSize(width: cellWidth, height: view.frame.height / 24)
        flowLayout1.minimumInteritemSpacing = 5  //아이템간의 가로거리
        flowLayout1.minimumLineSpacing = 5 //아이템간의 세로거리
//        flowLayout1.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) //테두리 거리
        flowLayout1.scrollDirection = .horizontal
        sortCV.showsHorizontalScrollIndicator = false
        
        sortCV.dataSource = self
        sortCV.delegate = self
        listCV.dataSource = self
        listCV.delegate = self
        
        sortCV.register(SortCustomCell.self, forCellWithReuseIdentifier: SortCustomCell.identifier)
        listCV.register(WineListCell.self, forCellWithReuseIdentifier: WineListCell.identifier)
        
    }
    //MARK: MyWineListVC layout()
    func layoutUI(){
        [sortCV, listCV ].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            sortCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 3),
            sortCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sortCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sortCV.heightAnchor.constraint(equalToConstant: view.frame.height / 24),
            
            listCV.topAnchor.constraint(equalTo: sortCV.bottomAnchor,constant: 5),
            listCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listCV.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100),
        ])
    }
}
