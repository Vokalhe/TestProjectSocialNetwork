//
//  EVAServerManager.m
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import "EVAServerManager.h"
#import "AFNetworking.h"

#import "EVADialog.h"
#import "EVAMessage.h"

@interface EVAServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *requestSessionManager;

@end

static NSInteger errorDuringNetworkRequest = 999;

@implementation EVAServerManager
- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL *url = [NSURL URLWithString:@"http://ec2-34-211-67-136.us-west-2.compute.amazonaws.com/api/chat/"];
        self.requestSessionManager = [[AFHTTPSessionManager manager] initWithBaseURL:url];
        
        
    }
    return self;
}

+(EVAServerManager*) sharedManager {
    static EVAServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EVAServerManager alloc] init];
    });
    return manager;
}

#pragma mark - GET

- (void)getAllChannels:(void(^)(NSArray *channelsArray, NSError *error))completion onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
   
    [self.requestSessionManager GET:@"channels" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *channelsDictionary = [responseObject objectForKey:@"channels"];
        NSMutableArray *objectsArray = [NSMutableArray array];
        
        for (NSDictionary *object in channelsDictionary) {
            EVADialog *dialog = [[EVADialog alloc] initWithServerResponse:object];
            [objectsArray addObject:dialog];
        }
        
        if (completion) {
            completion(objectsArray, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", [error localizedDescription]);
        if (failure) {
            failure(error, errorDuringNetworkRequest);
        }
    }];
}

-(void)getAllMessagesInChannel: (NSInteger) number completion:(void(^)(NSArray *messagesArray, NSError *error))completion onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSString *stringForRequest = [NSString stringWithFormat:@"channels/%ld/messages", (long)number];
    
    [self.requestSessionManager GET:stringForRequest parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *messagesDictionary = [responseObject objectForKey:@"messages"];
        NSMutableArray *objectsArray = [NSMutableArray array];
        
        for (NSDictionary *object in messagesDictionary) {
            EVAMessage *message = [[EVAMessage alloc] initWithServerResponse:object];
            [objectsArray addObject:message];
        }
        
        if (completion) {
            completion(objectsArray, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", [error localizedDescription]);
        if (failure) {
            failure(error, errorDuringNetworkRequest);
        }
    }];
}

@end
