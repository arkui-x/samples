export interface BotItem {
  text: string; //文本
  icon_normal: Resource; // 默认图标
  icon_selected: Resource; // 选中图标
}

export interface TopItem {
  title: string
  content?: string
}

export class Review {
  img: Resource;
  name: string;
  content: string;
  ago: string;
  where: string;
  love: number;

  constructor(img: Resource, name: string, content: string, ago: string, where: string, love: number) {
    this.img = img
    this.name = name
    this.content = content
    this.ago = ago
    this.where = where
    this.love = love
  }
}

export const where: string[] = ['北京', '上海', '苏州', '杭州', '南京', '长沙', '武汉', '西藏', '海南', '沈阳', '哈尔滨', '郑州', '洛阳', '焦作', '合肥', '福州', '厦门', '兰州', '贵阳', '石家庄', '长春', '吉林']

export const reviewImg: Resource[] = [$r('app.media.user1'), $r('app.media.user2'), $r('app.media.user3'), $r('app.media.user4'), $r('app.media.user55'), $r('app.media.user6'), $r('app.media.user7')]

export const reviewName: string[] = ['山河无恙1472', '直爽的孤勇者', '成熟百灵鸟RNX', '果壳里的宇宙0sS6', '颂岩1', '二哥19525', '姹紫亦千红', '雨中的凤米花']

export const reviewContent: string[] = ['妥妥的干货,赞赞', '已经收藏起来加关注，写的不错，很中肯', '中国好声音！', '大力推进成熟先进技术的工程化实践，从而推动行业技术进步和能力水平提升', '推动钢铁业高质量发展 ，加强科技创新和成果转化', '相约浙江乌镇，共绘数字合作美好愿景。', '十年沉淀，十年辉煌，祝伟大的祖国繁荣昌盛国泰民安！', '以创新保安全，集中力量攻克卡脖子钢材和核心技术！']

export const reviewAgo: string[] = ['5分钟前', '20分钟前', '30分钟前', '1小时前', '2小时前', '5小时前', '8小时前', '12小时前']

export const reviewLove: number[] = [0, 5, 22, 115, 223, 326, 562, 663]

export const WhereRandom: string = where[Math.floor(Math.random() * 22)]

export const NavBottom: BotItem[] = [
  {
    icon_normal: $r('app.media.ic_public_view_list'),
    icon_selected: $r('app.media.ic_public_view_list_click'),
    text: '首页',
  },
  {
    icon_normal: $r('app.media.ic_public_play'),
    icon_selected: $r('app.media.ic_public_play_click'),
    text: '视频',
  },
  {
    icon_normal: $r('app.media.ic_public_appstore'),
    icon_selected: $r('app.media.ic_public_appstore_click'),
    text: '商城',
  },
  {
    icon_normal: $r('app.media.ic_public_contacts'),
    icon_selected: $r('app.media.ic_public_contacts_click'),
    text: '未登录',
  },
]

export const NavTop: TopItem[] = [
  {
    title: '推荐',
    content: '推荐内容'
  },
  {
    title: '杭州',
    content: '杭州内容'
  },
  {
    title: '直播',
    content: '直播内容'
  },
  {
    title: '科技',
    content: '科技内容'
  },
  {
    title: '军事',
    content: '军事内容'
  },
  {
    title: '国际',
    content: '国际内容'
  },
  {
    title: '财经',
    content: '财经内容'
  },
  {
    title: '法律',
    content: '法律内容'
  },
  {
    title: '政法',
    content: '政法内容'
  },
  {
    title: '视界',
    content: '视界内容'
  },
]

export const videos: string[] = ['https://prod-streaming-video-msn-com.akamaized.net/a8c412fa-f696-4ff2-9c76-e8ed9cdffe0f/604a87fc-e7bc-463e-8d56-cde7e661d690.mp4', 'https://prod-streaming-video-msn-com.akamaized.net/fb194c01-2ff6-4b4e-afbd-a00289124c4c/af7a74f5-5cb6-423e-b428-d05c0d36478d.mp4', 'https://prod-streaming-video-msn-com.akamaized.net/178161a4-26a5-4f84-96d3-6acea1909a06/2213bcd0-7d15-4da0-a619-e32d522572c0.mp4', 'https://prod-streaming-video-msn-com.akamaized.net/e908e91f-370f-49ad-b4ce-775b7e7a05b4/a6287f74-46f0-42f9-b5d9-997f00585696.mp4', 'https://prod-streaming-video-msn-com.akamaized.net/fe13f13c-c2cc-4998-b525-038b23bfa9b5/1a9d30ca-54be-411e-8b09-d72ef4488e05.mp4']

export const images: Resource[] = [$r('app.media.uri1'), $r('app.media.uri2'), $r('app.media.uri3'), $r('app.media.uri4'), $r('app.media.uri5')]

export const imgs: Resource[] = [$r('app.media.image1'), $r('app.media.img'), $r('app.media.img_1'), $r('app.media.img_2'), $r('app.media.img_3'),$r('app.media.img_4'),$r('app.media.img_5'),$r('app.media.img_6'),$r('app.media.img_7')]