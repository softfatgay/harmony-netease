import axios from '@ohos/axios'
import router from '@ohos.router'
import { HOT_LIST_CAT, HOT_LIST_LIST, SUBMIT_ORDER_INFO, URL_HOME_NEW } from '../base/Api'
import { ResponseData } from '../base/BaseModel'
import { HotListNav } from '../model/hotlist/NavCat'
import { ItemListItem } from '../model/ItemListItem'
import { HotListData } from '../model/hotlist/HotListData'
import { appRed, appWhite, backgroundColor, backRedLight, textBlack, textGray, textRed, textWhite } from '../base/color'
import { CurrentCategory } from '../model/sort/CurrentCategory'
import { PageLoading } from '../component/PageLoading'
import { GoodItem, GoodTagName } from '../component/GoodItem'
import { ItemTagListItem } from '../model/ItemTagListItem'
import { dftAvatarIcon } from '../base/Url'
import { pageIndex } from '../utils/Routers'
import { PageState } from '../base/PageState'

@Entry
@Component
struct HotPage {
  @State private _categoryId: string = ''
  @State private _dataList: Array<ItemListItem> = []
  @State private submitInfo: Array<string> = []
  @State private hotListNav: HotListNav = null
  @State private subCateList: Array<CurrentCategory> = []
  @State private currentIndex: number = 0
  private _subCategoryId: number = 0
  private _bannerUrl: string = "https://yanxuan.nosdn.127.net/294b914321c27e2490b257b5b6be6fa5.png";
  @State _pageState: PageState = PageState.Loading

  aboutToAppear() {
    let categoryId = router.getParams()['categoryId'] as string
    this._categoryId = categoryId
    console.log('++++++++++++' + this._categoryId)
    this._getCat()
    this._getItemList()
    this._getSubmitInfo()
  }

  _getItemList() {
    console.log('===============sss',this._categoryId);
    console.log('===============sss',this._subCategoryId);
    this._pageState = PageState.Loading
    axios.get<ResponseData<HotListData>>(HOT_LIST_LIST, {
      params: {
        "categoryId": this._categoryId,
        "subCategoryId": this._subCategoryId,
        "userBusId": '',
      }
    }).then(res => {
      this._dataList = res.data.data.itemList
      this._pageState = PageState.Success
    }
    ).catch(err => {
      this._pageState = PageState.Error
      console.log(err)
    })
  }

  _getCat() {
    axios.get<HotListNav>(HOT_LIST_CAT, {
      params: {
        "categoryId": this._categoryId,
        "subCategoryId": this._subCategoryId
      }
    }).then(res => {
      let hotListNav = res.data
      let list = new Array<CurrentCategory>()
      let currentCategory = hotListNav.currentCategory
      currentCategory.name = '全部'
      list.push(currentCategory)
      let newList = list.concat(currentCategory.subCateList)
      this.subCateList = newList
      this.hotListNav = res.data
    }
    ).catch(err => {
      console.log(err)
    })
  }

  _getSubmitInfo() {
    axios.get<ResponseData<Array<string>>>(SUBMIT_ORDER_INFO, {
      params: {
        "categoryId": this._categoryId,
        "subCategoryId": 0
      }
    }).then(res => {
      this.submitInfo = res.data.data
    }
    ).catch(err => {
      console.log(err)
    })
  }

  build() {
    Stack() {
      Column() {
        Stack() {
          this.header()
          List() {
            ListItem() {
              Swiper() {
                ForEach(this.submitInfo, (item: string) => {
                  Text(item).fontSize(12).fontColor(Color.White)
                })
              }
              .backgroundColor('#0000001A')
              .borderRadius(10)
              .padding({ left: 20, right: 20 })
              .vertical(true)
              .autoPlay(true)
              .indicator(false)
              .height(20)
              .margin({ top: 120, bottom: 30 })
            }.width('100%')

            ListItemGroup({ header: this.stick() }) {
              ForEach(this._dataList, (item: ItemListItem, index: number) => {
                ListItem() {
                  this.itemView(item, index)
                }
              })
            }
          }
          .padding({ left: 12, right: 12 })
          .sticky(StickyStyle.Header)
        }.align(Alignment.Top)
      }
      .width('100%')
      .backgroundColor(backgroundColor)

      if (this._pageState == PageState.Loading)
        PageLoading()
    }.height('100%').width('100%').alignContent(Alignment.Center)
  }

  @Builder
  itemView(item: ItemListItem, index: number) {
    Column() {
      Row() {
        Stack() {
          Image(item.listPicUrl)
            .width('100%')
            .height('100%')
            .borderRadius(6)
          this._sortIcon(index)
        }
        .height(120)
        .width(120)
        .alignContent(Alignment.TopStart)

        Column() {
          GoodTagName(item)
          /// 好评率
          Row() {
            if (item.goodCmtRate != null) Row() {
              Image($r('app.media.zan'))
                .size({ width: 12, height: 12 })
                .backgroundColor(Color.White)
                .borderRadius(6)
                .padding(2)
              Text(`${item.goodCmtRate}好评率`).fontSize(10).fontColor(textWhite)
            }.linearGradient({
              direction: GradientDirection.Right, // 渐变方向
              repeating: false, // 渐变颜色是否重复
              colors: [[0xFFCF2524, 0.0], [0xFFFFA77E, 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
            })
            .height(14)
            .padding({ left: 1, right: 6, top: 1, bottom: 1 })
            .borderRadius(6)

            ForEach(item.itemTagList ?? [], (item: ItemTagListItem) => {
              Text(item.name)
                .fontSize(10)
                .fontColor(textWhite)
                .backgroundColor(backRedLight)
                .padding(2)
                .borderRadius(6)
            })
          }
          .width('100%')
          .align(Alignment.Start)
          .margin({ top: 10 })

          Row() {
            Text(`$${item.retailPrice}`)
              .fontSize(20)
              .fontColor(textRed)
              .fontWeight(600)
            Text(`$${item.counterPrice}`)
              .fontSize(12)
              .fontColor(textGray)
              .decoration({ type: TextDecorationType.LineThrough })
          }
          .width('100%')
          .alignItems(VerticalAlign.Bottom)
          .margin({ top: 20 })
        }
        .layoutWeight(1)
        .padding(10)
      }
      .align(Alignment.TopStart)
      .alignItems(VerticalAlign.Top)
      .width('100%')

      if (item.hotSaleListBottomInfo != null)
      Row() {
        Image(item.hotSaleListBottomInfo.iconUrl ?? dftAvatarIcon)
          .height('100%')
          .borderRadius(10)
        Text(item.hotSaleListBottomInfo.content ?? '')
          .layoutWeight(1)
          .fontSize(12)
          .fontColor(textGray)
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .textAlign(TextAlign.Start)
          .padding({ left: 6, right: 6 })
      }
      .width('100%')
      .backgroundColor(0xFFF6F6F6)
      .borderRadius(10)
      .height(20)
      .margin({ top: 12 })
    }
    .padding(6)
    .width('100%')
    .backgroundColor(appWhite)
    .borderRadius(8)
    .margin({ top: 12 })
    .onClick(e => {
      router.pushUrl({ url: pageIndex.detailPage,
        params: { 'id': `${item.id}` }
      })
    })
  }

  @Builder
  _sortIcon(index: number) {
    if (index == 0)
      Image('https://yanxuan.nosdn.127.net/f1566323de5e538cfd1c1845685285f2.png')
        .size({ width: 25, height: 25 })
        .borderRadius(6)
    else if (index == 1)
      Image('https://yanxuan.nosdn.127.net/5d91018eda410767b27ec57b8bf9b929.png')
        .size({ width: 25, height: 25 })
        .borderRadius(6)
    else if (index == 1)
      Image('https://yanxuan.nosdn.127.net/89748e835b8ffb8a328d945bc2b9de93.png')
        .size({ width: 25, height: 25 })
        .borderRadius(6)
    else Text(`${index + 1}`)
      .size({ width: 20, height: 20 })
      .textAlign(TextAlign.Center)
      .backgroundColor(0xFFD2D3D2)
      .borderRadius(10)
  }

  @Builder
  stick() {
    Scroll() {
      Row() {
        Tabs() {
          ForEach(this.subCateList, (item: CurrentCategory, index: number) => {
            TabContent() {
            }
            .visibility(Visibility.Hidden)
            .size({ height: 0, width: 0 })
            .tabBar(this.TabBuilder(item, index))
          })
        }
        .barMode(BarMode.Scrollable)
        .height(46)
        .width('100%')
        .barHeight(46)
        .onChange(index => {
          this.currentIndex = index
        })
      }
      .backgroundColor(Color.White)
      .borderRadius(6)
      .alignItems(VerticalAlign.Center)
      .onClick(e=>{

      })
    }
    .scrollable(ScrollDirection.Vertical)
    .width('100%')
  }

  @Builder
  TabBuilder(item: CurrentCategory, index: number) {
    Column() {
      Text(item.name)
        .fontColor(this.currentIndex === index ? textRed : textBlack)
        .fontSize(14)
        .maxLines(1)
        .fontWeight(600)
      Rect().fill(this.currentIndex === index ? appRed : Color.Transparent).width(30).height(2).margin({ top: 6 })
    }
    .height('100%')
    .margin({ left: 12, right: 12 })
    .justifyContent(FlexAlign.Center)
    .onClick(e => {
      this.currentIndex = index
      this._subCategoryId = item.id
      console.log('===============sssqqqqqq',item.superCategoryId);
      console.log('===============sssqqqqqq',item.id);
      this._getItemList()
    })
  }

  @Builder
  header() {
    Stack() {
      Image(this._bannerUrl).height(270).width('100%').objectFit(ImageFit.Fill)
    }
  }
}