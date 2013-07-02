//
//  BanBu_DigiCell.m
//  BanBu
//
//  Created by Jc Zhang on 13-3-15.
//
//

#import "BanBu_DigiCell.h"

@implementation BanBu_DigiCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //-setMasksToBounds:方法告诉layer将位于它之下的layer都遮盖住。这是必须的，这样会使圆角不被遮，但是这样会导致阴影效果没有，很多网上都给出资料，再添加一个SubLayer，添加阴影。
//        NSLog(@"%f",self.frame.size.width); 
        _shadowView = [[UIView alloc]initWithFrame:CGRectZero];
//        _shadowView.layer.shadowOffset = CGSizeMake(0, 3);
//        _shadowView.layer.shadowOpacity = 0.6;
//        _shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_shadowView.bounds].CGPath;
//        _shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
//        _shadowView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_shadowView];
        [_shadowView release];

         bkView = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, _shadowView.frame.size.width, _shadowView.frame.size.height)];
        bkView.userInteractionEnabled = YES;
        bkView.image = [[UIImage imageNamed:@"listbg(2).png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:4.0];
//        bkView.image = [UIImage imageNamed:@"框 (4).png"];

//        bkView.backgroundColor = [UIColor blackColor];
//        bkView.layer.cornerRadius = 6.0;
//        bkView.layer.masksToBounds = YES;
        
        [_shadowView addSubview:bkView];
        [bkView release];
        
        //*************************************************************/
        

        //头像
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = CGRectMake(10, 10, 35, 35);
        
//        _iconButton.layer.borderColor = [[UIColor blackColor]CGColor];
//        _iconButton.layer.borderWidth = 1.0;
//        _iconButton.layer.cornerRadius = 3.0;
//        _iconButton.layer.masksToBounds = YES;
        [_iconButton addTarget:self action:@selector(pushProfile:) forControlEvents:UIControlEventTouchUpInside];
//        [_iconButton setImage:[UIImage imageNamed:@"msg_fbtn1.png"] forState:UIControlStateNormal];
        [_shadowView addSubview:_iconButton];
        
        //名字
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 160, 17)];
        _nameLabel.backgroundColor = [UIColor clearColor];
//        _nameLabel.text = @"Yumi Lai and 张三";
        _nameLabel.font = [UIFont boldSystemFontOfSize:13];
        _nameLabel.textColor = [UIColor blackColor];
        [_shadowView addSubview:_nameLabel];
        [_nameLabel release];
        //距离与到达时间
        _distanceAndTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 27, 160, 17)];
        _distanceAndTimeLabel.backgroundColor = [UIColor clearColor];
//        _distanceAndTimeLabel.text = @"距离2.52千米/开车7分钟";
        _distanceAndTimeLabel.font = [UIFont boldSystemFontOfSize:13];
        _distanceAndTimeLabel.textColor = [UIColor lightGrayColor];
        [_shadowView addSubview:_distanceAndTimeLabel];
        [_distanceAndTimeLabel release];
        
        //最新上线时间
        _lastTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 10, 75, 17)];
        _lastTimeLabel.backgroundColor = [UIColor clearColor];
//        _lastTimeLabel.text = @"1天前";
        _lastTimeLabel.textAlignment = UITextAlignmentRight;
        _lastTimeLabel.font = [UIFont boldSystemFontOfSize:13];
        _lastTimeLabel.textColor = [UIColor lightGrayColor];
        [_shadowView addSubview:_lastTimeLabel];
        [_lastTimeLabel release];
        
        //文字（可选）
        _sayTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 44, 235, 0)];
//       _sayTextLabel.text = @"你没，你没，你没没，你没，你没没，你没，你没没，你没，你没没，你没，你没，都";
        _sayTextLabel.textColor = [UIColor blackColor];
        _sayTextLabel.font = [UIFont boldSystemFontOfSize:13];
        _sayTextLabel.backgroundColor = [UIColor clearColor];
//        textLabelHeight = [_sayTextLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(235, 100) lineBreakMode:NSLineBreakByTruncatingMiddle].height;
//        _sayTextLabel.frame = CGRectMake(55, 44+10, 235, textLabelHeight);
        _sayTextLabel.numberOfLines = 0;
        [_shadowView addSubview:_sayTextLabel];
        [_sayTextLabel release];
        
        //标签view
        _tagsView = [[UIView alloc]initWithFrame:CGRectZero];
        _tagsView.backgroundColor = [UIColor clearColor];
        [_shadowView addSubview:_tagsView];
        [_tagsView release];
 
        //电话
        _telButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _telButton.frame = CGRectMake(55, 55, 120, 10);
        [_telButton addTarget:self action:@selector(callThePhoneNumber) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_telButton];
        
        //主图片
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _headImageView.userInteractionEnabled = YES;
//        _headImageView.backgroundColor = [UIColor whiteColor];
//        _headImageView.image = [UIImage imageNamed:@"photo_default.png"];
//        _headImageView.layer.cornerRadius = 6.0;
//        _headImageView.layer.masksToBounds = YES;
        [_shadowView addSubview:_headImageView];
        [_headImageView release];
        
        //播放按钮(可选)
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _playButton.hidden = YES;
//        _playButton.frame = CGRectMake( 150-105/2, _shadowView.frame.size.height-13, 105, 26);
//        [_playButton setImage:[UIImage imageNamed:@"播放语音_未按下_不空.png"] forState:UIControlStateNormal];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playAction:)];
        [_playButton addGestureRecognizer:tap];
        [tap release];
        [_shadowView addSubview:_playButton];
 
        _soundTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        _soundTimeLabel.hidden = YES;
        _soundTimeLabel.backgroundColor = [UIColor clearColor];
        _soundTimeLabel.textColor = [UIColor whiteColor];
        _soundTimeLabel.font = [UIFont systemFontOfSize:14];
        _soundTimeLabel.textAlignment= UITextAlignmentRight;
        [_shadowView addSubview:_soundTimeLabel];
        [_soundTimeLabel release];
        
        //评论（可选）
        _commentView = [[UIView alloc]initWithFrame:CGRectMake(10, _shadowView.frame.origin.y, 300, 0)];
        _commentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_commentView];
        [_commentView release];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_numLabel];
        [_numLabel release];
      
        /********没辙了*********/
        {
            //头像
            _iconBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            _iconBtn1.frame = CGRectZero;
//            _iconBtn1.layer.cornerRadius = 3.0;
//            _iconBtn1.layer.masksToBounds = YES;
            [_iconBtn1 addTarget:self action:@selector(pushProfile:) forControlEvents:UIControlEventTouchUpInside];

            [self.commentView addSubview:_iconBtn1];
            //姓名
            _nameLabel1 = [[UILabel alloc]initWithFrame:CGRectZero];
            _nameLabel1.backgroundColor = [UIColor clearColor];
            _nameLabel1.font = [UIFont boldSystemFontOfSize:13];
            _nameLabel1.textColor = [UIColor blackColor];
            
            [self.commentView addSubview:_nameLabel1];
            [_nameLabel1 release];
            
            //语音
            _voiceBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            _voiceBtn1.frame = CGRectZero;
//            [_voiceBtn1 setImage:[UIImage imageNamed:@"广播详情-复选框-播放.png"] forState:UIControlStateNormal];
            [_voiceBtn1 addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [self.commentView addSubview:_voiceBtn1];
            
            _soundTimeLabel1 = [[UILabel alloc]initWithFrame:CGRectZero];
            _soundTimeLabel1.backgroundColor = [UIColor clearColor];
            _soundTimeLabel1.textColor = [UIColor whiteColor];
            _soundTimeLabel1.font = [UIFont systemFontOfSize:14];
            _soundTimeLabel1.textAlignment= UITextAlignmentRight;
            [self.commentView addSubview:_soundTimeLabel1];
            [_soundTimeLabel1 release];
            
            //文字
            _textLabel1 =  [[UILabel alloc]initWithFrame:CGRectZero];
            _textLabel1.textColor = [UIColor blackColor];
            _textLabel1.font = [UIFont systemFontOfSize:13];
            _textLabel1.backgroundColor = [UIColor clearColor];
            [self.commentView addSubview:_textLabel1];
            [_textLabel1 release];
            
            
            //时间
            _timeLabel1 = [[UILabel alloc]initWithFrame:CGRectZero];
            _timeLabel1.backgroundColor = [UIColor clearColor];
            _timeLabel1.textAlignment = UITextAlignmentRight;
            _timeLabel1.font = [UIFont boldSystemFontOfSize:13];
            _timeLabel1.textColor = [UIColor lightGrayColor];
            [self.commentView addSubview:_timeLabel1];
            [_timeLabel1 release];
            
            _lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
            _lineView1.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
            [self.commentView addSubview:_lineView1];
            [_lineView1 release];
        }
        {
            //头像
            _iconBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            _iconBtn2.frame = CGRectZero;
//            _iconBtn2.layer.cornerRadius = 3.0;
//            _iconBtn2.layer.masksToBounds = YES;
            [self.commentView addSubview:_iconBtn2];
            [_iconBtn2 addTarget:self action:@selector(pushProfile:) forControlEvents:UIControlEventTouchUpInside];
            //姓名
            _nameLabel2 = [[UILabel alloc]initWithFrame:CGRectZero];
            _nameLabel2.backgroundColor = [UIColor clearColor];
            _nameLabel2.font = [UIFont boldSystemFontOfSize:13];
            _nameLabel2.textColor = [UIColor blackColor];
            
            [self.commentView addSubview:_nameLabel2];
            [_nameLabel2 release];
            
            //语音
            
                    
            _voiceBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            _voiceBtn2.frame = CGRectZero;
//            [_voiceBtn2 setImage:[UIImage imageNamed:@"广播详情-复选框-播放.png"] forState:UIControlStateNormal];
            [_voiceBtn2 addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [self.commentView addSubview:_voiceBtn2];
            _soundTimeLabel2 = [[UILabel alloc]initWithFrame:CGRectZero];
            _soundTimeLabel2.backgroundColor = [UIColor clearColor];
            _soundTimeLabel2.textColor = [UIColor whiteColor];
            _soundTimeLabel2.font = [UIFont systemFontOfSize:14];
            _soundTimeLabel2.textAlignment= UITextAlignmentRight;
            [self.commentView addSubview:_soundTimeLabel2];
            [_soundTimeLabel2 release];

            //文字
            _textLabel2 =  [[UILabel alloc]initWithFrame:CGRectZero];
            _textLabel2.textColor = [UIColor blackColor];
            _textLabel2.font = [UIFont systemFontOfSize:13];
            _textLabel2.backgroundColor = [UIColor clearColor];
            [self.commentView addSubview:_textLabel2];
            [_textLabel2 release];
            
            
            //时间
            _timeLabel2 = [[UILabel alloc]initWithFrame:CGRectZero];
            _timeLabel2.backgroundColor = [UIColor clearColor];
            _timeLabel2.textAlignment = UITextAlignmentRight;
            _timeLabel2.font = [UIFont boldSystemFontOfSize:13];
            _timeLabel2.textColor = [UIColor lightGrayColor];
            [self.commentView addSubview:_timeLabel2];
            [_timeLabel2 release];
            
            _lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
            _lineView2.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
            [self.commentView addSubview:_lineView2];
            [_lineView2 release];
        }
        {
            //头像
            _iconBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            _iconBtn3.frame = CGRectZero;
//            _iconBtn3.layer.cornerRadius = 3.0;
//            _iconBtn3.layer.masksToBounds = YES;
            [self.commentView addSubview:_iconBtn3];
            [_iconBtn3 addTarget:self action:@selector(pushProfile:) forControlEvents:UIControlEventTouchUpInside];
            //姓名
            _nameLabel3 = [[UILabel alloc]initWithFrame:CGRectZero];
            _nameLabel3.backgroundColor = [UIColor clearColor];
            _nameLabel3.font = [UIFont boldSystemFontOfSize:13];
            _nameLabel3.textColor = [UIColor blackColor];
            
            [self.commentView addSubview:_nameLabel3];
            [_nameLabel3 release];
            
            //语音
            
                     
            _voiceBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            _voiceBtn3.frame = CGRectZero;
//            [_voiceBtn3 setImage:[UIImage imageNamed:@"广播详情-复选框-播放.png"] forState:UIControlStateNormal];
            [_voiceBtn3 addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [self.commentView addSubview:_voiceBtn3];
            _soundTimeLabel3 = [[UILabel alloc]initWithFrame:CGRectZero];
            _soundTimeLabel3.backgroundColor = [UIColor clearColor];
            _soundTimeLabel3.textColor = [UIColor whiteColor];
            _soundTimeLabel3.font = [UIFont systemFontOfSize:14];
            _soundTimeLabel3.textAlignment= UITextAlignmentRight;
            [self.commentView addSubview:_soundTimeLabel3];
            [_soundTimeLabel3 release];

            //文字
            _textLabel3 =  [[UILabel alloc]initWithFrame:CGRectZero];
            _textLabel3.textColor = [UIColor blackColor];
            _textLabel3.font = [UIFont systemFontOfSize:13];
            _textLabel3.backgroundColor = [UIColor clearColor];
            [self.commentView addSubview:_textLabel3];
            [_textLabel3 release];
            
            
            //时间
            _timeLabel3 = [[UILabel alloc]initWithFrame:CGRectZero];
            _timeLabel3.backgroundColor = [UIColor clearColor];
            _timeLabel3.textAlignment = UITextAlignmentRight;
            _timeLabel3.font = [UIFont boldSystemFontOfSize:13];
            _timeLabel3.textColor = [UIColor lightGrayColor];
            [self.commentView addSubview:_timeLabel3];
            [_timeLabel3 release];
            
            _lineView3 = [[UIView alloc] initWithFrame:CGRectZero];
            _lineView3.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
            [self.commentView addSubview:_lineView3];
            [_lineView3 release];
            
            //评论总数
                    _numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
                    _numLabel.backgroundColor = [UIColor clearColor];
                    _numLabel.font = [UIFont boldSystemFontOfSize:13];
                    _numLabel.textColor = [UIColor lightGrayColor];
                    [self.commentView addSubview:_numLabel];
                    [_numLabel release];
                    _lineView4 = [[UIView alloc] initWithFrame:CGRectZero];
                    _lineView4.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
                    [self.commentView addSubview:_lineView4];
                    [_lineView4 release];
            
            
            
            
        }
      }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    
    [super dealloc];
    
}

- (void)setAvatar:(NSString *)avatarUrlStr{
    
    [_iconButton setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];
    
}

- (void)setHeadImage:(NSString *)headImageUrlStr{
    
    [_headImageView setImageWithURL:[NSURL URLWithString:headImageUrlStr] placeholderImage:[UIImage imageNamed:@"photo_default.png"] andType:0];
}


-(void)playAction:(UITapGestureRecognizer *)tap{
    
    [self performSelector:@selector(play:) withObject:(UIButton *)tap.view];
}

-(void)play:(UIButton *)sender{
    
    if([self.delegate respondsToSelector:@selector(playVoiceButton:)]){
        
        [_delegate performSelector:@selector(playVoiceButton:) withObject:sender];
    }
}

-(void)pushProfile:(UIButton *)sender{
    
    if([self.delegate respondsToSelector:@selector(seeProfile:)]){
        
        [_delegate performSelector:@selector(seeProfile:) withObject:sender];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    ((UIView *)[_shadowView.subviews objectAtIndex:0]).frame = CGRectMake(0, 0, 300, _shadowView.frame.size.height);
//    _shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_shadowView.bounds].CGPath;

//    _playButton.frame = CGRectMake( 150-105/2, _shadowView.frame.size.height-26, 105, 26);
//    _commentView.frame = CGRectMake(10, _shadowView.frame.origin.y-140, 300, 140);
    _lineView1.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    _lineView2.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    _lineView3.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    _lineView4.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];

   
    
    if(self.highlighted){
        
        bkView.layer.shadowOffset = CGSizeMake(0, 0);
        bkView.layer.shadowOpacity = 0.9;
        bkView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_shadowView.bounds].CGPath;
        bkView.layer.shadowColor = [[UIColor cyanColor] CGColor];
        
    }else{
        bkView.layer.shadowOffset = CGSizeMake(0, 2);
        bkView.layer.shadowOpacity = 0.6;
        bkView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_shadowView.bounds].CGPath;
        bkView.layer.shadowColor = [[UIColor blackColor] CGColor];
 
    }


}

-(void)callThePhoneNumber{
    
    NSString *phoneNum = _telButton.titleLabel.text;// 电话号码
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
        
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
}
@end
