//
//  EVADialog.m
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import "EVADialog.h"

@implementation EVADialog

-(id) initWithServerResponse:(NSDictionary *)responseObject{
    
    if(self){
        
        self.usersDictionary = [responseObject objectForKey:@"users"];
        for (NSDictionary *dict in self.usersDictionary) {
            self.userOfDialogDictionary = dict;
            break;
        }
        self.lastMessageDictionary = [responseObject objectForKey:@"last_message"];
        self.idOfChannel = [responseObject objectForKey:@"id"];
        self.unreadMessagesCount = [responseObject objectForKey:@"unread_messages_count"];
        self.nameOfFriend = [NSString stringWithFormat:@"%@ %@", [self.userOfDialogDictionary objectForKey:@"first_name"], [self.userOfDialogDictionary objectForKey:@"last_name"]];
        //2017-05-30T12:15:42.065181Z
        NSString *lastDate = [self.lastMessageDictionary objectForKey:@"create_date"];
        
        NSString *dayDate = [lastDate substringWithRange:NSMakeRange(0, 10)];
        
        self.lastMessageTime = [lastDate substringWithRange:NSMakeRange(11, 5)];
        
        
        NSDateFormatter * dF = [[NSDateFormatter alloc] init];
        dF.dateFormat = @"yyyy-MM-dd";
        
        NSDate * dateOfMessage = [dF dateFromString: dayDate];
        NSString *messageDateString = [dF stringFromDate:dateOfMessage];

        NSDate *currentDate = [NSDate date];
        NSString *currentDateString = [dF stringFromDate:currentDate];
        
        int daysToMinus = -1;
        NSDate *yesterdayDate = [currentDate dateByAddingTimeInterval:60*60*24*daysToMinus];
        NSString *yesterdayDateString = [dF stringFromDate:yesterdayDate];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate * tempDate = [dateFormatter dateFromString: dayDate];
        [dateFormatter setDateFormat:@"dd MMMM"];
        

        if ([messageDateString isEqualToString:currentDateString]) {
            self.lastMessageDay = @"Today";
            self.lastMessageDateForChannel =  self.lastMessageTime;
        }else if ([messageDateString isEqualToString:yesterdayDateString]) {
            self.lastMessageDay = @"Yesterday";
            self.lastMessageDateForChannel = [NSString stringWithFormat:@"Yesterday, %@", self.lastMessageTime];
        }else{
            self.lastMessageDay = [dateFormatter stringFromDate:tempDate];
            [dateFormatter setDateFormat:@"dd MMM"];
            self.lastMessageDateForChannel = [NSString stringWithFormat:@"%@, %@",[dateFormatter stringFromDate:tempDate], self.lastMessageTime];
        }
        
        
    }
    
    return self;
}

@end
