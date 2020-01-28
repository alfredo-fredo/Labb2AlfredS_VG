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

typedef enum : NSUInteger {
    priority = 0,
    regular = 1,
    done = 2,
} taskStates;

- (instancetype) initWithDate: (NSString *)date andTask: (NSString *)task;
 
+ (NSDictionary*) makeDictionary :(TodoData *)todoData;

+ (TodoData*) makeTodoData :(NSDictionary *)fromDictionary;

@end

NS_ASSUME_NONNULL_END
