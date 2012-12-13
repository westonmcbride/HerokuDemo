//
//  TasksVC.m
//  AFHeroTest
//
//  Created by WM on 12/12/12.
//  Copyright (c) 2012 WM. All rights reserved.
//

#import "TasksVC.h"

#import "Task.h"

@interface TasksVC () <NSFetchedResultsControllerDelegate>

@property NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *taskTableView;

@end

@implementation TasksVC

@synthesize taskTableView;
@synthesize managedObjectContext;
@synthesize textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"ToDo", nil);
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Task"];
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"completedAt" ascending:NO]];
	
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
	self.fetchedResultsController.delegate = self;
	[self.fetchedResultsController performFetch:nil];
	
	[self setupTableView];
	// Do any additional setup after loading the view.
}

- (void)setupTableView
{
	self.taskTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
	taskTableView.delegate = self;
	taskTableView.dataSource = self;
	[self.view addSubview:taskTableView];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[self.fetchedResultsController sections] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	[self configureCell:cell forRowAtIndexPath:indexPath];
	
	return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//	NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
//	cell.textLabel.text = [managedObject valueForKey:@"text"];
	Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = task.text;
	cell.textLabel.textColor = [task isCompleted] ? [UIColor lightGrayColor] : [UIColor blackColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
	textField.delegate = self;
	textField.placeholder = @"Type here plz";
	return textField;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.managedObjectContext performBlock:^{
		Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
		task.completed = !task.completed;
		[self.managedObjectContext save:nil];
	}];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	[taskTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[taskTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeDelete:
			[taskTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[taskTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeDelete:
			[taskTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[taskTableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			[taskTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			[taskTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[taskTableView endUpdates];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)returnedTextField
{
	NSString *text = [returnedTextField.text copy];
	returnedTextField.text = nil;
	[returnedTextField resignFirstResponder];
	
	[self.managedObjectContext performBlock:^{
		NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
		[managedObject setValue:text forKey:@"text"];
		[self.managedObjectContext save:nil];
	}];
	
	return YES;
}



@end
