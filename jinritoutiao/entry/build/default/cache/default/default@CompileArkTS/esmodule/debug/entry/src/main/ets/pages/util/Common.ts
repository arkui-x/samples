import { images, Review, reviewAgo, reviewContent, reviewImg, reviewLove, reviewName, videos, where } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Mock";
interface RetValue {
    left: number;
    top: number;
    right: number;
    bottom: number;
}
export class Utils {
    static rect_left: number;
    static rect_top: number;
    static rect_right: number;
    static rect_bottom: number;
    static rect_value: RetValue;
    //获取组件所占矩形区域坐标
    static getComponentRect(key: string): Record<string, number> {
        let strJson = getInspectorByKey(key);
        let obj: Record<string, string> = JSON.parse(strJson);
        let rectInfo: string[] = JSON.parse('[' + obj.$rect + ']');
        Utils.rect_left = JSON.parse('[' + rectInfo[0] + ']')[0];
        Utils.rect_top = JSON.parse('[' + rectInfo[0] + ']')[1];
        Utils.rect_right = JSON.parse('[' + rectInfo[1] + ']')[0];
        Utils.rect_bottom = JSON.parse('[' + rectInfo[1] + ']')[1];
        return Utils.rect_value = {
            left: Utils.rect_left, top: Utils.rect_top, right: Utils.rect_right, bottom: Utils.rect_bottom
        };
    }
}
export function debounce(fn: () => void, delay: number) {
    let timer = 0;
    const _debounce = () => {
        // 取消上一次的定时器
        if (timer)
            clearTimeout(timer);
        // 延迟执行
        timer = setTimeout(() => {
            // 外部传入的真正要执行的函数
            fn();
            timer = 0;
        }, delay);
    };
    return _debounce;
}
export function formatDate(time: number) {
    let date = new Date(time * 1000);
    let y = date.getFullYear();
    let MM: number | string = date.getMonth() + 1;
    MM = MM < 10 ? ('0' + MM) : MM;
    let d: number | string = date.getDate();
    d = d < 10 ? ('0' + d) : d;
    let h: number | string = date.getHours();
    h = h < 10 ? ('0' + h) : h;
    let m: number | string = date.getMinutes();
    m = m < 10 ? ('0' + m) : m;
    return y + '-' + MM + '-' + d + ' ' + h + ':' + m;
}
export function getReviewList(length: number): Review[] {
    let ary: Review[] = [];
    for (let i = 0; i < length; i++) {
        ary.push(new Review(reviewImg[Math.floor(Math.random() * 7)], `${reviewName[Math.floor(Math.random() * 8)]}${i}${i}`, reviewContent[Math.floor(Math.random() * 8)], reviewAgo[Math.floor(Math.random() * 8)], where[Math.floor(Math.random() * 21)], reviewLove[Math.floor(Math.random() * 8)]));
    }
    return ary;
}
export function getTimeStr(timestamp: number) {
    const diff = timestamp / 1000; // 毫秒转换为秒
    if (diff < 60) {
        return "刚刚";
    }
    else if (diff < 3600) {
        return Math.floor(diff / 60) + "分钟前";
    }
    else if (diff < 86400) {
        return Math.floor(diff / 3600) + "小时前";
    }
    else if (diff < 604800) {
        return Math.floor(diff / 86400) + "天前";
    }
    else {
        return '一个月前';
    }
}
export function getVideoRandom(key: string) {
    let random = Math.floor(Math.random() * 6);
    if (key === 'src') {
        return videos[random];
    }
    else {
        return images[random];
    }
}
