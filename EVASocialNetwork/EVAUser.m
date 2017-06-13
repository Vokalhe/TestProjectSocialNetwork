//
//  EVAUser.m
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import "EVAUser.h"

@implementation EVAUser

-(id) initWithServerResponse:(NSDictionary *)responseObject{
    
    if(self){
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.username = [responseObject objectForKey:@"username"];
        self.idOfUser = [responseObject objectForKey:@"id"];
        
        NSString *photoString = [responseObject objectForKey:@"photo"];
        self.photoURL = [NSURL URLWithString:photoString];
        
    }
    
    return self;
}


@end
