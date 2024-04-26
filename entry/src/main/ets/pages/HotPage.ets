import axios from '@ohos/axios'
import router from '@ohos.router'
import { HOT_LIST_CAT, HOT_LIST_LIST, SUBMIT_ORDER_INFO, URL_HOME_NEW } from '../base/Api'
import { ResponseData } from '../base/BaseModel'
import { HotListNav } from '../model/hotlist/NavCat'
import { ItemListItem } from '../model/ItemListItem'
import { HotListData } from '../model/hotlist/HotListData'
import { appRed, backgroundColor, textBlack, textRed } from '../base/color'
import { CurrentCategory } from '../model/sort/CurrentCategory'
import { Loading } from '../component/Loading'
import { GoodItem } from '../component/GoodItem'

@Entry
@Component
struct HotPage {
  @State private _categoryId: string = ''
  @State private dataList: Array<ItemListItem> = []
  @State private submitInfo: Array<string> = []
  @State private hotListNav: HotListNav = null
  @State private subCateList: Array<CurrentCategory> = []
  @State private currentIndex: number = 0
  private _currentCategoryId: number = 0
  private _bannerUrl: string = "https://yanxuan.nosdn.127.net/294b914321c27e2490b257b5b6be6fa5.png";

  aboutToAppear() {
    let categoryId = router.getParams()['categoryId'] as string
    this._categoryId = categoryId
    console.log('++++++++++++' + this._categoryId)
    this._getCat()
    this._getItemList()
    this._getSubmitInfo()
  }

  _getItemList() {
    axios.post<ResponseData<HotListData>>(HOT_LIST_LIST, {
      body: {
        "categoryId": this._categoryId,
        "subCategoryId": this._currentCategoryId,
        "userBusId": '',
      },
      params: {
        "csrf_token": '',
      },
    }).then(res => {
      this.dataList = res.data.data.itemList
      console.log('===========success-ItemList');
      console.log(JSON.stringify(res.data.data.itemList.length))
    }
    ).catch(err => {
      console.log(err)
    })
  }

  _getCat() {
    axios.get<HotListNav>(HOT_LIST_CAT, {
      params: {
        "categoryId": this._categoryId,
        "subCategoryId": 0
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
      console.log('===========success-Cat');
      console.log(JSON.stringify(res.data.desc))
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
    if (this.hotListNav == null) Loading()
    else Column() {
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
            .margin({ top: 100 })
          }.width('100%')

          ListItemGroup({ header: this.stick() }) {
            ForEach(this.dataList, (item: ItemListItem) => {
              ListItem() {
                GoodItem(item)
              }
            })
          }
        }
        .sticky(StickyStyle.Header)
      }.align(Alignment.Top)
    }.width('100%')
  }

  @Builder
  stick() {
    Scroll() {
      Row() {
        Tabs() {
          ForEach(this.subCateList, (item: CurrentCategory, index: number) => {
            TabContent().visibility(Visibility.Hidden).size({ height: 0, width: 0 }).tabBar(this.TabBuilder(item, index))
          })
        }.scrollable(true)
      }
      .backgroundColor(Color.White)
      .borderRadius(20)
      .height(40)
      .alignItems(VerticalAlign.Center)
    }.scrollable(ScrollDirection.Vertical).width('100%')
  }

  @Builder TabBuilder(item: CurrentCategory, index: number) {
    Column() {
      Text(item.name)
        .fontColor(this.currentIndex === index ? textRed : textBlack)
        .fontSize(14)
        .maxLines(1)
        .fontWeight(600)
      Rect().fill(this.currentIndex === index ? appRed : Color.Transparent).width(30).height(2)
    }.justifyContent(FlexAlign.Center).onClick(e => {
      this.currentIndex = index
    }).width(100)
  }

  @Builder
  header() {
    Stack() {
      Image(this._bannerUrl).height(270).width('100%').objectFit(ImageFit.Fill)
    }
  }
}