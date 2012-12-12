//
//  AppDelegate.h
//  AFHeroTest
//
//  Created by WM on 12/12/12.
//  Copyright (c) 2012 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFHeroTestIncrementalStore.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
