import HomePageTest from './HomePage.test'
import IndexTest from './Index.test'
import abilityTest from './Ability.test'

export default function testsuite() {
  abilityTest()
  IndexTest()
  HomePageTest()
}