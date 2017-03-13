//
//  RemoteFilesTableViewController.m
//  VLC Controller
//
//  Created by rl1987 on 13/03/17.
//
//

#import "RemoteFilesTableViewController.h"

#import "PlayerManager.h"
#import "RemoteFile.h"

@interface RemoteFilesTableViewController ()

@property (nonatomic, strong) NSArray<RemoteFile *> *remoteFiles;

@property (nonatomic, strong) NSString *uri;

@end

@implementation RemoteFilesTableViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadFileList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.remoteFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"file_cell" forIndexPath:indexPath];
    
    // Configure the cell...
    RemoteFile *remoteFile = self.remoteFiles[indexPath.row];
    
    cell.textLabel.text = remoteFile.fileName;
    cell.imageView.image = remoteFile.isDirectory ? [UIImage imageNamed:@"Directory"] : [UIImage imageNamed:@"File"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemoteFile *remoteFile = self.remoteFiles[indexPath.row];
    
    if (remoteFile.isDirectory) {
        self.uri = remoteFile.uri;
        [self reloadFileList];
    } else {
        // TODO
    }
}

#pragma mark - Navigation


- (IBAction)doneTapped
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Private routines

- (void)reloadFileList
{
    if (self.uri)
    {
        [[PlayerManager defaultManager] listRemoteFilesAtURI:self.uri
                                       withCompletionHandler:^(NSArray<RemoteFile *> *files, NSError *error) {
                                           if (!error) {
                                               self.remoteFiles = files;
                                               [self.tableView reloadData];
                                           }
                                       }];
    }
    else
    {
        [[PlayerManager defaultManager] listRemoteFilesInDirectory:@"."
                                             withCompletionHandler:^(NSArray<RemoteFile *> *files, NSError *error) {
                                                 if (!error) {
                                                     self.remoteFiles = files;
                                                     [self.tableView reloadData];
                                                 }
                                             }];
    }
}

@end