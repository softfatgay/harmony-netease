import List from '@ohos.util.List'
import { BannerItem } from '../BannerItem'

export class CurrentCategory {
  id: number
  superCategoryId: number
  showIndex: number
  name: string
  frontName: string
  frontDesc: string
  bannerUrl: string
  showItem: ShowItem
  bannerList: Array<BannerItem>
  subCateList: Array<CurrentCategory>
}

export class ShowItem {
  id: number
  picUrl: string
}