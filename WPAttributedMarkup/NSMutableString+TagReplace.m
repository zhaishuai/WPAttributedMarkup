//
//  NSMutableString+TagReplace.m
//  SonoRoute
//
//  Created by Nigel Grange on 07/06/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import "NSMutableString+TagReplace.h"

@implementation NSMutableString (TagReplace)

-(BOOL)replaceFirstTagItoArray:(NSMutableArray*)array
{
    NSRange openTagRange = [self rangeOfString:@"<"];
    if (openTagRange.length == 0) {
        return NO;
    }
    NSRange closeTagRange = [self rangeOfString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(openTagRange.location+openTagRange.length, self.length - (openTagRange.location+openTagRange.length))];
    if (closeTagRange.length == 0) {
        return NO;
    }
    
    NSRange range = NSMakeRange(openTagRange.location, closeTagRange.location-openTagRange.location+1);
    NSString* tag = [self substringWithRange:range];
    [self replaceCharactersInRange:range withString:@""];
    
    BOOL isEndTag = [tag rangeOfString:@"</"].length == 2;
    
    if (isEndTag) {
        // Find matching open tag
        NSString* openTag = [tag stringByReplacingOccurrencesOfString:@"</" withString:@"<"];
        NSInteger count = array.count;
        for (NSInteger i=count-1; i>=0; i--) {
            NSDictionary* dict = array[i];
            NSString* dtag = dict[@"tag"];
            NSArray *a = [dtag componentsSeparatedByString:@"#"];
            NSString *m = @"";
            if(a.count == 2){
                m = [NSString stringWithFormat:@"%@>",a[0]];
            }else{
                m = [NSString stringWithFormat:@"%@",a[0]];
            }
            int vv = 0;
            NSString *b = @"";
            if (a.count > 1) {
                b =  [[a[1] componentsSeparatedByString:@"="][1] componentsSeparatedByString:@">"][0];
                vv = [b intValue];
                
            }
            
            if ([m isEqualToString:openTag]) {
                NSNumber* loc = dict[@"loc"];
                if ([loc integerValue] < range.location) {
                    [array removeObjectAtIndex:i];
                    NSString* strippedTag = [openTag substringWithRange:NSMakeRange(1, openTag.length-2)];
                    [array addObject:@{@"loc":loc, @"tag":strippedTag,@"value":[[NSNumber alloc] initWithInt:vv] ,@"endloc":@(range.location)}];
                }
                break;
            }
        }
    } else {
        [array addObject:@{@"loc":@(range.location), @"tag":tag}];
    }
    return YES;
}

-(void)replaceAllTagsIntoArray:(NSMutableArray*)array
{
    while ([self replaceFirstTagItoArray:array]) {};
}




/*
 if (isEndTag) {
 // Find matching open tag
 NSString* openTag = [tag stringByReplacingOccurrencesOfString:@"</" withString:@"<"];
 NSInteger count = array.count;
 for (NSInteger i=count-1; i>=0; i--) {
 NSDictionary* dict = array[i];
 NSString* dtag = dict[@"tag"];
 NSArray *a = [dtag componentsSeparatedByString:@"#"];
 NSString *m = [NSString stringWithFormat:@"%@>",a[0]];
 int vv = 0;
 NSString *b;
 if (a.count > 1) {
 b =  [[a[1] componentsSeparatedByString:@"="][1] componentsSeparatedByString:@">"][0];
 vv = [b intValue];
 
 }
 
 if ([m isEqualToString:openTag]) {
 NSNumber* loc = dict[@"loc"];
 if ([loc integerValue] < range.location) {
 [array removeObjectAtIndex:i];
 NSString* strippedTag = [openTag substringWithRange:NSMakeRange(1, openTag.length-2)];
 [array addObject:@{@"loc":loc, @"tag":strippedTag,@"value":b ,@"endloc":@(range.location)}];
 }
 break;
 }
 }
 } else {
 [array addObject:@{@"loc":@(range.location), @"tag":tag}];
 }
*/

@end
