import axios from '@ohos/axios';
import router from '@ohos.router';
import { baseUrl, DETAIL_AND_USER, GOOD_DETAIL, WAPITEM_DELIVERY, WAPITEM_RCMD } from '../../base/Api';
import { ResponseData } from '../../base/BaseModel';
import { GoodDetailPre } from '../../model/detail/GoodDetailPre';
import { HotListData } from '../../model/hotlist/HotListData';
import { CustomDialog01 } from '../../component/CustomDialog01'
import {
  AdBannersItem,
  AttrListItem,
  BrandInfo,
  FeaturedSeries,
  FullRefundPolicy,
  GoodDetail,
  PromotionSimple,
  SimpleBrandInfo,
  SpmcBanner
} from '../../model/detail/GoodDetail';
import { PageState } from '../../base/PageState';
import { PageLoading } from '../../component/PageLoading'
import { BannerModel, ProcessBanner } from '../../model/BannerModel';
import {
  appWhite,
  backBlack,
  backgroundColor,
  backRed,
  lineColor,
  textBlack,
  textGray,
  textLightGray,
  textRed,
  textWhite,
  textYellow
} from '../../base/color';
import resourceManager from '@ohos.resourceManager';
import image from '@ohos.multimedia.image';
import { goWebView, pageIndex } from '../../utils/Routers';
import { WapitemDeliveryModel } from '../../model/detail/WapitemDeliveryModel';
import { HdrkDetailVOListItem, PolicyListItem } from '../../model/SkuMapValue';
import { CommentItemView } from '../../component/CommentItem';
import { IssueListItem } from '../../model/IssueListItem';
import { ItemListItem } from '../../model/ItemListItem';
import { GoodItem } from '../../component/GoodItem';
import { RecommendModel } from '../../model/detail/RecommendModel';
import display from '@ohos.display';
import { TopData } from '../../model/topic/TopData';
import { CouponModel } from '../../model/CouponModel';

@Entry
@Component
struct DetailPage {
  @State _id: string = ''
  @State _primarySkuId: string = ''
  @State _policyList: Array<PolicyListItem> = []
  @State _goodDetail: GoodDetail = null
  @State _banner: Array<string> = []
  @State _pageState: PageState = PageState.Loading
  brandIcon = 'https://yanxuan.nosdn.127.net/9f91c012a7a42c776d785c09f6ed85b4.png'
  backColor = 0xFFF2F4F9
  @State _deliveryModel: WapitemDeliveryModel = null
  @State _detailImages: Array<string> = []
  @State _rcmdData: Array<ItemListItem> = []
  _scroller = new Scroller()
  /// 头部活动
  @State _activity: BannerModel = null
  @State _showTop: boolean = false
  @State _topData: Array<DetailTop> = [new DetailTop('商品', 0), new DetailTop('评价', 1), new DetailTop('详情', 2), new DetailTop('推荐', 3)]
  @State _topIndex: number = 0
  @State _coupon: Array<CouponModel> = []
  _controller: CustomDialogController = null

  aboutToAppear() {
    this._id = router.getParams()['id'] as string
    this._primarySkuId = router.getParams()['skuId'] as string
    this._getDetailData()
    this._queryByItemAndUser()
    this._recommend()
  }

  _getDetailData() {
    axios.get<GoodDetailPre>(GOOD_DETAIL, {
      params: {
        "id": this._id,
      }
    }).then(res => {
      let item = res.data.item
      this._policyList = res.data.policyList
      this._goodDetail = item
      this.getAllPic(item)
      this.bannerData(item)
      this._activity = item.banner
      this._pageState = PageState.Success
      this._wapitemDelivery(item.primarySkuId)
    }
    ).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  _queryByItemAndUser() {
    axios.get<ResponseData<Array<CouponModel>>>(DETAIL_AND_USER, {
      params: {
        'itemId': this._id,
        'skuId': this._primarySkuId
      }
    }).then(res => {
      this._coupon = res.data.data
    }
    ).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  _recommend() {
    axios.get<ResponseData<RecommendModel>>(WAPITEM_RCMD, {
      params: {
        "id": this._id,
      }
    }).then(res => {
      this._rcmdData = res.data.data.items
    }
    ).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  _wapitemDelivery(skuId: number) {
    axios.get<ResponseData<WapitemDeliveryModel>>(WAPITEM_DELIVERY, {
      params: {
        'type': 2,
        'provinceId': 110000,
        'cityId': 110100,
        'districtId': 110101,
        'townId': 110101001000,
        'provinceName': '北京市',
        'cityName': '北京市',
        'districtName': '东城区',
        'townName': '东华门街道',
        'address': '',
        'skuId': skuId
      }
    }).then(res => {
      this._deliveryModel = res.data.data
    }
    ).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  bannerData(item: GoodDetail) {
    let banner = new Array<string>()
    let itemDetail = item.itemDetail
    banner.push(itemDetail.picUrl1)
    banner.push(itemDetail.picUrl2)
    banner.push(itemDetail.picUrl3)
    banner.push(itemDetail.picUrl4)
    banner.push(itemDetail.picUrl5)
    this._banner = banner
  }

  build() {
    if (this._pageState == PageState.Loading) Column() {
      PageLoading()
    }.width('100%').height('100%').align(Alignment.Center).justifyContent(FlexAlign.Center)
    else Stack() {
      List({ scroller: this._scroller }) {
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
          Image(this._goodDetail.welfareCardVO.picUrl ?? '').width('100%').margin({ top: 10 }).onClick(e => {
            goWebView(this._goodDetail.welfareCardVO.schemeUrl)
          })
        }

        ///规则
        ListItem() {
          if (this._goodDetail.fullRefundPolicy != null
            && this._goodDetail.fullRefundPolicy.titles != null
            && this._goodDetail.fullRefundPolicy.titles.length > 0)
            this.fullRefundPolicy()
        }

        ListItem() {
          this.selectProperty()
        }

        ListItem() {
          if (this._goodDetail.adBanners != null)
          Swiper() {
            ForEach(this._goodDetail.adBanners, (item: AdBannersItem) => {
              Image(item.picUrl)
            })
          }.height(100).width('100%').autoPlay(true)
        }

        ListItem() {
          this.split()
        }

        ///用户评价
        ListItem() {
          this.detailComment()
        }

        ///_brandInfo
        if (this._goodDetail.brandInfo != null)
        ListItem() {
          this.brandInfo(this._goodDetail.brandInfo)
        }

        ListItem() {
          this.split()
        }

        ///商品详情
        ListItem() {
          this.detail()
        }

        ///常见问题
        ListItem() {
          this.issueList()
        }

        ///推荐
        ListItem() {
          this.recommend()
        }
      }
      .backgroundColor(appWhite)
      .sticky(StickyStyle.Header)
      .onScrollIndex((start, end) => {
        if (start >= 0 && start < 9) {
          if (this._topIndex != 0) {
            this._topIndex = 0
          }
        } else if (start >= 10 && start < 11) {
          if (this._topIndex != 1) {
            this._topIndex = 1
          }
        } else if (start >= 11 && start < 14) {
          if (this._topIndex != 2) {
            this._topIndex = 2
          }
        } else if (start > 14) {
          if (this._topIndex != 3) {
            this._topIndex = 3
          }
        }

        if (start >= 1) {
          if (!this._showTop) {
            this._showTop = true
          }
        } else {
          if (this._showTop) {
            this._showTop = false
          }
        }
      })

      this.header()
    }.alignContent(Alignment.TopStart)
  }

  showDialog() {

  }

  @Builder
  header() {
    if (this._showTop)
    Row() {
      Image($r('app.media.back')).size({ width: 30 }).padding(4).margin({ left: 12, right: 12 }).onClick(e => {
        router.back()
      })
      ForEach(this._topData, (item: DetailTop, index: number) => {
        RelativeContainer() {
          Text(item.tile)
            .fontSize(14)
            .fontColor(this._topIndex == index ? textRed : textBlack)
            .id('tile')
            .relativeCenter()
          Rect()
            .width(40)
            .height(2)
            .fill(this._topIndex == index ? textRed : Color.Transparent)
            .margin({ bottom: 1 })
            .id('line')
            .relativeBottomCenter()
        }.layoutWeight(1).height('100%').onClick(e => {
          if (item.index == 0) {
            this._scroller.scrollTo({ xOffset: 0, yOffset: 0, animation: { duration: 2000, curve: Curve.Linear } })
          } else if (item.index == 1) {
            this._scroller.scrollToIndex(10)
          } else if (item.index == 2) {
            this._scroller.scrollToIndex(12)
          } else if (item.index == 3) {
            this._scroller.scrollToIndex(15)
          }
        })
      })
    }
    .height(42)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .backgroundColor(appWhite)
    .border({ width: { bottom: 0.5 }, color: { bottom: 0xFFECECEC } })

    else Image($r('app.media.back'))
      .size({ width: 30, height: 30 })
      .backgroundColor(appWhite)
      .borderRadius(15)
      .border({ width: 1, color: 0xFFDEDEDE })
      .margin({ left: 15, top: 15 })
      .onClick(e => {
        router.back()
      })
  }

  @Builder
  recommend() {
    Column() {
      Text('你还可能喜欢').fontSize(16).fontColor(textBlack).margin({ top: 20, bottom: 12 })
      GridRow({ columns: 2, gutter: 8 }) {
        ForEach(this._rcmdData, (item: ItemListItem) => {
          GridCol() {
            GoodItem(item)
          }
        })
      }
    }.padding({ left: 12, right: 12 })
  }

  @Builder
  issueList() {
    Column() {
      Text('常见问题').fontSize(16).fontColor(textBlack).margin({ top: 20, bottom: 12 })
      ForEach(this._goodDetail.issueList ?? [], (item: IssueListItem) => {
        Column() {
          Row() {
            Rect().size({ width: 4, height: 4 }).borderRadius(2).fill(backRed)
            Text(item.question).fontSize(14).fontColor(textBlack).margin({ left: 3 })
          }

          Text(item.answer).fontColor(textGray).fontSize(12).margin({ top: 8 })
        }.alignItems(HorizontalAlign.Start).margin({ top: 8 })
      })
    }
    .width('100%')
    .padding({ left: 12, right: 12 })
  }

  @Builder
  detail() {
    Column() {
      Text('商品参数').fontSize(14).fontColor(textBlack).margin({ left: 12, top: 10 })
      /// 成分
      Column() {
        ForEach(this._goodDetail.attrList ?? [], (item: AttrListItem) => {
          Row() {
            Text(item.attrName).layoutWeight(1).fontColor(textLightGray).fontSize(12)
            Text(item.attrValue).layoutWeight(2).fontColor(textBlack).fontSize(14)
          }.border({ width: { top: 1 }, color: { top: textGray }, style: BorderStyle.Dashed })
          .padding({ top: 6, bottom: 6 })
        })
      }.border({ width: 1, color: { bottom: textGray, left: textGray, right: textGray }, style: BorderStyle.Dashed })
      .margin({ left: 12, right: 12, top: 10 })

      Column() {
        ForEach(this._detailImages, (item: string) => {
          Image(item).width('100%')
        })
      }.margin({ top: 12 })
    }
    .alignItems(HorizontalAlign.Start)
  }

  getHtml() {
    let html = this._goodDetail.itemDetail.detailHtml.replace(/p>/g, "span>");
    return html
  }

  getAllPic(goodDetail: GoodDetail) {
    let html = goodDetail.itemDetail.detailHtml
    let strs = html.split('"')

    let detailImages: Array<string> = []
    strs.forEach(item => {
      if (item.concat('http')) {
        detailImages.push(item)
      }
    })
    this._detailImages = detailImages
  }

  @Builder
  brandInfo(brandInfo: BrandInfo) {
    Column() {
      this.split()
      Row() {
        Column() {
          Rect().height(16)
          Image(brandInfo.picUrl).size({ width: 35, height: 35 })
          if (brandInfo.ownType == 2)
            Image('https://yanxuan.nosdn.127.net/9f91c012a7a42c776d785c09f6ed85b4.png').size({ width: 12, height: 12 })
          else Rect().height(16)
        }

        Column() {
          Row() {
            Text(brandInfo.title ?? '').fontSize(16).fontColor(textBlack).fontWeight(600)
            ArrowIcon()
          }.width('100%').justifyContent(FlexAlign.SpaceBetween)

          Text(brandInfo.desc).fontSize(12).fontColor(textBlack).margin({ top: 12 })
        }.layoutWeight(1).margin({ left: 12 })
      }.padding(12)
    }.onClick(e=>{
      router.pushUrl({
        url: pageIndex.brandPage,
        params: { 'brandInfo': brandInfo, 'id': this._id }
      })
    })
  }

  @Builder
  detailComment() {
    Column() {
      Row() {
        Text(`用户评价${this._goodDetail.commentCount}`).fontSize(14).fontColor(textBlack)
        Row() {
          Text(`${this._goodDetail.goodCmtRate ?? ''}`).fontColor(textRed).fontSize(16)
          Text(`${this._goodDetail.goodCmtRate == null ? '查看全部' : '好评率'}`).fontSize(14).fontColor(textBlack)
          ArrowIcon()
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .propertyStyle()
      .onClick(e => {
        router.pushUrl({ url: pageIndex.commentsPage, params: { 'id': this._id } })
      })

      if (this._goodDetail.comments != null && this._goodDetail.comments.length > 0)
        CommentItemView(this._goodDetail.comments[0])
    }
  }

  @Builder
  selectProperty() {
    Column() {
      this.split()
      ///领券
      if (this._goodDetail.promotionSimpleList != null
        && this._goodDetail.promotionSimpleList.length > 0)
      Row() {
        Text('领券：').fontSize(14).fontColor(textBlack)
        Row() {
          ForEach(this._goodDetail.promotionSimpleList, (item: PromotionSimple) => {
            Row() {
              Text(item.name ?? '')
                .fontSize(10)
                .fontColor(textWhite)
                .fontWeight(600)
                .padding({ left: 5, right: 5, top:3, bottom: 3 })
                .borderRadius(4)
                .backgroundColor(backRed)

              Text(item.desc ?? '')
                .fontSize(10)
                .fontWeight(600)
                .fontColor(textRed)
                .borderRadius(4)
                .padding(1)
                .border({ width: 2, color: backRed })
            }.margin({ right: 6 })
          })
        }.layoutWeight(1)

        ArrowIcon()
      }
      .alignItems(VerticalAlign.Center)
      .propertyStyle()
      .onClick(e => {
        this.propertyDetail(Property.COUPON, '领券')
      })

      /// 邮费
      if (this._goodDetail.skuFreight != null)
      Row() {
        Text(`${this._goodDetail.skuFreight.title ?? ''}：`).fontSize(14).fontColor(textBlack)
        Text(this._goodDetail.skuFreight.freightInfo ?? '').fontSize(14).fontColor(textBlack).layoutWeight(1)
        ArrowIcon()
      }
      .alignItems(VerticalAlign.Center)
      .propertyStyle()
      .onClick(e => {
        this.propertyDetail(Property.SKUFREIGHT, this._goodDetail.skuFreight.title ?? '', this._goodDetail.skuFreight.policyList ?? [])
      })

      /// 促销
      if (this._goodDetail.hdrkDetailVOList != null && this._goodDetail.hdrkDetailVOList.length > 0)
      Row() {
        Text('促销：').fontSize(14).fontColor(textBlack)
        Column() {
          ForEach(this._goodDetail.hdrkDetailVOList, (item: HdrkDetailVOListItem) => {
            Row() {
              Text(item.activityType)
                .fontSize(10)
                .fontColor(textRed)
                .border({ color: backRed, width: 1 })
                .borderRadius(8)
                .padding(2)
              Column() {
                Text(item.name).fontSize(12).fontColor(textBlack)
                if (item.promLimitDesc != null)
                  Text(item.promLimitDesc ?? '').fontSize(10).fontColor(textGray)
              }.alignItems(HorizontalAlign.Start).margin({ left: 4 })
            }
          })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        ArrowIcon()
      }.alignItems(VerticalAlign.Center)
      .propertyStyle()

      /// 购物反
      if (this._goodDetail.shoppingReward != null)
      Row() {
        Text(`${this._goodDetail.shoppingReward.name ?? ''}：`).fontSize(14).fontColor(textBlack)
        Text(`${this._goodDetail.shoppingReward.rewardDesc ?? ''}`).fontSize(14).fontColor(textBlack)
        Text(this._goodDetail.shoppingReward.rewardValue ?? '').fontSize(14).fontColor(textRed).layoutWeight(1)
        ArrowIcon()
      }
      .alignItems(VerticalAlign.Center)
      .propertyStyle()
      .onClick(e => {
        this.propertyDetail(Property.SHOPPINGREWARD, this._goodDetail.shoppingRewardRule.title ?? '', this._goodDetail.shoppingRewardRule.ruleList ?? [])
      })

      this.split()
      ///选择属性
      Row() {
        Text('请选择规格参数').fontSize(14).fontColor(textBlack)
        ArrowIcon()
      }
      .alignItems(VerticalAlign.Center)
      .propertyStyle()

      /// 限制
      if (this._goodDetail.itemLimit != null && this._goodDetail.itemLimit != '')
      Row() {
        Text('限制：').fontSize(14).fontColor(textBlack)
        Text(this._goodDetail.itemLimit ?? '').fontSize(14).fontColor(textBlack).layoutWeight(1)
        ArrowIcon()
      }
      .alignItems(VerticalAlign.Center)
      .propertyStyle()

      ///配送
      if (this._deliveryModel != null)
      Row() {
        Text('配送：').fontSize(14).fontColor(textBlack)
        Column() {
          Text(this._deliveryModel.addressName)
            .fontColor(textBlack)
            .fontSize(14)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          if (this._deliveryModel.deliveryTime != null)
            Text(this._deliveryModel.deliveryTime).fontColor(textGray).fontSize(14)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        ArrowIcon()
      }
      .alignItems(VerticalAlign.Center)
      .propertyStyle()

      ///服务
      if (this._policyList != null && this._policyList.length > 0)
      Row() {
        Text('服务：').fontSize(14).fontColor(textBlack)
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this._policyList, (item: PolicyListItem) => {
            Row() {
              Rect().size({ width: 4, height: 4 }).borderRadius(2).fill(backRed)
              Text(item.title).fontSize(14).fontColor(textGray).margin({ left: 2 })
            }.margin({ right: 12 })
          })
        }
        .layoutWeight(1)

        ArrowIcon()
      }
      .alignItems(VerticalAlign.Center)
      .propertyStyle()
      .onClick(e => {
        this.propertyDetail(Property.POLICY, '服务', this._policyList ?? [])
      })

    }
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 10, bottom: 10 })
  }

  @Builder
  couponDetail() {
    Column() {
      ForEach(this._coupon, (item: CouponModel) => {
        Column() {
          Row() {
            Row() {
              Text(item.briefDesc).fontSize(30).fontWeight(600).fontColor(textWhite)
              Text('元').fontSize(15).fontWeight(600).fontColor(textWhite)
            }.alignItems(VerticalAlign.Bottom)

            Column() {
              Text(item.name).fontSize(14).fontWeight(600).fontColor(textWhite)
              Text(item.timeDesc).fontSize(10).fontWeight(600).fontColor(textWhite)
            }.alignItems(HorizontalAlign.Start)

            Text()
              .fontSize(14)
              .fontColor(textRed)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .backgroundColor(0xffe65e5f)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceEvenly)
          .padding({ top: 30, bottom: 30, left: 20, right: 20 })
          .backgroundColor(0xfff4948a)

          Text(item.useCondition)
            .width('100%')
            .padding({ left: 16, top: 12, bottom: 12, right: 16 })
            .backgroundColor(0xffeb7073)
        }.width('100%')
      })
    }.padding({ left: 12, right: 12 })
  }

  propertyDetail(property: Property, title: string, data?: FullRefundPolicy | Array<PolicyListItem>) {
    this._controller = new CustomDialogController({
      builder: CustomDialog01({
        title: title,
        content: () => {
          if (property == Property.SKUFREIGHT ||
            property == Property.SHOPPINGREWARD ||
            property == Property.POLICY)
            this.skuFreightDetail(data as Array<PolicyListItem>)
          else if (Property.COUPON) this.couponDetail()
          else this.empty()
        },
        controller: this._controller
      }),
      alignment: DialogAlignment.Bottom,
      customStyle: true
    })
    this._controller.open()
  }

  @Builder
  skuFreightDetail(data: Array<PolicyListItem>) {
    Column() {
      ForEach(data, (item: PolicyListItem) => {
        Column() {
          Text(item.title).fontColor(textBlack).textAlign(TextAlign.Start)
          Text(item.content).fontSize(12).fontColor(textGray).textAlign(TextAlign.Start).padding({ top: 4, bottom: 8 })
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%').padding({ bottom: 30, top: 16 })
        .padding({ left: 12, right: 12 })
      })
    }
    .padding({ top: 16 })
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  fullRefundPolicy() {
    Row() {
      Text('规则').fontSize(14).fontColor(textBlack)
      Column() {
        ForEach(this._goodDetail.fullRefundPolicy.titles ?? [], (item: string) => {
          Row() {
            Rect().size({ width: 4, height: 4 }).borderRadius(2).fill(backRed)
            Text(item).fontSize(14).fontColor(textBlack).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
          }
        })
      }.alignItems(HorizontalAlign.Start)
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
              .fontSize(10)
              .width(14)
              .height(14)
              .textAlign(TextAlign.Center)
              .border({ width: 1, color: backRed })
              .borderRadius(7)
              .padding({ bottom: 2 })
            Text(item ?? '').fontSize(12).fontColor(textBlack).margin({ left: 2 })
          }
          .alignItems(VerticalAlign.Center)
          .margin({ top: 4 })
        })
      }
      .margin({ top: 4 })
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
      Text(this._goodDetail.name ?? '').layoutWeight(1).fontColor(textBlack).fontSize(15).fontWeight(600)
      if (this._goodDetail.commentCount > 0)
        if (this._goodDetail.goodCmtRate == null) Text('查看评价').fontSize(12).fontColor(textBlack)
        else Row() {
          Column() {
            Text(this._goodDetail.goodCmtRate ?? '').fontSize(16).fontColor(textRed)
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
      Row() {
        Text(`${spmcBanner.spmcDesc ?? ''}`)
          .fontSize(12)
          .fontColor(textBlack)
        Text(`${spmcBanner.spmcPrice ?? ''}`)
          .fontSize(12)
          .fontColor(textRed)
          .fontWeight(600)
      }.layoutWeight(1)

      Text('开通')
        .fontSize(12)
        .fontColor(textYellow)
        .backgroundColor(backBlack)
        .padding({ left: 8, top: 4, right: 8, bottom: 4 })
        .borderRadius(12)
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
    .padding(12)
    else Rect()
  }

  @Builder
  featuredSeries(featuredSeries: FeaturedSeries) {
    if (featuredSeries != null)
      Image(featuredSeries.detailPicUrl ?? '').width('100%').onClick(e => {
        goWebView(`${baseUrl}/featuredSeries/detail?id=${featuredSeries.id}`)
      })
    else Rect()
  }

  @Builder
  topActivities() {
    if (this._activity != null && this._activity.processBanner != null)
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

      Image(this._activity.processBanner.logoUrl ?? '').size({ height: 40 })
    }
    .width('100%')
    .height(60)
    .backgroundColor(this._activity.processBanner.bgColor ?? '#E53B44')
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

  @Builder
  split() {
    Rect().width('100%').fill(this.backColor).height(10)
  }

  @Builder
  empty() {
    Rect()
  }
}

class DetailTop {
  tile: string
  index: number = 0

  constructor(tile: string, index: number) {
    this.tile = tile
    this.index = index
  }
}

@Builder
function ArrowIcon() {
  Image($r('app.media.arrow_right')).size({ height: 12, width: 12 })
}

@Styles
function propertyStyle() {
  .width('100%')
  .padding({ top: 12, right: 24, bottom: 12 })
  .margin({ left: 12 })
  .border({ width: { bottom: 1 }, color: { bottom: 0xFFF2F4F9 } })
}

@Styles
function relativeCenter() {
  .alignRules(
    {
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    }
  )
}

@Styles
function relativeBottomCenter() {
  .alignRules(
    {
      center: { anchor: '__container__', align: VerticalAlign.Bottom },
      middle: { anchor: '__container__', align: HorizontalAlign.Center }
    }
  )
}

class ActivityData {
  day: number = 0
  hour: number = 0

  constructor() {
  }
}

enum Property {
  COUPON,
  SKUFREIGHT,
  SHOPPINGREWARD,
  POLICY
}