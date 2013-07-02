//
//  BanBuAPIs.h
//  BanBu
//
//  Created by zhengziyan19 on 12-8-1.
//
//

#import <Foundation/Foundation.h>

//#define BanBuHost @"http://www.halfeet.com"
//#define BanBuHost_Data @"http://db.halfeet.com"
//#define BanBuHost_Chat @"http://chat.halfeet.com"
//#define BanBuHost_File @"http://file.halfeet.com"


#define BanBuHost_Data @"http://192.168.1.111"
#define BanBuHost_Chat @"http://192.168.1.111"
#define BanBuHost_File @"http://192.168.1.111"


//#define BanBuHost @"http://192.168.1.111"

//#define BanBuHost @"http://74.117.60.99"

//#define BanBuHost @"http://199.71.212.202"

//#define BanBuHost @"http://cher.weixinchina.net/chathelper"

//static NSString *const BanBu_Sys_Dict = @"/_sys_dict/_get_sayhi_rand.php?jsonfrom=";

static NSString *const BanBu_Get_System_Facelist = @"/_user_login/_get_system_facelist.php?jsonfrom=";

static NSString *const BanBu_Get_Server_List = @"/_apps/_get_server_list.php?jsonfrom=";//获取服务器列表

static NSString *const Banbu_Send_Feedback = @"/_sys_dict/_send_feedback.php?jsonfrom=";//反馈意见
//新添根据本地未读消息数量来通知服务器应该显示的推送数量加到应用程序角标处
static NSString *const Banbu_Set_User_Pushcount = @"/_user_login/_set_user_pushcount.php?jsonfrom="; //推送消息数量/未读消息数量
static NSString *const Banbu_Set_User_Pushid = @"/_user_login/_set_user_pushid.php?jsonfrom="; //清除我的推送ID

/*登录注册相关  start*/

static NSString *const BanBu_Check_Email = @"/_user_login/_check_email_register.php?jsonfrom="; //检验邮箱是否可用
static NSString *const BanBu_Register_Email = @"/_user_login/_register_email.php?jsonfrom="; //注册邮箱
static NSString *const BanBu_Check_Login = @"/_user_login/_check_user_login.php?jsonfrom=";  //用户登录校验

static NSString *const BanBu_Check_Login_Bind = @"/_user_login/_check_user_login_bind.php?jsonfrom="; //用户绑定登录校验

static NSString *const BanBu_Set_User_Info = @"/_user_login/_set_user_infor.php?jsonfrom=";  //用户个人资料设置
static NSString *const BanBu_Get_User_Info = @"/_user_login/_get_user_infor.php?jsonfrom=";  //用户个人资料及头像列表读取
static NSString *const BanBu_Set_User_Avatar = @"/_user_login/_base64_user_face.php?";       //注册时上传头像
static NSString *const BanBu_Get_My_Info = @"/_user_login/_get_my_infor.php?jsonfrom=";       //读取自已的个人资料
static NSString *const BanBu_Set_My_Info = @"/_user_login/_set_my_expandext.php?jsonfrom=";   //修改自已的个人资料之扩展资料
static NSString *const BanBu_Del_My_Avatar = @"/_user_login/_del_user_face.php?jsonfrom=";     //删除用户头像照片
static NSString *const BanBu_Upload_My_Photos = @"/_user_login/_upload_my_photos.php?";       //上传多个头像
static NSString *const BanBu_Get_My_Facelist = @"/_user_login/_get_my_facelist.php?jsonfrom=";       //下载多个头像
static NSString *const BanBu_Set_User_Password = @"/_user_login/_set_user_password.php?jsonfrom=";     //修改密码


/*+++++++++++++++++++++++++++++++*/
static NSString *const BanBu_Set_Register_User = @"/_user_login/_set_register_user.php?jsonfrom=";     //一步提交
static NSString *const BanBu_Set_User_View = @"/_user_login/_set_user_view_link.php?jsonfrom=";     //声明访问了该用户

//社交网站帐号绑定
static NSString *const BanBu_Set_User_accountbind = @"/_user_login/_set_user_accountbind.php?jsonfrom=";

//好友的备注名
static NSString *const BanBu_Set_FriendName = @"/_friend/_set_friendname_byfuid.php?jsonfrom=";
static NSString *const BanBu_Get_FriendName_OfMy = @"/_friend/_get_friendname_ofmy.php?jsonfrom=";

/*登录注册相关   end*/


/*广播动态相关  start*/

//static NSString *const BanBu_Send_Broadcast = @"/_broad_cast/_send_broad_cast_temp.php?jsonfrom=";
static NSString *const BanBu_Send_Broadcast = @"/_broad_cast/_send_broad_cast.php?jsonfrom=";
static NSString *const BanBu_Get_Broadcast = @"/_broad_cast/_get_broadcast_byid.php?jsonfrom=";
static NSString *const BanBu_Reply_Broadcast = @"/_broad_cast/_reply_broad_cast.php?jsonfrom=";
static NSString *const BanBu_Report_Broadcat = @"/_broad_cast/_report_broadcast_byid.php?jsonfrom=";   //举报一条动态
static NSString *const BanBu_Vote_Broadcast = @"/_broad_cast/_vote_broadcast_byid.php?jsonfrom=";//喜欢，分享动态(广播)信息
static NSString *const BanBu_Delete_Broadcast = @"/_broad_cast/_delete_broad_byid.php?jsonfrom=";//删除自己的广播

/*广播动态相关  end*/

/*抛绣球 start*/

static NSString *const BanBu_SendBall_To_Area = @"/_application/_shakeball_throw.php?jsonfrom=";
static NSString *const BanBu_SendBall_To_User = @"/_application/_shakeball_sendmsg.php?jsonfrom=";
static NSString *const BanBu_ReceiveBallList =@"/_application/_shakeball_getmsg_byall.php?jsonfrom=";
static NSString *const BanBu_ReceiveBallMessage = @"/_application/_shakeball_getmsg_byuser.php?jsonfrom=";

//地图
static NSString *const BanBu_Get_CBD = @"/_map_city/_get_addresshot_bycity.php?jsonfrom=";
static NSString *const BanBu_Get_AddList = @"/_map_city/_get_addresslist_bykey_ext.php?jsonfrom=";


/*抛绣球 end*/

/*附近好友相关  start*/

static NSString *const BanBu_Set_User_Location = @"/_near_user/_set_user_location.php?jsonfrom=";   //提交我的坐标
static NSString *const BanBu_Get_User_Nearby = @"/_near_user/_get_user_nearby.php?jsonfrom=";       //附近的用户
static NSString *const BanBu_Get_User_Neardo = @"/_near_user/_get_user_neardo.php?jsonfrom=";       //附近的动态

/*附近好友相关  end*/

/*好友信息相关  start*/
static NSString *const BanBu_Report_User = @"/_friend/_report_user_bycase.php?jsonfrom=";//举报并拉黑
static NSString *const BanBu_Set_Friend_Link = @"/_friend/_link_user_touser.php?jsonfrom="; //好友关系变更，参数为black时，就是拉黑
static NSString *const BanBu_Get_Friend_ViewList = @"/_friend/_get_viewerlist_ofmy.php?jsonfrom=";       //返回看过我的人列表
static NSString *const BanBu_Get_Friend_OfMy = @"/_friend/_get_friendlist_ofmy.php?jsonfrom=";       //按类别好友的列表
static NSString *const BanBu_Get_Friend_FriendDo = @"/_friend/_get_friendaction_byfuid.php?jsonfrom=";       //一个用户的动态列表
static NSString *const BanBu_Get_Friend_FriendDos = @"/_friend/_get_friendaction_ofmy.php?jsonfrom=";      //好友动态列表

/*好友信息相关  end*/


/*上传文件相关  start*/

static NSString *const BanBu_UploadFile_To_Server = @"/_post_file/_post_file_byuser.php?jsonfrom="; //上传文件

/*上传文件相关  end*/


/*聊天相关  start*/
static NSString *const BanBu_AllOperation_Server=@"/_system/_get_system_message.php?jsonfrom=";


static NSString *const BanBu_SendMessage_To_Server = @"/_user_chat/_send_message_touser.php?jsonfrom=";       //发送消息至指定用户
static NSString *const BanBu_ReceiveMessage_From_Server = @"/_user_chat/_get_message_ofmy_byuser.php?jsonfrom="; //读取消息列表，限定来自于指定用户
static NSString *const BanBu_ReceiveMessage_From_All = @"/_user_chat/_get_message_ofmy_byall.php?jsonfrom="; //读取消息列表，所有人发给我的


static NSString *const BanBu_readMessage_byuser=@"/_user_chat/_set_message_read_byuser.php?jsonfrom=";// 向服务器发送信息我已经读了对方

static NSString *const BanBu_Send_Request_To_User = @"/_friend/_send_request_touser.php?jsonfrom=";//请求加为好友
static NSString *const BanBu_Get_Request_From_All = @"/_friend/_get_request_fromall.php?jsonfrom=";//请求加我为好友的用户的列表
static NSString *const BanBu_Delete_Request_ByIDList = @"/_friend/_delete_request_byidlist.php?jsonfrom=";//删除请求列表

/*聊天相关  end*/
/* 获取不文明的语言、*/

static NSString *const BanBu_BadWordto_check=@"/_sys_dict/_get_badwords_packet.php?jsonfrom=";

static NSString *const BanBu_Internationar_Language=@"/_sys_dict/_get_language_packet.php?jsonfrom=";
/*各种破冰语*/
static NSString *const BanBu_Get_Sayhi_Rand = @"/_sys_dict/_get_sayhi_rand.php?jsonfrom=";
static NSString *const BanBu_Get_Sayhi_Hot = @"/_sys_dict/_get_sayhi_hot.php?jsonfrom=";

static NSString *const BanBuDataformatError = @"CJSONScannerErrorDomain";
//static NSString *const NSLocalizedString(@"data_error", nil) = NSLocalizedString(@"data_error", nil);
//static NSString *const NSLocalizedString(@"network_error", nil) = NSLocalizedString(@"network_error", nil);

// const string

static NSString *const BuddyListPage = @"BuddyListPage";
static NSString *const FriendListPage = @"FriendListPage";
static NSString *const DosListPage = @"DosListPage";


static NSString *const ListKey = @"listtype";
static NSString *const PageNo = @"pageno";
static NSString *const Latitude = @"plat";
static NSString *const Longitude = @"plong";
static NSString *const LinkTouID = @"linktouid";
static NSString *const ReportTouID = @"touid";

static NSString *const Action = @"action";
static NSString *const MyProfile = @"MyProfile";
static NSString *const FriendShip = @"friendlist";
//static NSString *const  = @"friendlist";
// keys

static NSString *const KeyFromUid = @"userid";
static NSString *const KeyMediaStatus = @"mediastatus";
static NSString *const KeyMe = @"me";
static NSString *const KeyUface = @"uface";
static NSString *const KeyPname = @"pname";
static NSString *const KeyDistmeter = @"distmeter";
static NSString *const KeyDisttime = @"disttime";
static NSString *const KeyOldyears = @"oldyears";
static NSString *const KeyAge = @"oldyears";
static NSString *const KeySayme = @"sayme";
static NSString *const KeyGender = @"gender";
static NSString *const KeySex = @"sex";
static NSString *const KeySays = @"says";
static NSString *const KeyLasttalk = @"content";
static NSString *const KeyType = @"type";
static NSString *const KeyStime = @"stime";
static NSString *const KeyContent = @"content";
static NSString *const KeyID = @"ID";
static NSString *const KeyStatus = @"status";
static NSString *const KeyHeight = @"height";
static NSString *const KeyShowtime = @"showtime";
static NSString *const KeyUid = @"uid";
static NSString *const KeyUname = @"pname";
static NSString *const KeyUnreadNum = @"unreadnum";
static NSString *const KeyFileUrl = @"fileurl";
static NSString *const KeyFromUidTalk=@"fromuid";
static NSString *const KeyFacelist=@"facelist";
static NSString *const KeyShowFrom=@"msgfrom";

static NSString *const KeyAndroidFrom=@"msgfrom";



// 新添的个人资料的字段
static NSString *const KeyCompany=@"company";
static NSString *const KeyHbody=@"hbody";
static NSString *const KeyJobtitle=@"jobtitle";
static NSString *const KeyLiked=@"liked";
static NSString *const KeyLovego=@"lovego";
static NSString *const KeySchool=@"school";
static NSString *const KeySstar=@"sstar";
static NSString *const KeyWbody=@"wbody";
static NSString *const KeyXblood=@"xblood";

static NSString *const KeyDmeter=@"dmeter";

static NSString *const KeyDtime=@"ltime";


static NSString *const DBFieldType_BOOL = @"bool";
static NSString *const DBFieldType_INTEGER = @"integer";
static NSString *const DBFieldType_TEXT = @"text";
static NSString *const DBFieldType_DATA = @"blob";











