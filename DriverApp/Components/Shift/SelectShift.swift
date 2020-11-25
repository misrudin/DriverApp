//
//  SelectShift.swift
//  DriverApp
//
//  Created by Indo Office4 on 25/11/20.
//

import UIKit

protocol SelectShiftDelegate {
    func onSelectShift(_ vm: SelectShift, idShift: [Int])
    func onDayOff(_ vm: SelectShift)
}

struct CustomList: Codable {
    let id: Int
    let name: String
    var selected: Bool
}

class SelectShift: UIViewController {
    
    var delegate: SelectShiftDelegate?
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
//    var listShift = [ShiftTime]()
    
    var shifts = [CustomList]()
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    
    lazy var colectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ShiftTimeCell.self, forCellWithReuseIdentifier: ShiftTimeCell.id)
        cv.backgroundColor = UIColor.white
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    
    @IBOutlet weak var dayOffButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        view.addSubview(colectionView)
        colectionView.delegate = self
        colectionView.dataSource = self
        
        configureLayout()
        styleButton()
        
        colectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        shifts = [CustomList]()
        colectionView.reloadData()
    }
    
    private func styleButton(){
        addButton.backgroundColor = UIColor(named: "colorGreen")
        addButton.layer.cornerRadius = 5
        addButton.setTitleColor(.white, for: .normal)
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        dayOffButton.backgroundColor = UIColor(named: "colorYellow")
        dayOffButton.layer.cornerRadius = 5
        dayOffButton.setTitleColor(.black, for: .normal)
        dayOffButton.addTarget(self, action: #selector(off), for: .touchUpInside)
    }
    
    @objc
    func add(){
        dismiss(animated: true, completion: nil)
        var selectedShift: [Int] = []
        let filtered = shifts.filter { $0.selected != false }
        for item in filtered {
            selectedShift.append(item.id)
        }
        delegate?.onSelectShift(self, idShift: selectedShift)
    }
    
    @objc
    func off(){
        dismiss(animated: true, completion: nil)
        delegate?.onDayOff(self)
    }
    
    private func configureLayout(){
        titleLable.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        descriptionLable.anchor(top: titleLable.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 1, paddingLeft: 16, paddingRight: 16)
        line.anchor(top: descriptionLable.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 1)
        
        colectionView.anchor(top: line.bottomAnchor, left: view.leftAnchor,bottom: addButton.topAnchor, right: view.rightAnchor, paddingTop: 26,paddingBottom: 16, paddingLeft: 16, paddingRight: 16)
        
        addButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 16, width: view.frame.width/3, height: 45)
        dayOffButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: addButton.leftAnchor, paddingBottom: 16, paddingRight: 16, width: view.frame.width/3, height: 45)
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
        
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }

}


extension SelectShift: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shifts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colectionView.dequeueReusableCell(withReuseIdentifier: ShiftTimeCell.id, for: indexPath) as! ShiftTimeCell
        cell.lableName.text = shifts[indexPath.row].name.uppercased()
        cell.shift = shifts[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        shifts[indexPath.row].selected = !shifts[indexPath.row].selected
        
        print(shifts)
        self.colectionView.reloadData()
    }
    
}
