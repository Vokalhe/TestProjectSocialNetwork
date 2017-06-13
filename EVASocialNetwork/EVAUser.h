//
//  EVAUser.h
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVAUser : NSObject

@property(strong, nonatomic) NSString *lastName;
@property(strong, nonatomic) NSString *firstName;
@property(strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSNumber *idOfUser;
@property (strong, nonatomic) NSURL *photoURL;

-(id)initWithServerResponse:(NSDictionary *)responseObject;

@end
