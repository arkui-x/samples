import http from "@ohos:net.http";
class Log_pb {
    author_id: string;
    cell_layout_style: string;
    group_source: string;
    impr_id: string;
    is_customized_cover: string;
    is_following: string;
    is_portrait_shown: string;
    is_yaowen: string;
    logpb_group_id: string;
    sentinel_type: string;
    ui_style: string;
    constructor(author_id: string, cell_layout_style: string, group_source: string, impr_id: string, is_customized_cover: string, is_following: string, is_portrait_shown: string, is_yaowen: string, logpb_group_id: string, sentinel_type: string, ui_style: string) {
        this.author_id = author_id;
        this.cell_layout_style = cell_layout_style;
        this.group_source = group_source;
        this.impr_id = impr_id;
        this.is_customized_cover = is_customized_cover;
        this.is_following = is_following;
        this.is_portrait_shown = is_portrait_shown;
        this.is_yaowen = is_yaowen;
        this.logpb_group_id = logpb_group_id;
        this.sentinel_type = sentinel_type;
        this.ui_style = ui_style;
    }
}
class UserInfo {
    avatar_url: string;
    description: string;
    follow: boolean;
    live_info_type: number;
    name: string;
    user_auth_info: string;
    user_id: string;
    user_verified: boolean;
    verified_content: string;
    constructor(avatar_url: string, description: string, follow: boolean, live_info_type: number, name: string, user_auth_info: string, user_id: string, user_verified: boolean, verified_content: string) {
        this.avatar_url = avatar_url;
        this.description = description;
        this.follow = follow;
        this.live_info_type = live_info_type;
        this.name = name;
        this.user_auth_info = user_auth_info;
        this.user_id = user_id;
        this.user_verified = user_verified;
        this.verified_content = verified_content;
    }
}
class Media_info {
    avatar_url: string;
    media_id: number;
    name: string;
    user_verified: boolean;
    id: string;
    user_id: string;
    constructor(avatar_url: string, media_id: number, name: string, user_verified: boolean, id: string, user_id: string) {
        this.avatar_url = avatar_url;
        this.media_id = media_id;
        this.name = name;
        this.user_verified = user_verified;
        this.id = id;
        this.user_id = user_id;
    }
}
interface ActionList {
    action: number;
}
class FilterWordsItem {
    id: string;
    is_selected: boolean;
    name: string;
    constructor(id: string, is_selected: boolean, name: string) {
        this.id = id;
        this.is_selected = is_selected;
        this.name = name;
    }
}
class FilterWords {
    action_extra: string;
    filter_words: FilterWordsItem[];
    show_dislike: boolean;
    constructor(action_extra: string, filter_words: FilterWordsItem[], show_dislike: boolean) {
        this.action_extra = action_extra;
        this.filter_words = filter_words;
        this.show_dislike = show_dislike;
    }
}
interface Url {
    url: string;
}
export class ImageList {
    height: number;
    uri: string;
    url: string;
    url_list: Url[];
    width: number;
    constructor(height: number, uri: string, url: string, url_list: Url[], width: number) {
        this.height = height;
        this.uri = uri;
        this.url = url;
        this.url_list = url_list;
        this.width = width;
    }
}
interface ForwardInfo {
    forward_count: number;
}
class Optional {
    ban_download: string;
    keynews_expire_time: string;
    yunyu_type: string;
    constructor(ban_download: string, keynews_expire_time: string, yunyu_type: string) {
        this.ban_download = ban_download;
        this.keynews_expire_time = keynews_expire_time;
        this.yunyu_type = yunyu_type;
    }
}
class ShareType {
    pyq: number;
    qq: number;
    qzone: number;
    wx: number;
    constructor(pyq: number, qq: number, qzone: number, wx: number) {
        this.pyq = pyq;
        this.qq = qq;
        this.qzone = qzone;
        this.wx = wx;
    }
}
class ShareInfo {
    on_suppress: number;
    share_type: ShareType;
    share_url: string;
    title: string;
    token_type: number;
    constructor(on_suppress: number, share_type: ShareType, share_url: string, title: string, token_type: number) {
        this.on_suppress = on_suppress;
        this.share_type = share_type;
        this.share_url = share_url;
        this.title = title;
        this.token_type = token_type;
    }
}
class UgcRecommend {
    activity: string;
    reason: string;
    constructor(activity: string, reason: string) {
        this.activity = activity;
        this.reason = reason;
    }
}
interface VideoImg {
    height: number;
    uri: string;
    url: string;
    url_list: Url[];
    width: number;
}
class VideoDetail {
    detail_video_large_image: VideoImg;
    direct_play: number;
    group_flags: number;
    show_pgc_subscribe: number;
    video_id: string;
    video_preloading_flag: number;
    video_subject_id: number;
    video_type: number;
    video_watch_count: number;
    constructor(detail_video_large_image: VideoImg, direct_play: number, group_flags: number, show_pgc_subscribe: number, video_id: string, video_preloading_flag: number, video_subject_id: number, video_type: number, video_watch_count: number) {
        this.detail_video_large_image = detail_video_large_image;
        this.direct_play = direct_play;
        this.group_flags = group_flags;
        this.show_pgc_subscribe = show_pgc_subscribe;
        this.video_id = video_id;
        this.video_preloading_flag = video_preloading_flag;
        this.video_subject_id = video_subject_id;
        this.video_type = video_type;
        this.video_watch_count = video_watch_count;
    }
}
export class NewsItem {
    video_detail_info: VideoDetail;
    Abstract: string;
    action_extra: string;
    action_list: ActionList[];
    aggr_type: number;
    article_alt_url: string;
    article_sub_type: number;
    article_type: number;
    article_url: string;
    article_version: number;
    ban_comment: boolean;
    ban_danmaku: boolean;
    behot_time: number;
    bury_count: number;
    bury_style_show: number;
    cell_flag: number;
    cell_layout_style: number;
    cell_type: number;
    city: string;
    comment_count: number;
    common_raw_data: string;
    content_hash: string;
    cursor: number;
    data_type: number;
    detail_content: string;
    digg_count: number;
    disallow_web_transform: number;
    display_url: string;
    filter_words: FilterWords;
    forward_info: ForwardInfo;
    gallary_image_count: number;
    group_flags: number;
    group_id: string;
    group_source: number;
    group_type: number;
    has_image: boolean;
    has_m3u8_video: boolean;
    has_mp4_video: boolean;
    has_video: boolean;
    hot: number;
    id: string;
    image_list: ImageList[];
    image_type: string;
    info_desc: string;
    item_id: string;
    item_version: number;
    keywords: string;
    label: string;
    label_style: number;
    level: number;
    like_count: number;
    log_pb: Log_pb;
    media_info: Media_info;
    media_name: string;
    middle_image: ImageList;
    natant_level: number;
    need_client_impr_recycle: number;
    open_url: string;
    optional_data: Optional;
    preload_web: number;
    publish_time: number;
    raw_data: string;
    read_count: number;
    reason: string;
    reback_flag: number;
    repin_count: number;
    repin_time: number;
    req_id: string;
    share_count: number;
    share_info: ShareInfo;
    share_large_image: ImageList;
    share_url: string;
    show_max_line: number;
    source: string;
    source_icon_style: number;
    source_open_url: string;
    subject_group_id: number;
    tag: string;
    tag_id: number;
    tc_head_text: string;
    tip: number;
    title: string;
    ugc_recommend: UgcRecommend;
    url: string;
    user_bury: boolean;
    user_digg: boolean;
    user_info: UserInfo;
    user_like: number;
    user_repin: boolean;
    user_repin_time: number;
    user_verified: number;
    verified_content: string;
    video_duration: number;
    video_style: number;
    constructor(video_detail_info: VideoDetail, Abstract: string, action_extra: string, action_list: ActionList[], aggr_type: number, article_alt_url: string, article_sub_type: number, article_type: number, article_url: string, article_version: number, ban_comment: boolean, ban_danmaku: boolean, behot_time: number, bury_count: number, bury_style_show: number, cell_flag: number, cell_layout_style: number, cell_type: number, city: string, comment_count: number, common_raw_data: string, content_hash: string, cursor: number, data_type: number, detail_content: string, digg_count: number, disallow_web_transform: number, display_url: string, filter_words: FilterWords, forward_info: ForwardInfo, gallary_image_count: number, group_flags: number, group_id: string, group_source: number, group_type: number, has_image: boolean, has_m3u8_video: boolean, has_mp4_video: boolean, has_video: boolean, hot: number, id: string, image_list: ImageList[], image_type: string, info_desc: string, item_id: string, item_version: number, keywords: string, label: string, label_style: number, level: number, like_count: number, log_pb: Log_pb, media_info: Media_info, media_name: string, middle_image: ImageList, natant_level: number, need_client_impr_recycle: number, open_url: string, optional_data: Optional, preload_web: number, publish_time: number, raw_data: string, read_count: number, reason: string, reback_flag: number, repin_count: number, repin_time: number, req_id: string, share_count: number, share_info: ShareInfo, share_large_image: ImageList, share_url: string, show_max_line: number, source: string, source_icon_style: number, source_open_url: string, subject_group_id: number, tag: string, tag_id: number, tc_head_text: string, tip: number, title: string, ugc_recommend: UgcRecommend, url: string, user_bury: boolean, user_digg: boolean, user_info: UserInfo, user_like: number, user_repin: boolean, user_repin_time: number, user_verified: number, verified_content: string, video_duration: number, video_style: number) {
        this.video_detail_info = video_detail_info;
        this.Abstract = Abstract;
        this.action_extra = action_extra;
        this.action_list = action_list;
        this.aggr_type = aggr_type;
        this.article_alt_url = article_alt_url;
        this.article_sub_type = article_sub_type;
        this.article_type = article_type;
        this.article_url = article_url;
        this.article_version = article_version;
        this.ban_comment = ban_comment;
        this.ban_danmaku = ban_danmaku;
        this.behot_time = behot_time;
        this.bury_count = bury_count;
        this.bury_style_show = bury_style_show;
        this.cell_flag = cell_flag;
        this.cell_layout_style = cell_layout_style;
        this.cell_type = cell_type;
        this.city = city;
        this.comment_count = comment_count;
        this.common_raw_data = common_raw_data;
        this.content_hash = content_hash;
        this.cursor = cursor;
        this.data_type = data_type;
        this.detail_content = detail_content;
        this.digg_count = digg_count;
        this.disallow_web_transform = disallow_web_transform;
        this.display_url = display_url;
        this.filter_words = filter_words;
        this.forward_info = forward_info;
        this.gallary_image_count = gallary_image_count;
        this.group_flags = group_flags;
        this.group_id = group_id;
        this.group_source = group_source;
        this.group_type = group_type;
        this.has_image = has_image;
        this.has_m3u8_video = has_m3u8_video;
        this.has_mp4_video = has_mp4_video;
        this.has_video = has_video;
        this.hot = hot;
        this.id = id;
        this.image_list = image_list;
        this.image_type = image_type;
        this.info_desc = info_desc;
        this.item_id = item_id;
        this.item_version = item_version;
        this.keywords = keywords;
        this.label = label;
        this.label_style = label_style;
        this.level = level;
        this.like_count = like_count;
        this.log_pb = log_pb;
        this.media_info = media_info;
        this.media_name = media_name;
        this.middle_image = middle_image;
        this.natant_level = natant_level;
        this.need_client_impr_recycle = need_client_impr_recycle;
        this.open_url = open_url;
        this.optional_data = optional_data;
        this.preload_web = preload_web;
        this.publish_time = publish_time;
        this.raw_data = raw_data;
        this.read_count = read_count;
        this.reason = reason;
        this.reback_flag = reback_flag;
        this.repin_count = repin_count;
        this.repin_time = repin_time;
        this.req_id = req_id;
        this.share_count = share_count;
        this.share_info = share_info;
        this.share_large_image = share_large_image;
        this.share_url = share_url;
        this.show_max_line = show_max_line;
        this.source = source;
        this.source_icon_style = source_icon_style;
        this.source_open_url = source_open_url;
        this.subject_group_id = subject_group_id;
        this.tag = tag;
        this.tag_id = tag_id;
        this.tc_head_text = tc_head_text;
        this.tip = tip;
        this.title = title;
        this.ugc_recommend = ugc_recommend;
        this.url = url;
        this.user_bury = user_bury;
        this.user_digg = user_digg;
        this.user_info = user_info;
        this.user_like = user_like;
        this.user_repin = user_repin;
        this.user_repin_time = user_repin_time;
        this.user_verified = user_verified;
        this.verified_content = verified_content;
        this.video_duration = video_duration;
        this.video_style = video_style;
    }
}
export class ResponseResult {
    has_more: boolean;
    message: string;
    data: NewsItem[];
    constructor() {
        this.has_more = true;
        this.message = '';
        this.data = [];
    }
}
function httpRequestGet(url: string): Promise<ResponseResult> {
    let httpRequest = http.createHttp();
    let responseResult = httpRequest.request(url, {
        method: http.RequestMethod.GET,
        readTimeout: 60000,
        header: {
            'Content-Type': 'application/json'
        },
        connectTimeout: 60000,
        extraData: {}
    });
    let serverData: ResponseResult = new ResponseResult();
    return responseResult.then((value: http.HttpResponse) => {
        console.log('value.responseCode', value.responseCode);
        if (Number(value.responseCode) == 200) {
            let result = `${value.result}`;
            let resultJson: ResponseResult = JSON.parse(result);
            if (resultJson.message == 'success') {
                serverData.data = resultJson.data;
            }
            serverData.message = resultJson.message;
            serverData.has_more = resultJson.has_more;
        }
        else {
            serverData.message = 'error';
        }
        return serverData;
    }).catch((err: Error) => {
        console.log('httpError', JSON.stringify(err));
        serverData.message = 'error';
        return serverData;
    });
}
export function homePageRequest(key?: string): Promise<NewsItem[]> {
    return new Promise(async (resolve: Function, reject: Function) => {
        //视频网址
        let videoUrl = 'https://www.toutiao.com/api/pc/list/feed?channel_id=3431225546&max_behot_time=1701322954&offset=0&category=pc_profile_channel&client_extra_params=%7B%22short_video_item%22:%22filter%22%7D&aid=24&app_name=toutiao_web&_signature=_02B4Z6wo009010aFesQAAIDCs.qQWrnS63tGoX5AALTUaNYfjixwJgdqcs5FFiIN3dXBQVa7mTCF44Ls9UnvN9W33BgPeMYvUEXQVhkaD9tfn7eoHOl8lwDYwEAqZeiYEPfn.HngHxxSBCwL2b';
        //图文、文字网址
        let newsUrl = 'https://www.toutiao.com/api/pc/list/feed?channel_id=0&max_behot_time=1701322873&offset=0&category=pc_profile_recommend&aid=24&app_name=toutiao_web&_signature=_02B4Z6wo00901SrwKnAAAIDA34.A7NfPQUEq1C7AAC.XaNYfjixwJgdqcs5FFiIN3dXBQVa7mTCF44Ls9UnvN9W33BgPeMYvUEXQVhkaD9tfn7eoHOl8lwDYwEAqZeiYEPfn.HngHxxSBCwLb2';
        let url = key == 'video' ? videoUrl : newsUrl;
        httpRequestGet(url).then((data: ResponseResult) => {
            if (data.message === 'success' && data.data.length) {
                resolve(data.data);
            }
            else {
                reject('error');
            }
        }).catch((err: Error) => {
            reject('error');
        });
    });
}
