//
//  UILabel+UILabel_ChangeLineSpaceAndWordSpace_h.h
//  RowRabbitTravel
//
//  Created by yunyuchen on 2017/9/12.
//  Copyright © 2017年 xingyuntu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (UILabel_ChangeLineSpaceAndWordSpace_h)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


@end
