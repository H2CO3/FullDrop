#import "FDSettingsController.h"

@implementation FDSettingsController

@synthesize mainController = mainController;

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return YES;
	
}

- (void) viewDidLoad {

	[super viewDidLoad];
	
	UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStylePlain target: self action: @selector (close)];
	self.navigationItem.leftBarButtonItem = cancel;
	[cancel release];

	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector (done)];
	self.navigationItem.rightBarButtonItem = done;
	[done release];

	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = @"Settings";
	
	passwordEnabled = [UISwitch new];
	passwordEnabled.frame = CGRectMake (200, 10, 195, 45);
	passwordEnabled.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	passwordEnabled.on = [[NSUserDefaults standardUserDefaults] boolForKey: @"FDPasswordEnabled"];
	password = [UITextField new];
	password.frame = CGRectMake (10, 10, 280, 45);
	password.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	password.secureTextEntry = YES;
	password.placeholder = @"New password";
	password.text = (NSString *)[[[NSUserDefaults standardUserDefaults] objectForKey: @"FDPassword"] retain];
	password.delegate = self;
	[password becomeFirstResponder];
	tableView = [[UITableView alloc] initWithFrame: CGRectMake (0, 0, 320, 480) style: UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: tableView];
	
}

- (int) tableView: (UITableView *) theTableView numberOfRowsInSection: (int) section {

	return 3;
	
}


- (UITableViewCell *) tableView: (UITableView *) theTableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"FDSettingsCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: 3 reuseIdentifier: @"FDSettingsCell"];
	}
	
	if (indexPath.row == 0) {
	
		cell.textLabel.text = @"Enable password";
		[cell.contentView addSubview: passwordEnabled];
		
	} else if (indexPath.row == 1) {
	
		[cell.contentView addSubview: password];
		
	} else {

		cell.textLabel.text = @"Logout and exit";

	}
	
	return cell;
	
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	if (indexPath.row == 2) {

		[[DBSession sharedSession] unlink];
		[[NSUserDefaults standardUserDefaults] synchronize];
		exit (0);

	}

}

- (BOOL) textFieldShouldReturn: (UITextField *) textField {

	[textField resignFirstResponder];
	
	return YES;
	
}

- (void) done {

	[[NSUserDefaults standardUserDefaults] setBool: passwordEnabled.on forKey: @"FDPasswordEnabled"];
	[[NSUserDefaults standardUserDefaults] setObject: password.text forKey: @"FDPassword"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self close];
	
}

- (void) close {

	[self.mainController dismissModalViewControllerAnimated: YES];
	
}

@end

