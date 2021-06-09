//
//  SceneDelegate.m
//  TicketLand
//
//  Created by Дима Давыдов on 15.05.2021.
//

#import "SceneDelegate.h"
#import "TabBarController.h"
#import "NotificationService.h"
#import <UserNotifications/UserNotifications.h>


@interface SceneDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    CGRect frame = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:frame];
    [self.window makeKeyAndVisible];
    
    TabBarController *mainVC = [[TabBarController alloc] init];
    
    self.window.rootViewController = mainVC;
    
    UIWindowScene *windowScene = (UIWindowScene *) scene;
    
    [self.window setWindowScene: windowScene];
    
    [[NotificationService sharedInstance] configureService];
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"received notification");
    
    if ([response.notification.request.identifier containsString:@"favorite-ticket"]) {
        TabBarController *mainVC = (TabBarController *) self.window.rootViewController;
        mainVC.selectedIndex = 2;
    }
}



- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
