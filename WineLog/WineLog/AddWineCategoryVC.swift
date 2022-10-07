//
//  ViewController.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/03.
//

import UIKit

class AddWineCategoryVC: UIViewController {
    let button = UIButton()
//    let loadBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
}

extension AddWineCategoryVC{
    @objc func didTapButton(_ sender: UIButton){
        let nextVC = AddWineInformationVC()
        nextVC.wineType = .white
        nextVC.isAddWine = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
//    @objc func didTapLoadBtn(_ sender: UIButton){
//        loadFromJson()
//    }
}

extension AddWineCategoryVC{
    private func setUI(){
        button.setTitle("GO", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//        loadBtn.setTitle("LOAD", for: .normal)
//        loadBtn.setTitleColor(.blue, for: .normal)
//        loadBtn.addTarget(self, action: #selector(didTapLoadBtn), for: .touchUpInside)
        
        
        view.addSubview(button)
//        view.addSubview(loadBtn)
        button.translatesAutoresizingMaskIntoConstraints = false
//        loadBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
//            loadBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            loadBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            loadBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}


//extension AddWineCategoryVC{
//    func loadFromJson(){
//        let jsonDecoder = JSONDecoder()
//        do{
//            let data = try Data(contentsOf: Singleton.shared.getFilePath(), options: .mappedIfSafe)
//            let received = try jsonDecoder.decode([WineInformation].self, from: data)
//            let loadData: [WineInformation] = received
//            print(loadData)
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
//}
