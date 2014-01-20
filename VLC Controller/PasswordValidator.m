//
//  PasswordValidator.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 20/01/14.
//
//

#import "PasswordValidator.h"

@implementation PasswordValidator

- (BOOL)validate:(UITextField *)textField
{
    if ([textField.text length] > 0)
        return YES;
    
    return NO;
}

@end
