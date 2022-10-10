//
//  EditWineInfomationVC.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/08.
//
//WineInfomation - drinkDate 추가

import UIKit

class EditWineInfomationVC: UIViewController {
    var wineType: WineType!
    var isAddWine: Bool!  //추가모드: true / 편집모드: false
    var wineId: Int?  //편집모드 시 ID로 받기
    var isNewPhoto = false
    var bottomConstraint: NSLayoutConstraint!
    
    var totalStarArr = [UIImageView]()
    var sugarStarArr = [UIImageView]()
    var acidStarArr = [UIImageView]()
    var bodyStarArr = [UIImageView]()
    
    let decimalFormatter = NumberFormatter()
    let imagePicker = UIImagePickerController()
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGesture))
    
    let saveItem = UIBarButtonItem()
    
    let contentView = UIView()
    let firstBackView = UIView()
    let secondBackView = UIView()
    //사진
    let photoView = UIImageView()
    let addPhotoBtn = UIButton()
    //와인 이름
    let nameField = UITextField()
    // 와인종류
    let wineTypeLabel = UILabel()
    //제조일
    let madeDateField = UITextField()
    //제조국
    let madeContryField = UITextField()
    //구매처
    let placeLabel = UILabel()
    let placeField = UITextField()
    //구매가
    let priceLabel = UILabel()
    let priceField = UITextField()
    //시음일
    let drinkDateLabel = UILabel()
    let drinkDateField = UITextField()
    //별점(평점)
    let totalSlider = UISlider()
    let totalStack = UIStackView()
    //당도
    let sugarLabel = UILabel()
    let sugarSlider = UISlider()
    let sugarStack = UIStackView()
    //산도
    let acidLabel = UILabel()
    let acidSlider = UISlider()
    let acidStack = UIStackView()
    //바디감
    let bodyLabel = UILabel()
    let bodySlider = UISlider()
    let bodyStack = UIStackView()
    //메모
    let commentField = UITextView()
    let commentBackView = UIView()
    
    //MARK: LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        drinkDateField.delegate = self
        placeField.delegate = self
        priceField.delegate = self
        
        configureUI()
        
        if !isAddWine{
            loadInformation()
        }
        starAction(totalSlider, totalStarArr)
        starAction(sugarSlider, sugarStarArr)
        starAction(acidSlider, acidStarArr)
        starAction(bodySlider, bodyStarArr)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
//    deinit{
//        NotificationCenter.default.removeObserver(self)
//    }

    private func configureUI(){
        setNavigation()
        setAttributes()
        setUI()
        setFirstUI()
        setSecondUI()
    }
}

//Delegate
//MARK: Image Picker
extension EditWineInfomationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //카메라
    func presentCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true //편집
            imagePicker.cameraFlashMode = .on
            
            present(imagePicker, animated: true, completion: nil)
        }else{
            print("Camera Not Available")
        }
        
    }
    //갤러리
    func presentAlbum(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true //편집
        
        present(imagePicker, animated: true, completion: nil)
    }
    //이미지 선택 시 실행시킬 동작
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            photoView.image = image
            isNewPhoto = true
        }
        dismiss(animated: true, completion: nil)
    }
    //취소 버튼
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: ObjcectC Function
extension EditWineInfomationVC{
    @objc func didTapGesture(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    @objc func didTapAddPhotoBtn(_ sender: UIButton){
        showPhotoAlert()
    }
    @objc func didTapSaveBtn(_ sender: UIBarButtonItem){
        //필수적 요소들이 채워져 있는지 확인
        if (isAddWine && !isNewPhoto) || nameField.text?.count == 0 {
            failAlert()
        }else{
            saveAlert()
        }
    }
    @objc func didChangeSlider(_ sender: UISlider){
        switch sender{
        case totalSlider:
            starAction(totalSlider, totalStarArr)
        case sugarSlider:
            starAction(sugarSlider, sugarStarArr)
        case acidSlider:
            starAction(acidSlider, acidStarArr)
        case bodySlider:
            starAction(bodySlider, bodyStarArr)
        default:
            print("Not Exist Slider Error")
        }
    }
//    @objc func keyboardWillShow(_ sender: Notification){
//        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            print(keyboardHeight)
//        }
//    }
}

//MARK: Function
extension EditWineInfomationVC{
    //Star Manager
    func starAction(_ slider: UISlider, _ stackSubView: [UIImageView]){
        let value = round(slider.value)
        for i in 0...4{
            if i < Int(value){
                stackSubView[i].image = UIImage(named: "yellow_star_full")
            }else{
                stackSubView[i].image = UIImage(named: "star_empty")
            }
        }
    }
    
    private func loadInformation(){
        let loadWine = Singleton.shared.myWines.filter{$0.id == wineId!}.first!
        photoView.image = UIImage(data: loadWine.profileData)
        isNewPhoto = true
        nameField.text = loadWine.name
        if let value = loadWine.manufacturingDate{
            madeDateField.text = value
        }
        if let value = loadWine.manufacturingContry{
            madeContryField.text = value
        }
        if let value = loadWine.drinkDate{
            drinkDateField.text = value
        }
        if let value = loadWine.boughtPlace{
            placeField.text = value
        }
        if let value = loadWine.price{
            priceField.text = value.toDecimalFormat()
        }
        if let value = loadWine.comment{
            commentField.text = value
        }
        totalSlider.value = Float(loadWine.totalStar)
        sugarSlider.value = Float(loadWine.sugarStar)
        acidSlider.value = Float(loadWine.acidityStar)
        bodySlider.value = Float(loadWine.bodyStar)
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
                    print("encoded")
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
    func saveData(){
        if isAddWine{ //find id
            if Singleton.shared.myWines.count > 0{
                guard let oldId = Singleton.shared.myWines.sorted(by: {$0.id < $1.id}).last?.id else{
                    return}
//                if oldId == Int.max{
//                    //삭제된 element의 id값을 채우기 위해 재초기화
//                    //그럼에도 Int.max인 경우 더이상 추가 불가능 Alert present
//                }
                wineId = oldId + 1
            }else{
                wineId = 0
            }
        }else{
            Singleton.shared.myWines = Singleton.shared.myWines.filter{ $0.id != wineId}
        }
        let newPrice: Int? = Int(priceField.text?.components(separatedBy: [","]).joined() ?? "0")
        let newDrinkDate: String? = drinkDateField.text
        guard let imageData: Data = photoView.image?.pngData() else{return}
        let dateText: String? = madeDateField.text! == "" ? nil : madeDateField.text
        let contryText: String? = madeContryField.text! == "" ? nil : madeContryField.text
        let placeText: String? = placeField.text! == "" ? nil : placeField.text
        let comments = commentField.textColor == UIColor.lightGray ? nil : commentField.text
        let newWineInfo = WineInformation(id: wineId!,
                                          type: wineType,
                                          profileData: imageData,
                                          name: nameField.text!,
                                          manufacturingDate: dateText,
                                          manufacturingContry: contryText,
                                          boughtPlace: placeText,
                                          price: newPrice,
                                          drinkDate: newDrinkDate,
                                          totalStar: Int(round(totalSlider.value)),
                                          sugarStar: Int(round(sugarSlider.value)),
                                          acidityStar: Int(round(acidSlider.value)),
                                          bodyStar: Int(round(bodySlider.value)),
                                          comment: comments)
        Singleton.shared.myWines.append(newWineInfo)
        //FileManager Save
        saveToJson(Singleton.shared.myWines)
    }
}

//MARK: - Alert
extension EditWineInfomationVC{
    func showPhotoAlert(){
        let alertController = UIAlertController(title: "다음으로 사진을 가져옵니다.", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "카메라", style: .default){(action: UIAlertAction) in
            self.presentCamera()
        }
        let albumAction = UIAlertAction(title: "앨범", style: .default){(action: UIAlertAction) in
            self.presentAlbum()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    func saveAlert(){
        let alertController = UIAlertController(title: "안내", message: "와인 정보를 저장합니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "저장", style: .default){(action: UIAlertAction) in
            self.saveData()
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    func failAlert(){
        let alertController = UIAlertController(title: "필수정보를 입력해주세요.", message: "최소한 사진 및 제품명을 입력해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

//MARK: - UI
extension EditWineInfomationVC{
    private func setNavigation(){
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        logoView.contentMode = .scaleAspectFit
        logoView.image = UIImage(named: "logo_horiz")
        navigationItem.titleView = logoView
        
        saveItem.title = "저장"
        saveItem.target = self
        saveItem.action = #selector(didTapSaveBtn(_:))
        navigationItem.rightBarButtonItem = saveItem
    }
    
    private func setAttributes(){
        view.backgroundColor = .white
        
        firstBackView.backgroundColor = .myGreen?.withAlphaComponent(0.3)
        firstBackView.layer.cornerRadius = 25
    //first
        addPhotoBtn.setTitle("", for: .normal)
        addPhotoBtn.addTarget(self, action: #selector(didTapAddPhotoBtn(_:)), for: .touchUpInside)
        [photoView].forEach{
            $0.image = UIImage(named: "selectPhoto")
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        [nameField].forEach{
            $0.font = .boldSystemFont(ofSize: 23)
            $0.textAlignment = .center
            $0.placeholder = "제품명"
        }
        [wineTypeLabel].forEach {
            $0.font = .boldSystemFont(ofSize: 14)
            $0.textAlignment = .center
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
            switch wineType{
            case .white:
                $0.text = "white"
                $0.backgroundColor = .white
                $0.textColor = .black
            case .red:
                $0.text = "red"
                $0.backgroundColor = .red
                $0.textColor = .white
            case .rose:
                $0.text = "rose"
                $0.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                $0.textColor = .white
            case .none:
                print("Wine Type Error")
            }
        }
        [madeContryField].forEach{
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .gray
            $0.placeholder = "제조국"
            $0.textAlignment = .right
        }
        [madeDateField].forEach{
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .gray
            $0.placeholder = "제조일"
            $0.textAlignment = .left
        }
        [totalSlider].forEach{
            $0.maximumValue = 5.0
            $0.minimumValue = 0.0
            $0.value = 3.0
            $0.thumbTintColor = .clear
            $0.tintColor = .clear
            $0.alpha = 0.1
            $0.addTarget(self, action: #selector(didChangeSlider(_:)), for: .valueChanged)
        }
        [totalStack].forEach{
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
            for _ in 0...4{
                let imageView = UIImageView()
                imageView.image = UIImage(named: "star_empty")
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                $0.addArrangedSubview(imageView)
            }
        }
        for i in 0...4{
            totalStarArr.append(totalStack.subviews[i] as? UIImageView ?? UIImageView())
        }
    //second
        [placeLabel, priceLabel, drinkDateLabel, sugarLabel, acidLabel, bodyLabel].forEach{
            $0.font = .boldSystemFont(ofSize: 16)
            $0.textAlignment = .left
            $0.textColor = .darkGray
        }
        drinkDateLabel.text = "시음일"
        placeLabel.text = "구매처"
        priceLabel.text = "가격"
        sugarLabel.text = "당도"
        acidLabel.text = "산도"
        bodyLabel.text = "바디감"
        priceField.keyboardType = .numberPad
        
        [drinkDateField, placeField, priceField].forEach{
            $0.font = .boldSystemFont(ofSize: 16)
            $0.textAlignment = .left
            $0.textColor = .darkGray
        }
        drinkDateField.placeholder = "(선택)"
        placeField.placeholder = "(선택)"
        priceField.placeholder = "(선택)"
        
        [sugarSlider, acidSlider, bodySlider].forEach{
            $0.maximumValue = 5.0
            $0.minimumValue = 0.0
            $0.value = 3.0
            $0.thumbTintColor = .clear
            $0.tintColor = .clear
            $0.alpha = 0.1
            $0.addTarget(self, action: #selector(didChangeSlider(_:)), for: .valueChanged)
        }
        [sugarStack, acidStack, bodyStack].forEach{
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
            for _ in 0...4{
                let imageView = UIImageView()
                imageView.image = UIImage(named: "star_empty")
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
                $0.addArrangedSubview(imageView)
            }
        }
        for i in 0...4{
            sugarStarArr.append(sugarStack.subviews[i] as? UIImageView ?? UIImageView())
            acidStarArr.append(acidStack.subviews[i] as? UIImageView ?? UIImageView())
            bodyStarArr.append(bodyStack.subviews[i] as? UIImageView ?? UIImageView())
        }
    //comment
        commentBackView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        commentField.backgroundColor = .clear
        commentField.font = UIFont(name: "GowunBatang-Regular", size: 15)
        placeholderSetting()
    }
    
    private func setUI(){
        view.addSubview(contentView)
        contentView.addGestureRecognizer(tapGesture)
        contentView.addSubview(firstBackView)
        contentView.addSubview(secondBackView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        firstBackView.translatesAutoresizingMaskIntoConstraints = false
        secondBackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
//            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            firstBackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            firstBackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            firstBackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            firstBackView.heightAnchor.constraint(equalToConstant: 370),
            
            secondBackView.topAnchor.constraint(equalTo: firstBackView.bottomAnchor, constant: 20),
            secondBackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            secondBackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            secondBackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setFirstUI(){
        [photoView, addPhotoBtn, wineTypeLabel, madeContryField, madeDateField, nameField, totalStack, totalSlider].forEach{
            firstBackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: firstBackView.topAnchor, constant: 30),
            photoView.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 200),
            photoView.widthAnchor.constraint(equalTo: photoView.heightAnchor),
            
            addPhotoBtn.topAnchor.constraint(equalTo: photoView.topAnchor),
            addPhotoBtn.bottomAnchor.constraint(equalTo: photoView.bottomAnchor),
            addPhotoBtn.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
            addPhotoBtn.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
            
            wineTypeLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 30),
            wineTypeLabel.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),
            
            madeContryField.centerYAnchor.constraint(equalTo: wineTypeLabel.centerYAnchor),
            madeContryField.trailingAnchor.constraint(equalTo: wineTypeLabel.leadingAnchor, constant: -5),
            madeContryField.leadingAnchor.constraint(equalTo: firstBackView.leadingAnchor, constant: 10),

            madeDateField.centerYAnchor.constraint(equalTo: wineTypeLabel.centerYAnchor),
            madeDateField.leadingAnchor.constraint(equalTo: wineTypeLabel.trailingAnchor, constant: 5),
            madeDateField.trailingAnchor.constraint(equalTo: firstBackView.trailingAnchor, constant: -10),
            
            nameField.topAnchor.constraint(equalTo: wineTypeLabel.bottomAnchor, constant: 10),
            nameField.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),
            nameField.widthAnchor.constraint(equalTo: firstBackView.widthAnchor, constant: -10),
            
            totalStack.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 10),
            totalStack.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),
            totalStack.heightAnchor.constraint(equalToConstant: 30),
            totalStack.widthAnchor.constraint(equalTo: totalStack.heightAnchor, multiplier: 6.0),
            
            totalSlider.topAnchor.constraint(equalTo: totalStack.topAnchor),
            totalSlider.centerXAnchor.constraint(equalTo: firstBackView.centerXAnchor),
            totalSlider.heightAnchor.constraint(equalTo: totalStack.heightAnchor),
            totalSlider.widthAnchor.constraint(equalTo: totalStack.widthAnchor),
            
        ])
    }
    
    private func setSecondUI(){
        let firstLabelStack = UIStackView(arrangedSubviews: [drinkDateLabel, placeLabel, priceLabel])
        
        let textFieldStack = UIStackView(arrangedSubviews: [drinkDateField, placeField, priceField])
        
        let secondLabelStack = UIStackView(arrangedSubviews: [sugarLabel, acidLabel, bodyLabel])
        
        [firstLabelStack, textFieldStack, secondLabelStack].forEach{
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 8
            
            secondBackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [sugarStack, acidStack, bodyStack].forEach{
            secondBackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 20).isActive = true
            $0.widthAnchor.constraint(equalTo: $0.heightAnchor, multiplier: 6.0).isActive = true
        }
        [sugarSlider, acidSlider, bodySlider].forEach{
            secondBackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        secondBackView.addSubview(commentBackView)
        commentBackView.addSubview(commentField)
        commentBackView.translatesAutoresizingMaskIntoConstraints = false
        commentField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstLabelStack.topAnchor.constraint(equalTo: secondBackView.topAnchor, constant: 10),
            firstLabelStack.leadingAnchor.constraint(equalTo: secondBackView.leadingAnchor, constant: 10),
            firstLabelStack.widthAnchor.constraint(equalToConstant: 50),
            
            textFieldStack.centerYAnchor.constraint(equalTo: firstLabelStack.centerYAnchor),
            textFieldStack.leadingAnchor.constraint(equalTo: firstLabelStack.trailingAnchor, constant: 10),
            textFieldStack.trailingAnchor.constraint(equalTo: secondBackView.centerXAnchor, constant: -10),
            
            secondLabelStack.topAnchor.constraint(equalTo: firstLabelStack.topAnchor),
            secondLabelStack.leadingAnchor.constraint(equalTo: secondBackView.centerXAnchor),
            secondLabelStack.widthAnchor.constraint(equalToConstant: 50),
            
            sugarStack.centerYAnchor.constraint(equalTo: sugarLabel.centerYAnchor),
            sugarStack.leadingAnchor.constraint(equalTo: secondLabelStack.trailingAnchor),
            acidStack.centerYAnchor.constraint(equalTo: acidLabel.centerYAnchor),
            acidStack.leadingAnchor.constraint(equalTo: secondLabelStack.trailingAnchor),
            bodyStack.centerYAnchor.constraint(equalTo: bodyLabel.centerYAnchor),
            bodyStack.leadingAnchor.constraint(equalTo: secondLabelStack.trailingAnchor),
            
            sugarSlider.topAnchor.constraint(equalTo: sugarStack.topAnchor),
            sugarSlider.bottomAnchor.constraint(equalTo: sugarStack.bottomAnchor),
            sugarSlider.leadingAnchor.constraint(equalTo: sugarStack.leadingAnchor),
            sugarSlider.trailingAnchor.constraint(equalTo: sugarStack.trailingAnchor),
            acidSlider.topAnchor.constraint(equalTo: acidStack.topAnchor),
            acidSlider.bottomAnchor.constraint(equalTo: acidStack.bottomAnchor),
            acidSlider.leadingAnchor.constraint(equalTo: acidStack.leadingAnchor),
            acidSlider.trailingAnchor.constraint(equalTo: acidStack.trailingAnchor),
            bodySlider.topAnchor.constraint(equalTo: bodyStack.topAnchor),
            bodySlider.bottomAnchor.constraint(equalTo: bodyStack.bottomAnchor),
            bodySlider.leadingAnchor.constraint(equalTo: bodyStack.leadingAnchor),
            bodySlider.trailingAnchor.constraint(equalTo: bodyStack.trailingAnchor),
            
            commentBackView.topAnchor.constraint(equalTo: firstLabelStack.bottomAnchor, constant: 30),
            commentBackView.leadingAnchor.constraint(equalTo: secondBackView.leadingAnchor),
            commentBackView.trailingAnchor.constraint(equalTo: secondBackView.trailingAnchor),
            commentBackView.bottomAnchor.constraint(equalTo: secondBackView.bottomAnchor, constant: -10),
            commentField.topAnchor.constraint(equalTo: commentBackView.topAnchor, constant: 10),
            commentField.leadingAnchor.constraint(equalTo: commentBackView.leadingAnchor, constant: 10),
            commentField.trailingAnchor.constraint(equalTo: commentBackView.trailingAnchor, constant: -10),
            commentField.bottomAnchor.constraint(equalTo: commentBackView.bottomAnchor, constant: -10)
        ])
    }
}

//MARK: - UI Delegate
//MARK: UITextFieldDelegate
extension EditWineInfomationVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == priceField {
            decimalFormatter.numberStyle = .decimal // 1,000,000
            decimalFormatter.locale = Locale.current  //지역
            decimalFormatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
            if let removeAllSeparator = (textField.text?.replacingOccurrences(of: decimalFormatter.groupingSeparator, with: "")){
                var beforeForemattedString = removeAllSeparator + string
                if decimalFormatter.number(from: string) != nil{
                    if let formattedNumber = decimalFormatter.number(from: beforeForemattedString), let formattedString = decimalFormatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{ // 숫자가 아닐 때먽
                    if string == "" { // 백스페이스일때
                        let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                        beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                        if let formattedNumber = decimalFormatter.number(from: beforeForemattedString), let formattedString = decimalFormatter.string(from: formattedNumber){
                            textField.text = formattedString
                            return false
                        }
                    }else{ // 문자일 때
                        return false
                    }
                }
            }
            return true
        }else{return true}
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let secondHeight = secondBackView.frame.height
        let commentHeight = commentBackView.frame.height
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.bottomConstraint.constant = commentHeight - secondHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
//MARK: UITextViewDelegate
extension EditWineInfomationVC: UITextViewDelegate{
    func placeholderSetting(){
        commentField.delegate = self
        commentField.text = "한줄평을 작성해 주세요."
        commentField.textColor = UIColor.lightGray
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        let secondHeight = secondBackView.frame.height
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.bottomConstraint.constant = -secondHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            commentField.text = "한줄평을 작성해 주세요."
            commentField.textColor = UIColor.lightGray
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
