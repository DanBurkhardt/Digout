//
//  AppDelegate.swift
//  Digout
//
//  Created by Daniel Burkhardt on 2/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit

var storyboard = UIStoryboard(name: "Main", bundle: nil)

var initialViewControllerRoot: AnyObject = storyboard.instantiateInitialViewController()!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let api = APIInfo()
    
    let userHasOnboardedKey = "user_has_onboarded"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //        self.window!.backgroundColor = UIColor.whiteColor()
        // Override point for customization after application launch.
        
        
        self.setupNormalRootVC(false)
        
        
        // Determine if the user has completed onboarding yet or not
        let userHasOnboardedAlready = NSUserDefaults.standardUserDefaults().boolForKey(userHasOnboardedKey);
        
        
        // If the user has already onboarded, setup the normal root view controller for the application
        // without animation like you normally would if you weren't doing any onboarding
        
        if userHasOnboardedAlready {
            //self.window!.rootViewController = self.generateOnboardingViewController()
            self.setupNormalRootVC(false);
        }
            
            // Otherwise the user hasn't onboarded yet, so set the root view controller for the application to the
            // onboarding view controller generated and returned by this method.
        else {
            self.window!.rootViewController = self.generateOnboardingViewController()
        }
        
        self.window!.makeKeyAndVisible()
        
        
        
        
        
        
        //Set the SDK mode Market vs QA for Production and Pre-Production
        #if Debug
            MQALogger.settings().mode = MQAMode.QA
        #elseif Release
            MQALogger.settings().mode = MQAMode.Market
        #endif
        
        // Set the application key
        MQALogger.startNewSessionWithApplicationKey("1g035b18aa74520487825fc124c7e4f468253d2c46g0g1g1cfc0c30")
        
        // Set MQA uncaught exception handler for crashes
        NSSetUncaughtExceptionHandler(exceptionHandlerPointer)
        
        
        
        
        // Activate FBSDK
        FBSDKAppEvents.activateApp()
        
        let accessToken = FBSDKAccessToken.currentAccessToken()
        
        if accessToken != nil {
            
            defaults.setBool(true, forKey: "isUserLoggedIn")
            
        }else{
            
            defaults.setBool(false, forKey: "isUserLoggedIn")
        }
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)


        //return true
    }
    
    
    func setupNormalRootVC(animated : Bool) {
        // Here I'm just creating a generic view controller to represent the root of my application.
        let mainVC = UIViewController()
        mainVC.title = "RootView"
        
        // If we want to animate it, animate the transition - in this case we're fading, but you can do it
        // however you want.
        if animated {
            UIView.transitionWithView(self.window!, duration: 0.5, options:.TransitionCrossDissolve, animations: { () -> Void in
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
        
        let firstPage: OnboardingContentViewController = OnboardingContentViewController(title: "one", body: "", image: UIImage(named:
            ""), buttonText: "") {}
        
        
        // Generate the second page...
        let secondPage: OnboardingContentViewController = OnboardingContentViewController(title: "two", body: "", image: UIImage(named:
            ""), buttonText: "") {}
        
        // Generate the third page, and when the user hits the button we want to handle that the onboarding
        // process has been completed.
        let thirdPage: OnboardingContentViewController = OnboardingContentViewController(title: "three", body: "", image: UIImage(named:
            ""), buttonText: "") {}
        
        let fourthPage: OnboardingContentViewController = OnboardingContentViewController(title: "four", body: "", image: UIImage(named:
            ""), buttonText: "Get Started") {
                self.handleOnboardingCompletion()
        }
        // process has been completed.
        
        let bounds: CGRect = UIScreen.mainScreen().bounds
        let ScreenSize = bounds.size.width
        let blockImages = ["mtnblock","flagblock","bsktballblock"]
        
        //TEMPORARY FUNCS GO HERE
        
        // Create the onboarding controller with the pages and return it.
        let onboardingVC: OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "iTunesArtwork"), contents: [firstPage, secondPage, thirdPage, fourthPage])
        
        return onboardingVC
    }
    
    func handleOnboardingCompletion() {
        // Now that we are done onboarding, we can set in our NSUserDefaults that we've onboarded now, so in the
        // future when we launch the application we won't see the onboarding again.
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: userHasOnboardedKey)
        
        // Setup the normal root view controller of the application, and set that we want to do it animated so that
        // the transition looks nice from onboarding to normal app.
        setupNormalRootVC(true)
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

