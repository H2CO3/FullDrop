#import "FDPublicController.h"

@implementation FDPublicController

@synthesize mainController = mainController;

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return YES;

}

- (void) viewDidLoad {

	[super viewDidLoad];
	
	self.navigationItem.title = @"Public Directory";
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(close)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];

	NSURL *url = [[NSURL alloc] initWithString: @"http://dropbox.com/"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	[url release];
	webView = [UIWebView new];
	webView.frame = CGRectMake (0, 0, 320, 480);
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView.scalesPageToFit = YES;
	webView.multipleTouchEnabled = YES;
	webView.userInteractionEnabled = YES;
	[webView loadRequest: request];
	[self.view addSubview: webView];
	[request release];
	
}

// self

- (void) close {

	[self.mainController dismissModalViewControllerAnimated: YES];

}

@end

