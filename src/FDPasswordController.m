#import "FDPasswordController.h"

@implementation FDPasswordController

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return YES;

}

- (void) viewDidLoad {

	[super viewDidLoad];
	
	if ([self needsPassword]) {
		self.navigationItem.title = @"Enter password";
		tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 480) style: UITableViewStyleGrouped];
		tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		tableView.delegate = self;
		tableView.dataSource = self;
		[self.view addSubview: tableView];
		password = [UITextField new];
		password.secureTextEntry = YES;
		password.placeholder = @"your local password";
		password.frame = CGRectMake (10, 10, 290, 45);
		password.delegate = self;
		password.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[password becomeFirstResponder];

	} else {
		[self passwordAccepted];
	}
	
}

- (int) tableView: (UITableView *) tableView numberOfRowsInSection: (int) section {
	
	return 1;
	
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"FDPasswordCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: 0 reuseIdentifier: @"FDPasswordCell"];
	}
	[cell.contentView addSubview: password];

	return cell;
	
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

	[textField resignFirstResponder];
	NSString *password = (NSString *)[[[NSUserDefaults standardUserDefaults] objectForKey: @"FDPassword"] retain];
	if ([textField.text isEqualToString: password]) {
		[self passwordAccepted];
	} else {
		[self passwordRejected];
	}

	return YES;
	
}

- (BOOL) needsPassword {

	return [[NSUserDefaults standardUserDefaults] boolForKey: @"FDPasswordEnabled"];
	
}

- (void) passwordAccepted {

	fdc = [FDController new];
	fullDropController = [[UINavigationController alloc] initWithRootViewController: fdc];
	[fdc loadRoot];
	[fdc release];
	[self presentModalViewController: fullDropController animated: YES];
	
}

- (void) passwordRejected {

	UIAlertView *av = [UIAlertView new];
	av.title = @"Password rejected";
	av.message = @"The password you entered was incorrect. Please try again.";
	[av addButtonWithTitle: @"Dismiss"];
	[av show];
	[av release];
	
}

@end

