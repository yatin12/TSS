//
//  BDOpenPlatformShareRequest.h
//
//  Created by ByteDance on 2019/7/8.
//  Copyright (c) 2018年 ByteDance Ltd. All rights reserved.

#import "TikTokOpenSDKApplicationDelegate.h"
#import "TikTokOpenSDKObjects.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const TikTokVideoKitDisableMusicSelectionKey;

typedef NS_ENUM(NSUInteger, TikTokOpenSDKShareMediaType) {
    TikTokOpenSDKShareMediaTypeImage = 0, //!< Map to PHAssetMediaTypeImage
    TikTokOpenSDKShareMediaTypeVideo, //!< Map to PHAssetMediaTypeVideo
};

typedef NS_ENUM(NSUInteger, TikTokOpenSDKLandedPageType) {
    TikTokOpenSDKLandedPageClip = 0,//!< Landed to Clip ViewController
    TikTokOpenSDKLandedPageEdit,//!< Landed to Edit ViewController
    TikTokOpenSDKLandedPagePublish,//!< Landed to Edit ViewController
};

typedef NS_ENUM(NSUInteger, TikTokOpenSDKShareFormatType) {
    TikTokOpenSDKShareFormatNormal = 0,
    TikTokOpenSDKShareFormatGreenScreen,//!< Share media as green screen background
};

typedef NS_ENUM(NSInteger, TikTokOpenSDKShareRespState) {
    TikTokOpenSDKShareRespStateSuccess = 20000,                         //!< Success
    TikTokOpenSDKShareRespStateUnknownError = 20001,                    //!< Unknown or current SDK version unclassified error
    TikTokOpenSDKShareRespStateParamValidError = 20002,                 //!< Params parsing error, media resource type difference you pass
    TikTokOpenSDKShareRespStateSharePermissionDenied = 20003,           //!< Not enough permissions to operation.
    TikTokOpenSDKShareRespStateUserNotLogin = 20004,                    //!< User not login
    TikTokOpenSDKShareRespStateNotHavePhotoLibraryPermission = 20005,   //!< Has no album permissions
    TikTokOpenSDKShareRespStateNetworkError = 20006,                    //!< Network error
    TikTokOpenSDKShareRespStateVideoTimeLimitError = 20007,             //!< Video length doesn't meet requirements
    TikTokOpenSDKShareRespStatePhotoResolutionError = 20008,            //!< Photo doesn't meet requirements
    TikTokOpenSDKShareRespTimeStampError = 20009,                       //!< Timestamp check failed
    TikTokOpenSDKShareRespStateHandleMediaError = 20010,                //!< Processing photo resources faild
    TikTokOpenSDKShareRespStateVideoResolutionError = 20011,            //!< Video resolution doesn't meet requirements
    TikTokOpenSDKShareRespStateVideoFormatError = 20012,                //!< Video format is not supported
    TikTokOpenSDKShareRespStateCancel = 20013,                          //!< Sharing canceled
    TikTokOpenSDKShareRespStateHaveUploadingTask = 20014,               //!< Another video is currently uploading
    TikTokOpenSDKShareRespStateSaveAsDraft = 20015,                     //!< Users store shared content for draft or user accounts are not allowed to post videos
    TikTokOpenSDKShareRespStatePublishFailed = 20016,                   //!< Post share content failed
    TikTokOpenSDKShareRespStateMediaInIcloudError = 21001,              //!< Downloading from iCloud faild
    TikTokOpenSDKShareRespStateParamsParsingError = 21002,              //!< Internal params parsing error
    TikTokOpenSDKShareRespStateGetMediaError = 21003,                   //!< Media resources do not exist
};

TikTokOpenSDKShareRespState TikTokOpenSDKStringToShareState(NSString *string);


@class TikTokOpenSDKShareResponse;

typedef void (^TikTokOpenSDKShareCompletionBlock)(TikTokOpenSDKShareResponse *Response);
typedef void (^TikTokOpenSDKShareCompleteBlock)(TikTokOpenSDKShareResponse *Response) DEPRECATED_MSG_ATTRIBUTE("Use 'TikTokOpenSDKShareCompletionBlock' instead");

@interface TikTokOpenSDKShareRequest : TikTokOpenSDKBaseRequest

/**
   The local identifier of the video or image shared by the your application to Open Platform in the **Photo Album**. The content must be all images or video.

   - The aspect ratio of the images or videos should between: [1/2.2, 2.2]
   - If mediaType is Image:
    - The number of images should be more than one and up to 12.
   - If mediaType is Video:
    - Total video duration should be longer than 3 seconds.
    - No more than 12 videos can be shared
   - Video with brand logo or watermark will lead to video deleted or account banned. Make sure your applications share contents without watermark.
 */
@property (nonatomic, strong) NSArray *localIdentifiers;

/**
   Choose the landing page, default is TikTokOpenSDKLandedPageClip
 */
@property (nonatomic, assign) TikTokOpenSDKLandedPageType landedPageType;

/**
    Your app needs to be approved to set a custom hashtag. To associate your video with a hashtag, set the hashtag property on the request. The length cannot exceed 35.
 */
@property (nonatomic, copy) NSString *hashtag;

/**
   Pick a share format. Setting shareFormat to TikTokOpenSDKShareFormatGreenScreen will set a single video or a single photo as a background for the green screen effect in TikTok. Default is TikTokOpenSDKShareFormatNormal.
 */
@property (nonatomic, assign) TikTokOpenSDKShareFormatType shareFormat;

/**
    Add extra share options to disable/enable users from adding music, anchors, or effects when sharing to TikTok. If the dictionary is empty, the default will enable users to do what they want.
 */
@property (nonatomic, strong) NSDictionary *extraShareOptions;

/**
   The Media type of localIdentifiers in Album, All attachment localIdentifiers must be the same type
 */
@property (nonatomic, assign) TikTokOpenSDKShareMediaType mediaType;

/**
   Used to identify the uniqueness of the request, and finally returned by App when jumping back to the third-party program
 */
@property (nonatomic, copy, nullable) NSString *state;

/**
 * @brief Send share request to Open Platform.
 *
 * @param completion The async result call back. You can get result in share response.isSucceed;
 *
 * @return Share request is valid will return YES;
 */
- (BOOL)sendShareRequestWithCompletionBlock:(TikTokOpenSDKShareCompletionBlock)completion;

#pragma mark - Deprecated

- (BOOL)sendShareRequestWithCompleteBlock:(TikTokOpenSDKShareCompleteBlock)completed DEPRECATED_MSG_ATTRIBUTE("Use 'sendShareRequestWithCompletionBlock:' instead");

@end

@interface TikTokOpenSDKShareResponse : TikTokOpenSDKBaseResponse
/**
   Used to identify the uniqueness of the request, and finally returned by App when jumping back to the third-party program
 */
@property (nonatomic, copy, nullable) NSString *state;

@property (nonatomic, assign) TikTokOpenSDKShareRespState shareState;

@end

NS_ASSUME_NONNULL_END
