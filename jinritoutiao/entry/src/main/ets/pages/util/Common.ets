import {
  images,
  imgs,
  Review,
  reviewAgo,
  reviewContent,
  reviewImg,
  reviewLove,
  reviewName,
  videos,
  where
} from './Mock'

export function debounce(fn: () => void, delay: number) {
  let timer = 0
  const _debounce = () => {
    // 取消上一次的定时器
    if (timer) clearTimeout(timer)
    // 延迟执行
    timer = setTimeout(() => {
      // 外部传入的真正要执行的函数
      fn()
      timer = 0
    }, delay)
  }
  return _debounce
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
  let ary: Review[] = []
  for (let i = 0; i < length; i++) {
    ary.push(new Review(reviewImg[Math.floor(Math.random() * 7)], `${reviewName[Math.floor(Math.random() * 8)]}${i}${i}`, reviewContent[Math.floor(Math.random() * 8)], reviewAgo[Math.floor(Math.random() * 8)], where[Math.floor(Math.random() * 21)], reviewLove[Math.floor(Math.random() * 8)]));
  }
  return ary
}

export function getTimeStr(timestamp: number) {
  const diff = timestamp / 1000; // 毫秒转换为秒

  if (diff < 60) {
    return "刚刚";
  } else if (diff < 3600) {
    return Math.floor(diff / 60) + "分钟前";
  } else if (diff < 86400) {
    return Math.floor(diff / 3600) + "小时前";
  } else if (diff < 604800) {
    return Math.floor(diff / 86400) + "天前";
  } else {
    return '一个月前';
  }
}

export function getVideoRandom(key: string) {
  let random = Math.floor(Math.random() * 5)
  if (key === 'src') {
    return videos[random]
  } else {
    return images[random]
  }
}
