import { CartItemListItem } from './CartItemListItem'

export class AddBuyStepListItem {
  stepNo: number
  title: string
  isSatisfy: boolean
  addBuyItemList: Array<CartItemListItem>
  giftItemList: Array<CartItemListItem>
}