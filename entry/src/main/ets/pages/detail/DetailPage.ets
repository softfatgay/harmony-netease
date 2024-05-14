import axios from '@ohos/axios';
import router from '@ohos.router';
import { baseUrl, GOOD_DETAIL } from '../../base/Api';
import { ResponseData } from '../../base/BaseModel';
import { GoodDetailPre } from '../../model/detail/GoodDetailPre';
import { HotListData } from '../../model/hotlist/HotListData';
import { FeaturedSeries, GoodDetail, SimpleBrandInfo, SpmcBanner } from '../../model/detail/GoodDetail';
import { PageState } from '../../base/PageState';
import { PageLoading } from '../../component/PageLoading'
import { BannerModel, ProcessBanner } from '../../model/BannerModel';
import {
  appWhite,
  backRed,
  textBlack,
  textGray,
  textLightGray,
  textRed,
  textWhite,
  textYellow
} from '../../base/color';
import resourceManager from '@ohos.resourceManager';
import image from '@ohos.multimedia.image';
import { goWebView } from '../../utils/Routers';

@Entry
@Component
struct DetailPage {
  @State _id: string = ''
  @State _goodDetail: GoodDetail = null
  @State _banner: Array<string> = []
  @State _pageState: PageState = PageState.Loading
  brandIcon = 'https://yanxuan.nosdn.127.net/9f91c012a7a42c776d785c09f6ed85b4.png'

  /// 头部活动
  @State _activity: BannerModel = null

  aboutToAppear() {
    let id = router.getParams()['id'] as string
    this._id = id
    this._getDetailData()
  }

  _getDetailData() {
    axios.get<GoodDetailPre>(GOOD_DETAIL, {
      params: {
        "id": this._id,
      }
    }).then(res => {

      let item = res.data.item
      console.log('==============size', `${item.id}`);
      this._goodDetail = item
      this.bannerData(item)
      this._activity = item.banner
      this._pageState = PageState.Success

    }
    ).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  bannerData(item: GoodDetail) {
    let banner = new Array<string>()
    let itemDetail = item.itemDetail
    console.log('==============success', '1111');
    console.log('==============success', `${JSON.stringify(item.itemDetail)}`);
    console.log('==============success', '22222');
    // for (let key in keys) {
    //   if (key.startsWith('picUrl')) {
    //     console.log('==============success','3333');
    //     banner.push('https://yanxuan-item.nosdn.127.net/0aebf2f204251913a109f83e8a811875.png')
    //     console.log('==============success','4444');
    //     // banner.push(itemDetail[key])
    //   }
    // }
    banner.push(itemDetail.picUrl1)
    banner.push(itemDetail.picUrl2)
    banner.push(itemDetail.picUrl3)
    banner.push(itemDetail.picUrl4)
    banner.push(itemDetail.picUrl5)
    console.log('==============size', `${banner.length}`);
    this._banner = banner
  }

  build() {
    if (this._pageState == PageState.Loading) Column() {
      PageLoading()
    }.width('100%').height('100%').align(Alignment.Center).justifyContent(FlexAlign.Center)
    else List() {
      ListItem() {
        this.bannerView()
      }

      ListItem() {
        this.topActivities()
      }

      ListItem() {
        ///banner下面图片
        this.featuredSeries(this._goodDetail.featuredSeries)
      }

      if (this._goodDetail.showPrice)
      ListItem() {
        ///商品价格，showPrice字段控制
        this.promBanner()
      }
      if (this._goodDetail.spmcBanner != null)
      ListItem() {
        ///pro会员
        this.proVip(this._goodDetail.spmcBanner)
      }

      ListItem() {
        ///商品名称
        this.goodTitle()
      }

      if (this._goodDetail.simpleBrandInfo != null)
      ListItem() {
        ///品牌名称(网易严选)
        this.yanxuanIcon(this._goodDetail.simpleBrandInfo)
      }

      ListItem() {
        /// 推荐理由
        this.recommendReason()
      }

      if (this._goodDetail.welfareCardVO != null)
      ListItem() {
        ///活动卡
        Image(this._goodDetail.welfareCardVO.picUrl ?? '').width('100%')
      }
    }
  }

  @Builder
  recommendReason() {
    Column() {
      Text('推荐理由').fontSize(12).fontColor(textBlack)
      if (this._goodDetail.recommendReason == null || this._goodDetail.recommendReason.length == 0)
        Text(this._goodDetail.simpleDesc ?? '').fontSize(14).fontColor(textBlack)
      else Column() {
        ForEach(this._goodDetail.recommendReason, (item: string, index: number) => {
          Row() {
            Text(index + '')
              .fontColor(textRed)
              .fontSize(12)
              .width(14)
              .height(14)
              .textAlign(TextAlign.Center)
              .border({ width: 1, color: backRed })
              .borderRadius(7)
              .padding({ bottom: 2 })
            Text(item ?? '').fontSize(12).fontColor(textBlack)
          }.margin({ top: 2 })
        })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .align(Alignment.Start)
      .padding(10)
      .border({ width: 1, color: 0XFFE6E6E6 })
      .borderRadius(2)
      .backgroundColor(0XFFFAFAFA)
    }
    .padding({ left: 10, right: 10, top: 8 })
    .alignItems(HorizontalAlign.Start)
    .align(Alignment.Start)
  }

  @Builder
  yanxuanIcon(simpleBrandInfo: SimpleBrandInfo) {
    Row() {
      if (simpleBrandInfo.ownType == 1)
        Image($r('app.media.ziying_tag')).width(32)
      Image(simpleBrandInfo.logoUrl ?? this.brandIcon).height(14).margin({ left: 3 })
      Text(simpleBrandInfo.title ?? '').fontSize(14).fontColor(0xFF7F7F7F).margin({ left: 3 })
      if (this._goodDetail.countryInfo != null)
        Text(` ｜ ${this._goodDetail.countryInfo ?? ''}`).fontSize(14).fontColor(0xFF7F7F7F)
    }.alignItems(VerticalAlign.Center).padding({ left: 10 })
  }

  @Builder
  goodTitle() {
    Row() {
      Text(this._goodDetail.name??'').layoutWeight(1).fontColor(textBlack).fontSize(15).fontWeight(600)
      if (this._goodDetail.commentCount > 0)
        if (this._goodDetail.goodCmtRate == null) Text('查看评价').fontSize(12).fontColor(textBlack)
        else Row() {
          Column() {
            Text(this._goodDetail.goodCmtRate??'').fontSize(16).fontColor(textRed)
            Text('好评率').fontSize(12).fontColor(textGray)
          }

          Image($r('app.media.arrow_right')).size({ height: 12 })
        }
    }
    .margin({ top: 8 })
    .padding({ left: 10, right: 10 })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  proVip(spmcBanner: SpmcBanner) {
    Row() {
      Image($r('app.media.pro_icon')).size({ height: 12 })
      Text(`${spmcBanner.spmcDesc??''}${spmcBanner.spmcPrice??''}`).fontSize(12).fontColor(textBlack).layoutWeight(1)
      Text('开通').fontSize(12).fontColor(textYellow)
    }
    .backgroundColor(0XFFFFF1D2)
    .borderRadius(6)
    .margin({ left: 10, right: 10, top: 8 })
    .padding({ left: 10, right: 10, top: 8, bottom: 8 })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  promBanner() {
    if (this._goodDetail.detailPromBanner == null && this._goodDetail.price != null)
    Row() {
      Text('¥').fontSize(14).fontColor(textBlack)
      Text(this._goodDetail.price.basicPrice).fontSize(24).fontColor(textBlack).fontWeight(600)
      Text(this._goodDetail.price.counterPrice)
        .fontSize(14)
        .fontColor(textBlack)
        .fontWeight(600)
        .decoration({ type: TextDecorationType.LineThrough })
    }.alignItems(VerticalAlign.Bottom)
    else Rect()
  }

  @Builder
  featuredSeries(featuredSeries: FeaturedSeries) {
    if (featuredSeries != null)
      Image(featuredSeries.detailPicUrl??'').width('100%').onClick(e => {
        goWebView(`${baseUrl}/featuredSeries/detail?id=${featuredSeries.id}`)
      })
    else Rect()
  }

  @Builder
  topActivities() {
    if (this._activity.processBanner != null)
    Row() {
      Column() {
        Text(this.getActivityData(this._activity.processBanner))
          .fontSize(12)
          .fontColor(textWhite)
        if (this._goodDetail.price.finalPrice != null)Row() {
          Row() {
            Text('¥').fontSize(14).fontColor(textWhite)
            Text(this._goodDetail.price.basicPrice).fontSize(24).fontColor(textWhite).fontWeight(600)
          }.alignItems(VerticalAlign.Bottom)

          Row() {
            Text(`${this._goodDetail.price.finalPrice.prefix} ¥`).fontSize(12).fontColor(textRed)
            Text(`${this._goodDetail.price.finalPrice.price}`).fontSize(16).fontColor(textRed).fontWeight(600)
          }
          .margin({ left: 10 })
          .padding({ left: 4, right: 4 })
          .borderRadius(10)
          .backgroundColor(appWhite)
        }.alignItems(VerticalAlign.Center)
        else Row() {
          Text('¥').fontSize(12).fontColor(textWhite)
          Text(this._goodDetail.price.basicPrice).fontSize(24).fontColor(textWhite).fontWeight(600)
          if (this._goodDetail.price.counterPrice != this._goodDetail.price.basicPrice)
          Row() {
            Text('¥')
              .fontSize(12)
              .fontColor(textWhite)
              .decoration({ type: TextDecorationType.LineThrough })
              .margin({ left: 4 })
            Text(this._goodDetail.price.counterPrice)
              .fontSize(12)
              .fontColor(textWhite)
              .decoration({ type: TextDecorationType.LineThrough })
          }
        }.alignItems(VerticalAlign.Bottom)
      }
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceAround)

      Image(this._activity.processBanner.logoUrl??'').size({ height: 40, width: 40 })
    }
    .width('100%')
    .height(60)
    .backgroundColor(this._activity.processBanner.bgColor??'#E53B44')
    .padding({ left: 10, right: 10 })
    .justifyContent(FlexAlign.SpaceBetween)
    else Rect()
  }

  getActivityData(processBanner: ProcessBanner): string {
    let activeData = new ActivityData()
    let hour = 0
    let day = 0
    var countdown = processBanner.endTimeGap
    if (countdown != null && countdown > 0) {
      let d = countdown;
      console.log('-----------time', d + '')
      let e = Math.floor(d / 1000)
      console.log('-----------time', e + '')
      let f = Math.floor(e / 3600)
      console.log('-----------time', f + '')
      hour = Math.floor(f % 24)
      console.log('-----------time', hour + '')
      day = Math.floor(f / 24)
      console.log('-----------time', day + '')
    }
    activeData.day = day
    activeData.hour = hour
    let decStr = processBanner.title == null ? '' : `${processBanner.title} ｜ `
    if (hour > 0) {
      decStr += '距结束'
      if (day > 0) {
        decStr += day + '天'
      }
      decStr += hour + '小时'
    }
    return decStr
  }

  @Builder
  bannerView() {
    Swiper() {
      ForEach(this._banner, (item: string) => {
        Image(item).width('100%').height('100%')
      })
    }.width('100%').aspectRatio(1).autoPlay(true)
  }
}

class ActivityData {
  day: number = 0
  hour: number = 0

  constructor() {
  }
}