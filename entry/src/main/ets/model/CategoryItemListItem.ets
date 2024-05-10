import { Category } from './Category';
import { ItemListItem } from './ItemListItem';

export class CategoryItemListItem {
  category: Category
  itemList: Array<ItemListItem>
  type: number = 1
}