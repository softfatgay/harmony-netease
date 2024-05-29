export class UserModel {
  userSimpleVO: UserSimpleVO
  spmcEntrance: SpmcEntrance
  monthCardEntrance: WelfareCardEntrance
  welfareFissionInfo: WelfareFissionInfo
  welfareCardEntrance: WelfareCardEntrance
}

export class UserSimpleVO {
  avatar: string
  nickname: string
  memberLevel: number
  isNewUser: number
  hasInterestCategory: boolean
  hasMemGift: boolean
  pointsCnt: number
  mosaicUid: string
  uniqueId: number
  frontendAccountType: number
  hideQrCode: boolean
  mobile: string
}

export class SpmcEntrance {
  open: boolean
  status: number
  statusDesc: string
  showGiftIcon: boolean
}

export class MonthCardEntrance {
  title: string
  content: string
}

export class WelfareFissionInfo {
  picUrl: string
  schemeUrl: string
}

export class WelfareCardEntrance {
  title: string
  content: string
  url: string
  userType: number
  hasBuy: boolean
  type: number
  buttonName: string
  iconPicUrl: string
  titleUrl: string
}