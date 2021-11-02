//
//  ChatsViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire

class ChatsViewController: BaseViewController {

  private let tableView = UITableView()
  
  private let viewModel: ChatsViewModel
  
  init(viewModel: ChatsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
    viewModel.loadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    let lastLbl = UILabel()
    view.addSubview(lastLbl)
    lastLbl.text = "Last"
    lastLbl.textColor = .white
    lastLbl.font = .bpalB?.withSize(36)
    lastLbl.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
      make.leading.equalToSuperview().inset(21)
    }
    
    let lastScrollView = UIScrollView()
    lastScrollView.showsHorizontalScrollIndicator = false
    lastScrollView.contentInset.left = 20
    lastScrollView.contentInset.right = 20
    view.addSubview(lastScrollView)
    lastScrollView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(lastLbl.snp.bottom).offset(16)
      make.height.equalTo(115)
    }
    
    let lastStackView = UIStackView()
    lastStackView.spacing = 16
    lastScrollView.addSubview(lastStackView)
    lastStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalToSuperview()
    }
    
    viewModel.lastCellViewModels.forEach { itemViewModel in
      let cell = LastCellView(viewModel: itemViewModel)
      lastStackView.addArrangedSubview(cell)
    }
    
    
    let messLabl = UILabel()
    view.addSubview(messLabl)
    messLabl.text = "Messages"
    messLabl.textColor = .white
    messLabl.font = .bpalB?.withSize(36)
    messLabl.snp.makeConstraints { make in
      make.top.equalTo(lastScrollView.snp.bottom).offset(16)
      make.leading.equalToSuperview().inset(21)
    }
    
    

    
    view.addSubview(tableView)
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.estimatedRowHeight = 96
    tableView.rowHeight = UITableView.automaticDimension
    tableView.contentInset.bottom = 120
    tableView.snp.makeConstraints { make in
      make.top.equalTo(messLabl.snp.bottom).offset(8)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")
    
    tableView.delegate = self
    tableView.dataSource = self
    
    let tabbar = TabbarView()
    view.addSubview(tabbar)
    tabbar.select(item: .chat)
    tabbar.snp.makeConstraints { make in
      make.height.equalTo(71)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    tabbar.onTap = { item in
      self.showTab(item: item)
    }
    
    bindToViewModel()
  }
  
  private func bindToViewModel() {
    viewModel.onDidStartRequest = { [weak self] in
      self?.showProgress()
    }
    viewModel.onDidFinishRequest = { [weak self] in
      self?.hideProgress()
    }
    viewModel.onDidLoadData = { [weak self] in
      self?.tableView.reloadData()
    }
    viewModel.onDidReceiveError = { [weak self] error in
      self?.showAlert(text: error.localizedDescription)
    }
  }
  
}

extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.chatsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
    (cell as? ChatCell)?.configure(viewModel: viewModel.cellViewModel(for: indexPath.row))
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let chatInfo = viewModel.chatInfo(for: indexPath.row)
    navigationController?.pushViewController(ChatViewController(chatInfo: chatInfo), animated: true)
  }
}
