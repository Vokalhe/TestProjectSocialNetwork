//
//  EVAMessage.h
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVAMessage : NSObject

@property (strong, nonatomic) NSString *createDateString;
@property (strong, nonatomic) NSDictionary *senderDictionary;
@property (assign, nonatomic) BOOL isRead;
@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) NSString *lastMessageTime;
@property (strong, nonatomic) NSString *lastMessageDay;
@property (assign, nonatomic) BOOL isMyMessage;

-(id)initWithServerResponse:(NSDictionary *)responseObject;

@end
