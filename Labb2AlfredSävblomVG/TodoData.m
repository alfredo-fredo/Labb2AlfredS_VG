//
//  TodoData.m
//  Labb2AlfredSävblomVG
//
//  Created by Alfred on 2020-01-20.
//  Copyright © 2020 Alfred. All rights reserved.
//

#import "TodoData.h"

@implementation TodoData

- (instancetype) initWithDate:(NSString *)date andTask:(NSString *)task{
    self = [super init];
    
    if(self){
        self.date = date;
        self.task = task;
        self.state = regular;
    }
    
    return self;
}

+ (NSDictionary*) makeDictionary :(TodoData *)todoData{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSLog(@"%@ %@", todoData.date, todoData.task);
    [dictionary setObject:todoData.date forKey: @"date"];
    [dictionary setObject:todoData.task forKey: @"task"];
    [dictionary setObject:[NSNumber numberWithInt:todoData.state] forKey: @"state"];

    return dictionary;
}

+ (TodoData*) makeTodoData :(NSDictionary *)fromDictionary{
    TodoData *todoData = [[TodoData alloc] init];
    
    todoData.date = [fromDictionary objectForKey:@"date"];
    todoData.task = [fromDictionary objectForKey:@"task"];
    todoData.state = [[fromDictionary objectForKey:@"state"] intValue];
    
    return todoData;
}

@end
