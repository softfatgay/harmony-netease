import { AddBuyStepListItem } from './AddBuyStepListItem'
import { CartItemListItem } from './CartItemListItem'

export class CarItem {
  id: number
  promId: number
  promType: number
  cartItemList: Array<CartItemListItem>
  promTip: String
  promTipArray: Object
  promSatisfy: boolean
  checked: boolean
  canCheck: boolean
  showCheck: boolean
  editChecked: boolean
  promNotSatisfyType: number
  promotionBtn: number
  allowCount: number
  type: number
  suitCount: number
  source: number
  addBuyStepArray: Array<AddBuyStepListItem>
  giftStepArray: Array<AddBuyStepListItem>
}