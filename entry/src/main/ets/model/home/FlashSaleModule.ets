import List from '@ohos.util.List'
import { FlashSaleModuleItem } from './FlashSaleModuleItem'

export class FlashSaleModule {
  activityPrice: Number
  nextStartTime: Number
  remainTime: Number
  flashSaleScreenId: Number
  showFlash: Boolean
  primaryPicUrl: String
  itemList: List<FlashSaleModuleItem>
}