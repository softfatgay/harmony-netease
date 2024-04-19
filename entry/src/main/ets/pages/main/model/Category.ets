import List from '@ohos.util.List'
import { BannerItem } from './BannerItem'
import { ItemPicBeanList } from './ItemPicBeanList'
export class Category {
  id: Number
  superCategoryId: Number
  showIndex: Number
  picUrl: string
  categoryName: string
  targetUrl: String
  showPicUrl: String
  wapBannerUrl: String
  name: String
  frontName: String
  test: String
  itemPicBeanList: List<ItemPicBeanList>
  bannerList: List<BannerItem>
}
