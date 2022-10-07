//
//  AddWineInformationVC.swift
//  WineLog
//
//  Created by 이태형 on 2022/10/05.
//

import UIKit

class AddWineInformationVC: UIViewController {
    var wineType: WineType!
    var isAddWine: Bool!  //추가모드: true / 편집모드: false
    var wineId: Int?  //편집모드 시 ID로 받기
    var isNewPhoto = false
    let decimalFormatter = NumberFormatter()
    let yellowStar = ["yellow_star_full", "yellow_star_half", "star_empty"]
    let greenStar = ["green_star_full", "green_star_half", "star_empty"]
    var totalStarArr = [UIImageView]()
    var sugarStarArr = [UIImageView]()
    var acidStarArr = [UIImageView]()
    var bodyStarArr = [UIImageView]()
    let imagePicker = UIImagePickerController()
    
    let saveItem = UIBarButtonItem()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let photoView = UIImageView()
    let addPhotoBtn = UIButton()
    let nameView = UIView()
    let nameField = UITextField()
    let dateView = UIView()
    let madeDateField = UITextField()
    let contryView = UIView()
    let madeContryField = UITextField()
    let placeView = UIView()
    let placeField = UITextField()
    let priceView = UIView()
    let priceField = UITextField()
    let totalLabel = UILabel()
    let totalSlider = UISlider()
    let totalStack = UIStackView()
    let sugarLabel = UILabel()
    let sugarSlider = UISlider()
    let sugarStack = UIStackView()
    let acidLabel = UILabel()
    let acidSlider = UISlider()
    let acidStack = UIStackView()
    let bodyLabel = UILabel()
    let bodySlider = UISlider()
    let bodyStack = UIStackView()
    let commentField = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        setNavigation()
        setUI()
        
        if !isAddWine{  //편집모드일때 불러오기
            
        }
        starAction(totalSlider, totalStarArr, totalLabel, yellowStar)
        starAction(sugarSlider, sugarStarArr, sugarLabel, greenStar)
        starAction(acidSlider, acidStarArr, acidLabel, greenStar)
        starAction(bodySlider, bodyStarArr, bodyLabel, greenStar)
    }
    
}

//MARK: - Func
extension AddWineInformationVC{
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
            starAction(totalSlider, totalStarArr, totalLabel, yellowStar)
        case sugarSlider:
            starAction(sugarSlider, sugarStarArr, sugarLabel, greenStar)
        case acidSlider:
            starAction(acidSlider, acidStarArr, acidLabel, greenStar)
        case bodySlider:
            starAction(bodySlider, bodyStarArr, bodyLabel, greenStar)
        default:
            print("Not Exist Slider Error")
        }
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
                wineId = oldId + 1
            }else{
                wineId = 0
            }
        }else{
            Singleton.shared.myWines = Singleton.shared.myWines.filter{ $0.id != wineId}
        }
        let newPrice: Int? = Int(priceField.text?.components(separatedBy: [","]).joined() ?? "0")
        guard let imageData: Data = photoView.image?.pngData() else{return}
        let dateText: String? = madeDateField.text! == "" ? nil : madeDateField.text
        let contryText: String? = madeDateField.text! == "" ? nil : madeContryField.text
        let placeText: String? = madeDateField.text! == "" ? nil : placeField.text
        let comments = commentField.textColor == UIColor.lightGray ? nil : commentField.text
        let newWineInfo = WineInformation(id: wineId!,
                                          type: wineType,
                                          profileData: imageData,
                                          name: nameField.text!,
                                          manufacturingDate: dateText,
                                          manufacturingContry: contryText,
                                          boughtPlace: placeText,
                                          price: newPrice,
                                          totalStar: Double(String(format: "%.1f", round(totalSlider.value)/2))!,
                                          sugarStar: Double(String(format: "%.1f", round(sugarSlider.value)/2))!,
                                          acidityStar: Double(String(format: "%.1f", round(acidSlider.value)/2))!,
                                          bodyStar: Double(String(format: "%.1f", round(bodySlider.value)/2))!,
                                          comment: comments)
        Singleton.shared.myWines.append(newWineInfo)
        //FileManager Save
        saveToJson(Singleton.shared.myWines)
    }
}

//MARK: Image Picker
extension AddWineInformationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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

//MARK: Star Slider function
extension AddWineInformationVC{
    func starAction(_ slider: UISlider, _ stackSubView: [UIImageView], _ label: UILabel, _ color: [String]){
        let value = round(slider.value)
        var half = value.truncatingRemainder(dividingBy: 2)
        for i in 0...4{
            if i < Int(value/2){
                stackSubView[i].image = UIImage(named: color[0])
            }else{
                if half != 0{
                    stackSubView[i].image = UIImage(named: color[1])
                    half = 0
                }else{
                    stackSubView[i].image = UIImage(named: color[2])
                }
            }
        }
        guard var str = label.text else{return}
        if str.count > 5 {
            str.removeLast(3)
        }
        label.text = str + String(format: "%.1f", value/2)
    }
    func initStarArr(){
        for i in 0...4{
            totalStarArr.append(totalStack.subviews[i] as? UIImageView ?? UIImageView())
            sugarStarArr.append(sugarStack.subviews[i] as? UIImageView ?? UIImageView())
            acidStarArr.append(acidStack.subviews[i] as? UIImageView ?? UIImageView())
            bodyStarArr.append(bodyStack.subviews[i] as? UIImageView ?? UIImageView())
        }
    }
}

//MARK: - Alert
extension AddWineInformationVC{
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

//MARK: - About UI
//MARK: UITextFieldDelegate
extension AddWineInformationVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
    }
}
//MARK: UITextViewDelegate
extension AddWineInformationVC: UITextViewDelegate{
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
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            commentField.text = "한줄평을 작성해 주세요."
            commentField.textColor = UIColor.lightGray
        }
    }
}

//MARK: - Set UI & Navigation
extension AddWineInformationVC{
    private func setNavigation(){
        switch wineType {
        case .white:
            title = "화이트 와인"
        case .red:
            title = "레드 와인"
        case .rose:
            title = "로제 와인"
        case .none:
            print("Wine Type Error")
        }
        saveItem.title = "저장"
        saveItem.target = self
        saveItem.action = #selector(didTapSaveBtn(_:))
        navigationItem.rightBarButtonItem = saveItem
    }
    private func setUI(){
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = false
//        tapGesture.cancelsTouchesInView = false
        photoView.image = UIImage(named: "selectPhoto")
        addPhotoBtn.setTitle("", for: .normal)
        addPhotoBtn.addTarget(self, action: #selector(didTapAddPhotoBtn(_:)), for: .touchUpInside)
        [nameView,dateView,contryView,placeView,priceView].forEach{
            $0.layer.cornerRadius = 16
            $0.layer.borderWidth = 4
            $0.layer.borderColor = UIColor.lightGray.cgColor
        }
        [nameField, madeDateField, madeContryField, placeField, priceField].forEach{
            $0.font = .systemFont(ofSize: 18)
            $0.textAlignment = .center
        }
        nameField.placeholder = "제품명"
        madeDateField.placeholder = "제조일자(선택)"
        madeContryField.placeholder = "원산지(선택)"
        placeField.placeholder = "구매처(선택)"
        priceField.placeholder = "구매가(선택)"
        priceField.keyboardType = .numberPad
        priceField.delegate = self
        commentField.font = .systemFont(ofSize: 16)
        commentField.layer.cornerRadius = 15
        commentField.layer.borderWidth = 4
        commentField.layer.borderColor = UIColor.lightGray.cgColor
        placeholderSetting()
        totalLabel.text = "총평: "
        sugarLabel.text = "당도: "
        acidLabel.text = "산도: "
        bodyLabel.text = "바디감: "
        totalLabel.font = .systemFont(ofSize: 18)
        totalLabel.textColor = .black
        [sugarLabel, acidLabel, bodyLabel].forEach{
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .black
        }
        [totalSlider, sugarSlider, acidSlider, bodySlider].forEach{
            $0.maximumValue = 10.0
            $0.minimumValue = 0.0
            $0.value = 5.0
            $0.thumbTintColor = .clear
            $0.tintColor = .clear
            $0.alpha = 0.1
            $0.addTarget(self, action: #selector(didChangeSlider(_:)), for: .valueChanged)
        }
        totalStack.axis = .horizontal
        totalStack.alignment = .center
        totalStack.distribution = .equalSpacing
        for _ in 0...4{
            let imageView = UIImageView()
            imageView.image = UIImage(named: "star_empty")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
            totalStack.addArrangedSubview(imageView)
        }
        [sugarStack, acidStack, bodyStack].forEach{
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
            for _ in 0...4{
                let imageView = UIImageView()
                imageView.image = UIImage(named: "star_empty")
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
                $0.addArrangedSubview(imageView)
            }
        }
        initStarArr()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGesture))
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addGestureRecognizer(tapGesture)
        contentView.addSubview(photoView)
        contentView.addSubview(addPhotoBtn)
        contentView.addSubview(nameView)
        contentView.addSubview(dateView)
        contentView.addSubview(contryView)
        contentView.addSubview(placeView)
        contentView.addSubview(priceView)
        nameView.addSubview(nameField)
        dateView.addSubview(madeDateField)
        contryView.addSubview(madeContryField)
        placeView.addSubview(placeField)
        priceView.addSubview(priceField)
        contentView.addSubview(commentField)
        contentView.addSubview(totalLabel)
        contentView.addSubview(totalStack)
        contentView.addSubview(totalSlider)
        contentView.addSubview(sugarLabel)
        contentView.addSubview(sugarStack)
        contentView.addSubview(sugarSlider)
        contentView.addSubview(acidLabel)
        contentView.addSubview(acidStack)
        contentView.addSubview(acidSlider)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(bodyStack)
        contentView.addSubview(bodySlider)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        photoView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoBtn.translatesAutoresizingMaskIntoConstraints = false
        nameView.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        contryView.translatesAutoresizingMaskIntoConstraints = false
        placeView.translatesAutoresizingMaskIntoConstraints = false
        priceView.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        madeDateField.translatesAutoresizingMaskIntoConstraints = false
        madeContryField.translatesAutoresizingMaskIntoConstraints = false
        placeField.translatesAutoresizingMaskIntoConstraints = false
        priceField.translatesAutoresizingMaskIntoConstraints = false
        commentField.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalStack.translatesAutoresizingMaskIntoConstraints = false
        totalSlider.translatesAutoresizingMaskIntoConstraints = false
        sugarLabel.translatesAutoresizingMaskIntoConstraints = false
        sugarStack.translatesAutoresizingMaskIntoConstraints = false
        sugarSlider.translatesAutoresizingMaskIntoConstraints = false
        acidLabel.translatesAutoresizingMaskIntoConstraints = false
        acidStack.translatesAutoresizingMaskIntoConstraints = false
        acidSlider.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyStack.translatesAutoresizingMaskIntoConstraints = false
        bodySlider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            photoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),
            addPhotoBtn.topAnchor.constraint(equalTo: photoView.topAnchor),
            addPhotoBtn.bottomAnchor.constraint(equalTo: photoView.bottomAnchor),
            addPhotoBtn.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
            addPhotoBtn.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
            
            nameView.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 20),
            nameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            nameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            nameView.heightAnchor.constraint(equalToConstant: 35),
            dateView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 18),
            dateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            dateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            dateView.heightAnchor.constraint(equalToConstant: 35),
            contryView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 18),
            contryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            contryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            contryView.heightAnchor.constraint(equalToConstant: 35),
            placeView.topAnchor.constraint(equalTo: contryView.bottomAnchor, constant: 18),
            placeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            placeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            placeView.heightAnchor.constraint(equalToConstant: 35),
            priceView.topAnchor.constraint(equalTo: placeView.bottomAnchor, constant: 18),
            priceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            priceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            priceView.heightAnchor.constraint(equalToConstant: 35),
            nameField.centerYAnchor.constraint(equalTo: nameView.centerYAnchor),
            nameField.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: 15),
            nameField.trailingAnchor.constraint(equalTo: nameView.trailingAnchor, constant: -15),
            madeDateField.centerYAnchor.constraint(equalTo: dateView.centerYAnchor),
            madeDateField.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 15),
            madeDateField.trailingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: -15),
            madeContryField.centerYAnchor.constraint(equalTo: contryView.centerYAnchor),
            madeContryField.leadingAnchor.constraint(equalTo: contryView.leadingAnchor, constant: 15),
            madeContryField.trailingAnchor.constraint(equalTo: contryView.trailingAnchor, constant: -15),
            placeField.centerYAnchor.constraint(equalTo: placeView.centerYAnchor),
            placeField.leadingAnchor.constraint(equalTo: placeView.leadingAnchor, constant: 15),
            placeField.trailingAnchor.constraint(equalTo: placeView.trailingAnchor, constant: -15),
            priceField.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
            priceField.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 15),
            priceField.trailingAnchor.constraint(equalTo: priceView.trailingAnchor, constant: -15),
            
            commentField.topAnchor.constraint(equalTo: priceView.bottomAnchor, constant: 18),
            commentField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            commentField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            commentField.heightAnchor.constraint(equalToConstant: 100),
            
            totalLabel.topAnchor.constraint(equalTo: commentField.bottomAnchor, constant: 20),
            totalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 55),
            totalStack.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 8),
            totalStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            totalStack.heightAnchor.constraint(equalToConstant: 35),
            totalStack.widthAnchor.constraint(equalTo: totalStack.heightAnchor, multiplier: 6.5),
            totalSlider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            totalSlider.centerYAnchor.constraint(equalTo: totalStack.centerYAnchor),
            totalSlider.widthAnchor.constraint(equalTo: totalStack.widthAnchor),
            totalSlider.heightAnchor.constraint(equalTo: totalStack.heightAnchor),
            sugarLabel.topAnchor.constraint(equalTo: totalStack.bottomAnchor, constant: 20),
            sugarLabel.leadingAnchor.constraint(equalTo: sugarStack.leadingAnchor, constant: -25),
            sugarStack.topAnchor.constraint(equalTo: sugarLabel.bottomAnchor, constant: 8),
            sugarStack.trailingAnchor.constraint(equalTo: totalStack.trailingAnchor, constant: -10),
            sugarStack.heightAnchor.constraint(equalToConstant: 32),
            sugarStack.widthAnchor.constraint(equalTo: sugarStack.heightAnchor, multiplier: 6.3),
            sugarSlider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sugarSlider.centerYAnchor.constraint(equalTo: sugarStack.centerYAnchor),
            sugarSlider.widthAnchor.constraint(equalTo: sugarStack.widthAnchor),
            sugarSlider.heightAnchor.constraint(equalTo: sugarStack.heightAnchor),
            acidLabel.topAnchor.constraint(equalTo: sugarStack.bottomAnchor, constant: 12),
            acidLabel.leadingAnchor.constraint(equalTo: acidStack.leadingAnchor, constant: -25),
            acidStack.topAnchor.constraint(equalTo: acidLabel.bottomAnchor, constant: 8),
            acidStack.trailingAnchor.constraint(equalTo: totalStack.trailingAnchor, constant: -10),
            acidStack.heightAnchor.constraint(equalToConstant: 32),
            acidStack.widthAnchor.constraint(equalTo: acidStack.heightAnchor, multiplier: 6.3),
            acidSlider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            acidSlider.centerYAnchor.constraint(equalTo: acidStack.centerYAnchor),
            acidSlider.widthAnchor.constraint(equalTo: acidStack.widthAnchor),
            acidSlider.heightAnchor.constraint(equalTo: acidStack.heightAnchor),
            bodyLabel.topAnchor.constraint(equalTo: acidStack.bottomAnchor, constant: 12),
            bodyLabel.leadingAnchor.constraint(equalTo: bodyStack.leadingAnchor, constant: -25),
            bodyStack.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            bodyStack.trailingAnchor.constraint(equalTo: totalStack.trailingAnchor, constant: -10),
            bodyStack.heightAnchor.constraint(equalToConstant: 32),
            bodyStack.widthAnchor.constraint(equalTo: bodyStack.heightAnchor, multiplier: 6.3),
            bodySlider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bodySlider.centerYAnchor.constraint(equalTo: bodyStack.centerYAnchor),
            bodySlider.widthAnchor.constraint(equalTo: bodyStack.widthAnchor),
            bodySlider.heightAnchor.constraint(equalTo: bodyStack.heightAnchor),
            
            bodyStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
        ])
    }
}

