//
//  BanBu_DetailCell.m
//  BanBu
//
//  Created by Jc Zhang on 13-3-20.
//
//

#import "BanBu_DetailCell.h"

@implementation BanBu_DetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 54, 320, 1.0)];
        lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
        [self.contentView addSubview:lineView];
        [lineView release];
        //头像
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = CGRectMake(10, 10, 35, 35);
        
        //        _iconButton.layer.borderColor = [[UIColor blackColor]CGColor];
        //        _iconButton.layer.borderWidth = 1.0;
//        _iconButton.layer.cornerRadius = 3.0;
//        _iconButton.layer.masksToBounds = YES;
        [_iconButton addTarget:self action:@selector(pushProfile:) forControlEvents:UIControlEventTouchUpInside];
        //        [_iconButton setImage:[UIImage imageNamed:@"msg_fbtn1.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_iconButton];
        
        //名字
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 180, 17)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        //        _nameLabel.text = @"Yumi Lai and 张三";
        _nameLabel.font = [UIFont boldSystemFontOfSize:13];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel release];
               
        //回复时间
        _lastTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 10, 75, 17)];
        _lastTimeLabel.backgroundColor = [UIColor clearColor];
        //        _lastTimeLabel.text = @"1天前";
        _lastTimeLabel.textAlignment = UITextAlignmentRight;
        _lastTimeLabel.font = [UIFont boldSystemFontOfSize:13];
        _lastTimeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_lastTimeLabel];
        [_lastTimeLabel release];
        
        //文字（可选）
        _sayTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 27, 255, 17)];
        //       _sayTextLabel.text = @"你没，你没，你没没，你没，你没没，你没，你没没，你没，你没没，你没，你没，都";
        _sayTextLabel.textColor = [UIColor blackColor];
        _sayTextLabel.font = [UIFont systemFontOfSize:13];
        _sayTextLabel.backgroundColor = [UIColor clearColor];
        //        textLabelHeight = [_sayTextLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(235, 100) lineBreakMode:NSLineBreakByTruncatingMiddle].height;
        //        _sayTextLabel.frame = CGRectMake(55, 44+10, 235, textLabelHeight);
        _sayTextLabel.numberOfLines = 0;
        [self.contentView addSubview:_sayTextLabel];
        [_sayTextLabel release];

        //播放按钮(可选)
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.hidden = YES;
        [_playButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"广播详情-复选框-播放.png"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playButton];
        
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment= UITextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAvatar:(NSString *)avatarUrlStr{
    
    [_iconButton setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];
    
}

-(void)pushProfile:(UIButton *)sender{
     NSLog(@"%@",sender.titleLabel.text);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"seeProfile" object:sender];
    
}

-(void)play:(UIButton *)sender{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playVoice" object:sender];
}








@end
