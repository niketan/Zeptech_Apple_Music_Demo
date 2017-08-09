

#import "ViewController.h"
#import "ServerConnection.h"

@interface ViewController () <ConnectionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self callWSNewFeed];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)callWSNewFeed{

    [SVProgressHUD show];
    [[ServerConnection sharedConnectionWithDelegate:self] requestWithURL:REQUESTURL method:@"GET" data:nil withImages:nil withVideo:nil];
    
}

#pragma mark - Server Connection Delegate -

- (void)ConnectionDidFinishRequestURL: (NSString*)reqURL Data:(NSMutableDictionary*) dictData
{
    
    NSLog(@"%@",dictData);
    [SVProgressHUD dismiss];
}
- (void)ConnectionDidFailRequestURL: (NSString*)reqURL  Data: (NSString*)nData
{
    
    [SVProgressHUD dismiss];
}

@end
