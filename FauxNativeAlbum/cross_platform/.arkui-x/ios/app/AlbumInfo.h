
// AlbumInfo.h
  
#import <Foundation/Foundation.h>
  
@interface AlbumInfo : NSObject
  
@property (nonatomic, assign) long createTime;
@property (nonatomic, strong) NSString *uri;

- (NSDictionary *)dictionaryWithCreateTimeAndUri;

@end
