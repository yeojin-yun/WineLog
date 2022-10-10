//
//  ViewController.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/03.
//

import UIKit

class MyWineListVC: UIViewController {
    //REMOVE
    let rmButton = UIButton()
    
    var sortsData = ["와인종류순","별점순","가격순","초기화"]
    
    let flowLayout1 = UICollectionViewFlowLayout()
    lazy var sortCV = UICollectionView(frame: .zero, collectionViewLayout: flowLayout1)
    lazy var listCV = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
    var sortedWineList = [WineInformation]()
    var outputWineList = [WineInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        navigationItem.titleView = imageView
        setUI()
        layoutUI()
//        for i in outputWineList{
//            print(i.price)
//        }
 
        
        //REMOVE
        rmSetUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFromJson()
        sortedWineList = Singleton.shared.myWines.sorted(by: { $0.price ?? .max < $1.price ?? .max }) //오름차순
        outputWineList = wineListFilter(Singleton.shared.myWines)  //와인종류순

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
          guard let cell = listCV.dequeueReusableCell(withReuseIdentifier: WineListCell.identifier, for: indexPath) as? WineListCell
            else { fatalError() }
            
            if let priceValue: Int = outputWineList[indexPath.item].price {
                cell.priceLabel.text = "가격: " + String(priceValue.toDecimalFormat()) + "원"
                
            } else {
                cell.priceLabel.text = ""
            }
            
            cell.nameLabel.text = outputWineList[indexPath.item].name
            cell.scoreLabel.text = "별점: \(String(outputWineList[indexPath.item].totalStar))"
            cell.imageView.image = UIImage(data: outputWineList[indexPath.item].profileData)
            switch outputWineList[indexPath.item].type {
            case .white:
                cell.typeImageView.image = UIImage(named: "whiteIcon")
            case .rose:
                cell.typeImageView.image = UIImage(named: "roseIcon")
            case .red:
                cell.typeImageView.image = UIImage(named: "redIcon")
            }
            return cell
        }else{
            guard let cell = sortCV.dequeueReusableCell(withReuseIdentifier: SortCustomCell.identifier, for: indexPath) as? SortCustomCell else { fatalError() }
                    
            cell.label.text = self.sortsData[indexPath.item]
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
                alart1()
            case 1:
                alart2()
            case 2:
                alart3()
            case 3:
                alart4()
            default:
                fatalError()
            }
        }
        else {
            
        }
    }
}

extension MyWineListVC {
    func loadFromJson(){
        let jsonDecoder = JSONDecoder()
        do{
            let data = try Data(contentsOf: Singleton.shared.getFilePath(), options: .mappedIfSafe)
            let received = try jsonDecoder.decode([WineInformation].self, from: data)
            Singleton.shared.myWines = received
        }catch{
            print(error.localizedDescription)
        }
    }
}

//MARK: - MyWineListVC SetUI()
    extension MyWineListVC {
        func setUI(){
            
            flowLayout1.itemSize = CGSize(width: view.frame.width / 4, height: view.frame.height / 19)
            flowLayout1.minimumInteritemSpacing = 5  //아이템간의 가로거리
            flowLayout1.minimumLineSpacing = 5 //아이템간의 세로거리
            flowLayout1.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) //테두리 거리
            flowLayout1.scrollDirection = .horizontal
            
            sortCV.dataSource = self
            sortCV.delegate = self
            listCV.dataSource = self
            sortCV.delegate = self
            
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
                sortCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 15),
                sortCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                sortCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                sortCV.bottomAnchor.constraint(equalTo: view.topAnchor,constant: 170),
                
                listCV.topAnchor.constraint(equalTo: sortCV.bottomAnchor,constant: 10),
                listCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                listCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                listCV.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100),
            ])
        }
        
        func wineListFilter(_ wineList: [WineInformation]) ->[WineInformation] {
            var result = [WineInformation]()
            for idx in 0 ..< wineList.count {
                var typeBool = false
                let typeOption = Singleton.shared.wineType
                if typeOption == 0 {
                    typeBool = true
                } else {
                    if wineList[idx].type == Singleton.shared.wineTypeValue[typeOption - 1] {
                        typeBool = true
                    } else {
                        typeBool = false
                    }
                }
                
                var starBool = false
                let starOption = Singleton.shared.wineStar
                if starOption == 0 {
                    starBool = true
                } else {
                    switch starOption{
                    case 1: //5-4
                        print("5-4")
                        wineList[idx].totalStar
                    case 2: //3-2
                        print("3-2")
                    case 3: //1-0
                        print("1-0")
                    default:
                        starBool = false
                    }
//                    if Singleton.shared.myWines[idx].type == Singleton.shared.wineTypeValue[typeOption - 1] {
//                        typeBool = true
//                    } else {
//                        typeBool = false
//                    }
                }
                
                if typeBool && starBool{
                    result.append(Singleton.shared.myWines[idx])
                }
            }
            return result
        }
    }

extension MyWineListVC {
    func alart1() { //와인종류순
        let wineType = UIAlertController(title: "와인종류별", message: nil, preferredStyle: .actionSheet)
        let wineType0 = UIAlertAction(title: "전체선택", style: .default) { (UIAlertAction) in
            Singleton.shared.wineType = 0
            self.outputWineList = self.wineListFilter(Singleton.shared.myWines)
            self.listCV.reloadData()

        }
        let wineType1 = UIAlertAction(title: "RED", style: .default) { (UIAlertAction) in
            Singleton.shared.wineType = 2
            self.outputWineList = self.wineListFilter(Singleton.shared.myWines)
            self.listCV.reloadData()
            
        }
        let wineType2 = UIAlertAction(title: "WHITE", style: .default) { (UIAlertAction) in
            Singleton.shared.wineType = 1
            self.outputWineList = self.wineListFilter(Singleton.shared.myWines)

            self.listCV.reloadData()

        }
        
        let wineType3 = UIAlertAction(title: "ROSE", style: .default) { (UIAlertAction) in
            Singleton.shared.wineType = 3
            self.outputWineList = self.wineListFilter(Singleton.shared.myWines)

            self.listCV.reloadData()

        }
        let wineTypeCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [wineTypeCancelAction,wineType0,wineType1,wineType2,wineType3,].forEach {
            wineType.addAction($0)
                }
        
        wineType.view.tintColor = #colorLiteral(red: 0.1236173734, green: 0.3619198501, blue: 0.2140165269, alpha: 1)
        
        self.present(wineType, animated: true, completion: nil)
    }
    func alart2() { //별점순
        
        let wineType = UIAlertController(title: "별점", message: nil, preferredStyle: .actionSheet)
        let wineType0 = UIAlertAction(title: "전체", style: .default) {
            (UIAlertAction) in
            
        }
        let wineType1 = UIAlertAction(title: "별 4 ~ 5", style: .default) { (UIAlertAction) in
            
        }
        let wineType2 = UIAlertAction(title: "별 2 ~ 3", style: .default) { (UIAlertAction) in
            
        }
        let wineType3 = UIAlertAction(title: "별 0 ~ 1", style: .default) { (UIAlertAction) in
            
        }

        let wineTypeCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        wineType.view.tintColor = #colorLiteral(red: 0.1236173734, green: 0.3619198501, blue: 0.2140165269, alpha: 1)
        [wineTypeCancelAction,wineType0,wineType1,wineType2,wineType3].forEach {
            wineType.addAction($0)
        }
        self.present(wineType, animated: true, completion: nil)
    }
    
func alart3() { //가격순
    sortedWineList = Singleton.shared.myWines.sorted(by: { $0.price ?? .max < $1.price ?? .max }) //오름차순
    dump(sortedWineList)
    outputWineList = wineListFilter(sortedWineList) //와인종류순
    for i in outputWineList{
        print(i.price)
    }
    listCV.reloadData()
    
    let wineType = UIAlertController(title: "가격", message: nil, preferredStyle: .actionSheet)
    let wineType1 = UIAlertAction(title: "오름차순", style: .default) { (UIAlertAction) in
     //   let wines = Singleton.shared.myWines
        self.sortedWineList = self.outputWineList
        self.listCV.reloadData()
    }
    
    let wineType2 = UIAlertAction(title: "내림차순", style: .default, handler: nil)
    let wineTypeCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    wineType.addAction(wineTypeCancelAction)
    wineType.addAction(wineType1)
    wineType.addAction(wineType2)
    wineType.view.tintColor = #colorLiteral(red: 0.1236173734, green: 0.3619198501, blue: 0.2140165269, alpha: 1)

    self.present(wineType, animated: true, completion: nil)
 
}
    
    func alart4() {
        print("초기화")
    }
}

extension MyWineListVC {
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            //Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 7, trailing: 7)
            
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


//REMOVE
extension MyWineListVC{
    @objc func didTapRmBtn(_ sender: UIButton){
        let detailWineVC = DetailWineViewController(wineModel: Singleton.shared.myWines[0])
        self.navigationController?.pushViewController(detailWineVC, animated: true)
    }
    func rmSetUI(){
        rmButton.setImage(UIImage(named: "fullWine"), for: .normal)
        rmButton.addTarget(self, action: #selector(didTapRmBtn(_:)), for: .touchUpInside)
        view.addSubview(rmButton)
        rmButton.translatesAutoresizingMaskIntoConstraints = false
        rmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        rmButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        rmButton.heightAnchor.constraint(equalTo: rmButton.widthAnchor).isActive = true
    }
}
