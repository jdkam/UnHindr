/*
 File: [mainTabController.swift]
 Creators: [Jordan, Allan]
 Date created: [2/11/2019]
 Date updated: [3/11/2019]
 Updater name: [Allan]
 File description: [Controlls the tab view for switching between MyMeds screen and the meds graph]
 */

import Foundation
import UIKit

class mainTabController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
        tabFrame.size.height = 150
        tabFrame.origin.y = self.view.frame.size.height - 150
        self.tabBar.frame = tabFrame
    }
    
    
   
    }

