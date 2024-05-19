import axios, { AxiosResponse } from '@ohos/axios'
import { baseUrl, SORT_DATA, TOPIC_LIST, TOPIC_NAVWAP } from '../../base/Api'
import { ResponseData } from '../../base/BaseModel'
import { appRed, backgroundColor, textBlack, textGray, textLightGray } from '../../base/color'
import { margin_screen } from '../../base/dimens'
import { PageState } from '../../base/PageState'
import { NavItem } from '../../model/topic/NavItem'
import { TopData } from '../../model/topic/TopData'
import { TopicData } from '../../model/topic/TopicData'
import { TopicItem } from '../../model/topic/TopicItem'
import { LoadingMore } from '../../component/LoadingMore'
import { goWebView } from '../../utils/Routers'

@Entry
@Component
export struct TopicPage {
  @State private loadingState: PageState = PageState.Loading
  @State private navList: Array<NavItem> = []
  @State private topics: Array<TopicItem> = []
  @State private hasMore: boolean = true
  private scroller: Scroller = new Scroller()
  private page = 1

  aboutToAppear() {
    this.getTopData()
    this.getListData()
  }

  getListData() {
    axios.get<ResponseData<TopicData>>(TOPIC_LIST, {
      params: {
        'page': this.page,
        'size': 2,
        'exceptIds': ''
      }
    }).then(res => {
      let result = res.data.data.result
      let topic: Array<TopicItem> = []
      for (let item of result) {
        let concat = topic.concat(item.topics)
        topic = concat
      }
      let newTopic = this.topics.concat(topic)
      this.topics = newTopic

      this.hasMore = res.data.data.hasMore
      console.log('===============' + res.data.data.hasMore)
      console.log('===============' + this.topics.length)
    }).catch(err => {
      this.loadingState = PageState.Error
    })
  }

  getTopData() {
    axios.get<ResponseData<TopData>>(TOPIC_NAVWAP).then(res => {
      this.loadingState = PageState.Success
      this.navList = res.data.data.navList
    }
    ).catch(err => {
      this.loadingState = PageState.Error
    })
  }

  build() {
    Scroll() {
      Stack({ alignContent: Alignment.Top }) {
        Image($r('app.media.topic_header_back'))
          .height(270)
          .width('100%')
        Column() {
          this.title()
          this.nav()
          this.listView()
        }.margin({ left: margin_screen, right: margin_screen })
      }
      .align(Alignment.Top)
      .width('100%')
    }
    .backgroundColor(backgroundColor)
    .height('100%')
    .align(Alignment.Top)
    .onScrollEdge(event => {
      if (event.valueOf() == Edge.Bottom && this.hasMore) {
        this.page += 1
        this.getListData()
      }
    })
  }

  @Builder
  listView() {
    GridRow({ columns: 2, gutter: 12 }) {
      ForEach(this.topics, (item: TopicItem) => {
        GridCol() {
          this.itemList(item)
        }
      })
      GridCol({ span: 2 }) {
        LoadingMore(this.hasMore)
      }
    }.margin({ top: 20 })
  }

  @Builder
  itemList(item: TopicItem) {
    Column() {
      Image(item.picUrl)
        .backgroundColor(backgroundColor)
        .borderRadius({ topLeft: 8, topRight: 8 })

      Text(item.title)
        .fontSize(13)
        .fontColor(textBlack)
        .margin({ left: 6, right: 6, top: 8 })

      Row() {
        Row() {
          Image(item.avatar).height(20).width(20).borderRadius(20)
          Text(item.nickname).fontSize(12).fontColor(textGray).margin({ left: 4 })
        }

        Row() {
          Image($r('app.media.topic_look_icon')).width(12).borderRadius(20)
          Text(item.readCount + '').fontSize(12).fontColor(textGray).margin({ left: 4 })
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 6, top: 12, right: 6 })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(8)
    .alignItems(HorizontalAlign.Start)
    .padding({ bottom: 12 })
    .onClick(e => {
      var url = item.schemeUrl
      if (!url.startsWith('http')) {
        url = baseUrl + url
      }
      goWebView(url)
    })
  }

  @Builder
  nav() {
    Column() {
      Grid(this.scroller) {
        ForEach(this.navList, (item: NavItem) => {
          GridItem() {
            Column() {
              Image(item.picUrl).height(60)
              Text(item.mainTitle).fontSize(14).fontWeight(600).fontColor(textBlack).margin({ top: 6 })
              Text(item.viceTitle).fontSize(12).fontColor(textGray)
            }
            .justifyContent(FlexAlign.Center)
            .onClick(e => {
              goWebView(item.columnUrl)
            })
          }.width('25%')
        })
      }
      .height(250)
      .rowsTemplate('1fr 1fr')
      .rowsGap(15)
      .margin({ top: 12 })

      ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Horizontal, state: BarState.On }) {
        Rect().fill(appRed).width(30).height(4).radius(2)
      }
      .height(4)
      .width(100)
      .backgroundColor(backgroundColor).borderRadius(2)
    }
    .backgroundColor(Color.White)
    .borderRadius(12)
    .padding({ bottom: 10 })
    .margin({ top: 6 })
  }

  @Builder
  title() {
    Row() {
      Image($r('app.media.topic_icon')).height(35)
      Text('严选好物 用心生活').fontColor(Color.White).fontWeight(600).fontSize(14)
    }
    .width('100%')
    .alignItems(VerticalAlign.Bottom)
    .justifyContent(FlexAlign.Start)
    .margin({ top: 20 })
  }
}