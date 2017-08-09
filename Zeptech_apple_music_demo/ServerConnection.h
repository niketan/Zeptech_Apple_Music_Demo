

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "JSON.h"
#import "Alert.h"
#import <SVProgressHUD/SVProgressHUD.h>


@protocol ConnectionDelegate <NSObject>

- (void)ConnectionDidFinishRequestURL: (NSString*)reqURL Data:(NSMutableDictionary*) dictData;
- (void)ConnectionDidFailRequestURL: (NSString*)reqURL  Data: (NSString*)nData;

@end

@interface ServerConnection : NSObject
{
    @private
        id<ConnectionDelegate> connectionDelegate;
}
@property (nonatomic,strong) id connectionDelegate;

-(void)requestWithURL:(NSString *)URLString method:(NSString*)method data:(NSMutableDictionary*)dataDict withImages:(NSMutableDictionary *)dictImages withVideo:(NSDictionary *)dictVideo;

+ (ServerConnection*)sharedConnectionWithDelegate:(id)delegate;

+ (ServerConnection*)sharedConnection;

+ (BOOL)isConnected;

-(BOOL)isInternetAvailable;

@end
