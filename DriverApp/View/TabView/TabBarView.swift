//
//  TabBarView.swift
//  DriverApp
//
//  Created by Indo Office4 on 27/11/20.
//

import UIKit
import FloatingTabBarController

@available(iOS 13.0, *)
class TabBarView: FloatingTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "grayKasumi")
        tabBar.tintColor = UIColor(white: 0.5, alpha: 1)
        tabBar.backgroundColor = UIColor.white
        
        let homeVc = HomeVc()
        let historyVc = HistoryViewController()
        let dayOffVc = EditCurrentDayOff()
        
        let image = UIImage(named: "homeIcon")
        let baru = image?.resizeImage(CGSize(width: 25, height: 25))
        
        let images = [baru,baru,baru]
        let vcs = [homeVc,historyVc, dayOffVc]
        let titles = ["Jobs", "History", "Day Off"]
        
        viewControllers = (0...2).map({ (i) in
            let selected = images[i]
            let normal = images[i]
            let controller = vcs[i]
            controller.title = titles[i]
            controller.floatingTabItem = FloatingTabItem(selectedImage: selected!, normalImage: normal!)
            return controller
        })
        
        
    }

}
