//
//  BanBu_RequestViewController.h
//  BanBu
//
//  Created by apple on 13-1-29.
//
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableViewController.h"
#import "BanBu_RequestCell.h"
#import "BanBu_ChatViewController.h"
#import "BanBu_ChatDelegate.h"
@class BanBu_RequestCell;
@class RequestButton;
enum
{
    KMyfriendTag=1,
    
    KMyrequestTag=2,
    
    KMydisagree=3,
    
    KMyagree=4,

};
typedef struct
{
    int Request_tofriend;
    
    char *a[10];
    
    struct  Myfriend *left;
    
    struct  Myfriend *right;
    
    NSString *string;

}Myfriend;

struct Friend
{
    int k;
    
    struct Friend *next;

};

typedef struct Nex
{
  
    int k;
    
    struct Nex *next;
    
    Myfriend *what;
    
    struct Friend *why;
    
}Nwx;

@interface BanBu_RequestViewController :EGORefreshTableViewController
{
    Myfriend *friendt;

    NSString *badage;
    
    NSMutableArray *requestArr;
    
    BOOL enSure;
    int rowt;
  
    
}
@property(nonatomic,assign)Myfriend *friendt;
@property(nonatomic,retain)NSString *badage;
@property(nonatomic,retain)NSMutableDictionary *dictionary;
@property(nonatomic,retain)RequestButton *receiveButton;
@property(nonatomic,retain)NSMutableDictionary *profile;
@property(nonatomic,assign)id<BanBu_ChatDelegate>delegate;
@property(nonatomic,retain)NSMutableArray *relationArr;



-(id)initWithNumber:(NSString *)number MutableDictionary:(NSMutableDictionary *)dic;

-(void)reToAgreetoChange:(BanBu_RequestCell *)cell Button:(RequestButton *)sender;

-(void)retoDeleteChange:(BanBu_RequestCell *)cell;


-(void)pushTheNextController:(BanBu_RequestCell *)cell;


-(void)pushTheChatViewController:(BanBu_RequestCell *)cell;


@end
