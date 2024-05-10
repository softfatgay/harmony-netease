import axios, { AxiosResponse } from '@ohos/axios'
import { URL_HOME_NEW, URL_ITEM } from '../../base/Api'
import { ResponseData } from '../../base/BaseModel'
import { appRed, textBlack, textLightGray, textRed, textWhite } from '../../base/color'
import { margin_screen } from '../../base/dimens'
import { redPackageUrl } from '../../base/Url'
import { Category } from '../../model/Category'
import { CategoryHotSellModule } from '../../model/home/CategoryHotSellModule'

import { Cells } from '../../model/home/CellsModel'
import { FloorItem } from '../../model/home/FloorItem'
import { FocusItem } from '../../model/home/FocusItem'
import { HomeItems } from '../../model/home/HomeItems'
import { HomeDataModel, HomeModel } from '../../model/home/HomeModel'
import { ItemListItem } from '../../model/ItemListItem'
import { KingKongItem } from '../../model/home/KingKongModule'
import { PolicyDescItem } from '../../model/home/PolicyDescItem'
import { Loading } from '../../component/Loading'
import { GoodItem } from '../../component/GoodItem'
import { LoadingMore } from '../../component/LoadingMore'
import router from '@ohos.router'
import HashMap from '@ohos.util.HashMap'
import uri from '@ohos.uri'
import Url from '@ohos.url'

@Entry
@Component
export struct Homepage {
  @State private homeData: HomeDataModel = null
  @State private floorList: Array<FloorItem> = []
  @State private categoryHotSellModule: CategoryHotSellModule = null
  @State private itemIdsStr: string = ''
  @State private haseMore: boolean = false
  @State private items: Array<ItemListItem> = []
  private scroller = new Scroller()

  aboutToAppear() {
    axios.get<ResponseData<HomeModel>>(URL_HOME_NEW, {
      params: {
        "csrf_token": "",
        "__timestamp": Date.now().toLocaleString()
      }
    }).then(res => {
      var data = res.data.data.data
      this.homeData = data
      this.floorList = data.bigPromotionModule.floorList
      this.categoryHotSellModule = data.categoryHotSellModule
    }
    ).catch(err => {
      console.log(err)
    })
    this.recommend()
  }

  recommend() {
    const body = {
      "itemIdsStr": this.itemIdsStr,
      "size": "20"
    }
    axios.defaults.headers.post['Content-Type'] = 'application/json';
    axios.post<ResponseData<HomeItems>>(URL_ITEM, JSON.stringify(body)).then(res => {
      let homeItems = res.data.data
      let newItems = this.items.concat(homeItems.itemList)
      this.items = newItems
      this.itemIdsStr = homeItems.itemIdsStr
      this.haseMore = homeItems.hasMore
      console.log('this.items.length = ' + this.items.length)
    }).catch(err => {
    })
  }

  build() {
    if (this.homeData == null) Loading()
    else Column() {
      this.searView()
      Stack() {
        Scroll(this.scroller) {
          Column() {
            this._banner()
            this._topTags()
            this.kingKong()
            this.bigPromotion()
            this.label('新人专享')
            this.newAccount()
            this.labelTile('类目热销榜')
            this.categoryHotSell()
            this.labelTile('为您推荐')
            this.itemsRecommend()
          }
        }
        .onScrollEdge((side: Edge) => {
          if (side.valueOf() == Edge.Bottom && this.haseMore) {
            this.recommend()
          }
        })

        Image($r('app.media.up_top')).onClick(e => {
          this.scroller.scrollTo({ xOffset: 0, yOffset: 0, animation: { duration: 2000, curve: Curve.Linear } })
        }).size({ height: 40, width: 40 }).margin(20)
      }.alignContent(Alignment.BottomEnd).layoutWeight(1)
    }
  }

  @Builder
  itemsRecommend() {
    GridRow({ columns: 2, gutter: 12 }) {
      ForEach(this.items, (item: ItemListItem) => {
        GridCol() {
          GoodItem(item)
        }
      })
      GridCol({ span: 2 }) {
        LoadingMore(this.haseMore)
      }
    }.margin({ left: 12, right: 16 })
  }

  getPrice(item: ItemListItem) {
    let priceInfo = item.finalPriceInfoVO.priceInfo
    if (priceInfo.finalPrice == null) {
      return priceInfo.basicPrice
    }
    return priceInfo.finalPrice.prefix??'' + priceInfo.finalPrice.price
  }

  @Builder
  categoryHotSell() {
    if (this.categoryHotSellModule == null || this.categoryHotSellModule.categoryList == null || this.categoryHotSellModule.categoryList.length == 0) Rect()
    else Column() {
      Row() {
        this.categoryHotSellTopCell(this.categoryHotSellModule.categoryList[0], 0)
        Rect().width(6).height(10).fill(Color.Transparent)
        this.categoryHotSellTopCell(this.categoryHotSellModule.categoryList[1], 1)
      }.justifyContent(FlexAlign.SpaceBetween).width('100%').height(120)

      GridRow({ columns: 4, gutter: 6 }) {
        ForEach(this.categoryHotSellModule.categoryList.splice(2, this.categoryHotSellModule.categoryList.length - 1), (item: Category) => {
          GridCol() {
            Column() {
              Text(item.categoryName).fontSize(10).fontColor(textBlack).margin({ top: 10 })
              Image(item.picUrl).height(50).margin({ top: 10, bottom: 10 })
            }
            .backgroundColor(0xFFF2F2F2)
            .width('100%')
            .onClick(e => this.go2HotListPage(item))
          }
        })
      }.margin({ top: 6 })
    }.margin({ left: 6, right: margin_screen })
  }

  go2HotListPage(item: Category) {
    let url = item.targetUrl
    if (url != null && url.includes('categoryId')) {
      let urlObject = Url.URL.parseURL(url)
      let params = new Url.URLParams(urlObject.search)
      let categoryId = params.get('categoryId')
      router.pushUrl({
        url: 'pages/HotPage',
        params: {
          'categoryId': categoryId,
          'name': item.name,
        }
      })
    }
  }

  @Builder
  categoryHotSellTopCell(item: Category, index: number) {
    Row() {
      Stack() {
        Column() {
          Text(item.categoryName).fontSize(12).fontColor(textBlack).fontWeight(600)
          Rect().width(24).height(2).fill(textBlack).margin({ top: 2 })
        }.layoutWeight(1).align(Alignment.Start).alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)

      Image(item.picUrl).relativeCenter().id('image').layoutWeight(1)
    }
    .layoutWeight(1)
    .backgroundColor(index == 0 ? 0xFFF7F1DD : 0xFFE4E8F0).height('100%')
    .onClick(e => this.go2HotListPage(item))
  }

  @Builder
  newAccount() {
    Row() {
      RelativeContainer() {
        Image(redPackageUrl).height('50%').id('image').relativeCenter()
        Text('新人专享')
          .fontWeight(500)
          .margin({ bottom: 10 })
          .fontSize(12)
          .alignRules(
            {
              bottom: { anchor: 'image', align: VerticalAlign.Top },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            }
          )
          .id('tv')
      }
      .backgroundColor(0xFFF6E5C4)
      .layoutWeight(1)
      .height('100%')
      .margin({ right: 5 })

      Column() {

      }
      .layoutWeight(1)
      .backgroundColor(0xFFF6E5C4)
      .layoutWeight(1)
      .margin({ right: 5 })
    }
    .width('100%')
    .aspectRatio(1.5)
    .margin({ right: margin_screen })
  }

  @Builder
  label(tile: string) {
    Row() {
      Rect().width(15).height(1).fill(textBlack)
      Text(tile).fontSize(14).fontColor(textBlack)
      Rect().width(15).height(1).fill(textBlack)
    }.justifyContent(FlexAlign.Center).margin({ top: 16, bottom: 10 }).width('100%')
  }

  @Builder
  labelTile(tile: string) {
    Text(tile).fontSize(14).fontColor(textBlack).width('100%').margin({ left: margin_screen, top: 16, bottom: 10 })
  }

  @Builder
  bigPromotion() {
    Column() {
      ForEach(this.floorList, (item: FloorItem) => {
        Row() {
          GridRow({ columns: item.columnNum }) {
            ForEach(item.cells, (cell: Cells) => {
              GridCol() {
                Image(cell.picUrl).objectFit(ImageFit.Fill).height(item.height / 3 + 10)
              }
            })
          }.margin({ left: item.columnNum > 1 ? 6 : 0, right: item.columnNum > 1 ? 12 : 6, top: 6 })

          // ForEach(item.cells, (cell: Cells) => {
          //   Image(cell.picUrl)
          //
          //   // Row() {
          //   //   Flex() {
          //   //     // Image(cell.picUrl)
          //   //     if (item.layout == 2 || item.layout == 1) Image(item.cells[0].picUrl)
          //   //     else Row() {
          //   //       ForEach(cell.itemList, (cellItem: Cells) => {
          //   //         Image(cellItem.picUrl).height(30).width(30)
          //   //       })
          //   //     }
          //   //   }.width('100%')
          //   // }.width((98 / (item.columnNum)) + '%')
          // })
        }.justifyContent(FlexAlign.SpaceBetween).height((item.height / 3)).width('100%')
      })
    }.width('100%').margin({ top: 10 })
  }

  @Builder
  kingKong() {
    GridRow({ columns: 5 }) {
      ForEach(this.homeData.kingKongModule.kingKongList, (item: KingKongItem) => {
        GridCol() {
          Column() {
            Image(item.picUrl).size({ width: 45, height: 45 })
            Divider().color(Color.Transparent).height(4)
            Text(item.text).fontColor($r('app.color.text_black')).fontSize(12)
          }
          .margin({ top: 10 })
          .onClick(event => {
            // let param = new HashMap<string, string>()
            // param.set("schemeUrl", item.schemeUrl)
            // router.pushUrl(
            //   { url: 'pages/WebView', params: { "schemeUrl": item.schemeUrl } }
            // )
            this._goKingKong(item.schemeUrl);

          })
        }
      })
    }
  }

  _goKingKong(schemeUrl: string) {
    let url = decodeURI(schemeUrl)
    if (url.includes('item/list')) {
      let split = url.split('categoryId=')
      let splitincludeId = split[1]
      let splitId = splitincludeId.split('&')
      let categoryId = splitId[0]
      router.pushUrl({ url: 'pages/KingKongListPage', params: { 'categoryId': categoryId } })
    } else if (url.includes('item/newItem')) {

    } else {
      this._goWebView(schemeUrl)
    }
  }

  _goWebView(url: string) {
    router.pushUrl(
      { url: 'pages/WebView', params: { "schemeUrl": url } }
    )
  }

  @Builder
  _topTags() {
    Row() {
      ForEach(this.homeData.policyDescList, (item: PolicyDescItem) => {
        Row() {
          Image(item.icon).size({ width: 10, height: 10 })
          Text(item.desc).fontSize(10).fontColor($r('app.color.text_black'))
        }
      })
    }
    .width('100%')
    .padding({
      left: margin_screen,
      top: 6,
      right: margin_screen
    })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  _banner() {
    Swiper() {
      ForEach(this.homeData.focusList, (item: FocusItem) => {
        Image(item.picUrl).width('100%')
      })
    }.height(200).indicator(true).autoPlay(true)
  }

  @Builder
  searView() {
    Row() {
      Text('网易严选').fontSize(18).fontColor(textBlack).fontWeight(600)
      Row() {
        Image($r('app.media.search_icon'))
          .size({ width: 15, height: 15 })
          .margin({ left: 10, right: 10 })
        Swiper() {
          ForEach(searchSwiper, (item: Resource) => {
            Text(item)
              .fontSize(12)
              .fontColor(Color.Black)
          }, (item: Resource) => JSON.stringify(item))
        }
        .vertical(true)
        .indicator(false)
        .autoPlay(true)
        .duration(1000)
        .loop(true)
      }
      .margin({ left: 10, right: 10 })
      .backgroundColor('#ededed')
      .borderRadius(8)
      .height('100%')
      .layoutWeight(1)

      Text('登录')
        .padding(3)
        .border({ width: 1, color: $r('app.color.primary_color') })
        .borderRadius(4)
        .fontSize(10)
        .fontColor(Color.Red)
    }
    .margin({ left: margin_screen, right: margin_screen, top: 10, bottom: 10 })
    .height(30)
  }
}

const searchSwiper: string[] = [
  '羽绒服鹅毛了',
  '打你个柠檬',
  "开深蓝，品怨种人生",
  "春季计划"
]

@Styles function relativeCenter() {
  .alignRules(
    {
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      center: { anchor: '__container__', align: VerticalAlign.Center },
    }
  )
}

@Styles function relativeFull() {
  .alignRules(
    {
      top: { anchor: '__container__', align: VerticalAlign.Top },
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      left: { anchor: '__container__', align: HorizontalAlign.Start },
      right: { anchor: '__container__', align: HorizontalAlign.End }
    }
  )
}

@Styles function relativeBottomEnd() {
  .alignRules(
    {
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      right: { anchor: '__container__', align: HorizontalAlign.End }
    }
  )
}

@Styles function relativeEndCenter() {
  .alignRules(
    {
      center: { anchor: '__container__', align: VerticalAlign.Center },
      right: { anchor: '__container__', align: HorizontalAlign.End }
    }
  )
}

@Styles function relativeStartCenter() {
  .alignRules(
    {
      center: { anchor: '__container__', align: VerticalAlign.Center },
      left: { anchor: '__container__', align: HorizontalAlign.Start }
    }
  )
}
