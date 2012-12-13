//
//  Task.m
//  AFHeroTest
//
//  Created by WM on 12/12/12.
//  Copyright (c) 2012 WM. All rights reserved.
//

#import "Task.h"

@implementation Task

@dynamic text;
@dynamic completedAt;

- (BOOL)isCompleted
{
	return self.completedAt != nil;
}

- (void)setCompleted:(BOOL)completed
{
	self.completedAt = completed ? [NSDate date] : nil;
}

@end
