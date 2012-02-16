#import "FDAboutController.h"

@implementation FDAboutController

@synthesize mainController = mainController;

// super

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orientation {

	return YES;

}

- (void) viewDidLoad {

	[super viewDidLoad];
	
	self.navigationItem.title = @"About FullDrop";
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(close)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];

	NSURL *url = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"about" ofType: @"html"]];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	webView = [UIWebView new];
	webView.frame = CGRectMake (0, 0, 320, 480);
	webView.scalesPageToFit = YES;
	webView.multipleTouchEnabled = YES;
	webView.userInteractionEnabled = YES;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[webView loadRequest: request];
	[self.view addSubview: webView];
	[request release];
	
}

// self

- (void) close {

	[self.mainController dismissModalViewControllerAnimated: YES];

}

@end

