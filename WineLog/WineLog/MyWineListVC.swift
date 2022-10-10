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
    
    var sortsData = ["와인종류순","가격순","평점순","test4"]
    
    let flowLayout1 = UICollectionViewFlowLayout()
    lazy var sortCV = UICollectionView(frame: .zero, collectionViewLayout: flowLayout1)
    lazy var listCV = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo_horiz")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        setUI()
        layoutUI()
        
        loadFromJson()
        //REMOVE
        rmSetUI()
    }
}

//MARK: UICollectionViewDataSource
extension MyWineListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //갯수전달
        if collectionView == listCV {
            return Singleton.shared.myWines.count
        }
        return sortsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //내용전달
        if collectionView == listCV {
            guard let cell = listCV.dequeueReusableCell(withReuseIdentifier: WineListCell.identifier, for: indexPath) as? WineListCell
            else { fatalError() }
            cell.nameLabel.text = Singleton.shared.myWines[indexPath.item].name
            switch Singleton.shared.myWines[indexPath.item].type {
            case .white:
                cell.typeImageView.image = UIImage(named: "whiteIcon")
            case .rose:
                cell.typeImageView.image = UIImage(named: "roseIcon")
            case .red:
                cell.typeImageView.image = UIImage(named: "redIcon")
                
            }
            addGesture()
            
            return cell
        }else{
            guard let cell = sortCV.dequeueReusableCell(withReuseIdentifier: SortCustomCell.identifier, for: indexPath) as? SortCustomCell else { fatalError() }
            
            cell.backgroundColor = .myYellow
            //            cell.backgroundColor = #colorLiteral(red: 0.9589957595, green: 0.8265138268, blue: 0.5008742213, alpha: 1)
            
            cell.label.textColor = .myGreen
            //            cell.label.textColor = #colorLiteral(red: 0.1236173734, green: 0.3619198501, blue: 0.2140165269, alpha: 1)
            
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
            default:
                fatalError()
            }
        }
        else {
            
        }
    }
    
    
    func addGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        listCV.addGestureRecognizer(gesture)
        
    }
    
    @objc
    func didLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case.began: //사용자가 처음 누를때
            print("began")
        case.changed://누르고 이동할때
            print("changed")
        case.ended://손 땟을때
            print("ended")
        case.cancelled: // 중간에 전화오거나 알람 등 취소될때
            print("cancelled")
        default:
            break
        }
    }
}

//MARK: - Function
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

//MARK: - Compositional Layout
extension MyWineListVC {
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            //Size: absolute(고정값) / estimated(추측) / fraction(퍼센트)
            //Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 7, trailing: 7)
            
            //Group (row)  //세로길이: 33% , 그룹당 아이템 개수: 3
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: NSCollectionLayoutDimension.fractionalWidth(2/3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            //section.orthogonalScrollingBehavior = .continuous  //section내 스크롤 유형
            
            return section
        }
        return layout
    }
}

//MARK: - Alert
extension MyWineListVC {
    func alart1() {
        let wineType = UIAlertController(title: "와인종류별", message: nil, preferredStyle: .actionSheet)
        let wineType1 = UIAlertAction(title: "레드와인", style: .default, handler: nil)
        let wineType2 = UIAlertAction(title: "화이트와인", style: .default, handler: nil)
        let wineType3 = UIAlertAction(title: "로제와인", style: .default, handler: nil)
        let wineTypeCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        wineType.addAction(wineTypeCancelAction)
        wineType.addAction(wineType1)
        wineType.addAction(wineType2)
        wineType.addAction(wineType3)
        self.present(wineType, animated: true, completion: nil)
    }
    func alart2() {
        let wineType = UIAlertController(title: "가격순", message: nil, preferredStyle: .actionSheet)
        let wineType1 = UIAlertAction(title: "가격 오름차순", style: .default, handler: nil)
        let wineType2 = UIAlertAction(title: "가격 내림차순", style: .default, handler: nil)
        let wineTypeCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        wineType.addAction(wineTypeCancelAction)
        wineType.addAction(wineType1)
        wineType.addAction(wineType2)
        
        self.present(wineType, animated: true, completion: nil)
    }
    func alart3() {
        let wineType = UIAlertController(title: "평점순", message: nil, preferredStyle: .actionSheet)
        let wineType1 = UIAlertAction(title: "평점 오름차순", style: .default, handler: nil)
        let wineType2 = UIAlertAction(title: "평점 내림차순", style: .default, handler: nil)
        
        let wineTypeCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        wineType.addAction(wineTypeCancelAction)
        wineType.addAction(wineType1)
        wineType.addAction(wineType2)
        
        self.present(wineType, animated: true, completion: nil)
    }
}

//MARK: - UI
extension MyWineListVC {
    //MARK: MyWineListVC SetUI()
    func setUI(){
        
        flowLayout1.itemSize = CGSize(width: view.frame.width / 4, height: view.frame.height / 15)
        flowLayout1.minimumInteritemSpacing = 5  //아이템간의 가로거리
        flowLayout1.minimumLineSpacing = 10 //아이템간의 세로거리
        flowLayout1.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) //테두리 거리
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
            sortCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            sortCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sortCV.bottomAnchor.constraint(equalTo: view.topAnchor,constant: 150),
            
            listCV.topAnchor.constraint(equalTo: sortCV.bottomAnchor),
            listCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listCV.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -150),
            
            
        ])
    }
}

//REMOVE
extension MyWineListVC{
    @objc func didTapRmBtn(_ sender: UIButton){
        let detailWineVC = DetailWineViewController()
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
