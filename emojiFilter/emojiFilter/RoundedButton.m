//
//  RoundedButton.m
//  emojiFilter
//
//  Created by 廖祖德 on 16/4/14.
//  Copyright © 2016年 QingHong. All rights reserved.
//

#import "RoundedButton.h"

@implementation RoundedButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialHandle];
}


- (void)initialHandle {
    self.layer.cornerRadius = 4.0;
    
}

@end
