//
//  WPAttributedStyleAction.h
//  WPAttributedMarkupDemo
//
//  Created by Nigel Grange on 20/10/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPAttributedStyleAction : NSObject

@property (readwrite, copy) void (^action) ();

- (instancetype)initWithAction:(void (^)(int v))action;
+(NSArray*)styledActionWithAction:(void (^)(int v))action;
-(NSArray*)styledAction;


@end
