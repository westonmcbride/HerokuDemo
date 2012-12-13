//
//  TasksVC.h
//  AFHeroTest
//
//  Created by WM on 12/12/12.
//  Copyright (c) 2012 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksVC : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSManagedObjectContext *managedObjectContext;
@property UITextField *textField;

@end
