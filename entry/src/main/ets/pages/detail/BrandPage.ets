import router from '@ohos.router'
import axios from '@ohos/axios'
import { BRAND_INFO, BRAND_INFO_ITEMS } from '../../base/Api'
import { ResponseData } from '../../base/BaseModel'
import { appWhite, textBlack, textGray, textRed } from '../../base/color'
import { PageState } from '../../base/PageState'
import { GoodItem } from '../../component/GoodItem'
import { PageLoading } from '../../component/PageLoading'
import { BrandIndexModel } from '../../model/detail/BrandIndexModel'
import { BrandInfo } from '../../model/detail/GoodDetail'
import { ItemListItem } from '../../model/ItemListItem'

@Component
@Entry
struct BrandPage {
  @State _brandInfo: BrandInfo = null
  @State _goodId: string = ''
  @State _pageState: PageState = PageState.Loading
  @State _extInfo: string = '';
  _hasMore: boolean = true
  @State _itemList: Array<ItemListItem> = []
  @State _descSorted: boolean = true
  @State _sortType: number = 0
  @State _checkedIndex: number = 0

  aboutToAppear() {
    this._brandInfo = router.getParams()['brandInfo'] as BrandInfo
    this._goodId = router.getParams()['id'] as string
    this._getBrandInfo()
    this._getBrandIndex()
  }

  _getBrandInfo() {
    axios.get<ResponseData<BrandInfo>>(BRAND_INFO, {
      params: {
        'itemId': this._goodId,
        'brandId': this._brandInfo.brandId,
        'type': this._brandInfo.type,
        'merchantId': this._brandInfo.merchantId ?? 'undefined'
      }
    }).then(res => {
      let data = res.data.data
      this._brandInfo.subTitle = data.subTitle;
      this._brandInfo.desc = data.desc;
    }
    ).catch(err => {
      console.log(err)
      this._pageState = PageState.Error
    })
  }

  _getBrandIndex() {
    this._pageState = PageState.Loading
    let param = {
      'brandId': this._brandInfo.brandId,
      'descSorted': this._descSorted,
      'extInfo': this._extInfo,
      'itemId': this._goodId,
      'merchantId': this._brandInfo.merchantId ?? 'null',
      'sortType': this._sortType,
      'type': this._brandInfo.type + '',
    }
    axios.post<ResponseData<BrandIndexModel>>(BRAND_INFO_ITEMS, JSON.stringify(param)).then(res => {
      let data = res.data.data
      this._hasMore = data.hasMore ?? false
      this._itemList = data.itemList
      this._pageState = PageState.Success
    }).catch(err => {
      this._pageState = PageState.Error
    })
  }

  build() {
    List() {
      ListItem() {
        this.top()
      }
      if (this._pageState == PageState.Loading) ListItem() {PageLoading()}.width('100%')
      else ListItemGroup({ header: this.header() }) {
        ListItem() {
          GridRow({ columns: 2, gutter: 8 }) {
            ForEach(this._itemList, (item: ItemListItem) => {
              GridCol() {
                GoodItem(item)
              }
            })
          }.padding({ left: 12, right: 12 })
        }
      }
    }
    .sticky(StickyStyle.Header)
    .alignListItem(ListItemAlign.Center)
  }

  @Builder
  header() {
    Row() {
      Text('综合')
        .fontSize(14)
        .fontColor(this._checkedIndex == 0 ? textRed : textBlack)
        .textAlign(TextAlign.Center)
        .layoutWeight(1)
        .padding({ top: 12, bottom: 12 })
        .onClick(e => {
          this._checkedIndex = 0
          this._sortType = 0
          this._getBrandIndex()
        })

      Row() {
        Text('价格')
          .fontSize(14)
          .fontColor(this._checkedIndex == 1 ? textRed : textBlack)
          .textAlign(TextAlign.Center)
        Image(this._descSorted ? $r('app.media.arrow_down') : $r('app.media.arrow_up'))
          .size({ width: 16 })
          .colorFilter(this._checkedIndex == 1 ? textRed : textBlack)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .padding({ top: 12, bottom: 12 })
      .onClick(e => {
        this._checkedIndex = 1
        this._sortType = 1
        this._descSorted = !this._descSorted
        this._getBrandIndex()
      })

      Row() {
        Text('销量')
          .fontSize(14)
          .fontColor(this._checkedIndex == 2 ? textRed : textBlack)
          .textAlign(TextAlign.Center)
        Image(this._sortType == 5 ? $r('app.media.arrow_down') : $r('app.media.arrow_up'))
          .size({ width: 16 })
          .colorFilter(this._checkedIndex == 1 ? textRed : textBlack)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .padding({ top: 12, bottom: 12 })
      .onClick(e => {
        this._checkedIndex = 2
        this._sortType = 5
        this._getBrandIndex()
      })
    }.backgroundColor(appWhite)
  }

  @Builder
  top() {
    Column() {
      Row() {
        Image(this._brandInfo.picUrl).height(35)
        Column() {
          Text(this._brandInfo.title).fontSize(16).fontColor(textBlack).fontWeight(600)
          Text(this._brandInfo.subTitle).fontSize(12).fontColor(textGray).margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 30 })
      }
      .alignItems(VerticalAlign.Center)
      .padding({ top: 20, bottom: 20 })

      Text(this._brandInfo.desc).fontSize(12).fontColor(textBlack)
    }
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 12, right: 12 })
  }
}