//
//  NSData+CRC32.m
//  RowRabbit
//
//  Created by 恽雨晨 on 2016/12/17.
//  Copyright © 2016年 常州云阳驱动. All rights reserved.
//

#import "NSData+CRC32.h"
#import <zlib.h>

@implementation NSData (CRC32)

- (uint32_t)CRC32Value {
    uLong crc = crc32(0L, Z_NULL, 0);
    crc = crc32(crc, self.bytes, self.length);
    return crc;
}


@end
