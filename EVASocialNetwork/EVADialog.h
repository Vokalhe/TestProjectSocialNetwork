//
//  EVADialog.h
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVADialog : NSObject

@property (strong, nonatomic) NSDictionary *usersDictionary;
@property (strong, nonatomic) NSDictionary *userOfDialogDictionary;
@property (strong, nonatomic) NSDictionary *lastMessageDictionary;
@property (strong, nonatomic) NSNumber *idOfChannel;
@property (strong, nonatomic) NSNumber *unreadMessagesCount;

@property (strong, nonatomic) NSString *lastMessageTime;
@property (strong, nonatomic) NSString *lastMessageDay;
@property (strong, nonatomic) NSString *lastMessageDateForChannel;

@property (strong, nonatomic) NSString *nameOfFriend;

-(id)initWithServerResponse:(NSDictionary *)responseObject;

@end
