import router from '@ohos.router'
import axios from '@ohos/axios'
import { URL_SORT_LIST_NEW } from '../base/Api'
import { ResponseData } from '../base/BaseModel'
import { appRed, lineColor, textBlack, textGray, textRed } from '../base/color'
import { PageState } from '../base/PageState'
import { GoodItem } from '../component/GoodItem'
import { TopBar } from '../component/TopBar'
import { Category } from '../model/Category'
import { ItemListItem } from '../model/ItemListItem'
import { SortListData } from '../model/sort/SortListData'
import { PageLoading } from '../component/PageLoading'
import HashMap from '@ohos.util.HashMap'

@Entry
@Component
struct SortListPage {
  @State _categoryId: string = ''
  @State _subCategoryId: string = ''
  @State _catalogList: Array<Category> = []
  @State _currentIndex: number = 0
  @State _itemList: Array<ItemListItem> = []
  _controller: TabsController = new TabsController()
  @State _tittle: string = ''
  @State _pageState: PageState = PageState.None
  private cacheDatas: HashMap<string, Array<ItemListItem>> = new HashMap()

  aboutToAppear() {
    this._subCategoryId = router.getParams()['categoryId'] as string
    this._categoryId = router.getParams()['superCategoryId'] as string
    this._getData()
  }

  _getData() {
    this._pageState = PageState.Loading
    axios.get<ResponseData<SortListData>>(URL_SORT_LIST_NEW, {
      params: {
        "categoryType": "0",
        "subCategoryId": this._subCategoryId,
        "categoryId": this._categoryId,
      }
    }).then(res => {
      this._pageState = PageState.Success
      let dataList = res.data.data
      this._catalogList = dataList.categoryL2List
      this._itemList = dataList.categoryItems.itemList
      if (this._itemList != null && this._itemList.length > 0) {
        this.cacheDatas.set(this._subCategoryId, this._itemList)
      }
      this._tittle = this._catalogList[0].name
      console.log('==============size', 'success');
    }
    ).catch(err => {
      this._pageState = PageState.Error
      console.log(err)
    })
  }

  build() {
    Stack() {
      Column() {
        TopBar({ title: this._tittle })
        Tabs({ barPosition: BarPosition.Start, controller: this._controller, index: this._currentIndex }) {
          ForEach(this._catalogList, (item: Category, index: number) => {
            TabContent() {
              Scroll() {
                GridRow({ columns: 2, gutter: 8 }) {
                  ForEach(this._itemList, (goodItem: ItemListItem) => {
                    GridCol() {
                      GoodItem(goodItem)
                    }
                  })
                  GridCol({ span: 2 }) {
                    Text('没有更多了').fontSize(12).fontColor(textGray).margin({ top: 16, bottom: 16 })
                  }
                }.padding({ left: 12, right: 12 })
              }
            }.tabBar(this.tabs(item, index))
          })
        }
        .barHeight(46)
        .barMode(BarMode.Scrollable)
        .onChange(index => {
          this._tittle = this._catalogList[index].name
          this._categoryId = this._catalogList[index].superCategoryId + ''
          this._subCategoryId = this._catalogList[index].id + ''
          this.changeGetData(index)
        })
      }.height('100%')

      if (this._pageState == PageState.Loading)
        PageLoading()
    }
  }

  @Builder
  tabs(item: Category, index: number) {
    Column() {
      Text(item.name)
        .fontColor(this._currentIndex === index ? textRed : textBlack)
        .fontSize(14)
        .maxLines(1)
        .fontWeight(600)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
      Rect()
        .fill(this._currentIndex === index ? appRed : Color.Transparent)
        .width(30)
        .height(2)
    }
    .border({ width: { bottom: 1 }, color: { bottom: 0xFFF2F4F9 } })
    .height('100%')
    .padding({ left: 12, right: 12 })
    .onClick(e => {
      // this.changeGetData(index)
      this._currentIndex = index
    })
  }

  changeGetData(index: number) {
    if (this._currentIndex != index) {
      this._getData()
    }
    this._currentIndex = index
  }
}