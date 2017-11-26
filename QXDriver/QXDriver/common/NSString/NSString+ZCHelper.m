//
//  NSString+ZCHelper.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/13.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "NSString+ZCHelper.h"

@implementation NSString (ZCHelper)


static NSArray *configuerList(){
    static NSArray *configuerArray;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        configuerArray = @[@"A",@"B",@"C",@"D",
                           @"E",@"F",@"G",@"H",
                           @"I",@"J",@"K",@"L",
                           @"M",@"N",@"O",@"P",
                           @"Q",@"R",@"S",@"T",
                           @"U",@"V",@"W",@"X",
                           @"Y",@"Z"];
    });
    return configuerArray;
}

-(BOOL)invailadHKCerCard{
    if (self.length>8)return NO;
    
    NSMutableArray *cerletters = [NSMutableArray array];
    BOOL vailad = NO;
    NSString *searchText = self;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Z]\\d{2,6}\[A-Z-0-9]$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    vailad = result?YES:NO;
    if(vailad){
        NSArray *charLetter = configuerList();
        NSInteger vaildCer = 0;
        for (int i = 0; i <8 ; i++) {
            [cerletters addObject:[self substringWithRange:NSMakeRange(i, 1)]];
        }
        
        for (int i = 0; i < 7; i++) {
            if (i == 0) {
                NSInteger index = (NSInteger)[charLetter indexOfObject:cerletters[0]];
                vaildCer = (index+1)*(8-i);
            }
            else{
                NSInteger cer = [cerletters[i] integerValue];
                vaildCer = vaildCer+cer*(8-i);
            }
            
            
        }
        NSInteger cerCode = vaildCer%11;
        NSString  *cerCodeVailad = cerletters[7];
        if (cerCode == 1) {
            if (![cerCodeVailad isEqualToString:@"A"]) {
                vailad = NO;
            }
            else{
                vailad = YES;
            }
        }
        else{ //>1
            NSInteger codeVc = 11- cerCode;
            NSString* codeVcCode = [NSString stringWithFormat:@"%zd",codeVc];
            if (![codeVcCode isEqualToString:cerCodeVailad]) {
                vailad = NO;
            }
            else{
                vailad = YES;
            }
        }
    }
    
    
    return vailad;

}

-(BOOL)invailadatePhoneNumber{
    //正则匹配手机号码格式
    NSString *searchText = self;
    NSError *error = NULL;
    //匹配元
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[1][34578]\\d{9}$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    if (!result) {
        
        return NO;
    }
    
    return YES;
}

@end
