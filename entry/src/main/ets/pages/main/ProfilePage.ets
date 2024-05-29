import axios from '@ohos/axios'
import { BASE_URL, CHECK_LOGIN, LOGIN_PAGE_URL, USER_INFO, USER_INFO_ITEMS } from '../../base/Api'
import { ResponseData } from '../../base/BaseModel'
import { appWhite, lineColor, textBlack, textRed, textWhite } from '../../base/color'
import { PageState } from '../../base/PageState'
import { user_icon_url } from '../../base/Url'
import { cookie, csrf_token, timestampParams, User } from '../../base/User'
import { PageLoading } from '../../component/PageLoading'
import { MinePageItems } from '../../model/profile/MinePageItems'
import { UserModel, UserSimpleVO, WelfareCardEntrance, WelfareFissionInfo } from '../../model/profile/UserModel'
import { goWebView } from '../../utils/Routers'
import { LoginPage } from '../LoginPage'

@Entry
@Component
export struct ProfilePage {
  @State _isLogin: boolean = false
  @State _pageState: PageState = PageState.None
  @State _items: Array<MinePageItems> = []
  @State _userModel: UserModel = null

  aboutToAppear() {
    if (csrf_token == '') {
      this._isLogin = false
    } else {

    }
    this._checkLogin()
  }

  _checkLogin() {
    this._pageState = PageState.Loading
    axios.get<ResponseData>(CHECK_LOGIN, {
      params: timestampParams
    }).then(res => {
      console.log('==============islogin', JSON.stringify(res.data))
      let isLogin = res.data.data
      if (isLogin == null) {
        this._isLogin = false
      } else {
        this._isLogin = isLogin
        if (isLogin) {
          this._getUserInfo()
        }
      }
      this._pageState = PageState.Success
    }).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  _getUserInfo() {
    this._pageState = PageState.Loading
    axios.get<ResponseData<UserModel>>(USER_INFO, {
      params: { 'csrf_token': csrf_token }
    }).then(res => {
      this._userModel = res.data.data
    }).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })

    axios.get<ResponseData<Array<MinePageItems>>>(USER_INFO_ITEMS, {
      params: { 'csrf_token': csrf_token }
    }).then(res => {
      this._items = res.data.data
    }).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  build() {
    if (this._pageState == PageState.Loading) PageLoading()
    else Stack() {
      if (this._isLogin) this.profilePage()
      else LoginPage({
        onPageEnd: () => {

        },
        onPageBegin: () => {

        }
      })
    }
    .height('100%')
    .alignContent(Alignment.Top)
    .backgroundColor(0xeeeeee)
  }

  @Builder
  profilePage() {
    if (this._userModel != null)
    Scroll() {
      Column() {
        this.header(this._userModel!.userSimpleVO)
        this.mineItems()
        this.activities(this._userModel.welfareFissionInfo)
        Rect().height(10)
        this.adapters()
        Rect().height(20)
        this.loginOutBtn()
        Rect().height(10)
      }
      .align(Alignment.Top)
    }
  }

  @Builder
  loginOutBtn() {
    Text('退出登录')
      .width('100%')
      .fontSize(14)
      .fontColor(textBlack)
      .textAlign(TextAlign.Center)
      .height(50)
      .backgroundColor(appWhite)
      .onClick(e => {
        User.cookie('')
        this._checkLogin()
      })
  }

  @Builder
  activities(welfare: WelfareFissionInfo) {

  }

  @Builder
  adapters() {
    GridRow({ columns: 3, gutter: 1 }) {
      ForEach(this.mineSettingItems, (item) => {
        GridCol() {
          Column() {
            Image(item.pic).size({ width: 35, height: 35 })
            Text(item.name).fontSize(12).fontColor(textBlack).margin({ top: 5 })
          }
          .justifyContent(FlexAlign.Center)
          .backgroundColor(appWhite)
          .aspectRatio(1.4)
          .width('100%')
          .onClick(e => {
            switch (item.id) {
              case 0: {
              }
              case 1: {
              }
              case 2: {
              }
              case 3: {
              }
              case 4: {
              }
              case 6: {
              }
              case 8: {
              }
              case 9: {
              }
              case 11: {
              }

              case 5:
              case 7:
              case 10:
              case 12:
              case 13:
                goWebView(item.url)
            }
          })
        }
      })
    }
  }

  @Builder
  mineItems() {
    Column() {
      Text('我的资产').fontSize(15).fontColor(textBlack).margin(16)
      Rect().fill(lineColor).height(0.5).width('100%').margin({ left: 16 })
      Row() {
        ForEach(this._items, (item: MinePageItems) => {
          Column() {
            Text(item.fundType == 1 || item.fundType == 4 ? `¥${item.fundValue}` : `${item.fundValue}`)
              .fontSize(16)
              .fontColor(textBlack)
              .fontWeight(600)
            Text(`${item.fundName}`).fontSize(12).fontColor(textBlack)
          }
        })
      }
      .margin({ top: 16, bottom: 16 })
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')

      this.monthCard(this._userModel.monthCardEntrance)
      this.monthCard(this._userModel.welfareCardEntrance)
    }
    .backgroundColor(appWhite)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  monthCard(card: WelfareCardEntrance) {
    if (card != null)
    Row() {
      Image(card.iconPicUrl ?? '').height(25)
      Image(card.titleUrl ?? '').height(20)
      Text(card.title ?? '').fontSize(14).fontColor(textBlack)
      Rect().height(12).width(1).fill(textBlack).margin({ left: 10, right: 10 })
      Text(card.content).layoutWeight(1).fontColor(textBlack).fontSize(14).maxLines(1)
      if (card.buttonName != null && card.buttonName != '')
        Text(card.buttonName ?? '')
          .fontSize(12)
          .fontColor(textWhite)
          .padding({ left: 6, top: 3, right: 6, bottom: 3 })
          .backgroundColor(textRed)
          .borderRadius(20)
          .onClick(e => {
            goWebView(card.url)
          })
    }
    .margin({ left: 12, right: 12, bottom: 12 })
    .padding({ left: 10, top: 8, right: 10, bottom: 8 })
    .backgroundColor(0xFFFFF6F4)
    .borderRadius(8)
  }

  @Builder
  header(userSimple: UserSimpleVO) {
    Row() {
      Image(userSimple.avatar ?? user_icon_url)
        .size({ width: 72, height: 72 })
        .clip(new Circle({ width: 72, height: 72 }))
        .margin(20)
      Column() {
        Text(userSimple.nickname ?? '').fontSize(18).fontColor(textWhite)
        Text(userSimple.memberLevel == 0 ? "普通用户" : "vip用户").fontSize(16).fontColor(textWhite)
      }

      Column() {
        Image($r('app.media.mine_page_qr')).size({ width: 35, height: 35 })
      }
      .alignItems(HorizontalAlign.End)
      .layoutWeight(1)
    }
    .width('100%')
    .height(140)
    .backgroundImage($r('app.media.user_header_back'))
    .backgroundImageSize(ImageSize.Cover)
  }

  mineSettingItems = [
    {
      "name": "我的订单",
      "status": "0",
      "id": 0,
      "pic": $r('app.media.mine_item_1'),
    },
    {
      "name": "账号管理",
      "status": "0",
      "id": 1,
      "pic": $r('app.media.mine_item_2'),
    },
    {
      "name": "周六一起拼",
      "status": "0",
      "id": 2,
      "pic": $r('app.media.mine_item_4'),
    },
    {
      "name": "售后服务",
      "status": "0",
      "id": 3,
      "pic": $r('app.media.mine_item_5'),
    },
    {
      "name": "邀请返利",
      "status": "0",
      "id": 4,
      "pic": $r('app.media.mine_item_6'),
    },
    {
      "name": "优先购",
      "status": "0",
      "url": BASE_URL + "/preemption/index.html",
      "id": 5,
      "pic": $r('app.media.mine_item_7'),
    },
    {
      "name": "积分中心",
      "status": "0",
      "id": 6,
      "pic": $r('app.media.mine_item_8'),
    },
    {
      "name": "会员俱乐部",
      "status": "0",
      "url": BASE_URL + "/membership/index",
      "id": 7,
      "pic": $r('app.media.mine_item_9'),
    },
    {
      "name": "地址管理",
      "status": "0",
      "id": 8,
      "pic": $r('app.media.mine_item_10'),
    },
    {
      "name": "支付安全",
      "status": "0",
      "id": 9,
      "pic": $r('app.media.mine_item_11'),
    },
    {
      "name": "帮助与客服",
      "status": "0",
      "url": BASE_URL + "/help/new#/",
      "id": 10,
      "pic": $r('app.media.mine_item_12'),
    },
    {
      "name": "意见反馈",
      "status": "0",
      "id": 11,
      "pic": $r('app.media.mine_item_13'),
    },
    {
      "name": "我的拍卖",
      "status": "0",
      "url": BASE_URL + "/auction/wap/profile/list",
      "id": 13,
      "pic": $r('app.media.mine_item_14'),
    }
  ];
}