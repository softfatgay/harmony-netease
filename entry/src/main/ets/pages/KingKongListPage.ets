import router from '@ohos.router'
import axios from '@ohos/axios'

import { URL_KING_KONG } from '../base/Api'
import { ResponseData } from '../base/BaseModel'
import { BannerItem } from '../model/BannerItem'
import { CategoryItemListItem } from '../model/CategoryItemListItem'
import { KingKongModel } from '../model/kinfkong/KingkongModel'
import { Category } from '../model/Category'
import { ItemListItem } from '../model/ItemListItem'
import { KingKongType } from '../model/kinfkong/KingKongType'
import { GoodItem } from '../component/GoodItem'
import { backgroundColor, textBlack, textGray } from '../base/color'
import { TitleBar } from '../component/TitleBar'
import { TopBar } from '../component/TopBar'
import { PageState } from '../base/PageState'
import { PageLoading } from '../component/PageLoading'

@Entry
@Component
struct KingKongListPage {
  @State _categoryId: string = ''
  @State _title: string = ''
  @State _categoryItemList: Array<CategoryItemListItem> = []
  @State _bannerList: Array<BannerItem> = []
  @State _viewData: Array<any> = []
  @State _pageState: PageState = PageState.Loading

  aboutToAppear() {
    let id = router.getParams()['categoryId'] as string
    this._categoryId = id
    this._getData()
  }

  _getData() {
    axios.get<ResponseData<KingKongModel>>(URL_KING_KONG, {
      params: {
        "csrf_token": "",
        "style": "pd",
        "categoryId": this._categoryId,
        "__timestamp": Date.now().toLocaleString()
      }
    }).then(res => {
      let kingkong = res.data.data
      this._bannerList = kingkong.currentCategory.bannerList ?? []
      this._title = kingkong.currentCategory.name
      this._categoryItemList = kingkong.categoryItemList ?? []
      this._getViewItem()
      this._pageState = PageState.Success
    }).catch(err => {
      this._pageState = PageState.Error
    })
  }

  onChangeHandler(title) {
    this._title = title;
  }

  build() {
    Column() {
      TopBar({ title: this._title })
      Scroll() {
        if (this._pageState == PageState.Loading) PageLoading()
        else GridRow({ columns: 2, gutter: 8 }) {
          ForEach(this._viewData, (item: any) => {
            if (item.type == 0) {
              GridCol({ span: 2 }) {
                Column() {
                  Text(item.name).fontSize(14).fontColor(textBlack)
                  Text(item.frontDesc).fontSize(12).fontColor(textGray).margin({ top: 2 })
                }
                .padding({ top: 12, bottom: 12 })
                .margin({ top: 10 })

              }
            } else {
              GridCol() {
                GoodItem(item as ItemListItem)
              }
            }
          })
        }.padding({ left: 8, right: 16 })
      }.layoutWeight(1).align(Alignment.Center)
    }.height('100%').width('100%').backgroundColor(backgroundColor)
  }

  _getViewItem() {
    let data = new Array<any>()
    this._categoryItemList.forEach((item) => {
      data.push(item.category)
      let newData = data.concat(item.itemList)
      data = newData
    })
    this._viewData = data
  }
}

@Styles function relativeCenter() {
  .alignRules(
    {
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      center: { anchor: '__container__', align: VerticalAlign.Center },
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