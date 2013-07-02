//
//  BanBu_DialogueCell.m
//  BanBu
//
//  Created by 17xy on 12-7-30.
//
//

#import "BanBu_DialogueCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDataManager.h"
#define x 90
#define boyColor [UIColor colorWithRed:48.0/255 green:169.0/255 blue:217.0/255 alpha:1.0]
#define girlColor [UIColor colorWithRed:252.0/255 green:192.0/255 blue:213.0/255 alpha:1.0]

@implementation BanBu_DialogueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
        lineView = [[UIView alloc] initWithFrame:CGRectMake(-40, 83, 360, 1.0)];
        lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
        [self.contentView addSubview:lineView];
        [lineView release];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, 74, 74)];
        _iconView = imageView;
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
//		_iconView.layer.borderWidth = 1.0f;
//		_iconView.layer.borderColor = [[UIColor lightTextColor] CGColor];
		[self.contentView addSubview:_iconView];
        [imageView release];
		/*这是未读消息的badagevalue*/
 
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x,7, 140, 20)];
        _nameLabel = label;
		_nameLabel.textAlignment = UITextAlignmentLeft;
		_nameLabel.backgroundColor = [UIColor clearColor];
		_nameLabel.font = [UIFont systemFontOfSize:16];
		[self.contentView addSubview:_nameLabel];
        [label release];
        
        _distanceAndLastTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+100, 8, 120, 15)];
        _distanceAndLastTimeLabel.backgroundColor = [UIColor clearColor];
		_distanceAndLastTimeLabel.font = [UIFont systemFontOfSize:14];
		_distanceAndLastTimeLabel.textColor = [UIColor grayColor];
        _distanceAndLastTimeLabel.textAlignment=UITextAlignmentRight;
		[self.contentView addSubview:_distanceAndLastTimeLabel];
        [_distanceAndLastTimeLabel release];

        _distanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(x+100, 35, 120, 15)];
        _distanceLabel.backgroundColor=[UIColor clearColor];
        _distanceLabel.textColor=[UIColor grayColor];
        _distanceLabel.textAlignment=UITextAlignmentRight;
        [self.contentView addSubview:_distanceLabel];
        [_distanceLabel release];
        _ageAndSexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ageAndSexButton.frame = CGRectMake(x, 35, 28, 14);
        _ageAndSexButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_ageAndSexButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ageAndSexButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 10)];
		[self.contentView addSubview:_ageAndSexButton];
        
        /*这是状态的按钮的*/
        
        _readAndsend=[[UIImageView alloc]initWithFrame:CGRectMake(x+33, 35, 25, 14)];
        _readAndsend.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_readAndsend];
        [_readAndsend release];
        
        _readAndSendLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 14)];
        _readAndSendLabel.backgroundColor=[UIColor clearColor];
        _readAndSendLabel.textColor=[UIColor whiteColor];
        _readAndSendLabel.font=[UIFont systemFontOfSize:11];
        _readAndSendLabel.textAlignment=NSTextAlignmentCenter;
        [_readAndsend addSubview:_readAndSendLabel];
        [_readAndSendLabel release];
        
        
		_lastDialogueLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+25,55, 195, 20)];
		_lastDialogueLabel.backgroundColor = [UIColor clearColor];
        _lastDialogueLabel.numberOfLines = 0;
		_lastDialogueLabel.font = [UIFont systemFontOfSize:13];
		_lastDialogueLabel.textColor = [UIColor darkGrayColor];
		[self.contentView addSubview:_lastDialogueLabel];
        [_lastDialogueLabel release];
        
        _receiveAndsend=[UIButton buttonWithType:UIButtonTypeCustom];
        _receiveAndsend.frame=CGRectMake(x-3, 55, 25, 20);
        [self.contentView addSubview:_receiveAndsend];
       /*
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 65, 26, 12)];
        _statusLabel.backgroundColor = [UIColor orangeColor];
        _statusLabel.textAlignment = UITextAlignmentCenter;
		_statusLabel.font = [UIFont boldSystemFontOfSize:10];
		_statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.layer.cornerRadius = 3.0;
		[self.contentView addSubview:_statusLabel];
        [_statusLabel release];
        */
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(306, 60, 20,10)];
        _numLabel.backgroundColor = [UIColor clearColor];
		_numLabel.font = [UIFont systemFontOfSize:10];
		_numLabel.textColor = [UIColor redColor];
		[self.contentView addSubview:_numLabel];
        [_numLabel release];
        
        
    }
    return self;
}
-(void)setReceiveAndsend11:(BOOL)isMe
{
 
  if(isMe)
  {
  
      [_receiveAndsend setBackgroundImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
      [_receiveAndsend setBackgroundImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateHighlighted];

  
  }
   else
  {
   
      [_receiveAndsend setBackgroundImage:[UIImage imageNamed:@"receive.png"] forState:UIControlStateNormal];
      [_receiveAndsend setBackgroundImage:[UIImage imageNamed:@"receive.png"] forState:UIControlStateHighlighted];

      
   
  }
    
}

-(void)setReadAndSend:(DialogueMessageStautusType)type
{
    switch (type) {
        case 0:
        {
            _readAndsend.hidden=NO;
            _readAndSendLabel.hidden=NO;
            _readAndsend.image=[UIImage imageNamed:@"icon_msgfail1.png"];
            
            _readAndSendLabel.text= NSLocalizedString(@"newsState4", nil);
            
            
            
            CGFloat size=[NSLocalizedString(@"newsState4", nil) sizeWithFont:[UIFont systemFontOfSize:11]].width;
            
            _readAndsend.frame=CGRectMake(x+35, 35, size, 15);
            
            _readAndSendLabel.frame=CGRectMake(0, 0, size, 15);
            
        }
            break;
        case 1:
        {
            _readAndsend.hidden=NO;
            _readAndSendLabel.hidden=NO;
            _readAndsend.image=[UIImage imageNamed:@"icon_msgsent1.png"];
            
            
            _readAndSendLabel.text=NSLocalizedString(@"newsState", nil);
            
            //CGFloat btnLen = [NSLocalizedString(@"commendLabel", nil) sizeWithFont:[UIFontsystemFontOfSize:13] constrainedToSize:CGSizeMake(70, 15)].width;
            //    _commend.frame = CGRectMake(x+210-btnLen, 60, btnLen, 15);
            
            
            CGFloat size=[NSLocalizedString(@"newsState", nil) sizeWithFont:[UIFont systemFontOfSize:11]].width;
            
            _readAndsend.frame=CGRectMake(x+35, 35, size+2, 15);
            
            _readAndSendLabel.frame=CGRectMake(0, 0, size, 15);
            
            
            
            
        }
            break;
        case 2:
        {
            _readAndsend.hidden=NO;
            _readAndSendLabel.hidden=NO;
            _readAndsend.image=[UIImage imageNamed:@"icon_msgpend1.png"];
            
            _readAndSendLabel.text= NSLocalizedString(@"newsState3", nil);
            
            CGFloat size=[NSLocalizedString(@"newsState3", nil) sizeWithFont:[UIFont systemFontOfSize:11]].width;
            
            _readAndsend.frame=CGRectMake(x+35, 35, size, 15);
            
            _readAndSendLabel.frame=CGRectMake(0, 0, size, 15);
            
            
            
            
        }
            break;
        case 3:
        {
            
            _readAndsend.hidden=NO;
            _readAndSendLabel.hidden=NO;

            _readAndsend.image=[UIImage imageNamed:@"icon_msgread1.png"];
            
            _readAndSendLabel.text=NSLocalizedString(@"newsState1", nil);
            
            
            CGFloat size=[NSLocalizedString(@"newsState1", nil) sizeWithFont:[UIFont systemFontOfSize:11]].width;
            
            _readAndsend.frame=CGRectMake(x+35, 35, size+2, 15);
            
            _readAndSendLabel.frame=CGRectMake(0, 0, size, 15);
            
            
            
        }
            break;
        case 4:
        {
            _readAndsend.hidden=YES;
            
            _readAndSendLabel.hidden=YES;
            
        }
            break;
        default:
            break;
    }
    
}
//-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
//    [super setEditing:editing animated:animated];
//    if(editing){
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//		self.backgroundView = [[[UIView alloc] init] autorelease];
//		self.backgroundView.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor clearColor];
//    }
//}
  

- (void)setAvatar:(NSString *)avatarUrlStr
{
    [_iconView setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];
}

- (void)setName:(NSString *)name
{
    _nameLabel.text = name;
}

-(void)setDistance:(NSString *)distance
{
    _distanceLabel.font=[UIFont systemFontOfSize:13];
    _distanceLabel.text=distance;

}

- (void)setAge:(NSString *)age sex:(BOOL)sex
{
    switch (sex) {
        case 1:
        {
            [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateNormal];
            [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateHighlighted];
//            [_ageAndSexButton setBackgroundColor:[UIColor colorWithRed:120.0/255 green:200.0/255 blue:255.0/255 alpha:1.0]];
            [_ageAndSexButton setTitle:age forState:UIControlStateNormal];
        }
            break;
        case 0:
        {
            [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:@"girl.png"] forState:UIControlStateNormal];
            [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:@"girl.png"] forState:UIControlStateHighlighted];
//            [_ageAndSexButton setBackgroundColor:[UIColor colorWithRed:255.0/255 green:180.0/255 blue:210.0/255 alpha:1.0]];
            [_ageAndSexButton setTitle:age forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
 
    
}

- (void)setLastInfo:(NSString *)infoStr{    
   
    _distanceAndLastTimeLabel.text = [infoStr substringWithRange:NSMakeRange(5, infoStr.length-5-3)];
 
}

- (void)setlastDialogue:(NSString *)content andType:(NSString*)typeStr;
{
//    NSLog(@"%@---%@",content,typeStr);
    if([typeStr isEqualToString:@"emi"]){
        
        int t=[MyAppDataManager.emiNameArr indexOfObject:content];
//        content=[MyAppDataManager.emiLanguageArr objectAtIndex:t];
        if(t<38){
//            NSLog(@"%d",MyAppDataManager.emiLanguageArr.count);
            _lastDialogueLabel.text = [MyAppDataManager.emiLanguageArr objectAtIndex:t];

        }

    }else {
        _lastDialogueLabel.text = NSLocalizedString(content, nil);
    }
//    else if([typeStr isEqualToString:@"sound"] || [typeStr isEqualToString:@"image"] || [typeStr isEqualToString:@"location"]){
//         NSDictionary *mapDic = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"talkPicture", nil),@"image",NSLocalizedString(@"talkLocation", nil),@"location",NSLocalizedString(@"talkSound", nil),@"sound",nil];
//        content = [mapDic valueForKey:typeStr];
//    } 
}

- (void)setStatus:(DialogueStatusType)status num:(NSString *)numStr
{
    /*
    if(status == DialogueStatusNoneType)
    {
        _statusLabel.hidden = YES;
        _statusLabel.text = nil;
        _numLabel.text = nil;
    }
    else 
    {
        _statusLabel.text = (status == DialogueStatusSentType)?@"送达":@"未读";
        _statusLabel.hidden = NO;
        float width = [numStr sizeWithFont:_numLabel.font].width+2.0;
        _numLabel.frame = CGRectMake(320-width, 60, width, 10);
        _statusLabel.frame = CGRectMake(320-width-26, 65, 26, 12);
        _numLabel.text = numStr;
    }
     */
}
// 出现badageView
-(void)setBadageValue:(NSString *)badageValue
{
//    _readAndsend.hidden=YES;
    
    UIBadgeView *badgeView = (UIBadgeView *)[self viewWithTag:1000];
    if(!badageValue || ![badageValue intValue])
    {
        if(badgeView)
            [badgeView removeFromSuperview];
    }
    else
    {
        float width = [badageValue sizeWithFont:[UIFont boldSystemFontOfSize:14]].width+12;
        if(!badgeView)
        {
            badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(58, -5, width, 20)];

            badgeView.tag = 1000;
            badgeView.backgroundColor = [UIColor clearColor];
            badgeView.badgeColor = [UIColor redColor];
            [_iconView addSubview:badgeView];
            [badgeView release];
        }
        badgeView.badgeString = badageValue;
        badgeView.frame = CGRectMake(78-width, -5, width, 20);
    }


}

//多选删除部分
- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
		
		[UIView commitAnimations];
	}
	else
	{
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
	}
}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
//    NSLog(@"%d",animated);
	if (self.editing == editting)
	{
		return;
	}
	
	[super setEditing:editting animated:animated];
	
	if (editting)
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundView = [[[UIView alloc] init] autorelease];
		self.backgroundView.backgroundColor = [UIColor clearColor];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		
		if (m_checkImageView == nil)
		{
			m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellNotSelected.png"]];
			[self addSubview:m_checkImageView];
		}
		
		[self setChecked:m_checked];
 		m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
											  CGRectGetHeight(self.bounds) * 0.5);
		m_checkImageView.alpha = 0.0;
		[self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)
								alpha:1.0 animated:animated];
	}
	else
	{
		m_checked = NO;
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		self.backgroundView = nil;
		
		if (m_checkImageView)
		{
			[self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
													  CGRectGetHeight(self.bounds) * 0.5)
									alpha:0.0
								 animated:animated];
		}
	}
}

- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		m_checkImageView.image = [UIImage imageNamed:@"CellSelected.png"];
 	}
	else
	{
		m_checkImageView.image = [UIImage imageNamed:@"CellNotSelected.png"];
 	}
	m_checked = checked;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.highlighted)
    {
        _nameLabel.textColor = [UIColor whiteColor];
        _distanceLabel.textColor = [UIColor whiteColor];
        _distanceAndLastTimeLabel.textColor = [UIColor whiteColor];
        _lastDialogueLabel.textColor = [UIColor whiteColor];
        //        [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_sexString]] forState:UIControlStateHighlighted];
        
    }
    else
    {
  
        _nameLabel.textColor = [UIColor blackColor];
        _distanceLabel.textColor = [UIColor grayColor];
        _distanceAndLastTimeLabel.textColor = [UIColor darkGrayColor];
        _lastDialogueLabel.textColor = [UIColor grayColor];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
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
 


@end
