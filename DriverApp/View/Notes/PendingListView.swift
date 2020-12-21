//
//  PendingListView.swift
//  DriverApp
//
//  Created by Indo Office4 on 21/12/20.
//

import UIKit
import JGProgressHUD
import RxCocoa
import RxSwift

@available(iOS 13.0, *)
class PendingListView: UIViewController, UIScrollViewDelegate {
    
    private var bag = DisposeBag()
    
    private let emptyImage: UIView = {
        let view = UIView()
        let imageView: UIImageView = {
           let img = UIImageView()
            img.image = UIImage(named: "emptyImage")
            img.tintColor = UIColor(named: "orangeKasumi")
            img.clipsToBounds = true
            img.layer.masksToBounds = true
            img.translatesAutoresizingMaskIntoConstraints = false
            img.contentMode = .scaleAspectFit
            return img
        }()
        
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.backgroundColor = UIColor(named: "bgKasumi")
        view.layer.cornerRadius = 120/2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    var viewModel = NoteViewModel()
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    lazy var refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(named: "grayKasumi")
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        table.showsVerticalScrollIndicator = false
        table.sectionFooterHeight = 0
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        configureUi()
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        bindTableView()
    }
    
    private func bindTableView(){

        viewModel.items.asObservable()
                .bind(to: tableView.rx
                    .items(cellIdentifier: "Cell", cellType: NoteCell.self))
                { index, element, cell in
                        
                    cell.labelNote.text = element.note
                    cell.labelTime.text = element.created_time
            }.disposed(by: bag)
        
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                 let codeDriver = userData["codeDriver"] as? String else {
               print("No user data")
               return
           }
        viewModel.getNote(codeDriver: codeDriver)
    }
    
    private func configureUi(){
        view.addSubview(tableView)
        tableView.fill(toView: view)
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "Notes".localiz()
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: - GET DATA
//    private func getListNotePanding(){
//        spiner.show(in: view)
//        emptyImage.isHidden = true
//        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
//              let codeDriver = userData["codeDriver"] as? String else {
//            print("No user data")
//            return
//        }
//        noteViewModel.getDataNotePending(codeDriver: codeDriver) {[weak self] (result) in
//            switch result {
//            case .success(let dataPending):
//                DispatchQueue.main.async {
//                    self?.tableView.rx
//                    self?.tableView.reloadData()
//                    self?.spiner.dismiss()
//                    self?.emptyImage.isHidden = true
//                }
//            case .failure(let error):
//                print(error)
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                    self?.spiner.dismiss()
//                    self?.emptyImage.isHidden = false
//                }
//            }
//        }
//    }
    
}


@available(iOS 13.0, *)
extension PendingListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
