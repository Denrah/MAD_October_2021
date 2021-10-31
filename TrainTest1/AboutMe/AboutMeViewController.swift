//
//  AboutMeViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire
import PromiseKit

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

class AboutMeViewController: BaseViewController {
  
  let nameTF = TextField()
  let aboutTF = UITextView()
  
  let avatarButton = AvatarButton()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      let titleLabel = UILabel()
      titleLabel.font = .bpalB?.withSize(24)
      titleLabel.textColor = .white
      titleLabel.text = "Why are you scary?"
      view.addSubview(titleLabel)
      titleLabel.textAlignment = .center
      titleLabel.snp.makeConstraints { make in
        make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
        make.leading.trailing.equalToSuperview().inset(16)
      }
      
      
      view.addSubview(avatarButton)
      avatarButton.layer.cornerRadius = 75
      avatarButton.clipsToBounds = true
      avatarButton.imageView?.contentMode = .scaleAspectFill
      avatarButton.setImage(UIImage(named: "avatar-b1"), for: .normal)
      avatarButton.snp.makeConstraints { make in
        make.size.equalTo(150)
        make.top.equalTo(titleLabel.snp.bottom).offset(16)
        make.centerX.equalToSuperview()
      }
      
      view.addSubview(nameTF)
      nameTF.placeholder = "Name"
      nameTF.snp.makeConstraints { make in
        make.leading.trailing.equalToSuperview().inset(16)
        make.top.equalTo(avatarButton.snp.bottom).offset(28)
      }
      
      view.addSubview(aboutTF)
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

      
      let saveBTN = CommonButton()
      view.addSubview(saveBTN)
      saveBTN.setTitle("Save", for: .normal)
      saveBTN.snp.makeConstraints { make in
        make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
      }
      saveBTN.addTarget(self, action: #selector(save), for: .touchUpInside)
      
      avatarButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        // Do any additional setup after loading the view.
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
        "topics": []
      ], encoding: JSONEncoding.default)
    }.ensure {
      self.hideProgress()
    }.done { profile in
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
