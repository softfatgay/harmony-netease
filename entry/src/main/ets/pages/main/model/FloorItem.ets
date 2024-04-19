import List from '@ohos.util.List'
import { Cells } from './CellsModel'
export class FloorItem {
  layout: Number
  columnNum: number
  floorType: Number
  cells: Array<Cells> = []
  style: Number
  taskId: Number
  height: Number
}