/*
 File: [EmergencyContactViewController.swift]
 Creators: [Jake]
 Date created: [23/11/2019]
 Date updated: [24/11/2019]
 Updater name: [Jake]
 File description: [Controls functionality of the Emergency Contact screen]
 */

import Foundation
import UIKit

///Class to control the Emergency Notification view
///When the view is entered, start a timer that decrements every second and, upon reaching zero, sends a notification to all connected Caregivers. Holding down the screen for a sufficient amount of time, indicated by a circular bar buffer that fills as the screen is held, will cancel the notification and send the User back to the Home Screen
class EmergencyContactViewController: UIViewController {
    
    var notificationTimer = Timer()
    var notificationTimerValue = 20
    var cancelTimer = Timer()
    var cancelTimerValue = 3
    
    var shapeLayer = CAShapeLayer()
    var circleCenter = CGPoint()
    var timerPath = UIBezierPath()
    var animation = CABasicAnimation()
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        //Creates the notificationTimer to increment every 1 second.
        notificationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.notificationTimerAction), userInfo: nil, repeats: true )
        
        //Put the countdown timer in the centre of the screen
        CountdownLabel.center = view.center
        
        //Set the upper text label
        TopLabel.frame = CGRect(x: view.frame.width/8, y: view.frame.height*0.10, width: view.frame.width*3/4, height: view.frame.height/5)
        TopLabel.numberOfLines = 0
        TopLabel.text = "An emergency notification will be sent to all your connected Caregivers once the timer below reaches 0."
        
        //Set the lower text label
        BottomLabel.frame = CGRect(x: view.frame.width/8, y: view.frame.height*0.65, width: view.frame.width*3/4, height: view.frame.height/5)
        BottomLabel.numberOfLines = 0
        BottomLabel.text = "Press and hold the screen to cancel."
        
        //Set the cancel button to encompass the entire screen
        cancelButton.bounds = view.bounds
        cancelButton.center = view.center
        
        //Define the postion and path of the circular timer buffer
        circleCenter = cancelButton.center
        timerPath = UIBezierPath(arcCenter: circleCenter, radius: view.bounds.width / 3, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
    }
    
    // MARK: - Methods (and outlet) for controlling pressing and holding of the screen
    // buttonPressedDown and buttonReleased are used together to check that the user has pressed and held the screen for a sufficient amount of time to cancel the notification
    
    //Outlet for button that encompasses entire screen, used to cancel the notification.
    @IBOutlet weak var cancelButton: UIButton!
    
    // Function to execute when the screen is pressed
    // Input:
    //      1. The screen (cancel button) is pressed down
    // Output:
    //      1. cancelTimer is started, meant to count for the same amount of time that the ciruclar buffer fills and the screen needs to be held
    //      2. Stop notificationTimer, stopping the countdown unitl notification send.
    //      3. Circular buffer is created
    @IBAction func buttonPressedDown(_ sender: UIButton) {
        cancelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.cancelTimerAction), userInfo: nil, repeats: true )
        self.notificationTimer.invalidate()
        createCircularTimer()
    }
    
    // Function to execute when the screen is unpressed
    // Input:
    //      1. The screen (cancel button) is released
    // Output:
    //      1. Remove the circular buffer timer
    //      2. Resume the countdown to send the notification.
    //      3. Resets cancelTimerValue back to initial value
    //      4. If cancelTimerValue has reached 0, indicating the user has held the screen for a sufficient amount of time, transition back to Home Screen without sending the notification
    @IBAction func buttonReleased(_ sender: Any) {
        shapeLayer.removeFromSuperlayer()
        self.cancelTimer.invalidate()
        notificationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.notificationTimerAction), userInfo: nil, repeats: true )
        if (cancelTimerValue == 0) {
            Services.transitionHome(self)
        }
        cancelTimerValue = 3
    }
    
    // MARK: - Method for controlling circular buffer indicating time spent pressing the screen
    
    // Function to create the circular ring that fills as the screen is pressed and held.
    // Input:
    //      1. None
    // Output:
    //      1. If notificationTimer value > 0, decrement it and display it to the screen
    //      2. If cancelTimerValue > 0, create the circular buffer ring that fills and add it onto the screen.
    func createCircularTimer() {
        CATransaction.begin()
        //Code to execute once the animation of the buffer filling ends. If the timer is <= 0, then transition to the Home Screen without sending the notification
        CATransaction.setCompletionBlock({
            if (self.cancelTimerValue <= 0) {
                self.cancelTimer.invalidate()
                Services.transitionHome(self)
            }
        })
        
        //Create the circular ring
        shapeLayer.path = timerPath.cgPath
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.lineWidth = view.bounds.width / 40
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        //Create the animation to fill the ring
        animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "cancelTimer")
        CATransaction.commit()
        view.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Outlets for the text on the screen, including the countdown timer
    
    @IBOutlet weak var CountdownLabel: UILabel!
    @IBOutlet weak var TopLabel: UILabel!
    @IBOutlet weak var BottomLabel: UILabel!
    
    //MARK: - Methods for controlling code to execute when each timer increments
    
    // Function to execute every time notificationTimer increments
    // Input:
    //      1. None
    // Output:
    //      1. If notificationTimer value > 0, decrement it and display it to the screen
    //      2. If notificationTimer value <= 0, cancel the timer, send an alert to the screen, then transition back to the Home Screen.
    @objc func notificationTimerAction(){
        notificationTimerValue -= 1
        CountdownLabel.text = String(notificationTimerValue)
        if (notificationTimerValue <= 0)
        {
            notificationTimer.invalidate()
 
            let alert = UIAlertController(title: "The Emergency Notification has been sent.", message: "", preferredStyle: .alert)
 
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                alert.dismiss(animated: true, completion: nil)
                Services.transitionHome(self)
            }
        }
    }
    
    // Function to execute every time cancelTimer increments
    // Input:
    //      1. None
    // Output:
    //      1. If cancelTimerAction > 0, decrement it.
    @objc func cancelTimerAction(){
        if (cancelTimerValue > 0) {
            cancelTimerValue -= 1
        }
    }
}

