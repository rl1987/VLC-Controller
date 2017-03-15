//
//  PlaylistTableViewController.h
//  VLC Controller
//
//  Created by rl1987 on 14/03/17.
//
//

#import <UIKit/UIKit.h>

#import "Playlist.h"

@interface PlaylistTableViewController : UITableViewController

@property (nonatomic, strong) Playlist *playlist;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *customBackButton;

- (IBAction)doneTapped;
- (IBAction)clearTapped;

@end
