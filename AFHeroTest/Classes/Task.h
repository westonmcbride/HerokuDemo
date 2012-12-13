//
//  Task.h
//  AFHeroTest
//
//  Created by WM on 12/12/12.
//  Copyright (c) 2012 WM. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Task : NSManagedObject

@property NSString *text;
@property NSDate *completedAt;

@property (nonatomic, getter = isCompleted) BOOL completed;

@end
