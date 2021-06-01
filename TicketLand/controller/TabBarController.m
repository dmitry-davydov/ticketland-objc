//
//  TabBarController.m
//  TicketLand
//
//  Created by Дима Давыдов on 01.06.2021.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"

@implementation TabBarController
- (instancetype)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self setupTabBar];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    return self;
}

- (NSArray<UIViewController *> *)setupTabBar {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage systemImageNamed:@"magnifyingglass"] selectedImage:[UIImage systemImageNamed:@"magnifyingglass.circle.fill"]];
    
    UINavigationController *mainVCWithNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    [controllers addObject:mainVCWithNavigationController];
    
    
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage systemImageNamed:@"map"] selectedImage:[UIImage systemImageNamed:@"map.fill"]];
    
    UINavigationController *mapVCWithNavigationViewController = [[UINavigationController alloc] initWithRootViewController:mapVC];
    
    [controllers addObject:mapVCWithNavigationViewController];
    
    return controllers;
}
@end
