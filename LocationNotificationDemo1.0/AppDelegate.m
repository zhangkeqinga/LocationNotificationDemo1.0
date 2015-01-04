//
//  AppDelegate.m
//  LocationNotificationDemo1.0
//
//  Created by Dong on 15-1-4.
//  Copyright (c) 2015年 jhony. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self addLocationNotification8];
    
    return YES;
}

- (void)addLocationNotification7{// 创建一个本地推送
    //IOS7 之前的通知能够使用
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:10];//10秒后通知
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        notification.alertBody=@"通知内容";//提示信息 弹出提示框
        notification.alertAction = @"打开";  //提示框按钮
        //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        // NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        //notification.userInfo = infoDict; //添加额外的信息
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


- (void)addLocationNotification8{// 创建一个本地推送
    
    //1.创建消息上面要添加的动作(按钮的形式显示出来)
    UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
    action.identifier = @"action";//按钮的标示
    action.title=@"确定";//按钮的标题
    action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    //    action.authenticationRequired = YES;
    //    action.destructive = YES;
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];//第二按钮
    action2.identifier = @"action2";
    action2.title=@"取消";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action.authenticationRequired = YES;
    //需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action.destructive = YES;
    
    //2.创建动作(按钮)的类别集合
    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
    categorys.identifier = @"alert";//这组动作的唯一标示
    [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
    
    //3.创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
    
    //4.注册推送
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    
    
    //5.发起本地推送消息
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:15];
    notification.timeZone=[NSTimeZone defaultTimeZone];
    notification.alertBody=@"测试推送的快捷回复";
    notification.category = @"alert";
    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
    
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];//直接触发本地通知
    //用这两个方法判断是否注册成功
    // NSLog(@"currentUserNotificationSettings = %@",[[UIApplication sharedApplication] currentUserNotificationSettings]);
    //[[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    
   
}




//本地推送通知
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //成功注册registerUserNotificationSettings:后，回调的方法
    NSLog(@"%@",notificationSettings);
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //点击提示框的打开
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"ddddd" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

    application.applicationIconBadgeNumber = 0;
    NSLog(@"%@",notification);

}
//在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
//    NSLog(@"%@----%@",identifier,notification);
    
    if([@"action" isEqualToString:identifier]){
        
        NSLog(@"%@----%@",identifier,notification);

    }
    if([@"action2" isEqualToString:identifier]){
        
        NSLog(@"%@----%@",identifier,notification);
        
    }
    
    completionHandler();//处理完消息，最后一定要调用这个代码块
}


//远程推送通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //向APNS注册成功，收到返回的deviceToken
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //向APNS注册失败，返回错误信息error
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //收到远程推送通知消息
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //当程序还在后天运行
    application.applicationIconBadgeNumber = 0;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
