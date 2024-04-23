import List from '@ohos.util.List';
import { CategoryGroupItem } from './CategoryGroupItem';
import { CategoryL1Item } from './CategoryL1Item';
import { CurrentCategory } from './CurrentCategory';

export class SortData {
  categoryL1List: Array<CategoryL1Item>
  currentCategory: CurrentCategory
  categoryGroupList: Array<CategoryGroupItem>
}