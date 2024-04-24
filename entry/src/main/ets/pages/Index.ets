import { tabBarList, TabBarModel } from '../model/TabBarModel'
import { CartPage } from './main/CartPage';
import { SortPage } from './main/SortPage';
import { Homepage } from './main/HomePage'
import { ProfilePage } from './main/ProfilePage';
import { TopicPage } from './main/TopicPage';

@Entry
@Component
struct Index {
  @State currentPageIndex: number = 0;

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        ForEach(tabBarList, (item: TabBarModel, index: number) => {
          TabContent() {
            if (index == 0) {
              Homepage()
            } else if (index == 1) {
              SortPage()
            } else if (index == 2) {
              TopicPage()
            }else if (index == 3) {
              CartPage()
            } else {
              ProfilePage()
            }
          }.tabBar(this.BottomNavigation(tabBarList[index]))
        }, item => JSON.stringify(item))
      }
      .barWidth('100%')
      .barHeight(56)
      .scrollable(false)
      .onChange((index: number) => {
        this.currentPageIndex = index;
      })
    }.backgroundColor(Color.White)
  }

  @Builder BottomNavigation(item: TabBarModel) {
    Column() {
      Image(this.currentPageIndex == item.index ? item.selectImg : item.normalImg)
        .objectFit(ImageFit.Contain)
        .width(24)
        .height(24)
      Text(item.title)
        .fontColor(this.currentPageIndex == item.index ? '#e92f4f' : Color.Black)
        .fontWeight(500)
        .textAlign(TextAlign.Center)
        .fontSize(12)
    }.width('100%').height('100%').alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.Center)
  }
}
