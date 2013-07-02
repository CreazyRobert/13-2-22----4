//
//  BanBu_DialogueCell.h
//  BanBu
//
//  Created by 17xy on 12-7-30.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIBadgeView.h"
typedef enum {
    DialogueStatusNoneType = 0,
    DialogueStatusSentType,
    DialogueStatusUnreadType
} DialogueStatusType;

// 各种状态
typedef enum
{
  DialogueMessageStausFailType=0,
  DialogueMessageStautusSentType,
  DialogueMessageStautusSendingType,
  DialogueMessageStautusReadType,
  DialogueMessageStautusNoneType

}DialogueMessageStautusType;
/*ChatStatusSendFail = 0,
ChatStatusSent,
ChatStatusSending,
ChatStatusReaded,
ChatStatusNone
*/



@interface BanBu_DialogueCell : UITableViewCell
{
    UILabel *_nameLabel;
    UIButton *_ageAndSexButton;
    UILabel *_distanceAndLastTimeLabel;
    UILabel *_lastDialogueLabel;
    UILabel *_statusLabel;
    UILabel *_numLabel;
    UIImageView *_iconView;
    UIView *lineView;
    // 状态的
   // UILabel *_readAndsend;
    
    UIImageView *_readAndsend;
    
    UILabel *_readAndSendLabel;
    
    UIButton *_receiveAndsend;

    UILabel *_distanceLabel;
    
    UIImageView*	m_checkImageView;
	BOOL			m_checked;
    
}
@property(nonatomic,assign)UIButton *receiveAndsend;

- (void) setChecked:(BOOL)checked;

- (void)setAvatar:(NSString *)avatarUrlStr;
- (void)setName:(NSString *)name;
- (void)setAge:(NSString *)age sex:(BOOL)sex;
- (void)setLastInfo:(NSString *)infoStr;
- (void)setlastDialogue:(NSString *)content andType:(NSString*)typeStr;
- (void)setStatus:(DialogueStatusType)status num:(NSString *)numStr;

//void setReadAndsend(DialogueStatusType status);

-(void)setReadAndSend:(DialogueMessageStautusType )type;

-(void)setBadageValue:(NSString*)badageValue;

-(void)setReceiveAndsend11:(BOOL)isMe;

-(void)setDistance:(NSString *)distance;


- (void)cancelImageLoad;



@end
