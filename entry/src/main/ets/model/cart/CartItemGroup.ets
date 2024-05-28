import { CartGlobalGroup } from './CartGlobalGroup'

export class CartItemGroup{
  groupTitle:string
  groupTip:string
  checked:boolean
  canCheck:boolean
  promotionGroupList:Array<CartGlobalGroup>
}