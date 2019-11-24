/*
 File: [EmergencyContactViewController.swift]
 Creators: [Jake]
 Date created: [23/11/2019]
 Date updated: [23/11/2019]
 Updater name: [Jake]
 File description: [Controls funcitonality of the Emergency Contact screen]
 */

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class EmergencyContactViewController: UIViewController {
    
    var notificationTimer = Timer()
    var notificationTimerValue = 20
    var cancelTimer = Timer()
    var cancelTimerValue = 3
    
    var shapeLayer = CAShapeLayer()
    var circelCenter = CGPoint()
    var timerPath = UIBezierPath()
    var animation = CABasicAnimation()
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        //Creates the notificationTimer to increment every 1 second.
        notificationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.notificationTimerAction), userInfo: nil, repeats: true )
        
        CountdownLabel.center = view.center
        TopLabel.frame = CGRect(x: view.frame.width/8, y: view.frame.height*0.10, width: view.frame.width*3/4, height: view.frame.height/5)
        TopLabel.numberOfLines = 0
        TopLabel.text = "An emergency notification will be sent to all your connected Caregivers once the timer below reaches 0."
        
        BottomLabel.frame = CGRect(x: view.frame.width/8, y: view.frame.height*0.65, width: view.frame.width*3/4, height: view.frame.height/5)
        BottomLabel.numberOfLines = 0
        BottomLabel.text = "Press and hold the screen to cancel."
        
        cancelButton.bounds = view.bounds
        cancelButton.center = view.center
        circelCenter = cancelButton.center
        timerPath = UIBezierPath(arcCenter: circelCenter, radius: view.bounds.width / 3, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func buttonPressedDown(_ sender: UIButton) {
        cancelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.cancelTimerAction), userInfo: nil, repeats: true )
        self.notificationTimer.invalidate()
        createCircularTimer()
    }
    @IBAction func buttonReleased(_ sender: Any) {
        shapeLayer.removeFromSuperlayer()
        self.cancelTimer.invalidate()
        notificationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.notificationTimerAction), userInfo: nil, repeats: true )
        if (cancelTimerValue == 0) {
            goToHomeScreen()
        }
        cancelTimerValue = 3
    }
    
    func createCircularTimer() {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            if (self.cancelTimerValue <= 0) {
                self.cancelTimer.invalidate()
                self.goToHomeScreen()
            }
        })
        shapeLayer.path = timerPath.cgPath
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.lineWidth = view.bounds.width / 40
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "cancelTimer")
        CATransaction.commit()
        view.layer.addSublayer(shapeLayer)
    }
    
    @IBOutlet weak var CountdownLabel: UILabel!
    @IBOutlet weak var TopLabel: UILabel!
    @IBOutlet weak var BottomLabel: UILabel!
    
    
    @objc func notificationTimerAction(){
        notificationTimerValue -= 1
        CountdownLabel.text = String(notificationTimerValue)
        if (notificationTimerValue <= 0)
        {
            notificationTimer.invalidate()
            
            //send the emerg notif
            
            Services.showAlert("DEATH", "", vc: self)
            //Services.transitionHome(self)
            goToHomeScreen()
        }
    }
    
    @objc func cancelTimerAction(){
        if (cancelTimerValue > 0) {
            cancelTimerValue -= 1
        }
    }
    func goToHomeScreen() {
        let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
}

