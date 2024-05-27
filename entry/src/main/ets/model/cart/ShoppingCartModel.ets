import { CarItem } from './CarItem'
import { PostageVO } from './PostageVO'

export class ShoppingCartModel {
  totalPrice: number
  promotionPrice: number
  actualPrice: number
  totalPoint: number
  actualPoint: number
  postageVO: PostageVO
  cartGroupList: Array<CarItem>
  invalidCartGroupList: Array<CarItem>
}