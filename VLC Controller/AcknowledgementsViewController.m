//
//  AcknowledgementsViewController.m
//  VLC Controller
//
//  Created by rl1987 on 13/03/17.
//
//

#import "AcknowledgementsViewController.h"

#import <MMMarkdown/MMMarkdown.h>

@interface AcknowledgementsViewController ()

@end

@implementation AcknowledgementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pods-VLC Controller-acknowledgements"
                                                         ofType:@"markdown"];

    NSString *markdown = [NSString stringWithContentsOfFile:filePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL];
    
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:markdown
                                                   extensions:MMMarkdownExtensionsNone
                                                        error:NULL];
    
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"https://cococapods.com"]];

}

@end
