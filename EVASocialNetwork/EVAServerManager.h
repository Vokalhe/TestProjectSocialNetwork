//
//  EVAServerManager.h
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVAServerManager : NSObject

+(EVAServerManager*) sharedManager;
- (void)getAllChannels:(void(^)(NSArray *channelsArray, NSError *error))completion onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;
-(void)getAllMessagesInChannel: (NSInteger) number completion:(void(^)(NSArray *messagesArray, NSError *error))completion onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
