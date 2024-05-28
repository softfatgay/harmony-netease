import { LocationItemModel } from '../LocationItemModel'
import { CartBottomBannerVO } from './CartBottomBannerVO'
import { CartGlobalGroup } from './CartGlobalGroup'
import { CartItemGroup } from './CartItemGroup'
import { CartItemListItem } from './CartItemListItem'
import { GlobalInfoVO } from './GlobalInfoVO'
import { PriceDetailBanner } from './PriceDetailBanner'

export class CartModel{
  cartAddressVO:Array<LocationItemModel>
  cartGlobalGroupList:Array<CartGlobalGroup>
  cartItemGroupList:Array<CartItemGroup>
  invalidItemList:Array<CartItemListItem>
  priceDetailBanner:PriceDetailBanner
  cartBottomBannerVO:CartBottomBannerVO
  globalInfoVO:GlobalInfoVO
}