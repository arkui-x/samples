import { describe, it, expect } from '@ohos/hypium'
import { ON,Driver } from '@ohos.UiTest';
export default function IndexTest() {
  describe('IndexTest', async function() {
    const driver = Driver.create();
    const transitionBtn = await driver.findComponent(ON.id('ListItem0'));
    await transitionBtn.click()
    const pageTransitionBtn = await driver.findComponent(ON.id('secondLevelMenu0'));
    await pageTransitionBtn.click()
  })
}