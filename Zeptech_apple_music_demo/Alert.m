
#import "Alert.h"


@implementation Alert

#pragma mark - To show Alert -


+(UIAlertController*)showAlertOKButtonWithMessage:(NSString *)message withActionHandler:(AlertBlock)handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:APPNAME message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault
                                                     handler:handler];
    [alertController addAction:okAction];
    
    return alertController ;
}

+(UIAlertController*)showAlertOkAndCancelButtonWithMessage:(NSString *)message withOKActionHandler:(AlertBlock)OKhandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:APPNAME message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:OKhandler];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action") style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    return alertController ;
}

+(UIAlertController*)showAlertYesAndNoButtonWithMessage:(NSString *)message withYesTitle:(NSString*)strYesTitle withNoTitle:(NSString*)strNoTitle withYesActionHandler:(AlertBlock)YEShandler andWithNOHandler:(AlertBlock)NOhandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:APPNAME message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(strYesTitle, @"Yes action") style:UIAlertActionStyleDefault handler:YEShandler];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(strNoTitle, @"No action") style:UIAlertActionStyleCancel handler:NOhandler];
    
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    
    return alertController ;
}

@end
