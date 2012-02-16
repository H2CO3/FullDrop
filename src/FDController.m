#import "FDController.h"

@implementation FDController

// super

- (id) init {

	self = [super init];

	self.navigationItem.title = @"FullDrop";
	
	DBSession *dbSession = [[DBSession alloc] initWithConsumerKey: @"hj2rypfw83x3qll" consumerSecret: @"bcsxmhgw9u9xet2"];
	
	[DBSession setSharedSession: dbSession];
	[dbSession release];

	restClient = [[DBRestClient alloc] initWithSession: [DBSession sharedSession]];
	restClient.delegate = self;
	
	contents = [NSMutableArray new];
	
	loginController = [DBLoginController new];
	loginController.delegate = self;

	lfc = [FDLocalFilesController new];
	localFilesController = [[UINavigationController alloc] initWithRootViewController: lfc];
	lfc.mainController = self;
	
	fdpc = [FDPublicController new];
	publicController = [[UINavigationController alloc] initWithRootViewController: fdpc];
	fdpc.mainController = self;

	fdac = [FDAboutController new];
	fdac.mainController = self;
	aboutController = [[UINavigationController alloc] initWithRootViewController: fdac];
	
	sc = [FDSettingsController new];
	sc.mainController = self;
	settingsController = [[UINavigationController alloc] initWithRootViewController: sc];

	currDir = @"/";

	return self;

}

- (void) dealloc {

	[loginController release];
	[contents release];
	[fileList release];
	[restClient release];
	
	loginController = nil;
	contents = nil;
	fileList = nil;
	restClient = nil;
	
	[super dealloc];
	
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return YES;

}

- (void) viewDidLoad {

	[super viewDidLoad];

	UIBarButtonItem *root = [[UIBarButtonItem alloc] initWithTitle: @"Up" style: UIBarButtonItemStylePlain target: self action: @selector (login)];
	self.navigationItem.leftBarButtonItem = root;
	[root release];

	UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithTitle: @"More" style: UIBarButtonItemStylePlain target: self action: @selector (showMore)];
	self.navigationItem.rightBarButtonItem = more;
	[more release];

	self.view.backgroundColor = [UIColor whiteColor];
	
	fileList = [UITableView new];
	fileList.frame = CGRectMake (0, 0, 320, 480);
	fileList.delegate = self;
	fileList.dataSource = self;
	[self.view addSubview: fileList];

	fileList.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	actsh = [UIActionSheet new];
	actsh.title = @"Miscellaneous";
	actsh.delegate = self;
	[actsh addButtonWithTitle: @"Show local files"];
	[actsh addButtonWithTitle: @"Get public links"];
	[actsh addButtonWithTitle: @"About"];
	[actsh addButtonWithTitle: @"Create directory"];
	[actsh addButtonWithTitle: @"Settings"];
	[actsh addButtonWithTitle: @"Cancel"];
	
}

- (void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {

	[super willAnimateRotationToInterfaceOrientation: interfaceOrientation duration: duration];
	if (loadingView != nil) {
		[loadingView setOrientation: interfaceOrientation];
	}
	
}

// DBRestClientDelegate

- (void) restClient: (DBRestClient *) client loadedMetadata: (DBMetadata *) metadata {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO]; 

	[contents removeAllObjects];
	
	for (DBMetadata *item in metadata.contents) {
		[contents addObject: item];
	}
	
	[fileList reloadData];

	NSArray *pathComponents = [metadata.path componentsSeparatedByString: @"/"];
	if ([pathComponents count] != 1) {
		self.navigationItem.title = [pathComponents lastObject];
	} else {
		self.navigationItem.title = @"/";
	}
	if (loadingView != nil) {
		[loadingView dismissAnimated: YES];
		[loadingView release];
		loadingView = nil;
	}
	
}

- (void) restClient: (DBRestClient *) client loadMetadataFailedWithError: (NSError *) error {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	UIAlertView *av = [UIAlertView new];
	av.title = @"Error loading metadata";
	av.message = error.localizedDescription;
	[av addButtonWithTitle: @"Dismiss"];
	[av show];
	[av release];
	if (loadingView != nil) {
		[loadingView dismissAnimated: YES];
		[loadingView release];
		loadingView = nil;
	}

}

- (void) restClient: (DBRestClient *) client uploadedFile: (NSString *) destPath from: (NSString *) srcPath {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	if (loadingView != nil) {
		[loadingView dismissAnimated: YES];
		[loadingView release];
		loadingView = nil;
	}
	[self loadMetadata: currDir];

}

- (void) restClient: (DBRestClient *) client uploadFileFailedWithError: (NSError *) error {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	UIAlertView *av = [UIAlertView new];
	av.title = @"Upload failed";
	av.message = [error localizedDescription];
	[av addButtonWithTitle: @"Dismiss"];
	[av show];
	[av release];
	if (loadingView != nil) {
		[loadingView dismissAnimated: YES];
		[loadingView release];
		loadingView = nil;
	}

}

- (void) restClient: (DBRestClient *) client loadedFile: (NSString *) destPath {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	[lfc reloadCurrentDirectory];
	[self showFile: destPath];
	if (loadingView != nil) {
		[loadingView dismissAnimated: YES];
		[loadingView release];
		loadingView = nil;
	}
	
}

- (void) restClient: (DBRestClient *) client loadFileFailedWithError: (NSError *) error {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	UIAlertView *av = [UIAlertView new];
	av.title = @"Download failed";
	av.message = [error localizedDescription];
	[av addButtonWithTitle: @"Dismiss"];
	[av show];
	[av release];
	if (loadingView != nil) {
		[loadingView dismissAnimated: YES];
		[loadingView release];
		loadingView = nil;
	}

}

- (void) restClient: (DBRestClient *) client createdFolder: (DBMetadata *) folder {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	if (loadingView != nil) {
		[loadingView dismissAnimated: YES];
		[loadingView release];
		loadingView = nil;
	}
	[self loadMetadata: currDir];
	
}

- (void) restClient: (DBRestClient *) client createFolderFailedWithError: (NSError *) error {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	UIAlertView *av = [UIAlertView new];
	av.title = @"Cannot create folder";
	av.message = [error localizedDescription];
	[av addButtonWithTitle: @"Dismiss"];
	[av show];
	[av release];
	if (loadingView != nil) {
		[loadingView dismissAnimated: YES];
		[loadingView release];
		loadingView = nil;
	}

}

- (void) restClient: (DBRestClient *) client deletedPath: (NSString *) path {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	if (loadingView != nil) {
		[loadingView dismissAnimated: YES];
		[loadingView release];
		loadingView = nil;
	}

}

- (void) restClient: (DBRestClient *) client deletePathFailedWithError: (NSError *) error {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	UIAlertView *av = [UIAlertView new];
	av.title = @"Cannot delete item";
	av.message = [error localizedDescription];
	[av addButtonWithTitle: @"Dismiss"];
	[av show];
	[av release];
	if (loadingView != nil) {
		[loadingView dismissAnimated: YES];
		[loadingView release];
		loadingView = nil;
	}

}

// DBLoginControllerDelegate

- (void) loginControllerDidLogin: (DBLoginController *) controller {

	[self loadRoot];
	
}

- (void) loginControllerDidCancel: (DBLoginController *) controller {

	UIAlertView *av = [UIAlertView new];
	av.title = @"FullDrop";
	av.message = @"Please note that you will have to log in in order to use this app with your DropBox account.";
	[av addButtonWithTitle: @"Dismiss"];
	[av show];
	[av release];
	
}

// UITableViewDataSource

- (int) numberOfSectionsInTableView: (UITableView *) tableView {

	return 1;
	
}

- (int) tableView: (UITableView *) tableView numberOfRowsInSection: (int) section {

	return [contents count];
	
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"FDCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle: 3 reuseIdentifier: @"FDCell"];
	}
	cell.textLabel.text = [[[[contents objectAtIndex: indexPath.row] path] componentsSeparatedByString: @"/"] lastObject];
	NSString *typeStr = [[[[[contents objectAtIndex: indexPath.row] path] componentsSeparatedByString: @"."] lastObject] lowercaseString];
	if ([typeStr isEqualToString: @"png"]) {
		typeStr = @"image";
	} else if ([typeStr isEqualToString: @"jpg"]) {
		typeStr = @"image";
	} else if ([typeStr isEqualToString: @"gif"]) {
		typeStr = @"image";
	} else if ([typeStr isEqualToString: @"bmp"]) {
		typeStr = @"image";
	} else if ([typeStr isEqualToString: @"psd"]) {
		typeStr = @"image";
	} else if ([typeStr isEqualToString: @"svg"]) {
		typeStr = @"image";
	} else if ([typeStr isEqualToString: @"mp3"]) {
		typeStr = @"sound";
	} else if ([typeStr isEqualToString: @"wav"]) {
		typeStr = @"sound";
	} else if ([typeStr isEqualToString: @"wma"]) {
		typeStr = @"sound";
	} else if ([typeStr isEqualToString: @"mid"]) {
		typeStr = @"sound";
	} else if ([typeStr isEqualToString: @"aiff"]) {
		typeStr = @"sound";
	} else if ([typeStr isEqualToString: @"mp4"]) {
		typeStr = @"video";
	} else if ([typeStr isEqualToString: @"avi"]) {
		typeStr = @"video";
	} else if ([typeStr isEqualToString: @"flv"]) {
		typeStr = @"video";
	} else if ([typeStr isEqualToString: @"pdf"]) {
		typeStr = @"pdf";
	} else if ([typeStr isEqualToString: @"xls"]) {
		typeStr = @"xls";
	} else if ([typeStr isEqualToString: @"doc"]) {
		typeStr = @"doc";
	} else if ([typeStr isEqualToString: @"ppt"]) {
		typeStr = @"ppt";
	} else if ([typeStr isEqualToString: @"html"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"txt"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"rtf"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"css"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"js"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"c"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"cpp"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"m"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"mm"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"h"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"xml"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"plist"]) {
		typeStr = @"text";
	} else if ([typeStr isEqualToString: @"tar"]) {
		typeStr = @"package";
	} else if ([typeStr isEqualToString: @"gz"]) {
		typeStr = @"package";
	} else if ([typeStr isEqualToString: @"bz2"]) {
		typeStr = @"package";
	} else if ([typeStr isEqualToString: @"deb"]) {
		typeStr = @"package";
	} else if ([typeStr isEqualToString: @"zip"]) {
		typeStr = @"package";
	} else if ([typeStr isEqualToString: @"xar"]) {
		typeStr = @"package";
	} else {
		typeStr = @"file";
	}

	UIImage *img = [UIImage imageNamed: [[contents objectAtIndex: indexPath.row] isDirectory] ? @"dir.png" : [NSString stringWithFormat: @"%@.png", typeStr]];
	cell.imageView.image = img;
	
	if (! [[contents objectAtIndex: indexPath.row] isDirectory]) {
		cell.detailTextLabel.text = [[contents objectAtIndex: indexPath.row] humanReadableSize];
	} else {
		cell.detailTextLabel.text = nil;
	}
	
	return cell;
	
}

- (void) tableView: (UITableView *) tableView commitEditingStyle: (UITableViewCellEditingStyle) editingStyle forRowAtIndexPath: (NSIndexPath *) indexPath {

	NSString *item = [[[contents objectAtIndex: indexPath.row] path] retain];
	[self deletePath: item];
	[contents removeObjectAtIndex: indexPath.row];
	NSArray *array = [NSArray arrayWithObject: indexPath];
	[tableView deleteRowsAtIndexPaths: array withRowAnimation: UITableViewRowAnimationRight];
	[array release];

}

// UITableViewDelegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	DBMetadata *item = [[contents objectAtIndex: indexPath.row] retain];
	if ([item isDirectory]) {
		[self loadMetadata: [item path]];
	} else {
		[self downloadFile: [item path]];
	}
	[item release];

}

// UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex: (int) index {

	if (index == 0) {
		[self loadLocal];
	} else if (index == 1) {
		[self getPublicLinks];
	} else if (index == 2) {
		[self showAbout];
	} else if (index == 3) {
		[self askForDirectoryName];
	} else if (index == 4) {
		[self showSettings];
	} else {
		return;
	}
	
}

// FDInputView delegate

- (void) inputView: (FDInputView *) inputView didReceiveInput: (NSString *) input {

	NSString *separator = ([currDir isEqualToString: @"/"] ? @"" : @"/");
	NSString *newDir = [[NSString alloc] initWithFormat: @"%@%@%@", currDir, separator, input];
	[self createDirectory: newDir];
	[newDir release];
	
}

// self

- (void) login {

	if ([[DBSession sharedSession] isLinked]) {
		[self loadRoot];
	} else {
		[loginController presentFromController: self];
	}
	
}

- (void) loadLocal {

	[lfc reloadCurrentDirectory];
	[self presentModalViewController: localFilesController animated: YES];

}

- (void) showAbout {

	[self presentModalViewController: aboutController animated: YES];

}

- (void) showFile: (NSString *) path {

	FDFileViewerController *fvc = [FDFileViewerController new];
	fvc.mainController = self;
	fvc.fileToShow = [path retain];
	UINavigationController *fileViewer = [[UINavigationController alloc] initWithRootViewController: fvc];
	[fvc release];
	[self presentModalViewController: fileViewer animated: YES];
	
}

- (void) getPublicLinks {

	[self presentModalViewController: publicController animated: YES];
	
}

- (void) showMore {

	[actsh showInView: self.view];
	
}

- (void) showSettings {

	[self presentModalViewController: settingsController animated: YES];
	
}

- (void) loadRoot {

	NSString *path;
	
	NSArray *components = [currDir componentsSeparatedByString: @"/"];
	NSRange range = NSMakeRange (0, [components count] - 1);
	path = [[components subarrayWithRange: range] componentsJoinedByString: @"/"];
	
	if ([path isEqualToString: @""]) {
		path = @"/";
	}
	
	[self loadMetadata: path];

}

- (void) loadMetadata: (NSString *) path {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	if (loadingView == nil) {
		loadingView = [[DBLoadingView alloc] initWithTitle: @"Loading metadata"];
		[loadingView setOrientation: self.interfaceOrientation];
		[loadingView show];
	}

	[restClient loadMetadata: path];
	currDir = [path retain];

}

- (void) downloadFile: (NSString *) path {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	if (loadingView == nil) {
		loadingView = [[DBLoadingView alloc] initWithTitle: @"Downloading"];
		[loadingView setOrientation: self.interfaceOrientation];
		[loadingView show];
	}

	NSString *destPath = [[NSString alloc] initWithFormat: @"/var/mobile/Library/FullDrop/%@", [[path componentsSeparatedByString: @"/"] lastObject]];
	[restClient loadFile: path intoPath: destPath];
	[destPath release];
	
}

- (void) uploadFile: (NSString *) srcPath toPath: (NSString *) destPath {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	if (loadingView == nil) {
		loadingView = [[DBLoadingView alloc] initWithTitle: @"Uploading"];
		[loadingView setOrientation: self.interfaceOrientation];
		[loadingView show];
	}

	NSString *file = [[srcPath componentsSeparatedByString: @"/"] lastObject];
	[restClient uploadFile: file toPath: destPath fromPath: srcPath];

}

- (void) createDirectory: (NSString *) path {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	if (loadingView == nil) {
		loadingView = [[DBLoadingView alloc] initWithTitle: @"Creating folder"];
		[loadingView setOrientation: self.interfaceOrientation];
		[loadingView show];
	}

	[restClient createFolder: path];
	
}

- (void) askForDirectoryName {

	FDInputView *iv = [FDInputView new];
	iv.title = @"Please enter name";
	iv.delegate = self;
	[iv show];

}

- (void) deletePath: (NSString *) path {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	if (loadingView == nil) {
		loadingView = [[DBLoadingView alloc] initWithTitle: @"Deleting"];
		[loadingView setOrientation: self.interfaceOrientation];
		[loadingView show];
	}

	[restClient deletePath: path];
	
}

@end

