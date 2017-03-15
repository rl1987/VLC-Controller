//
//  PlaylistTableViewController.m
//  VLC Controller
//
//  Created by rl1987 on 14/03/17.
//
//

#import "PlaylistTableViewController.h"

#import "PlayerManager.h"

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
    
    UILabel *textLabel = [cell viewWithTag:1];
    UILabel *detailTextLabel = [cell viewWithTag:2];
    
    if ([child isKindOfClass:[Playlist class]]) {
        textLabel.text = [(Playlist *)child name];
        detailTextLabel.text = nil;
        
        [[cell viewWithTag:3] setHidden:YES];
    } else if ([child isKindOfClass:[PlaylistEntry class]]) {
        textLabel.text = [(PlaylistEntry *)child name];
        
        NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
        dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad | NSDateComponentsFormatterZeroFormattingBehaviorDropLeading;
        dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
        
        detailTextLabel.text = [dateComponentsFormatter stringFromTimeInterval:[(PlaylistEntry *)child duration]];
        
        BOOL isCurrent =  [(PlaylistEntry *)child isCurrent];
        [[cell viewWithTag:3] setHidden:!isCurrent];
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
    } else if ([child isKindOfClass:[PlaylistEntry class]]) {
        for (id c in self.playlist.children) {
            if ([c isKindOfClass:[PlaylistEntry class]]) {
                if ([(PlaylistEntry *)c isCurrent]){
                    [(PlaylistEntry *)c setIsCurrent:NO];
                    break;
                }
            }
        }
        
        [[PlayerManager defaultManager] playPlaylistEntry:child];
        
        [(PlaylistEntry *)child setIsCurrent:YES];
        
        [self.tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.playlist.children[indexPath.row] isKindOfClass:[PlaylistEntry class]];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PlaylistEntry *entryToDelete = self.playlist.children[indexPath.row];
        
        [[PlayerManager defaultManager] removePlaylistEntry:entryToDelete];
        
        NSMutableArray *mutableChildrenArray = [self.playlist.children mutableCopy];
        
        [mutableChildrenArray removeObjectAtIndex:indexPath.row];
        
        self.playlist.children = [mutableChildrenArray copy];
        
        [self.tableView reloadData];
    }
}

#pragma mark - IBActions

- (IBAction)doneTapped
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearTapped
{
    [[PlayerManager defaultManager] clearPlaylist];
    
    PlaylistTableViewController *firstPTVC = [self.navigationController.viewControllers firstObject];
    
    firstPTVC.playlist = nil;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
