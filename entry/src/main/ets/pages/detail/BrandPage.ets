import router from '@ohos.router'
import axios from '@ohos/axios'
import { BRAND_INFO, BRAND_INFO_ITEMS } from '../../base/Api'
import { ResponseData } from '../../base/BaseModel'
import { appWhite, textBlack, textGray } from '../../base/color'
import { PageState } from '../../base/PageState'
import { GoodItem } from '../../component/GoodItem'
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
    let param = {
      'brandId': this._brandInfo.brandId,
      'descSorted': true,
      'extInfo': this._extInfo,
      'itemId': this._goodId,
      'merchantId': this._brandInfo.merchantId ?? 'null',
      'sortType': 0,
      'type': this._brandInfo.type + '',
    }
    axios.post<ResponseData<BrandIndexModel>>(BRAND_INFO_ITEMS, JSON.stringify(param)).then(res => {
      let data = res.data.data
      this._hasMore = data.hasMore ?? false
      let newItems = this._itemList.concat(data.itemList)
      this._itemList = newItems
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

      ListItemGroup({ header: this.header() }) {
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
    }.sticky(StickyStyle.Header)
  }

  @Builder
  header() {
    Row() {
      Text('综合')
        .fontSize(14)
        .fontColor(textBlack)
        .textAlign(TextAlign.Center)
        .layoutWeight(1)
        .padding({ top: 12, bottom: 12 })
      Text('价格')
        .fontSize(14)
        .fontColor(textBlack)
        .textAlign(TextAlign.Center)
        .layoutWeight(1)
        .padding({ top: 12, bottom: 12 })
      Text('销量')
        .fontSize(14)
        .fontColor(textBlack)
        .textAlign(TextAlign.Center)
        .layoutWeight(1)
        .padding({ top: 12, bottom: 12 })
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