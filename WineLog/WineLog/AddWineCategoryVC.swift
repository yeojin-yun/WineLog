//
//  ViewController.swift
//  WineLog
//
//  Created by 순진이 on 2022/10/03.
//

import UIKit

class AddWineCategoryVC: UIViewController {
    
    let infoLabel = CustomLabel()
    
    let redWineButton = UIButton()
    let whiteWineButton = UIButton()
    let roseWindeButton = UIButton()
    let buttonStackView = UIStackView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        Singleton.shared.loadFromJson()
        openIntro()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
//MARK: - Button Action
extension AddWineCategoryVC{
    @objc func wineButtonTapped(_ sender: UIButton) {
        switch sender.configuration?.title {
        case "red":
            addWineToNextVC(.red)
        case "white":
            addWineToNextVC(.white)
        case "rose":
            addWineToNextVC(.rose)
        default:
            break
        }
    }
    
    func addWineToNextVC(_ wineType: WineType) {
//        let nextVC = AddWineInformationVC()
        let nextVC = EditWineInfomationVC()
        nextVC.wineType = wineType
        nextVC.isAddWine = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func buttonPressed(_ sender: UIBarButtonItem){
//        present(IntroduceVC(), animated: true)
        present(FirstIntroVC(), animated: true)
    }
    
    func openIntro(){
        var isOpen = false
        if UserDefaults.standard.bool(forKey: "firstIntro") != nil{
            isOpen = UserDefaults.standard.bool(forKey: "firstIntro")
        }
        if !isOpen{
            present(FirstIntroVC(), animated: true)
        }
    }
}

//MARK: -UI
extension AddWineCategoryVC{
    private func configureUI() {
        setNavigation()
        setAttributes()
        addTarget()
        setConstraints()
    }
    private func setNavigation(){
        let titleView = UIView()
        let imageView = UIImageView(image: UIImage(named: "titleLogo4"))
        imageView.contentMode = .scaleAspectFit
        titleView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 80),
        ])
        navigationItem.titleView = imageView
                       
        self.navigationController?.navigationBar.tintColor = .myGreen
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(buttonPressed(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .myGreen
    }
    
    private func setAttributes() {
        guard let redImage = UIImage(named: "redWine") else { return }
        guard let whiteImage = UIImage(named: "whiteWine") else { return }
        guard let roseImage = UIImage(named: "roseWine") else { return }
        redWineButton.configuration = .setWineButtonStyle("red", image: redImage)
        whiteWineButton.configuration = .setWineButtonStyle("white", image: whiteImage)
        roseWindeButton.configuration = .setWineButtonStyle("rose", image: roseImage)
        
        [infoLabel].forEach {
            $0.text = "기록하고 싶은 와인을\n눌러주세요."
            $0.font = UIFont(name: "GowunBatang-Regular", size: 18)
            $0.textAlignment = .center
        }
    }
    
    private func addTarget() {
        redWineButton.addTarget(self, action: #selector(wineButtonTapped(_:)), for: .touchUpInside)
        whiteWineButton.addTarget(self, action: #selector(wineButtonTapped(_:)), for: .touchUpInside)
        roseWindeButton.addTarget(self, action: #selector(wineButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        buttonStackView.addArrangedSubview(whiteWineButton)
        buttonStackView.addArrangedSubview(roseWindeButton)
        buttonStackView.addArrangedSubview(redWineButton)
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 3
        
        [buttonStackView, infoLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            UIScreen.main.bounds.height < 700 ? infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50) : infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
//            buttonStackView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 250),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            redWineButton.widthAnchor.constraint(equalToConstant: 30),
            redWineButton.heightAnchor.constraint(equalToConstant: 150)

        ])
    }
}
