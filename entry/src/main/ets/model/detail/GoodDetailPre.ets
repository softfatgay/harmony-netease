import { PolicyListItem } from '../SkuMapValue';
import { GoodDetail } from './GoodDetail';

export class GoodDetailPre {
  item: GoodDetail
  policyList: Array<PolicyListItem>
  commentCount: number
  commentWithPicCount: number
  source: number
}