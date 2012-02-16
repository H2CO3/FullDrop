#import "FDFileViewerController.h"

@implementation FDFileViewerController

@synthesize fileToShow = fileToShow;
@synthesize mainController = mainController;

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return YES;

}

- (void) viewDidLoad {

	[super viewDidLoad];
	
	webView = [UIWebView new];
	webView.frame = CGRectMake (0, 0, 320, 480);
	webView.multipleTouchEnabled = YES;
	webView.userInteractionEnabled = YES;
	webView.scalesPageToFit = YES;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView.hidden = YES;
	[self.view addSubview: webView];

	textView = [UITextView new];
	textView.frame = CGRectMake (0, 0, 320, 480);
	textView.editable = NO;
	textView.font = [UIFont fontWithName: @"courier" size: 12];
	textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	textView.hidden = YES;
	[self.view addSubview: textView];


	self.navigationItem.title = self.fileToShow;

	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector (close)];
	self.navigationItem.rightBarButtonItem = closeButton;
	[closeButton release];

	UIBarButtonItem *openButton = [[UIBarButtonItem alloc] initWithTitle: @"Open in iFile" style: UIBarButtonItemStylePlain target: self action: @selector (openInIFile)];
	self.navigationItem.leftBarButtonItem = openButton;
	[openButton release];

	NSURL *url = [NSURL fileURLWithPath: self.fileToShow];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	[webView loadRequest: request];
	[request release];
	
	NSString *textContent = [[NSString alloc] initWithContentsOfFile: self.fileToShow];
	textView.text = textContent;
	[textContent release];
	
	if ([self fileIsTextFile: self.fileToShow]) {
	
		textView.hidden = NO;
		webView.hidden = YES;
		
	} else {
	
		webView.hidden = NO;
		textView.hidden = YES;
		
	}

}

// self

- (void) close {

	[self.mainController dismissModalViewControllerAnimated: YES];

}

- (BOOL) fileIsTextFile: (NSString *) file {

	return [file hasSuffix: @".txt"] || [file hasSuffix: @".plist"] || [file hasSuffix: @".xml"] || [file hasSuffix: @".h"] || \
	       [file hasSuffix: @".c"] || [file hasSuffix: @".m"] || [file hasSuffix: @".cpp"] || [file hasSuffix: @".mm"] || [file hasSuffix: @".sh"] || [file hasSuffix: @".css"] || [file hasSuffix: @".js"];
	
}

- (void) openInIFile {

	NSString *unescapedUrlString = [[NSString alloc] initWithFormat: @"ifile://%@", self.fileToShow];
	NSString *urlString = [unescapedUrlString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
	[unescapedUrlString release];
	NSURL *url = [[NSURL alloc] initWithString: urlString];
	[[UIApplication sharedApplication] openURL: url];
	[url release];
	
}

@end

