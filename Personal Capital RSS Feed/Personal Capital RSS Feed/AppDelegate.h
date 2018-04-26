//
//  AppDelegate.h
//  Personal Capital RSS Feed
//
//  Created by Archit Mendiratta on 4/21/18.
//  Copyright © 2018 Archit Mendiratta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property(nonatomic, retain) UINavigationController *navController;

- (void)saveContext;


@end

