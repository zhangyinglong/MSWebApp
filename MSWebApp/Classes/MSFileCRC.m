//
//  MSFileCRC.m
//  Pods
//
//  Created by Dylan on 2016/9/12.
//
//

#import "MSFileCRC.h"

@implementation MSFileCRC

+ (unsigned short) crc16: (NSData*) data {
    unsigned int crc;
    
    crc = 0xFFFF;
    
    uint8_t byteArray[[data length]];
    [data getBytes:&byteArray];
    
    for (int i = 0; i<[data length]; i++) {
        Byte byte = byteArray[i];
        crc = (crc >> 8) ^ crc16table[(crc^ byte) & 0xFF];
    }
    return crc;
}

+ (unsigned short) crcForFile: (NSString *) filePath {
    if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
        if ( fileData ) {
            return [self crc16:fileData];
        }
    }
    return 0;
}

@end
