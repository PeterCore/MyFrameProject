//
//  NSMutableAttributedString+ZCHelper.m
//  FamilyEdu
//
//  Created by zhangchun on 2017/6/28.
//  Copyright © 2017年 ye. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "NSMutableAttributedString+ZCHelper.h"

@implementation NSMutableAttributedString (ZCHelper)


-(NSInteger)layoutlineWithAttributedString: (CGSize) size
{
    NSString *text = [self string];
    if ([text length] < 1 ) {
        return 0;
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    CTFrameRef ctFrame;
    CGRect frameRect;
    CFRange rangeAll = CFRangeMake(0, text.length);
    
    
    // Measure how mush specec will be needed for this attributed string
    // So we can find minimun frame needed
    CFRange fitRange;
    CGSize s = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeAll, NULL, CGSizeMake(size.width, MAXFLOAT), &fitRange);
    
    frameRect = CGRectMake(0, 0, s.width, s.height);
    CGPathRef framePath = CGPathCreateWithRect(frameRect, NULL);
    ctFrame = CTFramesetterCreateFrame(framesetter, rangeAll, framePath, NULL);
    CGPathRelease(framePath);
    
    NSArray* lines = (NSArray*)CTFrameGetLines(ctFrame);
    NSUInteger lineCount = [lines count];
    return lineCount;
}



-(NSMutableAttributedString*)layoutFontWithAttributedString: (CGSize) size
                                                moreContent: (NSString*)content
                                                  limitLine: (NSInteger)limitLine
{
    
    NSString *text = [self string];
    if ([text length] < 1 || content.length < 1) {
        NSMutableAttributedString *sourceAttri =  [[NSMutableAttributedString alloc] initWithString:@""];
        return sourceAttri;
    }
    
    UIFont *font ;
    UIColor *lineColor;
    __block NSString *substr = @"";
    font = [self attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    lineColor = [self attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    CTFrameRef ctFrame;
    CGRect frameRect;
    CFRange rangeAll = CFRangeMake(0, text.length);
    
    
    // Measure how mush specec will be needed for this attributed string
    // So we can find minimun frame needed
    CFRange fitRange;
    CGSize s = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeAll, NULL, CGSizeMake(size.width, MAXFLOAT), &fitRange);
    
    frameRect = CGRectMake(0, 0, s.width, s.height);
    CGPathRef framePath = CGPathCreateWithRect(frameRect, NULL);
    ctFrame = CTFramesetterCreateFrame(framesetter, rangeAll, framePath, NULL);
    CGPathRelease(framePath);
    
    NSArray* lines = (NSArray*)CTFrameGetLines(ctFrame);
    NSUInteger lineCount = [lines count];
    
    CGPoint *lineOrigins = malloc(sizeof(CGPoint) * lineCount);
    CGRect *lineFrames = malloc(sizeof(CGRect) * lineCount);
    
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    if (limitLine >= lineCount) {
        NSMutableAttributedString *sourceAttri =  [[NSMutableAttributedString alloc] initWithString:text];
        return sourceAttri;
    }
    
    NSMutableString *mutStr = [[NSMutableString alloc]initWithCapacity:limitLine];
    for(CFIndex i = 0; i < limitLine; ++i) {
        
        
        CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        
        CFRange lineRange = CTLineGetStringRange(line);
        
        CGPoint lineOrigin = lineOrigins[i];
        CGFloat ascent, descent, leading;
        CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        BOOL useRealHeight = i < lineCount - 1;
        CGFloat neighborLineY = i > 0 ? lineOrigins[i - 1].y : (lineCount - 1 > i ? lineOrigins[i + 1].y : 0.0f);
        CGFloat lineHeight = ceil(useRealHeight ? fabs(neighborLineY - lineOrigin.y) : ascent + descent + leading);
        
        lineFrames[i].origin = lineOrigin;
        lineFrames[i].size = CGSizeMake(lineWidth, lineHeight);
        NSString *lineString = [text substringWithRange:NSMakeRange(lineRange.location, lineRange.length)];
        
        if (i == limitLine-1) {
            NSStringEnumerationOptions options = 0;
            [lineString enumerateSubstringsInRange:NSMakeRange(lineRange.length-content.length, content.length) options:options usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                substr = substring;
                
            }];
            NSString *replace = [lineString stringByReplacingOccurrencesOfString:substr withString:content];
            lineString = replace;
        }
        [mutStr appendString:lineString];
        
    }
    
    NSString *replaceStr = [mutStr copy];
    NSMutableAttributedString *sourceAttri =  [[NSMutableAttributedString alloc] initWithString:replaceStr];
    [sourceAttri addAttribute:NSForegroundColorAttributeName value:lineColor range:NSMakeRange(0, replaceStr.length-content.length)];
    [sourceAttri addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, replaceStr.length-content.length)];
    [sourceAttri addAttribute:NSForegroundColorAttributeName value:lineColor range:NSMakeRange(replaceStr.length-content.length, content.length)];
    [sourceAttri addAttribute:NSFontAttributeName value:font range:NSMakeRange(replaceStr.length-content.length, content.length)];
    [sourceAttri addAttribute:NSLinkAttributeName value:font range:NSMakeRange(replaceStr.length-content.length, content.length)];
    return sourceAttri;
    
}


@end
