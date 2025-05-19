import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

export default class FragmentAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'FragmentAbility onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'FragmentAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this FragmentAbility
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'FragmentAbility onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'FragmentAbility onWindowStageDestroy');
  }

  onForeground(): void {
    // FragmentAbility has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'FragmentAbility onForeground');
  }

  onBackground(): void {
    // FragmentAbility has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'FragmentAbility onBackground');
  }
}
