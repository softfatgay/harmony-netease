import List from '@ohos.util.List'
import { BigPromotionModule } from './BigPromotionModule'
import { CategoryHotSellModule } from './CategoryHotSellModule'
import { FlashSaleModule } from './FlashSaleModule'
import { FocusItem } from './FocusItem'
import { IndexActivityModule } from './IndexActivityModule'
import { KingKongModule } from './KingKongModule'
import { NewItemModel } from './NewItemModel'
import { PolicyDescItem } from './PolicyDescItem'
import { SceneLightShoppingGuideModule } from './SceneLightShoppingGuideModule'
import { TagItem } from './TagItem'

export class HomeModel {
  data: HomeDataModel
  noticeList: List<Object>[]
}

export class HomeDataModel {
  bigPromotionModule: BigPromotionModule
  tagList: List<TagItem>[]
  policyDescList: Array<PolicyDescItem>
  categoryHotSellModule: CategoryHotSellModule
  freshmanFlag: Boolean
  focusList: Array<FocusItem>
  sceneLightShoppingGuideModule: List<SceneLightShoppingGuideModule>
  kingKongModule: KingKongModule
  indexActivityModule: Array<IndexActivityModule>
  newItemList: List<NewItemModel>
  flashSaleModule: FlashSaleModule
  freshmanUrl: String
}
