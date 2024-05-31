import http from '@ohos.net.http';

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
    this.avatar_url = avatar_url
    this.description = description
    this.follow = follow
    this.live_info_type = live_info_type
    this.name = name
    this.user_auth_info = user_auth_info
    this.user_id = user_id
    this.user_verified = user_verified
    this.verified_content = verified_content
  }
}

class MediaInfo {
  avatar_url: string;
  follow: boolean;
  is_star_user: boolean;
  media_id: number;
  name: string;
  recommend_reason: string;
  recommend_type: number;
  live_info_type: number;
  user_id: string;
  user_verified: boolean;
  verified_content: string;

  constructor(avatar_url: string, follow: boolean, is_star_user: boolean, media_id: number, name: string, recommend_reason: string, recommend_type: number, live_info_type: number, user_id: string, user_verified: boolean, verified_content: string) {
    this.avatar_url = avatar_url
    this.is_star_user = is_star_user
    this.follow = follow
    this.media_id = media_id
    this.name = name
    this.recommend_reason = recommend_reason
    this.recommend_type = recommend_type
    this.live_info_type = live_info_type
    this.user_id = user_id
    this.user_verified = user_verified
    this.verified_content = verified_content
  }
}

interface Url {
  url: string
}

export class ImageList {
  height: number;
  uri: string;
  url: string;
  url_list: Url[];
  width: number;

  constructor(height: number, uri: string, url: string, url_list: Url[], width: number) {
    this.height = height
    this.uri = uri
    this.url = url
    this.url_list = url_list
    this.width = width
  }
}

export class NewsItem {
  abstract: string;
  behot_time: number;
  comment_count: number;
  common_raw_data: string
  digg_count: number;
  has_image: boolean;
  image_list: ImageList[];
  detail_image_list: ImageList[];
  publish_time: number;
  share_count: number;
  source: string;
  title: string;
  user_info: UserInfo;
  media_info: MediaInfo

  constructor(detail_image_list: ImageList[], abstract: string, behot_time: number, comment_count: number, common_raw_data: string, digg_count: number, has_image: boolean, image_list: ImageList[], publish_time: number, share_count: number, source: string, title: string, user_info: UserInfo, media_info: MediaInfo) {
    this.abstract = abstract
    this.behot_time = behot_time
    this.comment_count = comment_count
    this.common_raw_data = common_raw_data
    this.digg_count = digg_count
    this.has_image = has_image
    this.image_list = image_list
    this.publish_time = publish_time
    this.share_count = share_count
    this.source = source
    this.title = title
    this.user_info = user_info
    this.detail_image_list = detail_image_list
    this.media_info = media_info
  }
}

export interface ContentItem {
  code: string
  content: string
}

export class ResponseResult {
  message: string;
  data: ContentItem[];

  constructor() {
    this.message = '';
    this.data = [];
  }
}

export class NewsData {
  message: string;
  data: NewsItem[];

  constructor() {
    this.message = '';
    this.data = [];
  }
}

function httpRequestGet(url: string): Promise<NewsData> {
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
  let serverData: NewsData = new NewsData();
  return responseResult.then((value: http.HttpResponse) => {
    console.log('value.responseCode', value.responseCode)
    if (Number(value.responseCode) == 200) {
      let result = `${value.result}`;
      console.log('value.responseCode', result)
      let resultJson: ResponseResult = JSON.parse(result);
      console.log('resultJson', resultJson)
      if (resultJson.message == 'success') {
        let serverItem: NewsItem[] = resultJson.data.map((t: ContentItem): NewsItem => (JSON.parse(t.content)))
        serverData.data = serverItem;
      }
      serverData.message = resultJson.message;
    } else {
      serverData.message = 'error';
    }
    return serverData;
  }).catch((err: Error) => {
    console.log('httpError', JSON.stringify(err))
    serverData.message = 'error';
    return serverData;
  })
}

export function homePageRequest(key?: string): Promise<NewsItem[]> {
  return new Promise(async (resolve: Function, reject: Function) => {
    let newsUrl = 'https://is.snssdk.com/api/news/feed/v58/'
    httpRequestGet(newsUrl).then((data: NewsData) => {
      if (data.message === 'success' && data.data.length) {
        if (key == 'video') {
          resolve(data.data.splice(0, 4));
        } else {
          resolve(data.data);
        }
      } else {
        reject('error');
      }
    }).catch((err: Error) => {
      reject('error');
    });
  });
}