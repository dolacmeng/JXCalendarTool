//
//  JXCalendarTool.h
//  JXCalendarToolDemo
//
//  Created by 许伟杰 on 2019/3/10.
//  Copyright © 2019 JackXu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXCalendarTool : NSObject

@property(nonatomic,strong) EKEventStore *store;

/**
 * 单例对象
*/
+ (instancetype)shared;

/**
 添加新的事件
 @param title 事件名称
 @param startDate 事件开始时间
 */
- (NSString*)addEventWithTitle:(NSString*)title startDate:(NSDate*)startDate;

/**
 添加新的事件
 @param title 事件名称
 @param startDate 事件开始时间
 
 */
- (NSString*)addEventWithTitle:(NSString*)title startDate:(NSDate*)startDate duration:(NSInteger)durationMinute alarmBeforeMinute:(NSInteger)alarmMinute notes:(NSString*)notes url:(NSString*)url;

/**
 询问用户以获取日历权限
 
 @param block 用户点击后回调
 */
-(void)requestCalendarAuthorizationBlock:(void (^)(BOOL granted))block;


@end

NS_ASSUME_NONNULL_END
