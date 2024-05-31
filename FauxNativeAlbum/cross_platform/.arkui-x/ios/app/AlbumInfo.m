// AlbumInfo.m
  
#import "AlbumInfo.h"
  
@implementation AlbumInfo

- (NSDictionary *)dictionaryWithCreateTimeAndUri {
    return @{
        @"createTime": @(self.createTime),
        @"uri": self.uri
    };
}  

@end
