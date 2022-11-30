import UIKit
import Flutter
import WebEngage
import webengage_flutter
import AVKit
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

//    var imageView: UIImageView?

    

    


  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    

    

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    
    application.registerForRemoteNotifications()
      
      
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
    let nativeChannel = FlutterMethodChannel(name: "native_channel",
                                                   binaryMessenger: controller.binaryMessenger)
      
      
//      nativeChannel.setMethodCallHandler({
//          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//
//          guard call.method == "alternatePlay" else{
//            
//              result(FlutterMethodNotImplemented)
//              return
//          }
//
//
//          print("reached here" );
//
//            let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//            let player = AVPlayer(url: videoURL!)
//            let playerLayer = AVPlayerLayer(player: player)
//
//        })

       

    WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

//     WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
      GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
        
    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        imageView = UIImageView(frame: window!.frame)
//        imageView?.image = UIImage(named: "AppIcon")
//        window?.addSubview(imageView!)
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        if imageView != nil {
//            imageView?.removeFromSuperview()
//            imageView = nil
//        }
//    }
//
    
    
//      override func applicationWillResignActive(
//        _ application: UIApplication
//      ) {
//        self.window.isHidden = true;
//      }
//      override func applicationDidBecomeActive(
//        _ application: UIApplication
//      ) {
//        self.window.isHidden = false;
//      }
//
//    
//    
    
    

    
 


    
    

    
}
