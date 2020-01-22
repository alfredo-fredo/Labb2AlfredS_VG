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

- (instancetype) initWithDate: (NSString *)date andTask: (NSString *)task;
 
@end

NS_ASSUME_NONNULL_END
