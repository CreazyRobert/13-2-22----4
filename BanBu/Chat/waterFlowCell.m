//
//  waterFlowCell.m
//  BanBu
//
//  Created by apple on 12-12-11.
//
//

#import "waterFlowCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation waterFlowCell
@synthesize columnCount=_columnCount,strReuseIndentifier=_strReuseIndentifier,
indexpath=_indexpath;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithIndentifer:(NSString *)indentifer
{
    self=[super init];
    
    if(self)
    {
    
        self.strReuseIndentifier=indentifer;
    
        return self;
    
    }
    
    return nil;


}
// 父类的方法
-(void)relayoutViews
{


}
// dealloc

-(void)dealloc
{   self.indexpath=nil;
    
    self.strReuseIndentifier=nil;

    [super dealloc];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end


// 这是位置的写的方法
@implementation IndexPath;

@synthesize cloumn,row;
+(IndexPath *)initWithRow:(int)indexrow WithCloumn:(int)cloumn
{
    IndexPath *t=[[IndexPath alloc]init];
    
    t.row=indexrow;
    
    t.cloumn=cloumn;
    
    return [t autorelease];


}

@end