//
//  LastCellView.swift
//  TrainTest1
//
//  Created by National Team on 02.11.2021.
//

import UIKit

class LastCellView: UIView {
  init(viewModel: LastCellViewModel) {
    super.init(frame: .zero)
    
    let imageView = UIImageView()
    imageView.kf.setImage(with: viewModel.avatarURL)
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 41
    imageView.clipsToBounds = true
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.size.equalTo(82)
      make.leading.trailing.top.equalToSuperview()
    }
    
    let titleLabl = UILabel()
    titleLabl.textColor = .white
    titleLabl.font = .bpalB?.withSize(14)
    titleLabl.textAlignment = .center
    titleLabl.text = viewModel.name
    addSubview(titleLabl)
    titleLabl.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(8)
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(25)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
