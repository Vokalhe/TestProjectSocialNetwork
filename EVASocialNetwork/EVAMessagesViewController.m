//
//  EVAMessagesViewController.m
//  EVASocialNetwork
//
//  Created by Admin on 12.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import "EVAMessagesViewController.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "EVAServerManager.h"

#import "EVAMessageTableViewCell.h"

#import "EVAMessage.h"
#import "EVADialog.h"

@interface EVAMessagesViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UINavigationBar *ibNavigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ibBack;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ibBackButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ibBlockButton;
@property (strong, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) IBOutlet UITextField *ibTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTextFieldConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomImageConstrain;
@property (strong, nonatomic) NSMutableArray *arrayOfMessages;
@property (strong, nonatomic) UIRefreshControl *refresh;

@end

@implementation EVAMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayOfMessages = [NSMutableArray array];
    self.ibNavigationBar.topItem.title = [NSString stringWithFormat:@"%@", self.dialog.nameOfFriend];
    self.ibNavigationBar.barTintColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1];
    [self getAllMessagesInChannel:self.number];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.ibTableView addSubview:refreshControl];
    self.refresh = refreshControl;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self setupNotifications];
    [self.ibTextField becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup
- (void)setupNotifications {
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

#pragma mark - Handle

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
}

#pragma mark - Notifications

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat textFieldHeight = self.ibTextField.frame.size.height;
    
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    [UIView animateWithDuration:0.25f
                          delay:0.f
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.bottomImageConstrain.constant = keyboardSize.height;
                         self.bottomTextFieldConstrain.constant = keyboardSize.height;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                     }];
    
    CGPoint pointInTable = [self.ibTextField.superview convertPoint:self.ibTextField.frame.origin toView:self.ibTableView];
    CGPoint contentOffset = self.ibTableView.contentOffset;
    contentOffset.y = (pointInTable.y - textFieldHeight);
    [self.ibTableView setContentOffset:contentOffset animated:YES];

}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25f
                          delay:0.f
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.bottomImageConstrain.constant -= keyboardSize.height;
                         self.bottomTextFieldConstrain.constant -= keyboardSize.height;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                     }];
    
    //[self.ibTableView setContentOffset:CGPointZero animated:YES];
    
}

#pragma mark - API
-(void) getAllMessagesInChannel:(NSInteger) number{
    [[EVAServerManager sharedManager] getAllMessagesInChannel:number completion:^(NSArray *messagesArray, NSError *error) {
        
        if (messagesArray) {
            [self.arrayOfMessages removeAllObjects];
            messagesArray = [self sortedMessagesArray:messagesArray];
            [self.arrayOfMessages addObjectsFromArray: messagesArray];
            [self.ibTableView reloadData];
            NSIndexPath* lastCell = [NSIndexPath indexPathForRow:[self.arrayOfMessages count]-1 inSection:0];
            [self.ibTableView scrollToRowAtIndexPath:lastCell atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }

    } onFailure:^(NSError *error, NSInteger statusCode) {
        
    }];
    
}

#pragma mark - Private Methods
-(void) refreshTable{
    
    [self getAllMessagesInChannel:self.number];
    [self.refresh endRefreshing];
    
}

- (NSArray *)sortedMessagesArray:(NSArray *) arrayMessages {
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createDateString" ascending:YES];
    arrayMessages = [arrayMessages sortedArrayUsingDescriptors:@[sortDescriptor]];
    return arrayMessages;
    
}
#pragma mark - Actions

- (IBAction)actionBack:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionBlock:(UIBarButtonItem *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attention" message:@"Are you sure?"preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayOfMessages count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifierOtherCell = @"identifierOtherCell";
    
    EVAMessageTableViewCell *cell = (EVAMessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifierOtherCell];
    
    if (!cell) {
        cell = [[EVAMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierOtherCell];
    }
    cell.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    
    EVAMessage *message = [self.arrayOfMessages objectAtIndex:indexPath.row];
    
    if ([self.arrayOfMessages count] == 1 || indexPath.row == 0) {
        [cell configureCellWithMessage:message BeforeMessage:message viewController:self andArrayCount:1];
    }else{
        EVAMessage *messageBefore = [self.arrayOfMessages objectAtIndex:indexPath.row - 1];
        [cell configureCellWithMessage:message BeforeMessage:messageBefore viewController:self andArrayCount:2];
    }
    
    cell.textMessageLabel.text = message.text;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", message.lastMessageTime];
    cell.imageURLView.image = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __weak EVAMessageTableViewCell* weakCell = cell;
        
        [cell.imageURLView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.dialog.userOfDialogDictionary objectForKey:@"photo"]]]
                                 placeholderImage:nil success:^void(NSURLRequest * __nonnull request, NSHTTPURLResponse * __nonnull responce, UIImage * __nonnull image) {
                                     
                                     weakCell.imageURLView.image = image;
                                     [weakCell.imageURLView layoutSubviews];
                                     
                                 } failure:^ void(NSURLRequest * __nonnull request,
                                                  NSHTTPURLResponse * __nonnull responce,
                                                  NSError * __nonnull error) {
                                 }];
        
    });

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EVAMessage* message = [self.arrayOfMessages objectAtIndex:indexPath.row];
    if ([self.arrayOfMessages count] == 1 || indexPath.row == 0) {
        return [EVAMessageTableViewCell heightForMessage:message BeforeMessage:message viewController:self andCount:1];
    }else{
        EVAMessage *messageBefore = [self.arrayOfMessages objectAtIndex:indexPath.row - 1];
        return [EVAMessageTableViewCell heightForMessage:message BeforeMessage:messageBefore viewController:self andCount:2];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
        return NO;
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
