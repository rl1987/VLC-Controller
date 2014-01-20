//
//  FakeConfigPresentingViewController.h
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 30/12/13.
//
//

#import <UIKit/UIKit.h>

#import "ConfigViewController.h"

@interface FakeConfigPresentingViewController : UIViewController
<ConfigViewControllerDelegate>

@property (nonatomic, strong) ConfigViewController *configViewControllerFromDelegate;

@property (nonatomic, strong) NSString *ipAddressString;
@property (nonatomic, assign) int port;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, assign) BOOL delegateMethodCalled;

@end
