//
//  UserCardView.swift
//  TrainTest1
//
//  Created by National Team on 02.11.2021.
//

import UIKit
import Kingfisher

class UserCardView: UIView {
  private let viewModel: UserCardViewModel
  
  init(viewModel: UserCardViewModel) {
    self.viewModel = viewModel
    
    super.init(frame: .zero)
    
    layer.cornerRadius = 13
    clipsToBounds = true
    
    let imageView = UIImageView()
    imageView.backgroundColor = .gray
    imageView.contentMode = .scaleAspectFill
    imageView.kf.setImage(with: viewModel.avatarURL)
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    let bottomView = UIView()
    bottomView.backgroundColor = .dark2
    bottomView.layer.cornerRadius = 13
    addSubview(bottomView)
    bottomView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(66)
    }
    
    let nameLabel = UILabel()
    nameLabel.textColor = .white
    nameLabel.font = .bpalB?.withSize(21)
    nameLabel.text = viewModel.name
    bottomView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
    
    
    
    let matchLabel = UILabel()
    matchLabel.textColor = .orange1
    matchLabel.font = .bpalB?.withSize(21)
    matchLabel.text = viewModel.topicsCountText
    bottomView.addSubview(matchLabel)
    matchLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
    
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(gesure:))))
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hanleTap)))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func hanleTap() {
    viewModel.didTapView()
  }
  
  @objc func didPan(gesure: UIPanGestureRecognizer) {
    
    
    switch gesure.state {
    case .began, .changed:
      let translation = gesure.translation(in: superview)
      let delta = translation.x / UIScreen.main.bounds.width
      transform = CGAffineTransform(translationX: translation.x, y: translation.y).concatenating(CGAffineTransform(rotationAngle: (CGFloat.pi / 8) * delta))
    case .ended, .cancelled:
      let translation = gesure.translation(in: superview)
      let delta = translation.x / UIScreen.main.bounds.width
      
      if translation.x > UIScreen.main.bounds.width / 3 {
        viewModel.didLike()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
          self.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * 2, y: 0).concatenating(CGAffineTransform(rotationAngle: (CGFloat.pi / 8) * delta))
        }) { _ in
         
        }
      } else if translation.x < -UIScreen.main.bounds.width / 3 {
        viewModel.didDislike()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
          self.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width * 2, y: 0).concatenating(CGAffineTransform(rotationAngle: (CGFloat.pi / 8) * delta))
        }) { _ in
         
        }
      } else {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
          self.transform = CGAffineTransform(translationX: 0, y: 0).concatenating(CGAffineTransform(rotationAngle: .zero))
        }, completion: nil)
      }
    default:
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
        self.transform = CGAffineTransform(translationX: 0, y: 0).concatenating(CGAffineTransform(rotationAngle: .zero))
      }, completion: nil)
    }
  }
}
