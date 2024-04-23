import axios from '@ohos/axios'
import List from '@ohos.util.List'
import { SORT_DATA } from '../../base/Api'
import { ResponseData } from '../../base/BaseModel'
import { appRed, darkRed, lineColor, textBlack, textGray, textRed } from '../../base/color'
import { SortData } from './model/sort/SortData'
import { CategoryL1Item } from './model/sort/CategoryL1Item'
import { Loading } from '../../component/Loading'
import { CategoryGroupItem } from './model/sort/CategoryGroupItem'
import { BannerItem } from './model/BannerItem'
import { Category } from './model/Category'
import { PageState } from '../../base/PageState'

@Entry
@Component
export struct SortPage {
  @State categoryId: string = ''
  @State sortData: SortData = null
  @State index: number = 0
  @State dataContent: SortModel = null
  categoryL1List: Array<CategoryL1Item> = null
  @State loadingState: PageState = PageState.Loading

  aboutToAppear() {
    this.getData()
  }

  getData() {
    axios.get<ResponseData<SortData>>(SORT_DATA, {
      params: { "categoryId": this.categoryId }
    }).then(res => {
      this.sortData = res.data.data
      if (this.categoryL1List == null || this.categoryL1List.length == 0) {
        this.categoryL1List = this.sortData.categoryL1List
      }
      if (this.sortData.categoryGroupList != null) {
        this.dataContent = new SortModel(this.sortData.categoryGroupList, this.sortData.currentCategory.bannerList)
      }
      this.loadingState = PageState.Success
      console.log('================SortPage')
      console.log(this.sortData.categoryL1List.length + "")
    }
    ).catch(err => {
      this.loadingState = PageState.Error
      console.log(err)
    })
  }

  build() {
    if (this.dataContent == null) Loading()
    else Column() {
      this.searchBar()
      this.content()
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  content() {
    Row() {
      this.tabs()
      Rect().height('100%').width(0.5).fill(lineColor)
      this.tabContent()
    }
    .width('100%')
    .layoutWeight(1)
    .margin({ top: 10 })
    .border({
      width: 0.5,
      color: lineColor
    })
  }

  @Builder
  tabContent() {
    if (this.loadingState == PageState.Loading) Stack() {
      Loading(40)
    }.layoutWeight(1)
    else Scroll() {
      Column() {
        Swiper() {
          ForEach(this.dataContent.bannerList, (item: BannerItem) => {
            Image(item.picUrl)
              .height(120)
              .borderRadius(10)
              .width('100%')
              .backgroundColor(0xeeeeee)
          })
        }

        ForEach(this.dataContent.dataList, (item: CategoryGroupItem) => {
          Column() {
            Text(item.name)
              .fontSize(16)
              .fontWeight(600)
              .fontColor(textBlack)
            Rect().width('100%').height(0.5).fill(lineColor).margin({ top: 6 })
            GridRow({ columns: 3, gutter: 16 }) {
              ForEach(item.categoryList, (category: Category) => {
                GridCol() {
                  Column() {
                    Image(category.wapBannerUrl).width('100%').aspectRatio(1)
                    Text(category.name).fontColor(textBlack).fontSize(12).margin({ top: 6 })
                  }
                }
              })
            }.margin({ top: 10 })
          }.alignItems(HorizontalAlign.Start).margin({ top: 20 })
        })
      }
    }.layoutWeight(1).height('100%').padding(10).align(Alignment.Top)
  }

  getTabs() {
    let tabs: List<string>
    this.sortData.categoryL1List.forEach(item => {
      tabs.add(item.name)
    })
    return tabs
  }

  @Builder
  tabs() {
    Scroll() {
      Column() {
        ForEach(this.categoryL1List, (item: CategoryL1Item, index: number) => {
          Row() {
            Rect()
              .height(25)
              .width(2)
              .fill(this.index == index ? darkRed : Color.Transparent)
            Text(item.name)
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
              .fontColor(this.index == index ? textRed : textBlack)
              .height('100%')
          }.height(50).width('100%').onClick(event => {
            this.loadingState = PageState.Loading
            this.categoryId = item.id + ''
            this.index = index
            this.getData()
          })
        })
      }.alignItems(HorizontalAlign.Center)
    }
    .scrollBar(BarState.Off)
    .height('100%')
    .width('20%')
  }

  @Builder
  searchBar() {
    Stack({ alignContent: Alignment.Bottom }) {
      Row() {
        Image($r('app.media.search_icon'))
          .size({ width: 15, height: 15 })
          .margin({ left: 10, right: 10 })
        Text('搜索商品').fontColor(textGray).fontSize(12)
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#ededed')
      .borderRadius(8)
      .width('100%')
      .height(30)
    }
    .width('100%')
    .height(40)
    .padding({ left: 6, right: 12 })
  }
}

class SortModel {
  dataList: Array<CategoryGroupItem> = []
  bannerList: Array<BannerItem> = []

  constructor(dataList: Array<CategoryGroupItem>, bannerList: Array<BannerItem>) {
    this.dataList = dataList
    this.bannerList = bannerList
  }
}