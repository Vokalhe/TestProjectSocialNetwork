//
//  EVAMessage.m
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import "EVAMessage.h"

@implementation EVAMessage

-(id) initWithServerResponse:(NSDictionary *)responseObject{
    
    if(self){
        
        self.createDateString = [responseObject objectForKey:@"create_date"];
        self.senderDictionary = [responseObject objectForKey:@"sender"];
        self.isRead = [[responseObject objectForKey:@"is_read"] boolValue];
        self.text = [responseObject objectForKey:@"text"];
        
        NSNumber *idSender = [self.senderDictionary objectForKey:@"id"];
        if ([idSender intValue] == 1947) {
            self.isMyMessage = YES;
        }else{
            self.isMyMessage = NO;
        }
        //2017-05-30T12:15:42.065181Z
        NSString *lastDate = self.createDateString;
        
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
        }else if ([messageDateString isEqualToString:yesterdayDateString]) {
            self.lastMessageDay = @"Yesterday";
        }else{
            self.lastMessageDay = [dateFormatter stringFromDate:tempDate];
        }

    }
    
    return self;
}


@end
