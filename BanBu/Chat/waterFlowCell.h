//
//  waterFlowCell.h
//  BanBu
//
//  Created by apple on 12-12-11.
//
//

#import <UIKit/UIKit.h>
@class IndexPath;
@interface waterFlowCell : UIView{

    
    
    
}
@property(nonatomic,assign)int columnCount;// 有几列
@property(nonatomic,retain)IndexPath *indexpath;// 位置
@property(nonatomic,retain)NSString *strReuseIndentifier;// 重用符号

-(id)initWithIndentifer:(NSString *)indentifer;

-(void)relayoutViews;


@end
@interface IndexPath : NSObject
{
    int cloumn;
    
    int row;


}
@property(nonatomic,assign)int cloumn;
@property(nonatomic,assign)int row;

+(IndexPath*)initWithRow:(int)indexrow WithCloumn:(int)cloumn;
@end