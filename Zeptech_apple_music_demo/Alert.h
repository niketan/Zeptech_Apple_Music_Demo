

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

typedef void (^AlertBlock)(UIAlertAction *action);

@interface Alert : NSObject

+(UIAlertController*)showAlertOKButtonWithMessage:(NSString *)message withActionHandler:(AlertBlock)handler;

+(UIAlertController*)showAlertOkAndCancelButtonWithMessage:(NSString *)message withOKActionHandler:(AlertBlock)handler;

+(UIAlertController*)showAlertYesAndNoButtonWithMessage:(NSString *)message withYesTitle:(NSString*)strYesTitle withNoTitle:(NSString*)strNoTitle withYesActionHandler:(AlertBlock)YEShandler andWithNOHandler:(AlertBlock)NOhandler;

/*
+(UIAlertAction *)alertActionCancel;
+(UIAlertAction *)alertActionOK;
*/
@end
