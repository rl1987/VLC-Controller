//
//  PlaylistTableViewController.m
//  VLC Controller
//
//  Created by rl1987 on 14/03/17.
//
//

#import "PlaylistTableViewController.h"

#import "PlayerManager.h"

@interface PlaylistTableViewController ()

@end

@implementation PlaylistTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.navigationController.viewControllers firstObject] != self) {
        [self.navigationItem setLeftBarButtonItem:nil];
    }
    
    if (!self.playlist)
    {
        [[PlayerManager defaultManager] getPlaylistWithCompletionHandler:^(Playlist *playlist, NSError *error) {
            if (!error && playlist) {
                self.playlist = playlist;
                
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playlist.children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playlist_cell" forIndexPath:indexPath];
    
    id child = self.playlist.children[indexPath.row];
    
    if ([child isKindOfClass:[Playlist class]]) {
        cell.textLabel.text = [(Playlist *)child name];
        cell.detailTextLabel.text = nil;
    } else if ([child isKindOfClass:[PlaylistEntry class]]) {
        cell.textLabel.text = [(PlaylistEntry *) child name];
        cell.detailTextLabel.text = @"TODO";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id child = self.playlist.children[indexPath.row];
    
    if ([child isKindOfClass:[Playlist class]]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        
        PlaylistTableViewController *newPTVC =
        (PlaylistTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PlaylistTableViewController"];
    
        newPTVC.playlist = child;
        
        [self.navigationController pushViewController:newPTVC animated:YES];
    }
}

- (IBAction)doneTapped
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
