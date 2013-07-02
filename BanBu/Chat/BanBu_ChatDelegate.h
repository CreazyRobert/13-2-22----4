//
//  BanBu_ChatDelegate.h
//  BanBu
//
//  Created by apple on 13-2-1.
//
//

#import <Foundation/Foundation.h>

@class BanBu_ChatViewController;
@protocol BanBu_ChatDelegate <NSObject>
-(void)RequestOneMsg:(id)object type:(ChatCellType)type filePathExtension:(NSString *)pathExtension From:(NSString *)from;

@end
