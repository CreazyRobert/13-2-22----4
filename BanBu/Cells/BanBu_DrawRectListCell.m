//
//  BanBu_DrawRectListCell.m
//  BanBu
//
//  Created by Jc Zhang on 13-4-25.
//
//

#import "BanBu_DrawRectListCell.h"

#define x 90
#define featureEndx 310
#define sep 2.0

#define boyColor [UIColor colorWithRed:48.0/255 green:169.0/255 blue:217.0/255 alpha:1.0]
#define girlColor [UIColor colorWithRed:252.0/255 green:192.0/255 blue:213.0/255 alpha:1.0]




@implementation BanBu_DrawRectListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //        UIImageView *bkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 84)];
        //        bkView.image = [[UIImage imageNamed:@"listbg.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:4.0];
        //        self.backgroundView = bkView;
        //        [bkView release];
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 83, 320, 1.0)];
//        lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
//        [self.contentView addSubview:lineView];
//        [lineView release];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, 74, 74)];
        _iconView = imageView;
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        //		_iconView.layer.borderWidth = 1.0f;
        //		_iconView.layer.borderColor = [[UIColor lightTextColor] CGColor];
		[self.contentView addSubview:_iconView];
        [imageView release];
		

//        _nameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
//        _nameLabel.frame = CGRectMake(x,5, 120, 20);
////		_nameLabel.titleLabel.textAlignment = UITextAlignmentLeft;
//        _nameLabel.titleLabel.textColor = [UIColor darkTextColor];
//
////        _nameLabel.contentEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 45);
//        _nameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//		_nameLabel.backgroundColor = [UIColor clearColor];
//		_nameLabel.titleLabel.font = [UIFont systemFontOfSize:16];
//		[self.contentView addSubview:_nameLabel];
// 		
//        _ageAndSexButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _ageAndSexButton.userInteractionEnabled = NO;
//        _ageAndSexButton.frame = CGRectMake(x, 35, 28, 14);
//        _ageAndSexButton.titleLabel.font = [UIFont systemFontOfSize:11];
//        [_ageAndSexButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _ageAndSexButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//        [_ageAndSexButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 10)];
//		[self.contentView addSubview:_ageAndSexButton];
// 
//        _distanceLabel = [UIButton buttonWithType:UIButtonTypeCustom];
//        _distanceLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//        _distanceLabel.frame = CGRectMake(x+50, 33, 160, 16);
//		_distanceLabel.backgroundColor = [UIColor clearColor];
//		_distanceLabel.titleLabel.font = [UIFont systemFontOfSize:13];
//		_distanceLabel.titleLabel.textColor = [UIColor grayColor];
//		[self.contentView addSubview:_distanceLabel];
// 		
//        _signatureLabel = [UIButton buttonWithType:UIButtonTypeCustom];
//        _signatureLabel.frame = CGRectMake(x,55, 220, 20);
//		_signatureLabel.backgroundColor = [UIColor clearColor];
//		_signatureLabel.titleLabel.font = [UIFont systemFontOfSize:13];
//		_signatureLabel.titleLabel.textColor = [UIColor darkGrayColor];
//        _signatureLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _signatureLabel.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
//		[self.contentView addSubview:_signatureLabel];
//  
//        
//        _lastTimeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
//        _lastTimeLabel.frame = CGRectMake(x+120, 8, 100, 15);
//        _lastTimeLabel.backgroundColor = [UIColor clearColor];
//		_lastTimeLabel.titleLabel.font = [UIFont systemFontOfSize:13];
////        _lastTimeLabel.titleLabel.textAlignment = UITextAlignmentRight;
//		_lastTimeLabel.titleLabel.textColor = [UIColor grayColor];
//        _lastTimeLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//
//		[self.contentView addSubview:_lastTimeLabel];
     }

    return self;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
//    CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);  // white color
     UIGraphicsPopContext();
//    CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
    
    
//    CGContextBeginPath(ctx);
//    CGContextSetLineWidth(ctx, 0.5);
//    CGContextMoveToPoint(ctx,0, 83);
//    CGContextAddLineToPoint(ctx,320,83);
//    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0] CGColor]);
//    CGContextStrokePath(ctx);
    
    
    
    
    //绘制不同的颜色的字
    //姓名
    CGContextSetFillColorWithColor(ctx, [[UIColor darkTextColor] CGColor]);
    [_nameString drawInRect:CGRectMake(x,5, 120, 20) withFont:[UIFont systemFontOfSize:16]];
    //距离和最新上线
    CGContextSetFillColorWithColor(ctx, [[UIColor grayColor] CGColor]);
    [_distanceString drawInRect:CGRectMake(x+50, 33, 160, 16) withFont:[UIFont systemFontOfSize:13]];
    CGSize aSize = [_lastTimeString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(100, 16)];
    [_lastTimeString drawInRect:CGRectMake(320-10-aSize.width, 8, aSize.width, 15) withFont:[UIFont systemFontOfSize:13]];
    //签名
    CGContextSetFillColorWithColor(ctx, [[UIColor darkGrayColor] CGColor]);
    [_signatureString drawInRect:CGRectMake(x,55, 220, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
 
    UIImage * imagePic=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_sexString]];
    [imagePic drawInRect:CGRectMake(x, 35, 28, 14)];
}

- (void)setAvatar:(NSString *)avatarUrlStr{
    [_iconView setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];

}

- (void)setName:(NSString *)name{
    _nameString = name;
    [_nameLabel setTitle:name forState:UIControlStateHighlighted];
}

- (void)setAge:(NSString *)age sex:(NSString *)sex{
     _sexString = sex;
    [_ageAndSexButton setTitle:age forState:UIControlStateNormal];

}

- (void)setDistance:(NSString *)disStr timeAgo:(NSString *)timeStr{
    _distanceString = [[NSString alloc] initWithFormat:@"%@ | %@",disStr,timeStr];
    [_distanceLabel setTitle: [NSString stringWithFormat:@"%@ | %@",disStr,timeStr] forState:UIControlStateHighlighted];
    
}

- (void)setSignature:(NSString *)signature{
    _signatureString = signature;
    [_signatureLabel setTitle:signature forState:UIControlStateHighlighted];
}

- (void)setLastInfo:(NSString *)infoStr{
    _lastTimeString = infoStr;
    [_lastTimeLabel setTitle:infoStr forState:UIControlStateHighlighted];

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.highlighted)
    {
        _nameLabel.titleLabel.textColor = [UIColor whiteColor];
        _distanceLabel.titleLabel.textColor = [UIColor whiteColor];
        _signatureLabel.titleLabel.textColor = [UIColor whiteColor];
        _lastTimeLabel.titleLabel.textColor = [UIColor whiteColor];
        [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_sexString]] forState:UIControlStateHighlighted];
        [self setNeedsDisplay];
        
    }
    else
    {
        _nameLabel.titleLabel.textColor = [UIColor darkTextColor];
        _distanceLabel.titleLabel.textColor = [UIColor grayColor];
        _signatureLabel.titleLabel.textColor = [UIColor darkGrayColor];
        _lastTimeLabel.titleLabel.textColor = [UIColor grayColor];
        
    }
}

-(void)cancelImageLoad{
    
    [_iconView cancelCurrentImageLoad];
    _iconView.image = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	if(!newSuperview) {
		[self cancelImageLoad];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [_distanceString release];
    [super dealloc];
}

@end
