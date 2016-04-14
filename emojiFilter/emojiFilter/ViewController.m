//
//  ViewController.m
//  emojiFilter
//
//  Created by 廖祖德 on 16/4/14.
//  Copyright © 2016年 QingHong. All rights reserved.
//

#import "ViewController.h"
#import "RoundedButton.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *needTrans;
@property (weak, nonatomic) IBOutlet UITextView *transformedTextV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"示例";
}

- (IBAction)filterEmojiExpressions:(RoundedButton *)sender {
    if (self.needTrans.text && self.needTrans.text.length > 0) {
        NSMutableString *originText = [NSMutableString stringWithString:self.needTrans.text];
        [originText enumerateSubstringsInRange:NSMakeRange(0, originText.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
            const unichar hs = [substring characterAtIndex:0];
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        [originText deleteCharactersInRange:substringRange];
                    }
                }
            } else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    [originText deleteCharactersInRange:substringRange];
                }
            } else {
                if (0x2100 <= hs && hs <= 0x27ff) {
                    [originText deleteCharactersInRange:substringRange];
                } else if (0x2B05 <= hs && hs <= 0x2b07) {
                    [originText deleteCharactersInRange:substringRange];
                } else if (0x2934 <= hs && hs <= 0x2935) {
                    [originText deleteCharactersInRange:substringRange];
                } else if (0x3297 <= hs && hs <= 0x3299) {
                    [originText deleteCharactersInRange:substringRange];
                } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    [originText deleteCharactersInRange:substringRange];
                }
            }
        }];
        self.transformedTextV.text = [NSString stringWithFormat:@"变换后文字：%@",originText];
    }
}

- (IBAction)transformChineseToSpelling:(RoundedButton *)sender {
    NSString *oriText = self.needTrans.text;
    NSString *transferdText = nil;
    if (oriText && oriText.length > 0) {
        transferdText = [self spellingCharactersTransformWithChinese:oriText inRange:[oriText rangeOfString:oriText]];
    }
    if (transferdText) {
        self.transformedTextV.text = [NSString stringWithFormat:@"变换后文字：%@",transferdText];
    }
}

- (NSString *)spellingCharactersTransformWithChinese:(NSString *)chineStr inRange:(NSRange)range {
    chineStr = [chineStr substringWithRange:range];
    NSMutableString *mutaStr = [[NSMutableString alloc] initWithString:chineStr];
    CFIndex cLocation = (CFIndex)range.location;
    CFIndex cLength = (CFIndex)range.length;
    CFRange cRange = CFRangeMake(cLocation, cLength);
    //must first convert to string that has tone
    if (CFStringTransform((__bridge CFMutableStringRef)mutaStr, &cRange, kCFStringTransformMandarinLatin, NO)) {
        //remove tone from string the first step created
//        if (CFStringTransform((__bridge CFMutableStringRef)mutaStr, &cRange, kCFStringTransformStripDiacritics, NO)) {
//            return mutaStr;
//        }
        return mutaStr;
    }
    return nil;
}
- (IBAction)resetAction:(RoundedButton *)sender {
    self.transformedTextV.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
