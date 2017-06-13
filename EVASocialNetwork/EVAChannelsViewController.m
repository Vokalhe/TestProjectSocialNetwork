//
//  ViewController.m
//  EVASocialNetwork
//
//  Created by Admin on 06.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import "EVAChannelsViewController.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "EVAServerManager.h"

#import "EVAChooseTableViewCell.h"
#import "EVAChannelTableViewCell.h"

#import "EVADialog.h"

#import "EVAMessagesViewController.h"

#import <NSMutableArray+SWUtilityButtons.h>

@interface EVAChannelsViewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *arrayAllChannels;
@property (strong, nonatomic) NSMutableArray *arrayOfMessagesUnread;
@property (strong, nonatomic) NSMutableArray *arrayOfMessagesRead;
@property (strong, nonatomic) EVAChooseTableViewCell *chooseCell;
@property (assign, nonatomic) KindOfSwipe swipe;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) UIButton *removeButton;
@end

@implementation EVAChannelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.ibTableView addSubview:refreshControl];
    self.refresh = refreshControl;

    self.ibNavigationBar.barTintColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1];
    self.arrayAllChannels = [NSMutableArray array];
    self.arrayOfMessagesUnread = [NSMutableArray array];
    self.arrayOfMessagesRead = [NSMutableArray array];
    [self getChats];
    
    self.removeButton.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SwipeGestureRecognizer
-(void) handleSwipeRight{

    self.swipe = KindOfSwipeRight;
    [self clearArrays];
    [self.ibTableView reloadData];
    
}

-(void) handleSwipeLeft{

    self.swipe = KindOfSwipeLeft;
    [self getChats];
    
}

#pragma mark - API

-(void) getChats{
    
    [[EVAServerManager sharedManager] getAllChannels:^(NSArray *channelsArray, NSError *error) {
        
        if (channelsArray) {
            
            [self clearArrays];

            [self.arrayAllChannels addObjectsFromArray:channelsArray];
            
            for (int i = 0; i < [self.arrayAllChannels count]; i++) {
                EVADialog *dialog = [self.arrayAllChannels objectAtIndex:i];
                if ([dialog.unreadMessagesCount intValue] > 0) {
                    [self.arrayOfMessagesUnread addObject:dialog];
                }else{
                    [self.arrayOfMessagesRead addObject:dialog];
                }
            }
            self.count = [self.arrayOfMessagesUnread count];
            [self.ibTableView reloadData];

        }
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
    }];

}

#pragma mark - Private Methods 

- (NSArray *)leftButtons
{
    
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1] title:@"Remove"];
    
    return leftUtilityButtons;
    
}

-(void) refreshTable{
    
    if (self.swipe == KindOfSwipeLeft) {
        [self getChats];
    }
    [self.refresh endRefreshing];
    
}

-(void) clearArrays{
    
    self.count = [self.arrayOfMessagesUnread count];
    [self.arrayAllChannels removeAllObjects];
    [self.arrayOfMessagesUnread removeAllObjects];
    [self.arrayOfMessagesRead removeAllObjects];

}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return [self.arrayOfMessagesUnread count];
    }else{
        return [self.arrayOfMessagesRead count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifierOtherCell = @"identifierOtherCell";

    if (indexPath.section == 0) {
        
        EVAChooseTableViewCell *cell = [[EVAChooseTableViewCell alloc] initCell:self withSwipe:self.swipe andCount:self.count];
        
        self.chooseCell = cell;
        self.chooseCell.indexPathOfCell = indexPath;
        
        UISwipeGestureRecognizer* gestureR;
        gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight)];
        gestureR.direction = UISwipeGestureRecognizerDirectionRight;
        [cell addGestureRecognizer:gestureR];
        
        UISwipeGestureRecognizer* gestureL;
        gestureL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft)];
        gestureL.direction = UISwipeGestureRecognizerDirectionLeft;
        [cell addGestureRecognizer:gestureL];
        
        return cell;
        
    }else if (indexPath.section == 1){
        EVAChannelTableViewCell *cell = (EVAChannelTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifierOtherCell];
        
        if (!cell) {
            cell = [[EVAChannelTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierOtherCell];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.delegate = self;
        [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:102.0];

        EVADialog *dialog = [self.arrayOfMessagesUnread objectAtIndex:indexPath.row];
        
        [cell configureCellWithDialog:dialog viewController:self];

        cell.textMessageLabel.text = [NSString stringWithFormat:@"%@", [dialog.lastMessageDictionary objectForKey:@"text"]];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@", dialog.lastMessageDateForChannel];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [dialog.userOfDialogDictionary objectForKey:@"first_name"], [dialog.userOfDialogDictionary objectForKey:@"last_name"]];
        cell.countOfUnreadMessagesLabel.text = [NSString stringWithFormat:@"%@", dialog.unreadMessagesCount];
        cell.imageURLView.image = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __weak EVAChannelTableViewCell* weakCell = cell;
            
            [cell.imageURLView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dialog.userOfDialogDictionary objectForKey:@"photo"]]]
                                     placeholderImage:nil success:^void(NSURLRequest * __nonnull request, NSHTTPURLResponse * __nonnull responce, UIImage * __nonnull image) {
                                         
                                         weakCell.imageURLView.image = image;
                                         [weakCell.imageURLView layoutSubviews];
                                         
                                     } failure:^ void(NSURLRequest * __nonnull request,
                                                      NSHTTPURLResponse * __nonnull responce,
                                                      NSError * __nonnull error) {
                                     }];
            
        });
        
        cell.countOfUnreadMessagesLabel.text = [NSString stringWithFormat:@"%@", dialog.unreadMessagesCount];
        
        if (indexPath.row == [self.arrayOfMessagesUnread count]-1) {
            [cell createSeparator:self];
        }
        
        return cell;
        
    }else if (indexPath.section == 2){
        
        EVAChannelTableViewCell *cell = (EVAChannelTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifierOtherCell];
        
        if (!cell) {
            cell = [[EVAChannelTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierOtherCell];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.delegate = self;
        [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:102.0];
        
        EVADialog *dialog = [self.arrayOfMessagesRead objectAtIndex:indexPath.row];
        
        [cell configureCellWithDialog:dialog viewController:self];
        
        cell.textMessageLabel.text = [NSString stringWithFormat:@"%@", [dialog.lastMessageDictionary objectForKey:@"text"]];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@", dialog.lastMessageDateForChannel];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [dialog.userOfDialogDictionary objectForKey:@"first_name"], [dialog.userOfDialogDictionary objectForKey:@"last_name"]];
        cell.countOfUnreadMessagesLabel.text = [NSString stringWithFormat:@"%@", dialog.unreadMessagesCount];
        cell.imageURLView.image = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __weak EVAChannelTableViewCell* weakCell = cell;
            
            [cell.imageURLView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dialog.userOfDialogDictionary objectForKey:@"photo"]]]
                                     placeholderImage:nil success:^void(NSURLRequest * __nonnull request, NSHTTPURLResponse * __nonnull responce, UIImage * __nonnull image) {
                                         
                                         weakCell.imageURLView.image = image;
                                         [weakCell.imageURLView layoutSubviews];
                                         
                                     } failure:^ void(NSURLRequest * __nonnull request,
                                                      NSHTTPURLResponse * __nonnull responce,
                                                      NSError * __nonnull error) {
                                     }];
            
        });
        
        cell.countOfUnreadMessagesLabel.text = [NSString stringWithFormat:@"%@", dialog.unreadMessagesCount];
        return cell;
        
    }
    

    return nil;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 65.f;
    }else if (indexPath.section == 1){
        if (indexPath.row == [self.arrayOfMessagesUnread count]-1){
            return 81.f;
        }
    }
    
    return 70.f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EVADialog *dialog;
    NSInteger number = 0;
    if (indexPath.section == 1) {
        
        dialog = [self.arrayOfMessagesUnread objectAtIndex:indexPath.row];
        number = indexPath.row;
        
    }else if (indexPath.section == 2){
        
        dialog = [self.arrayOfMessagesRead objectAtIndex:indexPath.row];
        number = [self.arrayOfMessagesUnread count] + indexPath.row;
    }
    
    EVAMessagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EVAMessagesViewController"];
    vc.dialog = dialog;
    vc.number = number;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - UIViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - SWTableViewCellDelegate

- (BOOL)swipeableTableViewCell:(SWTableViewCell*)cell canSwipeToState:(SWCellState)state{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell*)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
    
    if (index == 0) {
        
        NSIndexPath *cellIndexPath = [self.ibTableView indexPathForCell:cell];
        
        if (cellIndexPath.section == 1) {
            [self.arrayOfMessagesUnread removeObjectAtIndex:cellIndexPath.row];
        }else if (cellIndexPath.section == 2){
            [self.arrayOfMessagesRead removeObjectAtIndex:cellIndexPath.row];
        }
        self.count = [self.arrayOfMessagesUnread count];
        [self.ibTableView reloadData];

    }

}
@end
