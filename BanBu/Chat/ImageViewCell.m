//
//  ImageViewCell.m
//  BanBu
//
//  Created by apple on 12-12-11.
//
//

#import "ImageViewCell.h"
#import "AppDataManager.h"
#define TOPMARGIN 8.0f
#define LEFTMARGIN 10.0f
@implementation ImageViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc{
    [imageView release];
    [gifImageView release];
    [super dealloc];
}

// 继承ImageviewCell
-(id)initWithIdentifier:(NSString *)indentifier
{
    self=[super initWithIndentifer:indentifier];
    
    if(self)
    {
        imageView=[[UIImageView alloc]init];
    
        imageView.backgroundColor=[UIColor clearColor];
        
        [self addSubview:imageView];
        
        
        gifImageView = [[UIImageView alloc]init];
        gifImageView.backgroundColor = [UIColor clearColor];
        [imageView addSubview:gifImageView];
        
        imageView.layer.borderWidth = 1;
        imageView.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] CGColor];
    }


    return self;

}

-(void)setImageWithURL:(NSURL *)imageUrl
{

    [imageView setImageWithURL:imageUrl];
 
}

-(void)setImage:(UIImage *)image
{
    imageView.image=image;
    
}


-(void)setImagewithString:(NSString *)image
{

    
     [imageView setImageWithURL:[NSURL URLWithString:image]];
    NSArray *gifArr = [image componentsSeparatedByString:@"."];
    if([[gifArr lastObject] isEqualToString:@"gif"]){
        gifImageView.image = [UIImage imageNamed:@"iconGif.png"];

    }else{
        gifImageView.image = nil;

    }

}


-(void)relayoutViews
{
    float originX = 0.0f;
    float originY = 0.0f;
    float width = 0.0f;
    float height = 0.0f;
    
    originY = TOPMARGIN;
    height = CGRectGetHeight(self.frame) - TOPMARGIN;
    
    if (self.indexpath.cloumn == 0) {
        
        originX = LEFTMARGIN/2;
        
        width = CGRectGetWidth(self.frame) - LEFTMARGIN - 1/2.0*LEFTMARGIN;
    }else if (self.indexpath.cloumn < self.columnCount - 1){
        
        originX = LEFTMARGIN/2.0-2;
        width = CGRectGetWidth(self.frame) - LEFTMARGIN;
    }else{
        
        originX = LEFTMARGIN/2.0-2;
        width = CGRectGetWidth(self.frame) - LEFTMARGIN - 1/2.0*LEFTMARGIN;
    }
    
  
    
    imageView.frame = CGRectMake( originX, originY,100, height);
    gifImageView.frame = CGRectMake(100-26, height-26, 24, 24);
    [super relayoutViews];


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
