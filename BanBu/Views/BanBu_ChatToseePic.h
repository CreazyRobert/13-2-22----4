//
//  BanBu_ChatToseePic.h
//  BanBu
//
//  Created by apple on 13-1-22.
//
//

#import "MWPhotoBrowser.h"
#import "TKLoadingView.h"
#import "WBEngine.h"
#import "QWeiboAsyncApi.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

typedef enum {
    
    DrawTypeBroadcast = 0,
    DrawTypeChat
    
}DrawType;

@interface BanBu_ChatToseePic : MWPhotoBrowser<UIActionSheetDelegate,WBEngineDelegate,FHSTwitterEngineAccessTokenDelegate>{
    ALAssetsLibrary *_assetLibrary;
    
    DrawType _type;

}
@property(nonatomic,retain)NSMutableArray *shareArr;
@property (nonatomic, retain) NSURLConnection *connection;//tencent
@property(nonatomic,assign)DrawType type;
@end
