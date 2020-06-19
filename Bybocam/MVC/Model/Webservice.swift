//
//  Webservice.swift
//  Bybocam
//
//  Created by APPLE on 18/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import Foundation

let BASE_URL = "http://srv1.a1professionals.net/bybocam/api/user/"

let Image_Base_URL = "http://srv1.a1professionals.net/bybocam/assets/images/"

 let Message_Image_Base_URL = "http://srv1.a1professionals.net/bybocam/assets/messageAsImage/"

let Video_Base_URL = "http://srv1.a1professionals.net/bybocam/assets/videos/"

let Post_Base_URL = "http://srv1.a1professionals.net/bybocam/assets/posts/"


/////////////////////////////////////////////////////////////////////////////////////////////////////


let SIGNUP_URL = BASE_URL + "signUp"

let LOGIN_URL = BASE_URL + "signIn"

let LOGOUT_URL = BASE_URL + "userLogout"

let FORGET_ONE_URL = BASE_URL + "forgotPassword"

let FORGET_TWO_URL = BASE_URL + "changePassword"

let EDIT_PROFILE_URL = BASE_URL + "editProfile"

let VIEW_PROFILE_URL = BASE_URL + "viewProfile"

//let VIEW_USER_PROFILE_URL = BASE_URL + "viewProfile"

let VIEW_USER_PROFILE_URL = BASE_URL + "viewProfileOurUser"

let ADD_VIDEO_URL = BASE_URL + "addVideo"

let ADD_NEW_POST_URL = BASE_URL + "addPost"

let GET_NEW_POST_URL = BASE_URL + "getAllPost"

let SEARCH_POST_URL = BASE_URL + "postSearch"

let RECOMENDATION_URL = BASE_URL + "getAllUserByLatLong"

let REPORT_PROBLEM_URL = BASE_URL + "addUserReport"

let User_Like_URL = BASE_URL + "userLikeDislike"

let DELETE_ACCOUNT_URL = BASE_URL + "deleteUser"

let FEVOURITE_USER_URL = BASE_URL + "getFavouriteUsers"

let Follower_USER_URL = BASE_URL + "get_User_List_Liked_Me"

let ADD_SINGLE_AND_GROUP_MSG_URL = BASE_URL + "addComments"

let GET_ALL_CHAT_MSG_URL = BASE_URL + "getAllComment"

let GET_SINGLE_CHATMSG_URL = BASE_URL + "getChatMessage"

let ADD_SINGLE_CHATMSG_URL = BASE_URL + "addSingleChatMessage"


let ADD_Image_Message_URL = BASE_URL + "addCommentAsFile"

let GET_ALL_USERNAME = BASE_URL + "UserNameSearch"


let LIKE_POST = BASE_URL + "userPostLikeUnlike"

let COMMENT_POST = BASE_URL + "addCommentsOnPost"

let GET_COMMENT_POST = BASE_URL + "getAllCommentsOnPost"

let GET_ALL_NOTIFICATION = BASE_URL + "getAllnotificationData"

let BLOCK_USER_API = BASE_URL + "userBlock"


let BLOCKED_USERLIST = BASE_URL + "getBlockedUsersByMe"

let LIKED_VIDEO = BASE_URL + "getPostsLikedByMe"
