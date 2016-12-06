//
//  OnboardSecondPageViewController.swift
//  digout
//
//  Created by Daniel Burkhardt on 10/28/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit
import AVFoundation

class OnboardViewController: UIViewController {

    ///MARK: Class variables
    let defaults = UserDefaults.standard
    let apiInfo = APIInfo()
    let request = NetworkRequests()
    //var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()

    ///MARK: Programmer defined functions
    
    
    
    ///MARK: Default class functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let filePath = Bundle.main.path(forResource: "snow", ofType: ".mp4")
        print("filepath: \(filePath)")
        
        let path = URL(fileURLWithPath: "snow.mp4")
        let videoPath = NSData(contentsOfFile: filePath!)
        
        playerView = AVPlayer(url: path)
        
        NotificationCenter.default.addObserver(self,
                                                         selector: "playerItemDidReachEnd:",
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                         object: self.playerView.currentItem) // Add observer
        
        //playerViewController.player = playerView
        
        //amend the frame of the view
        //self.playerViewController.player.frame = CGRectMake(0, 0, 200, 200)
        
        //reset the layer's frame, and re-add it to the view
        var playerLayer: AVPlayerLayer =   AVPlayerLayer(player: self.playerView)
        
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)

        
        if (defaults.object(forKey: self.apiInfo.userAuthenticationString) != nil){
            
            print("USER IS AUTHENTICATED")
            self.performSegue(withIdentifier: "navHome", sender: self)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
