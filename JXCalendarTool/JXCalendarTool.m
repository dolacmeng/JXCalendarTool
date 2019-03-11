//
//  JXCalendarTool.m
//  JXCalendarToolDemo
//
//  Created by 许伟杰 on 2019/3/10.
//  Copyright © 2019 JackXu. All rights reserved.
//

#import "JXCalendarTool.h"
#import <EventKit/EventKit.h>

@implementation JXCalendarTool

static JXCalendarTool *tool;
+ (instancetype)shared{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        tool = [[self alloc] init];
        tool.store = [[EKEventStore alloc] init];
    });
    return tool;
}

- (NSString*)addEventWithTitle:(NSString*)title startDate:(NSDate*)startDate{
    return [self addEventWithTitle:title startDate:startDate duration:0 alarmBeforeMinute:-1 notes:@"" url:@""];
}

- (NSString*)addEventWithTitle:(NSString*)title startDate:(NSDate*)startDate duration:(NSInteger)durationMinute alarmBeforeMinute:(NSInteger)alarmMinute notes:(NSString*)notes url:(NSString*)url{
    
    if (![JXCalendarTool getCalendarAuthorizationState]) {
        NSLog(@"没有日历权限");
        return nil;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.minute = durationMinute;
    NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
    
    EKEvent *event = [EKEvent eventWithEventStore:_store];
    event.calendar = [_store defaultCalendarForNewEvents];
    event.title = title;
    event.startDate = startDate;
    event.endDate = endDate;
    event.notes = notes;
    
    if (alarmMinute > 0) {
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:alarmMinute * -60.0f]];
    }

    NSError *error;
    [_store saveEvent:event span:EKSpanFutureEvents commit:YES  error:&error];
    if (!error) {
        NSLog(@"添加日程成功！");
        return event.eventIdentifier;
    }else{
        NSLog(@"添加日程失败：%@",error);
        return nil;
    }
}

-(void)requestCalendarAuthorizationBlock:(void (^)(BOOL granted))block {
    [_store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if(!granted){
            NSLog(@"用户拒绝了日历访问权限");
        }
        block(granted);
    }];
}

+(BOOL)getCalendarAuthorizationState{
    EKAuthorizationStatus EKstatus = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (EKstatus) {
        case EKAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            return YES;
            break;
        case EKAuthorizationStatusDenied:
            NSLog(@"Denied'");
            break;
        case EKAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case EKAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    return NO;
}

@end
