#import <CoreFoundation/CoreFoundation.h>
#import <objc/runtime.h>
#import "EVOBLEAdapter.h"

#import "EVOBLE.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.viewController = [[MainViewController alloc] init];
    return YES; // [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

//- (void)createGapView
//{
////    CGRect webViewBounds = self.view.bounds;
////
////    webViewBounds.origin = self.view.bounds.origin;
////
////    UIView* view = [self newCordovaViewWithFrame:webViewBounds];
////
////    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
////    [self.view addSubview:view];
////    [self.view sendSubviewToBack:view];
//}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.

    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/* Comment out the block below to over-ride */

/*
 - (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
 {
 return[super newCordovaViewWithFrame:bounds];
 }

 - (NSUInteger)supportedInterfaceOrientations
 {
 return [super supportedInterfaceOrientations];
 }

 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
 }

 - (BOOL)shouldAutorotate
 {
 return [super shouldAutorotate];
 }
 */

@end

@implementation MainCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
 in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation MainCommandQueue

/* To override, uncomment the line in the init function(s)
 in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end

@implementation EVOBLEAdapter

- (id) init
{
    self = [super init];
    if (self) {
    }

    AppDelegate* appDelegate = [AppDelegate alloc];
    [appDelegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil];

    self.evoble = [EVOBLE alloc];
    [appDelegate.viewController registerPlugin:self.evoble withClassName:@"EVOBLE"];

    return self;
}

- (int) powerStatus
{
    return [self.evoble powerStatus];
}

- (void) startScan: (NSArray*) command
      onScanResult: (void (^)(NSString* arg)) successCallback
           onError: (void (^)(NSString* arg)) errorCallback
{
    NSLog(@"Callback ID: %@", (NSString*) command[0]);
    successCallback(@"Testing");
}

@end
