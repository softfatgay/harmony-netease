import List from '@ohos.util.List'
import { BannerItem } from './BannerItem'
import { ItemPicBeanList } from './home/ItemPicBeanList'
import { KingKongType } from './kinfkong/KingKongType'

export class Category extends KingKongType {
  id: Number
  superCategoryId: Number
  showIndex: Number
  picUrl: string
  categoryName: string
  targetUrl: string
  showPicUrl: String
  wapBannerUrl: string
  name: string
  frontName: String
  frontDesc: string
  test: String
  itemPicBeanList: List<ItemPicBeanList>
  bannerList: Array<BannerItem>
  type: number = 0
}
