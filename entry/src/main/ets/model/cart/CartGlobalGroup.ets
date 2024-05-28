import { CartItemListItem } from './CartItemListItem'

export class CartGlobalGroup {
  promTitle: string
  promTip: string
  promId: number
  promType: number
  promSatisfy: boolean
  couponSendOut: boolean
  invalid: boolean
  checked: boolean
  canCheck: boolean
  promotionTip: string
  showTable: boolean
  showCheck: boolean
  addBuyPreview: AddBuyPreview
  cartItemList:Array<CartItemListItem>
}

export class AddBuyPreview {
  addBuyPreviewItemList: Array<CartItemListItem>
  hasMore: boolean
  tip: string
}