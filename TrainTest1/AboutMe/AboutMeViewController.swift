//
//  AboutMeViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire
import PromiseKit
import TPKeyboardAvoiding
import SnapKit

struct Topic: Codable {
  let id: String?
  let title: String?
}

struct Profile: Codable {
  let name: String?
  let userId: String?
  let aboutMyself: String?
  let avatar: String?
  let topics: [Topic]
}

class AvatarButton: UIButton {
  var isImageSelected: Bool = false {
    didSet {
      layer.cornerRadius = 75
      layer.shadowColor = UIColor.orange2.cgColor
      layer.shadowOffset = .zero
      layer.shadowOpacity = 0.71
      layer.shadowRadius = 20
      layer.borderWidth = 4
      layer.borderColor = UIColor.orange2.cgColor
    }
  }
  
  override var isHighlighted: Bool {
    didSet {
      guard !isImageSelected else { return }
      if isHighlighted {
        layer.cornerRadius = 75
        layer.shadowColor = UIColor.orange2.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.71
        layer.shadowRadius = 20
        layer.borderWidth = 4
        layer.borderColor = UIColor.orange2.cgColor
        setImage(UIImage(named: "avatar-b2"), for: .normal)
      } else {
        layer.shadowOpacity = 0
        layer.borderColor = UIColor.clear.cgColor
        setImage(UIImage(named: "avatar-b1"), for: .normal)
      }
    }
  }
  
  init() {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

class TopicButton: UIButton {
  override var intrinsicContentSize: CGSize {
    return CGSize(width: super.intrinsicContentSize.width + 16, height: 24)
  }
  
  var isChoosen: Bool = false {
    didSet {
      if isChoosen {
        backgroundColor = .orange2
        setTitleColor(.dark1, for: .normal)
      } else {
        backgroundColor = .clear
        setTitleColor(.orange2, for: .normal)
      }
    }
  }
  
  let topic: Topic
  
  init(topic: Topic) {
    self.topic = topic
    super.init(frame: .zero)
    layer.cornerRadius = 12
    layer.borderColor = UIColor.orange2.cgColor
    layer.borderWidth = 1
    setTitle(topic.title, for: .normal)
    setTitleColor(.orange2, for: .normal)
    titleLabel?.font = .bpalB?.withSize(14)
    
    addTarget(self, action: #selector(handleTap), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func handleTap() {
    isChoosen.toggle()
  }
}

class TopicsView: UIView {
  private(set) var topicButtons: [TopicButton] = []
  
  private var heightConstraint: Constraint?
  
  init() {
    super.init(frame: .zero)
    snp.makeConstraints { make in
      heightConstraint = make.height.equalTo(0).constraint
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(topics: [Topic]) {
    topicButtons.removeAll()
    subviews.forEach { $0.removeFromSuperview() }
    
    var dx: CGFloat = 0
    var dy: CGFloat = 0
    
    topics.forEach { topic in
      let button = TopicButton(topic: topic)
      button.sizeToFit()
      addSubview(button)
      
      if dx + button.frame.width + 24 < (UIScreen.main.bounds.width - 32) {
        button.snp.makeConstraints { make in
          make.leading.equalToSuperview().inset(dx)
          make.top.equalToSuperview().inset(dy)
        }
        dx += button.frame.width + 24
      } else {
        dx = button.frame.width + 24
        dy += 32
        button.snp.makeConstraints { make in
          make.leading.equalToSuperview().inset(0)
          make.top.equalToSuperview().inset(dy)
        }
      }
      
      topicButtons.append(button)
    }
    
    if let lastView = topicButtons.last {
      heightConstraint?.deactivate()
      snp.makeConstraints { make in
        make.bottom.equalTo(lastView.snp.bottom)
      }
    } else {
      heightConstraint?.activate()
    }
    
    layoutIfNeeded()
  }
}

class AboutMeViewController: BaseViewController {
  
  let scrollView = TPKeyboardAvoidingScrollView()
  let containerView = UIView()
  
  let nameTF = TextField()
  let aboutTF = UITextView()
  
  let dateTextField = UITextField()
  let datePicker = UIDatePicker()
  
  let selectDateBtn = UIButton()
  
  let avatarButton = AvatarButton()
  
  let topicsView = TopicsView()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let titleLabel = UILabel()
    titleLabel.font = .bpalB?.withSize(24)
    titleLabel.textColor = .white
    titleLabel.text = "Why are you scary?"
    containerView.addSubview(titleLabel)
    titleLabel.textAlignment = .center
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(24)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    view.addSubview(scrollView)
    scrollView.showsVerticalScrollIndicator = false
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    scrollView.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
      make.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.height)
    }
    
    
    containerView.addSubview(avatarButton)
    avatarButton.layer.cornerRadius = 75
    avatarButton.clipsToBounds = true
    avatarButton.imageView?.contentMode = .scaleAspectFill
    avatarButton.setImage(UIImage(named: "avatar-b1"), for: .normal)
    avatarButton.snp.makeConstraints { make in
      make.size.equalTo(150)
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.centerX.equalToSuperview()
    }
    
    containerView.addSubview(nameTF)
    nameTF.placeholder = "Name"
    nameTF.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.top.equalTo(avatarButton.snp.bottom).offset(28)
    }
    
    containerView.addSubview(aboutTF)
    aboutTF.font = .bpalB
    aboutTF.textColor = .white
    aboutTF.backgroundColor = .dark2
    aboutTF.text = "About"
    aboutTF.layer.cornerRadius = 16
    aboutTF.isScrollEnabled = true
    aboutTF.contentInset = UIEdgeInsets(top: 18, left: 24, bottom: 18, right: 24)
    aboutTF.snp.makeConstraints { make in
      make.top.equalTo(nameTF.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(128)
    }
    
    let topicsLabel = UILabel()
    topicsLabel.textColor = .white
    topicsLabel.text = "Party Topics"
    topicsLabel.font = .bpalB?.withSize(24)
    containerView.addSubview(topicsLabel)
    topicsLabel.snp.makeConstraints { make in
      make.top.equalTo(aboutTF.snp.bottom).offset(24)
      make.centerX.equalToSuperview()
    }
    
    containerView.addSubview(topicsView)
    topicsView.snp.makeConstraints { make in
      make.top.equalTo(topicsLabel.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    
    let partyDateLbl = UILabel()
    partyDateLbl.textColor = .white
    partyDateLbl.text = "Party Date"
    partyDateLbl.font = .bpalB?.withSize(24)
    containerView.addSubview(partyDateLbl)
    partyDateLbl.snp.makeConstraints { make in
      make.top.equalTo(topicsView.snp.bottom).offset(24)
      make.centerX.equalToSuperview()
    }
    
    
    containerView.addSubview(selectDateBtn)
    selectDateBtn.setTitleColor(.orange2, for: .normal)
    selectDateBtn.titleLabel?.font = .bpalB?.withSize(24)
    selectDateBtn.setTitle("Select Date and Time", for: .normal)
    selectDateBtn.snp.makeConstraints { make in
      make.top.equalTo(partyDateLbl.snp.bottom).offset(8)
      make.height.equalTo(42)
      make.leading.equalToSuperview().inset(16)
    }
    selectDateBtn.addTarget(self, action: #selector(selectDate), for: .touchUpInside)
    
    
    containerView.addSubview(dateTextField)
    dateTextField.alpha = 0
    dateTextField.inputView = datePicker
    
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.backgroundColor = .orange2
    dateTextField.inputView?.backgroundColor = .orange2
    datePicker.datePickerMode = .dateAndTime
    
    let doneButton = UIButton()
    doneButton.setTitle("Done", for: .normal)
    doneButton.titleLabel?.font = .bpalB?.withSize(16)
    doneButton.setTitleColor(.orange2, for: .normal)
    doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
    
    let accView = UIView()
    accView.backgroundColor = .dark2
    accView.snp.makeConstraints { make in
      make.height.equalTo(40)
      make.width.equalTo(UIScreen.main.bounds.width)
    }
    
    accView.addSubview(doneButton)
    doneButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(16)
    }
    
    datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    
    dateTextField.inputAccessoryView = doneButton
    
    let saveBTN = CommonButton()
    containerView.addSubview(saveBTN)
    saveBTN.setTitle("Save", for: .normal)
    saveBTN.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(selectDateBtn.snp.bottom).offset(40)
      make.top.equalTo(selectDateBtn.snp.bottom).offset(40).priority(250)
      make.leading.trailing.bottom.equalToSuperview().inset(16)
    }
    saveBTN.addTarget(self, action: #selector(save), for: .touchUpInside)
    
    avatarButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
    // Do any additional setup after loading the view.
    
    getTopics()
  }
  
  func getTopics() {
    showProgress()
    network.request(type: [Topic].self, url: "/v1/topic", method: .get, params: nil, encoding: URLEncoding.default).ensure {
      self.hideProgress()
    }.done { topics in
      self.topicsView.configure(topics: topics ?? [])
      self.view.layoutIfNeeded()
    }.catch { error in
      self.showAlert(text: error.localizedDescription)
    }
  }
  
  @objc func done() {
    view.endEditing(true)
  }
  
  @objc func selectDate() {
    dateTextField.becomeFirstResponder()
  }
  
  @objc func dateDidChange() {
    let date = datePicker.date
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy - HH:mm"
    let dateStr = formatter.string(from: date)
    selectDateBtn.setTitle(dateStr, for: .normal)
    
    UserDefaults(suiteName: "group.scareme")?.setValue(dateStr, forKey: "partyDate")
  }
  
  @objc func save() {
    let name = nameTF.text
    var about = aboutTF.text
    if about == "About" {
      about = nil
    }
    
    guard name?.isEmpty == false else {
      showAlert(text: "Fill in name")
      return
    }
    
    showProgress()
    
    firstly {
      self.uploadPhoto()
    }.then { _ in
      self.network.request(type: Profile.self, url: "/v1/profile", method: .patch, params: [
        "name": name ?? "",
        "aboutMyself": about ?? "",
        "topics": self.topicsView.topicButtons.filter(\.isChoosen).map(\.topic.id)
      ], encoding: JSONEncoding.default)
    }.ensure {
      self.hideProgress()
    }.done { profile in
      let topicsData = try? JSONEncoder().encode(self.topicsView.topicButtons.filter(\.isChoosen).map(\.topic))
      UserDefaults.standard.set(topicsData, forKey: "topics")
      self.navigationController?.setViewControllers([MainViewController()], animated: true)
    }.catch { error in
      self.showAlert(text: error.localizedDescription)
    }
  }
  
  
  @objc func pickImage() {
    let alert  = UIAlertController(title: "Select image", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = .camera
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      self.present(imagePicker, animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = .photoLibrary
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      self.present(imagePicker, animated: true, completion: nil)
    }))
    
    present(alert, animated: true, completion: nil)
  }
  
  func uploadPhoto() -> Promise<Void> {
    return Promise { seal in
      guard let image = avatarButton.imageView?.image else {
        seal.fulfill(())
        return
      }
      AF.upload(multipartFormData: { formData in
        formData.append(image.jpegData(compressionQuality: 0.3) ?? Data(), withName: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")
      }, to: network.baseURL + "/v1/profile/avatar", headers: [
        "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "access") ?? "")"
      ], interceptor: network).responseData { response in
        switch response.result {
        case .success:
          print("success")
          seal.fulfill(())
        case .failure(let error):
          print(error)
          seal.reject(error)
        }
      }
    }
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension AboutMeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    
    if let image = info[.editedImage] as? UIImage {
      avatarButton.setImage(image, for: .normal)
      avatarButton.isImageSelected = true
    }
  }
}
