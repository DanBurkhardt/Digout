//
//  AppDelegate.swift
//  Digout
//
//  Created by Daniel Burkhardt on 2/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Onboard



var storyboard = UIStoryboard(name: "Main", bundle: nil)

var initialViewControllerRoot: AnyObject = storyboard.instantiateInitialViewController()!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let defaults = UserDefaults.standard
    
    let api = APIInfo()
    
    let userHasOnboardedKey = "user_has_onboarded"
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set status bar to the light theme
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //*********************************
        // ONBOARD COCOAPOD SETUP
        //*********************************
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //        self.window!.backgroundColor = UIColor.whiteColor()
        // Override point for customization after application launch.
        
        
        self.setupNormalRootVC(false)

        
        // Determine if the user has completed onboarding yet or not
        let userHasOnboardedAlready = UserDefaults.standard.bool(forKey: userHasOnboardedKey);
        
        
        // If the user has already onboarded, setup the normal root view controller for the application
        // without animation like you normally would if you weren't doing any onboarding
        
        if userHasOnboardedAlready {
            //self.window!.rootViewController = self.generateOnboardingViewController()
            
            setupNormalRootVC(false)
        }
            
            // Otherwise the user hasn't onboarded yet, so set the root view controller for the application to the
            // onboarding view controller generated and returned by this method.
        else {
            self.window!.rootViewController = generateOnboardingViewController()
        }
        
        self.window!.makeKeyAndVisible()
        
        
        //*********************************
        // MOBILE QUALITY ASSURANCE SETUP
        //*********************************
        
        //Set the SDK mode Market vs QA for Production and Pre-Production
        #if Debug
            MQALogger.settings().mode = MQAMode.QA
        #elseif Release
            MQALogger.settings().mode = MQAMode.Market
        #endif
        
        // Set the application key
        MQALogger.startNewSession(withApplicationKey: "1g3ae27c9e4871fcb5374f9be546ad60081746c46ag0g2g39bf0cfd")
        
        // Set MQA uncaught exception handler for crashes
        NSSetUncaughtExceptionHandler(exceptionHandlerPointer)
        
        
        
        //*********************************
        // FACEBOOK SDK SETUP
        //*********************************
        
        /*
        // Activate FBSDK
        FBSDKAppEvents.activateApp()
        
        let accessToken = FBSDKAccessToken.currentAccessToken()
        
        if accessToken != nil {
            
            defaults.set(true, forKey: "isUserLoggedIn")
            
        }else{
            
            defaults.set(false, forKey: "isUserLoggedIn")
        }
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
         */
        return true
    }
    
    
    
    // MARK: Onboard Cocoapod Setup Methods
    
    func setupNormalRootVC(_ animated : Bool) {
        // Here I'm just creating a generic view controller to represent the root of my application.
        let mainVC = UIViewController()
        mainVC.title = "RootView"
        
        // If we want to animate it, animate the transition - in this case we're fading, but you can do it
        // however you want.
        if animated {
            UIView.transition(with: self.window!, duration: 0.5, options:.transitionCrossDissolve, animations: { () -> Void in
                self.window!.rootViewController = initialViewControllerRoot as? UIViewController
                }, completion:nil)
        }
            
            // Otherwise we just want to set the root view controller normally.
        else {
            self.window?.rootViewController = initialViewControllerRoot as? UIViewController;
        }
    }
    
    
    func generateOnboardingViewController() -> OnboardingViewController {
        // Generate the first page...
        
        let firstPage: OnboardingContentViewController = OnboardingContentViewController(title: "welcome", body: "this is an onboarding sequence", image: UIImage(named:
            "shovel"), buttonText: "") {}
        
        
        // Generate the second page...
        let secondPage: OnboardingContentViewController = OnboardingContentViewController(title: "welcome", body: "to my app", image: UIImage(named:
            "snow"), buttonText: "") {}
        
        // Generate the third page, and when the user hits the button we want to handle that the onboarding
        // process has been completed.
        let thirdPage: OnboardingContentViewController = OnboardingContentViewController(title: "welcome", body: "to the future", image: UIImage(named:
            "wand"), buttonText: "Get Started") {
                self.handleOnboardingCompletion()
        }
        
        
        // process has been completed.
        
        let bounds: CGRect = UIScreen.main.bounds
        let ScreenSize = bounds.size.width
        let blockImages = ["mtnblock","flagblock","bsktballblock"]
        
        //TEMPORARY FUNCS GO HERE
        
        // Video
        let bundle = Bundle.main
        let moviePath = bundle.path(forResource: "snow", ofType: "mp4")
        let movieURL = URL(fileURLWithPath: moviePath!)
        
        let onboardingVC = OnboardingViewController(backgroundVideoURL: movieURL, contents: [firstPage, secondPage, thirdPage])
        
        onboardingVC?.shouldMaskBackground = false
        onboardingVC?.allowSkipping = true
        
        
        return onboardingVC!
    }
    
    func handleOnboardingCompletion() {
        // Now that we are done onboarding, we can set in our NSUserDefaults that we've onboarded now, so in the
        // future when we launch the application we won't see the onboarding again.
        UserDefaults.standard.set(true, forKey: userHasOnboardedKey)
        
        // Setup the normal root view controller of the application, and set that we want to do it animated so that
        // the transition looks nice from onboarding to normal app.
        setupNormalRootVC(true)
    }
    
    
    
    // MARK: Facebook SDK Setup Methods
    
        /*
    func application(_ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }*/
    
    
    
    // MARK: Default App Delegate Methods

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

