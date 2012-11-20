//
//  UIImage+AnimatedGif.m
//  ADNClient
//
//  Created by phil on 10/8/12.
//  Copyright (c) 2012 Year of Code. All rights reserved.
//

#import "UIImage+AnimatedGif.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (AnimatedGif)


+ animatedGifWithImageData:(NSData *)imageData
{
    if (imageData == nil) {
        return nil;
    }
    
    UIImage *img = nil;
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    
    if (source == nil) {
        return nil;
    }
    
    NSDictionary *properties = (__bridge_transfer NSDictionary *)CGImageSourceCopyProperties(source, NULL);
    NSTimeInterval duration = [properties[(__bridge NSString *)kCGImagePropertyGIFDictionary][(__bridge NSString *)kCGImagePropertyGIFDelayTime] doubleValue] / 100.0;
    
    size_t count = CGImageSourceGetCount(source);
    NSTimeInterval durationByFrames = 0;

    if (count > 1) {
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
        for (size_t i = 0; i < count; ++i) {
            CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!cgImage)
                return nil;
            [images addObject:[UIImage imageWithCGImage:cgImage]];
            
            CGImageRelease(cgImage);
        }
        
        // use 1/15s as the default frame duration
        // (most browsers seem to use 1/10s)
        if (duration == 0) {
            duration = (1.0/15.0) * count;
        }
        
        img = [UIImage animatedImageWithImages:images duration:duration];
    } else {
        img = [UIImage imageWithData:imageData];
    }
    
    CFRelease(source);
    return img;
}



@end
