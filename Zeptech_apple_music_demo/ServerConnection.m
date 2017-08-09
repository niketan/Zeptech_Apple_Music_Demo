

#import "ServerConnection.h"

@interface ServerConnection ()
@end

@implementation ServerConnection
@synthesize connectionDelegate;

static ServerConnection *sharedConnection = nil;

+(ServerConnection *)sharedConnection
{
    if (!sharedConnection) {
        sharedConnection = [[ServerConnection alloc] init];
    }
    return sharedConnection;
}

+(ServerConnection *)sharedConnectionWithDelegate:(id)delegate
{
    if (!sharedConnection)
    {
        sharedConnection = [[ServerConnection alloc]init];
    }
    sharedConnection.connectionDelegate = delegate;
    return sharedConnection;
}

+(BOOL)isConnected
{
    //  return [AFNetworkReachabilityManager sharedManager].reachable;
    if ([[AFNetworkReachabilityManager sharedManager]networkReachabilityStatus]!= AFNetworkReachabilityStatusNotReachable)
        return YES;
    else
        return NO;
}

-(BOOL)isInternetAvailable
{
    if ([[AFNetworkReachabilityManager sharedManager]networkReachabilityStatus]!= AFNetworkReachabilityStatusNotReachable)
    {
        return YES;
    }
    else
    {
        [SVProgressHUD dismiss];
        UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
        UIViewController *mainController = [keyWindow rootViewController];
        [mainController presentViewController:[Alert showAlertOKButtonWithMessage:@"No Internet Connection available." withActionHandler:nil] animated:YES completion:nil];
        return NO;
    }
}

-(BOOL)connected
{
    __block BOOL reachable;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        switch (status)
        {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"No Internet Connection");
                reachable = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                reachable = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                reachable = YES;
                break;
            default:
                NSLog(@"Unkown network status");
                reachable = NO;
                break;
        }
    }];
    
    return reachable;
    
}
#pragma mark - Normal Request Method -

-(void)presentAlertController:(UIAlertController*)alertcontroller
{
    //1st way
    /*
    UINavigationController *vctemp= (UINavigationController*)[[APPDELEGATE window] rootViewController];
    [[vctemp topViewController] presentViewController:alertcontroller animated:YES completion:nil];
     */
    
    //2ND WAY
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    UIViewController *mainController = [keyWindow rootViewController];
    [mainController presentViewController:alertcontroller animated:YES completion:nil];
}

-(void)dismissAlertController:(UIAlertController *)alertcontroller{
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    UIViewController *mainController = [keyWindow rootViewController];
    [mainController dismissViewControllerAnimated:YES completion:nil];
}


-(void)requestWithURL:(NSString *)URLString method:(NSString*)method data:(NSMutableDictionary*)dataDict withImages:(NSMutableDictionary *)dictImages withVideo:(NSDictionary *)dictVideo
{
    if ([[AFNetworkReachabilityManager sharedManager]networkReachabilityStatus]!= AFNetworkReachabilityStatusNotReachable)
    {
        
        if ([method isEqualToString:@"GET"])
        {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            //    NSLog(@"URL %@ :: request %@ ",URLString, [dataDict JSONRepresentation]);
//            NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *jsonStr = [[NSString alloc] initWithData:data
//                                                      encoding:NSUTF8StringEncoding];
//            
//            NSLog(@"URL %@ :: request %@ ",URLString, jsonStr);
            
            [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionTask *operation, id responseObject)
             {
                 NSMutableDictionary *dictResp = [[NSMutableDictionary alloc]initWithDictionary:responseObject];
                 
                 if ([connectionDelegate respondsToSelector:@selector(ConnectionDidFinishRequestURL:Data:)])
                 {
                     [connectionDelegate ConnectionDidFinishRequestURL:[operation.response.URL absoluteString] Data:dictResp];
                 }
                 
             } failure:^(NSURLSessionTask *operation, NSError *error) {
                 if ([connectionDelegate respondsToSelector:@selector(ConnectionDidFailRequestURL:Data:)])
                 {
                     if ([error code] == -1009 || [error code] == -1003)
                     {
                         UIAlertController *alert =  [Alert showAlertOKButtonWithMessage:ALERT_MSG_INTERNET withActionHandler:nil];
                         [self presentAlertController:alert];
                     }
                     else if ([error code] == -1001)
                     {
                         UIAlertController *alert =  [Alert showAlertOKButtonWithMessage:@"Request timed out! Please try again." withActionHandler:nil];
                         [self presentAlertController:alert];
                    }
                     else if ([error code] == -1005)
                     {
                        UIAlertController *alert =  [Alert showAlertOKButtonWithMessage:[[error userInfo] objectForKey:@"NSLocalizedDescription"] withActionHandler:nil];
                         [self presentAlertController:alert];
                     }
                     else
                     {
                         [connectionDelegate ConnectionDidFailRequestURL:[operation.response.URL absoluteString] Data:[error localizedDescription]];
                     }
                     [SVProgressHUD dismiss];
                 }
             }];
        }
    }
    else
    {
        if ([connectionDelegate respondsToSelector:@selector(ConnectionDidFailRequestURL:Data:)])
        {
            UIAlertController *alert =  [Alert  showAlertOKButtonWithMessage:ALERT_MSG_INTERNET withActionHandler:nil];
            [self presentAlertController:alert];
            [SVProgressHUD dismiss];
        }
    }
}

#pragma mark - CHECK NULL VALUES

-(NSMutableDictionary*)getValuesWithOutNull:(NSDictionary*)yourDictionary
{
    NSMutableDictionary *replaced = [NSMutableDictionary
                                     dictionaryWithDictionary: yourDictionary];
    id nul = [NSNull null];
    NSString *blank = @"";
    
    for (NSString *key in yourDictionary)
    {
        
        const id object = [yourDictionary objectForKey: key];
        if (object == nul)
        {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]])
        {
            [replaced setObject:[self getValuesWithOutNull:object]
                         forKey:key];
        }
        else if([object isKindOfClass: [NSArray class]])
        {
            NSMutableArray *array  = [NSMutableArray
                                      arrayWithArray:object];
            for(int i = 0 ;i < array.count;i++)
            {
                // NSDictionary *dict = [array objectAtIndex:i];
                
                const id diObject = [array objectAtIndex:i];
                if([diObject isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *dictNew = [self getValuesWithOutNull:(NSDictionary *)diObject];
                    [array replaceObjectAtIndex:i withObject:dictNew];
                    [replaced setObject:array forKey:key];
                }
                else
                {
                    [replaced setObject:array forKey:key];
                }
            }
        }
    }
    return  replaced;
}


@end
