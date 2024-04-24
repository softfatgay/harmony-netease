import List from '@ohos.util.List'
import { SkuSpecValue } from './SkuSpecValue'

export class SkuSpecListItem {
  id: number
  name: String
  type: number
  skuSpecValueList: List<SkuSpecValue>
}