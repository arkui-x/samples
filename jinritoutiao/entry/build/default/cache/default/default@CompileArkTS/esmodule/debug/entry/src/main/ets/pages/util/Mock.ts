export interface BotItem {
    text: string; //文本
    icon_normal: Resource; // 默认图标
    icon_selected: Resource; // 选中图标
}
export interface TopItem {
    title: string;
    content?: string;
}
export class Review {
    img: Resource;
    name: string;
    content: string;
    ago: string;
    where: string;
    love: number;
    constructor(img: Resource, name: string, content: string, ago: string, where: string, love: number) {
        this.img = img;
        this.name = name;
        this.content = content;
        this.ago = ago;
        this.where = where;
        this.love = love;
    }
}
export const where: string[] = ['北京', '上海', '苏州', '杭州', '南京', '长沙', '武汉', '西藏', '海南', '沈阳', '哈尔滨', '郑州', '洛阳', '焦作', '合肥', '福州', '厦门', '兰州', '贵阳', '石家庄', '长春', '吉林'];
export const reviewImg: Resource[] = [{ "id": 16777281, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }, { "id": 16777282, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }, { "id": 16777283, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }, { "id": 16777284, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }, { "id": 16777285, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }, { "id": 16777286, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }, { "id": 16777287, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }];
export const reviewName: string[] = ['山河无恙1472', '直爽的孤勇者', '成熟百灵鸟RNX', '果壳里的宇宙0sS6', '颂岩1', '二哥19525', '姹紫亦千红', '雨中的凤米花'];
export const reviewContent: string[] = ['妥妥的干货,赞赞', '已经收藏起来加关注，写的不错，很中肯', '中国好声音！', '大力推进成熟先进技术的工程化实践，从而推动行业技术进步和能力水平提升', '推动钢铁业高质量发展 ，加强科技创新和成果转化', '相约浙江乌镇，共绘数字合作美好愿景。', '十年沉淀，十年辉煌，祝伟大的祖国繁荣昌盛国泰民安！', '以创新保安全，集中力量攻克卡脖子钢材和核心技术！'];
export const reviewAgo: string[] = ['5分钟前', '20分钟前', '30分钟前', '1小时前', '2小时前', '5小时前', '8小时前', '12小时前'];
export const reviewLove: number[] = [0, 5, 22, 115, 223, 326, 562, 663];
export const WhereRandom: string = where[Math.floor(Math.random() * 22)];
export const NavBottom: BotItem[] = [
    {
        icon_normal: { "id": 16777255, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
        icon_selected: { "id": 16777256, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
        text: '首页',
    },
    {
        icon_normal: { "id": 16777252, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
        icon_selected: { "id": 16777253, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
        text: '视频',
    },
    {
        icon_normal: { "id": 16777244, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
        icon_selected: { "id": 16777245, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
        text: '商城',
    },
    {
        icon_normal: { "id": 16777248, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
        icon_selected: { "id": 16777249, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
        text: '未登录',
    },
];
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
];
export const videos: string[] = ['http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4', 'https://media.w3.org/2010/05/sintel/trailer.mp4', 'http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4', 'http://mirror.aarnet.edu.au/pub/TED-talks/AlGore_2020T-480p.mp4', 'https://www.w3schools.com/html/movie.mp4'];
export const images: Resource[] = [{ "id": 16777276, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }, { "id": 16777277, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }, { "id": 16777278, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }, { "id": 16777279, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }, { "id": 16777280, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" }];
