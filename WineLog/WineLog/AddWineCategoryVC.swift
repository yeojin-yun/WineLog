//
//  ViewController.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/03.
//

import UIKit

class AddWineCategoryVC: UIViewController {
    let testBtn = UIButton()  //REMOVE
    
    let redWineButton = UIButton()
    let whiteWineButton = UIButton()
    let roseWindeButton = UIButton()
    let buttonStackView = UIStackView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadFromJson()
    }
    
}
//MARK: - Button Action
extension AddWineCategoryVC{
    @objc func wineButtonTapped(_ sender: UIButton) {
//        let nextVC = AddWineInformationVC()
        let nextVC = EditWineInfomationVC()
        nextVC.isAddWine = true
        switch sender{
        case redWineButton:
            nextVC.wineType = .red
        case whiteWineButton:
            nextVC.wineType = .white
        case roseWindeButton:
            nextVC.wineType = .rose
//            nextVC.isAddWine = false
//            nextVC.wineId = 0
        default:
            print("Not Exist Button")
            return
        }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //REMOVE
    @objc func didTapTest(_ sender: UIButton){
        let jsonDecoder = JSONDecoder()
        do{
            let data = try Data(contentsOf: Singleton.shared.getFilePath(), options: .mappedIfSafe)
            let received = try jsonDecoder.decode([WineInformation].self, from: data)
            let loadData = received
            print(loadData)
        }catch{
            print(error.localizedDescription)
        }
    }
}

extension AddWineCategoryVC{
    private func configureUI() {
        setNavigation()
        setAttributes()
        addTarget()
        setConstraints()
    }
    private func setNavigation(){
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        logoView.contentMode = .scaleAspectFit
        logoView.image = UIImage(named: "logo_horiz")
        navigationItem.titleView = logoView
    }
    
    private func setAttributes() {
        redWineButton.setTitle("red", for: .normal)
        redWineButton.setTitleColor(UIColor.red, for: .normal)
//        redWineButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 30)
        redWineButton.imageView?.contentMode = .scaleAspectFill
        redWineButton.setImage(UIImage(named: "redWine"), for: .normal)
        whiteWineButton.setImage(UIImage(named: "whiteWine"), for: .normal)
        whiteWineButton.setTitle("white", for: .normal)
        whiteWineButton.imageView?.contentMode = .scaleAspectFill
        roseWindeButton.setImage(UIImage(named: "roseWine"), for: .normal)
        roseWindeButton.setTitle("rose", for: .normal)
        roseWindeButton.imageView?.contentMode = .scaleAspectFill
    }
    
    private func addTarget() {
        redWineButton.addTarget(self, action: #selector(wineButtonTapped(_:)), for: .touchUpInside)
        whiteWineButton.addTarget(self, action: #selector(wineButtonTapped(_:)), for: .touchUpInside)
        roseWindeButton.addTarget(self, action: #selector(wineButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setConstraints(){
        buttonStackView.addArrangedSubview(whiteWineButton)
        buttonStackView.addArrangedSubview(roseWindeButton)
        buttonStackView.addArrangedSubview(redWineButton)
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 3
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
//        view.addSubview(redWineButton)
        
        //REMOVE
        testBtn.setTitle("LOAD", for: .normal)
        testBtn.setTitleColor(.blue, for: .normal)
        testBtn.addTarget(self, action: #selector(didTapTest), for: .touchUpInside)
        view.addSubview(testBtn)
        testBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            buttonStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            buttonStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            buttonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//            redWineButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
//            redWineButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
//            redWineButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            redWineButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            redWineButton.widthAnchor.constraint(equalToConstant: 30),
            
            //REMOVE
            testBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            testBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension AddWineCategoryVC { //load json to singlton
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
