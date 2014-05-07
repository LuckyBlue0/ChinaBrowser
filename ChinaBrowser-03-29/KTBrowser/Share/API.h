//
//  API.h
//  WKBrowser
//
//  Created by David on 13-10-18.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * app name
 */
extern NSString * const API_AppName;

/*
 * 用户接口
 * ++++++++++++++++++++++++++++++++++++++++++++++
 * @url: http://www.veryapps.com/plugin/browser/user.php
 * @method post 请求方式
 *
 * @param string $app 应用名(jisu:极速浏览器,wukong:悟空浏览器)
 * @param string $ac 类型(login:登录,register:注册,modify:修改,passport:授权登录)
 *
 * $ac = login
 * @param string $username 用户名
 * @param string $password 密码
 *
 * $ac = register
 * @param string $username 用户名
 * @param string $nickname 昵称
 * @param string $password 密码
 * @param string $email 邮箱
 * @param file $avatar 头像
 * @param string $sign 签名字符串(队sign,ac外的所有参数按键值排序连接的md5)
 *
 * $ac = modify
 * @param integer $uid 登录用户id
 * @param string $hash 登录标识
 * @param string $username 用户名
 * @param string $nickname 昵称
 * @param string $oldpwd 旧密码
 * @param string $newpwd 新密码
 * @param file $avatar 头像
 *
 * $ac = oauth
 * @param integer $uid 登录用户id
 * @param string $hash 登录标识
 * @param string $type 帐号类型(必须)
 *                     weibo:新浪微博,
 *                     tqq:腾讯微博,
 *                     qq:qq空间
 * @param string $access_token 授权access_token(必须)
 * @param string $refresh_token 授权refresh_token
 * @param string $expires_in 授权access_token过期时间(必须)
 * @param string $openid 授权openid 腾讯微博登录需要传入
 *
 * 说明: 传入uid和hash表示绑定已经有帐号
 *
 * @return Json
 * error 错误代码
 * msg     错误信息
 * data:
 *         id: 用户id
 *         hash: 登录标识
 *         username: 用户名
 *         nickname: 昵称
 *         avatar: 头像
 *         email: 邮箱
 *         auto_create: 是否自动生成
 *
 * auto_create字段标识帐号是否是第三方平台帐号登录自动生成的,
 * 为1时表示是通过第三方平台帐号生成,提示用户修改帐号密码,
 * 修改密码后auto_create的值会变为0
 */
extern NSString * const API_User;

/*
 * 用户收藏
 * ++++++++++++++++++++++++++++++++++++++++++++++
 * @url: http://www.veryapps.com/plugin/browser/favorite.php
 * @method post 请求方式
 *
 * @param string $app 应用名(jisu:极速浏览器)
 * @param string $ac 接口类型(list:收藏列表,add:添加收藏,delete:删除收藏)
 * @param integer $uid 用户id
 * @param string $hash 登录标识
 *
 * $ac = add
 * @param string $title 标题
 * @param string $link 链接
 * @param string $type 链接类型(favorite:收藏,home:首页,history:历史)w
 *
 * $ac = delete
 * @param integer $id 收藏id
 *
 * $ac = delete_all 清空浏览历史
 *
 * $ac = batch_delete
 * @param string $ids 收藏id(多个用逗号隔开)
 * @param string $type 链接类型(favorite:收藏,home:首页,history:历史)
 *
 * $ac = modify
 * @param integer $id 收藏id
 * @param string $title 标题
 * @param string $link 链接
 * @param string $type 链接类型(favorite:收藏,home:首页,history:历史)
 *
 * $ac = list
 * @param integer $page 页码(每页20)
 * @param string $type 链接类型(favorite:收藏,home:首页,history:历史)
 *
 * @return Json
 * error 错误代码
 * msg     错误信息
 * total 总记录数
 * next_page 是否有下一页(Y:有;N:没有)
 * data:
 *         id: 收藏id
 *         title: 标题
 *         link: 链接
 *         time: 收藏时间
 *
 * 接口已经禁用缓存
 */
extern NSString * const API_Favorite;

//------ ShareSDK 相关
extern NSString * const SSK_AppId_ShareSDK;

extern NSString * const SSK_AppKey_SinaWeibo;
extern NSString * const SSK_Secret_SinaWeibo;
extern NSString * const SSK_Redirect_SinaWeibo;

extern NSString * const SSK_AppKey_TencentWeibo;
extern NSString * const SSK_Secret_TencentWeibo;
extern NSString * const SSK_Redirect_TencentWeibo;

extern NSString * const SSK_AppKey_QZone;
extern NSString * const SSK_Secret_QZone;
extern NSString * const SSK_Redirect_QZone;

extern NSString * const SSK_AppId_WeiXin;
extern NSString * const SSK_AppKey_WeiXin;

// ---------- BaiduMobStat AppKey
extern NSString * const BaiduMobAppKey;
