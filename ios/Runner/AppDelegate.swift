import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    initPlatformChannelAndCallMethod()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func initPlatformChannelAndCallMethod(){
            let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            let appChannel = FlutterMethodChannel(name: CHANNEL,
                                                  binaryMessenger: controller.binaryMessenger)
        
            appChannel.setMethodCallHandler({
                 (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                switch( call.method){
            
                case "launchLocalNotification":
                    if let arguments = call.arguments as? [String :  Any] ,
                       let title = arguments[ "title" ] as? Double,
                       let message = arguments["message"] as? String
                    {
                        
                        self.triggerNotification(id: "1", title:  title , subtitle: message)
                                       result(true)
                                   } else {
                                       result(false)
                                   }
                    
                     
                default :
                    result(FlutterMethodNotImplemented)
                }
               })
        }
    
    func triggerNotification( id : String , title : String , subtitle: String){
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = subtitle
            content.sound = .default
            content.badge = 0
            let requestTriggerRightAway = UNNotificationRequest(identifier:  id , content:  content , trigger:  nil)
            UNUserNotificationCenter.current().add( requestTriggerRightAway ){
                 error in
                guard error == nil else { print( "Notification scheduled error" ); return }
                
            }
        }
    
    
}
