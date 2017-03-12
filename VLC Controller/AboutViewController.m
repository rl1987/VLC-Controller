//
//  AboutViewController.m
//  VLC Controller
//
//  Created by rl1987 on 12/03/17.
//
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

    self.versionLabel.text = [@"Version " stringByAppendingString:appVersion];
}

@end
