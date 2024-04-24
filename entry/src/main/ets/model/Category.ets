import List from '@ohos.util.List'
import { BannerItem } from './BannerItem'
import { ItemPicBeanList } from './home/ItemPicBeanList'
export class Category {
  id: Number
  superCategoryId: Number
  showIndex: Number
  picUrl: string
  categoryName: string
  targetUrl: String
  showPicUrl: String
  wapBannerUrl: string
  name: string
  frontName: String
  test: String
  itemPicBeanList: List<ItemPicBeanList>
  bannerList: List<BannerItem>
}
