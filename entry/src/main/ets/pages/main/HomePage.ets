import axios, { AxiosResponse } from '@ohos/axios'
import { URL_HOME_NEW, URL_ITEM } from '../../base/Api'
import { ResponseData } from '../../base/BaseModel'
import { appRed, textBlack, textLightGray, textRed, textWhite } from '../../base/color'
import { margin_screen } from '../../base/dimens'
import { redPackageUrl } from '../../base/Url'
import { Category } from './model/Category'
import { CategoryHotSellModule } from './model/CategoryHotSellModule'

import { Cells } from './model/CellsModel'
import { FloorItem } from './model/FloorItem'
import { FocusItem } from './model/FocusItem'
import { HomeItems } from './model/HomeItems'
import { HomeDataModel, HomeModel } from './model/HomeModel'
import { ItemListItem } from './model/ItemListItem'
import { KingKongItem } from './model/KingKongModule'
import { PolicyDescItem } from './model/PolicyDescItem'
import { TopLogo } from './model/TopLogo'
import { Loading } from '../../component/Loading'
import { GoodItem } from '../../component/GoodItem'
import { LoadingMore } from '../../component/LoadingMore'

@Entry
@Component
export struct Homepage {
  @State homeData: HomeDataModel = null
  @State floorList: Array<FloorItem> = []
  @State categoryHotSellModule: CategoryHotSellModule = null
  @State itemIdsStr: string = ''
  @State haseMore: boolean = false
  @State items: Array<ItemListItem> = []
  scroller = new Scroller()

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
    }.margin({ left: 12, right: 24 })
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
            }.backgroundColor(0xFFF2F2F2).width('100%')
          }
        })
      }.margin({ top: 6 })
    }.margin({ left: 6, right: margin_screen })
  }

  @Builder
  categoryHotSellTopCell(item: Category, index: number) {
    Row() {
      Stack(){
        Column() {
          Text(item.categoryName).fontSize(12).fontColor(textBlack).fontWeight(600)
          Rect().width(24).height(2).fill(textBlack).margin({top:2})
        }.layoutWeight(1).align(Alignment.Start).alignItems(HorizontalAlign.Start)
      }.layoutWeight(1)

      Image(item.picUrl).relativeCenter().id('image').layoutWeight(1)
    }.layoutWeight(1).backgroundColor(index == 0 ? 0xFFF7F1DD : 0xFFE4E8F0).height('100%')
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
          ForEach(item.cells, (cell: Cells) => {
            Row() {
              Flex() {
                Image(cell.picUrl)
                if (item.layout == 2) Image(item.cells[0].itemList[0].picUrl)
                else Row() {
                  ForEach(cell.itemList, (cellItem: Cells) => {
                    Image(cellItem.picUrl).height(30).width(30)
                  })
                }
              }.width('100%')
            }.width((98 / (item.columnNum)) + '%')
          })
        }.justifyContent(FlexAlign.SpaceBetween).height(120).width('100%')
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
          }.margin({ top: 10 })
        }
      })
    }
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
