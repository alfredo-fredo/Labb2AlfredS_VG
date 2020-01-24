//
//  TodoData.h
//  Labb2AlfredSävblomVG
//
//  Created by Alfred on 2020-01-20.
//  Copyright © 2020 Alfred. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoData : NSObject

@property (nonatomic) NSString* date;
@property (nonatomic) NSString* task;

@property (nonatomic) int state;

// State 0 Prioritize, state 1 regular, state 2 done.

@property (nonatomic) enum taskStates{
priority,
regular,
done
};

- (instancetype) initWithDate: (NSString *)date andTask: (NSString *)task;
 
@end

NS_ASSUME_NONNULL_END
