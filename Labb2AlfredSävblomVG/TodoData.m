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
    }
    
    return self;
}

@end
