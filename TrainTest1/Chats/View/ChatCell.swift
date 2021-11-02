//
//  ChatCell.swift
//  TrainTest1
//
//  Created by National Team on 02.11.2021.
//

import UIKit

class ChatCell: UITableViewCell {
  let avImageView = UIImageView()
  let nameLabel = UILabel()
  let msgLabel = UILabel()
  let dividerView = UIView()
  
  let containerView = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    contentView.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.height.greaterThanOrEqualTo(96)
      make.edges.equalToSuperview()
    }
    
    
    containerView.addSubview(avImageView)
    avImageView.contentMode = .scaleAspectFill
    avImageView.layer.cornerRadius = 32
    avImageView.clipsToBounds = true
    avImageView.snp.makeConstraints { make in
      make.size.equalTo(64)
      make.leading.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
    
    let stackView = UIStackView()
    stackView.spacing = 4
    stackView.axis =  .vertical
    containerView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.leading.equalTo(avImageView.snp.trailing).offset(16)
      make.trailing.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
      make.top.bottom.lessThanOrEqualToSuperview().inset(16)
    }
    
   
    nameLabel.textColor = .white
    nameLabel.numberOfLines = 0
    nameLabel.font = .bpalB?.withSize(16)
    stackView.addArrangedSubview(nameLabel)
    
    msgLabel.textColor = .white
    msgLabel.numberOfLines = 0
    msgLabel.font = .bpalB?.withSize(16)
    stackView.addArrangedSubview(msgLabel)
    
   
    dividerView.backgroundColor = .orange1
    containerView.addSubview(dividerView)
    dividerView.snp.makeConstraints { make in
      make.leading.equalTo(avImageView.snp.trailing).offset(16)
      make.trailing.bottom.equalToSuperview()
      make.height.equalTo(1)
    }
    
    selectionStyle = .none
  }
  
  func configure(viewModel: ChatCellViewModel) {
    avImageView.kf.setImage(with: viewModel.avatarURL)
    msgLabel.text = viewModel.text
    nameLabel.text = viewModel.name
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
