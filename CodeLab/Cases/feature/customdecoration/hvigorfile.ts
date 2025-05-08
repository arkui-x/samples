import { harTasks } from '@ohos/hvigor-ohos-plugin';
import { DecorationPluginConfig, etsDecorationPlugin } from '@app/ets-decoration-generator';

const config: DecorationPluginConfig = {
    scanFiles: ["src/main/ets/components/MainPage"],
}

export default {
    system: harTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins:[etsDecorationPlugin(config)]         /* Custom plugin to extend the functionality of Hvigor. */
}
