//
//  AreWeThereYetAppDelegate.h
//  AreWeThereYet
//
//  Created by Xiaoyi Cai on 13/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreWeThereYetAppDelegate : UIResponder <UIApplicationDelegate>{
    
    // define a tab bar controller
    UITabBarController *tabBarController;

}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
