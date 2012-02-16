#import "FDLocalFilesController.h"

@implementation FDLocalFilesController

@synthesize mainController = mainController;

// UITableViewDelegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	NSString *fileName = [contents objectAtIndex: indexPath.row];
	if ([fileName hasSuffix: @"/"]) {
	
		[self readDirectory: [NSString stringWithFormat: @"%@/%@", currDir, fileName]];
		
	} else {
	
		UIActionSheet *actsh = [UIActionSheet new];
		actsh.title = @"File operation";
		processedFile = [[NSString stringWithFormat: @"%@/%@", currDir, [contents objectAtIndex: indexPath.row]] retain];
		[actsh addButtonWithTitle: @"Show"];
		[actsh addButtonWithTitle: @"Upload to /Public"];
		[actsh addButtonWithTitle: @"Upload to /FullDrop"];
		[actsh addButtonWithTitle: @"Cancel"];
		actsh.delegate = self;
		[actsh showInView: self.view];
		[actsh release];
	
	}

}

- (UITableViewCellEditingStyle) tableView: (UITableView *) tableView editingStyleForRowAtIndexPath: (NSIndexPath *) indexPath {

	return UITableViewCellEditingStyleDelete;
	
}

// UITableViewDataSource

- (int) numberOfSectionsInTableView: (UITableView *) tableView {

	return 1;

}

- (int) tableView: (UITableView *) tableView numberOfRowsInSection: (int) section {

	return [contents count];

}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: 3 reuseIdentifier: @"FDLocalFileCell"];
	cell.textLabel.text = [contents objectAtIndex: indexPath.row];
		
	NSString *typeStr = [[[[contents objectAtIndex: indexPath.row] componentsSeparatedByString: @"."] lastObject] lowercaseString];
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

	UIImage *img = [UIImage imageNamed: [self itemIsDirectoryAtPath: [NSString stringWithFormat: @"%@/%@", currDir, [contents objectAtIndex: indexPath.row]]] ? @"dir.png" : [NSString stringWithFormat: @"%@.png", typeStr]];
	cell.imageView.image = img;

	return cell;

}

- (void) tableView: (UITableView *) tableView commitEditingStyle: (UITableViewCellEditingStyle) editingStyle forRowAtIndexPath: (NSIndexPath *) indexPath {

	NSString *item = [[NSString alloc] initWithFormat: @"%@/%@", currDir, [contents objectAtIndex: indexPath.row]];
	[[NSFileManager defaultManager] removeItemAtPath: item error: NULL];
	[item release];
	[contents removeObjectAtIndex: indexPath.row];
	NSArray *array = [NSArray arrayWithObject: indexPath];
	[tableView deleteRowsAtIndexPaths: array withRowAnimation: UITableViewRowAnimationRight];

}

// UIActionSheetDelegate

- (void) actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex: (NSInteger) index {

	if (index == 0) {
		[self showFile: processedFile];
	} else if (index == 1) {
		[self.mainController uploadFile: processedFile toPath: @"/Public"];
	} else if (index == 2) {
		[self.mainController uploadFile: processedFile toPath: @"/FullDrop"];
	} else {
		return;
	}
	
}

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return YES;

}

- (id) init {

	self = [super init];
	contents = [NSMutableArray new];

	[self readDirectory: @"/var/mobile/Library/FullDrop"];
	
	return self;
	
}

- (void) viewDidLoad {

	[super viewDidLoad];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(close)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Up" style: UIBarButtonItemStylePlain target: self action: @selector(loadParent)];
	self.navigationItem.leftBarButtonItem = backButton;
	[backButton release];

	fileList = [UITableView new];
	fileList.frame = CGRectMake (0, 0, 320, 480);
	fileList.delegate = self;
	fileList.dataSource = self;
	[self.view addSubview: fileList];

	fileList.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
}

// self

- (void) close {

	[self.mainController dismissModalViewControllerAnimated: YES];

}

- (void) readDirectory: (NSString *) directory {

	NSString *fileName;

	files = [[NSFileManager defaultManager] directoryContentsAtPath: directory];
	
	[contents removeAllObjects];

	for (file in files) {
	
		if ([self itemIsDirectoryAtPath: [NSString stringWithFormat: @"%@/%@", directory, file]]) {
			fileName = [NSString stringWithFormat: @"%@/", file];
		} else {
			fileName = file;
		}
	
		[contents addObject: fileName];
		
	}
	
	[fileList reloadData];
	
	currDir = [directory retain];
	self.navigationItem.title = currDir;

}

- (void) reloadCurrentDirectory {

	[self readDirectory: currDir];
	
}

- (void) showFile: (NSString *) path {

	FDFileViewerController *fvc = [FDFileViewerController new];
	fvc.mainController = self;
	fvc.fileToShow = [path retain];
	UINavigationController *fileViewer = [[UINavigationController alloc] initWithRootViewController: fvc];
	[fvc release];
	[self presentModalViewController: fileViewer animated: YES];
	
}

- (BOOL) itemIsDirectoryAtPath: (NSString *) path {

	BOOL result;
	[[NSFileManager defaultManager] fileExistsAtPath: path isDirectory: &result];
	
	return result;
	
}

- (void) loadParent {

	NSArray *components = [currDir componentsSeparatedByString: @"/"];
	NSRange parentRange = NSMakeRange (0, [components count] - 2);
	NSString *pathDir = [[components subarrayWithRange: parentRange] componentsJoinedByString: @"/"];
	if ([pathDir isEqualToString: @""]) {
		pathDir = @"/";
	}
	[self readDirectory: pathDir];

}

@end

