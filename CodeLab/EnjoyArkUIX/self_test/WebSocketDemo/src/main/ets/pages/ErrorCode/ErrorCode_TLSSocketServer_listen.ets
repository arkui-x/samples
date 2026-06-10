import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';

export interface ProxyOptions {
  type: socket.ProxyTypes;
  address?: socket.NetAddress;
  username?: string;
  password?: string;
}

type ProxyType = socket.ProxyTypes;

interface CommonConfig {
  tlsConnectOptions: socket.TLSConnectOptions;
  proxyOptions?: ProxyOptions;
}

@Entry
@Component
struct testTLSSocketServerListen {
  @State testResults: string[] = [];

  aboutToAppear(): void {
  }

  private readonly serverKey = "-----BEGIN PRIVATE KEY-----\n" +
    "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCgu+M+ROW0Mm34\n" +
    "gkuMfiI/zz9mHOA8uRSj1ck/Wd9Fx6wY77ftxATq+XN8SHxd0u3ZHc2b4sXEtJml\n" +
    "byrhJPXCMmPq702Sy3XWQp3/AB6Bzwy/pM7Rgx90yuEEF+HT2dxS8VI+kYzdm/ji\n" +
    "bBRzGUGD722+k4M6b4Rsayl1/VELENoPT8iNHovOzuZHMI2jcFcVIm+AA9Z9YEXo\n" +
    "FjSHb1FzB/JT5bmNRakY6jXCfTuZVIij91ELBe2X982h5BEHIAp2vziRFuyHmCdJ\n" +
    "Wzevtb6WNmf32ZzyhG7k3PpGU6G5wA5wN66ELFQ/Y9S6mqlVgyw1ZfwYbOEc53bz\n" +
    "QhfokVEnAgMBAAECggEAcWJ5OFjzzTzx1KddUfs8f9Tb/VWLXWqWQ8iw0Y69cQUc\n" +
    "wu5/yitH6NYVgGvFx43fGRTsEPZU2qEn7crQ7cfb0aUoVPeAunfqZT3TJKpZ2upL\n" +
    "LPm+p48e5o2jU/bg6Eg8Iwp3IQod28qGNHtXpaYAUGja+uAmZ1d5i93Afqo2vF2F\n" +
    "sAjVsRTSV7S9PCsVGp1xgMihAA3J+IIU3La0mAiDBuxq6uWLUMIVBwx6t8w9vO0V\n" +
    "cViq4uRuxQT2Z+UODiCqioZ9ek1zr7M7sRVeTY0WQPtgFWvicgz/IU+wlZ1b9h95\n" +
    "ktdWe2MNH1r1Q3KjvZjMyfFy38sZfqBpyOA0QYmW4QKBgQDNK4VfjqLiTrg3IPe5\n" +
    "6F413lzj9rjqDgZZvBCQrmvgO6BB6SGZulC4TIjF7l9EN1v27rnwPBWLMgwvvOdK\n" +
    "B9P+PHDyhXTIxt4ey+/R499A5Z2NdYxT/qmXBnTgshIMmRCCqZHqr9sYkp4nsk+n\n" +
    "0Rsw5z/y1DrHxISlHTyW0VX+MQKBgQDIjhoVerTbDTyazMIA+oVePZC5k3olfw+D\n" +
    "qmHxAHvH6cpM2kl4MaOGd+HpXLP6M0fQIPmZVjA/ytdWH/mSSop6db0VLGSf6AEF\n" +
    "RVvDbcK5N3OhdrZXaT1uJwI05LtO57V6blk1XrSPcrevWxmWyxxBZMjBBiTE1EwR\n" +
    "2M0kzkK21wKBgQCs7/c/AZLIYQQj69UDzhrDG0h/GrLpDqNJthzcZzkky/2cMO8S\n" +
    "jhqGDnTnKbMBZAxPixANsAeUyb2962OlYg3N6ZJmyhkTN5V4rfvallHTePghiaic\n" +
    "EDdQxq9zyoUuO0LQcDA/erWZ89P9r+42jSp3QSUFAOD/C+Wm64rrsU3jsQKBgQCc\n" +
    "LSSc02hhKMaoGYl+L5iKEdFQ4kp9RpvzQUxx25mIzUOPY3FRGv6nqVWQX3N8BFEI\n" +
    "/5S/VsHN+4yC8fVseYWq5WLwSRi2+XlJ/IAACMpZZ5gxBXvrR/XhgJkUTYabZI8L\n" +
    "H0Fy8SQUjRYDhSLBLbv8JJq8zab2bAgs4bKm1cRYEwKBgAHAhpv0aFZbulveNyQ1\n" +
    "Qam0KNxLWQjZscX4kQNOMl301se343+8EVzIM5kCcR1WGgKLAgutoEc+8URPakGm\n" +
    "KAuxhqRmAUfpDfFGkuX25eWLBMOTiKmlxvvLFV1vfwS28dsaH6pMOIQGGpEISY/I\n" +
    "vUUev502w5PXY+keOeHn1+60\n" +
    "-----END PRIVATE KEY-----";

  // 服务端证书
  private readonly serverCert = "-----BEGIN CERTIFICATE-----\n" +
    "MIIDZTCCAk0CFDTT79/rmba0ndVnsXuRu2eHwHApMA0GCSqGSIb3DQEBCwUAMFYx\n" +
    "CzAJBgNVBAYTAkNOMRAwDgYDVQQIDAdCZWlqaW5nMRAwDgYDVQQHDAdCZWlqaW5n\n" +
    "MQ4wDAYDVQQKDAVNeSBDQTETMBEGA1UEAwwKTXkgUm9vdCBDQTAeFw0yNTEyMDQw\n" +
    "ODAyMDhaFw0yNjEyMDQwODAyMDhaMIGHMQswCQYDVQQGEwJDTjERMA8GA1UECAwI\n" +
    "c2hhbmdoYWkxETAPBgNVBAcMCHNoYW5naGFpMRQwEgYDVQQKDAtIVUFXRUlfVEVT\n" +
    "VDEWMBQGA1UECwwNY29tbXVuaWNhdGlvbjESMBAGA1UEAwwJMTI3LjAuMC4xMRAw\n" +
    "DgYJKoZIhvcNAQkBFgEwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA\n" +
    "oLvjPkTltDJt+IJLjH4iP88/ZhzgPLkUo9XJP1nfRcesGO+37cQE6vlzfEh8XdLt\n" +
    "2R3Nm+LFxLSZpW8q4ST1wjJj6u9Nkst11kKd/wAegc8Mv6TO0YMfdMrhBBfh09nc\n" +
    "UvFSPpGM3Zv44mwUcxlBg+9tvpODOm+EbGspdf1RCxDaD0/IjR6Lzs7mRzCNo3BX\n" +
    "FSJvgAPWfWBF6BY0h29RcwfyU+W5jUWpGOo1wn07mVSIo/dRCwXtl/fNoeQRByAK\n" +
    "dr84kRbsh5gnSVs3r7W+ljZn99mc8oRu5Nz6RlOhucAOcDeuhCxUP2PUupqpVYMs\n" +
    "NWX8GGzhHOd280IX6JFRJwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQAxNEKhpVu2\n" +
    "uT5xK1GkbICJ9/84/D8IyZ1mLFZtq4GwOu9/PbzIzrN3mKaWXWcFUuZr19WQ2kRg\n" +
    "P0TmI3IjVEcE7MnCxwf5p65Bdg2g7as8wbuTRldUHd8mwAHUxQkXleBu5tVPiOPt\n" +
    "JW7Nok6V2HJbRXPrkWKpssV9qtxVV8Ju7ELbAi1CujgFDOVZBOMWbgOQtbeGLpNt\n" +
    "uxUVHIAYJenoTomd0MeZJOpv4uS7eZNWJK1K2qX823qx5OuqdCM+BJmVzvdwRS9S\n" +
    "iV+Yoz1FKbfxyQOiZ3gGEY0kwAtKaTjL7FVjwvUImc3wH1pIgsVHrr8aOXVzMulk\n" +
    "wJ9SjDRIyOez\n" +
    "-----END CERTIFICATE-----";

  private readonly serverCa = "-----BEGIN CERTIFICATE-----\n" +
    "MIIDjTCCAnWgAwIBAgIUOs5K47mhbnfCywd9U9lzPTvOzGMwDQYJKoZIhvcNAQEL\n" +
    "BQAwVjELMAkGA1UEBhMCQ04xEDAOBgNVBAgMB0JlaWppbmcxEDAOBgNVBAcMB0Jl\n" +
    "aWppbmcxDjAMBgNVBAoMBU15IENBMRMwEQYDVQQDDApNeSBSb290IENBMB4XDTI1\n" +
    "MTIwNDA3MzI0MVoXDTM1MTIwMjA3MzI0MVowVjELMAkGA1UEBhMCQ04xEDAOBgNV\n" +
    "BAgMB0JlaWppbmcxEDAOBgNVBAcMB0JlaWppbmcxDjAMBgNVBAoMBU15IENBMRMw\n" +
    "EQYDVQQDDApNeSBSb290IENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC\n" +
    "AQEAqDLENI4F1aqUV1Jqh16yWkgO5fpco5m3m4oT4RSxcAKVc4AfOZIR4EGDk7Lx\n" +
    "mjMsRyYnOrvnEm0olacykajI4sh0K6N6yEIYlAljrZ6wzUsifgWcMnu34iZhlWkq\n" +
    "NQt8jew1T8ThwBc5Q7OT/X3zKcETFmIFqL2iXeKiB4YkFIv2p701ghqJG2q4hToq\n" +
    "uTcSfNW1RmRU6VKXR7iPvAquXRuJG/LQLJIZyYt4lJ/B1ab3iDl+QqeTunmFwc3s\n" +
    "ZzOgUtP3ZEWxm+6kvSlBkQC24kqgd/ALllUWBNxj0ZBncY0UvreQxrmO1CrSs1f3\n" +
    "bvYG75DxCux721pY7/xV5aAJywIDAQABo1MwUTAdBgNVHQ4EFgQUJGV56hcSKnl/\n" +
    "KUKEqN0PD6tMItUwHwYDVR0jBBgwFoAUJGV56hcSKnl/KUKEqN0PD6tMItUwDwYD\n" +
    "VR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAbZ7gzy2xnJX8KXnQabZV\n" +
    "qLh5846x7TrluB1djbxPVzsafez2lmNpSq+JHKAYc2cq9Y5a3waCYrCYs+0VFiyU\n" +
    "+jrCy2LqXrDjMxeGk8Gk3YHj+5lcGi3X8i6ec69KTsqIsY032+y2ihVrDUWvq+iQ\n" +
    "NXi7onaUiyQKo/eN9A83vZbTKLxrtM+Ko3crsG+R9l3nf2J+KnG7l18ZAxWiwS+7\n" +
    "Y/+dzrKNAC+TCwYr8ys+wMgEEKt/BjjgpxgrzLLfi4e7rHS7/3zSDFf5gtYSbcR/\n" +
    "d6J4Xvh/+tfPFqTaVPtGAabvsSIrTWMH7gVOP0GTDwwi3hVhDw5iUGuEiGAboYeq\n" +
    "qA==\n" +
    "-----END CERTIFICATE-----";

  // 客户端私钥
  private readonly clientKey = "-----BEGIN PRIVATE KEY-----\n" +
    "MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDgm2c4+EvB7fUj\n" +
    "OTMFpZ8nD4bAIjWNKaEklFMQxoQOgcz+674hAbCIM7gfkdcUrV8TFSbGdC7l6m5e\n" +
    "L/8cqbnGozXdfYLi3EoZ4uGtzQnYcu5e8C3NMX6FP1VsBpwHvqsgSOs9CqejFMIA\n" +
    "rzXhfoGBs5d1uF5GXbrfDnI4aD1InxX6rkwdFQbcd6pxe+9jqjUDsaaycI+tIxV+\n" +
    "jwOGIauGbmePpY+peEy1z+rY9MAubrXpgtzH6afd0N7SZX6YKo1focRN9dBPfFAc\n" +
    "Zc2uE0bFLOR/LrV0yCrGJ+ZHRRGr2UK8kMtJw9vUpBajSJTFMEOO6XwreMNwdyOU\n" +
    "ofgjiOnHAgMBAAECggEBAKxDhC+Vf8UFFHYncJJsLFxw9BB4LEpQG19Kw0qidrYJ\n" +
    "p4f8lp4KBbLwt86+tA8PyVOBbXPXuABuhKeIeEkrg2ht1OpDURddjRe9gwkhsONp\n" +
    "gpkd7ILr6vWXVZS8nP7zpZvlUUZH3bqeOQz9VH3V4M3xR8Dp3qRpTuG02rWYfSgs\n" +
    "Kuv/D7dunGSRyrIeeAfCNOYOhUYqyahJ3YiA9VwwLqsDngKaU8vJhkTr6KJTJHoD\n" +
    "AoIoXTMYsARSDWJ3GcTg3rhExCJjNTUX4CaGmwEKyAj0ESLgyFDD12hSA2wos3//\n" +
    "uf0N6gQbEAl8JDZNQxt8MiKGjoRS7iuwuGc+yykG9EECgYEA/dauysFczqC/AzJO\n" +
    "0mbjx+VXUHdOVaXKfkkkXFkLkxiBnZYaXWHAxMHaVMlADfSHeTQwtrjGC18rJDOH\n" +
    "xG0PpZpV9MR2sIgl0qY+LiVpnt2tRb0M/iHf/ZLM+aCQ5QtW6tIDHWeVYkeOpjSx\n" +
    "c/zniSd+AjEtoKmnscng1I4Z2o0CgYEA4oUAYf4OQNrhR5lB12d5eek+seIQqqHA\n" +
    "TCUBDZ+NGL0z7J3ykwSfr1IHM04GuMKF/zKtn8mEUuJMfTHup9Abvh+mhu8eHNfv\n" +
    "lSR3uESMb7K2iJk2zkFdj8gwXiKMFUbQMl2ofnypA6cuD5GqBsiIOIQPWNZj0IUN\n" +
    "w2d2mrj+SqMCgYEAhSwvkeI2XZWKARRQtCQU1tfkoiulpluPzAd1kxmIcAjIX7PT\n" +
    "azCQ4OlPMXJQL8IdnSIbeJGiHW81hA2g6hXJwrkg5YR5PI6BQW3Ea5NnQVjNwiu3\n" +
    "+FAvYqq07TYnLnNvi0zZI4Enp2MhXOOCQfbqRlO40U+Zv5Oijiz6zqkquTUCgYEA\n" +
    "lFVMHt9jLg0nIN+3Qfs8jRy0NYA4McSiTDqfKfClUOH1Mqlrw+JvPzuUA4DA3hRj\n" +
    "8u2YzN4FjNEsDX+5LKMWx7WqMwo6yeCNvziWPVCGNk7tQR4zyXT8c79ADSTKXtR0\n" +
    "WccDI3E2rHG5s/BLSw3eRkQUWLRrwIygqqkB/efOfckCgYBhDy1x1bNX2ZmGhWOJ\n" +
    "3ztWyfskt5kZPMZLLEeRZKeNiaxcgRJ2WcKBVacpbBK9t8c+6TJtEUwj7x1CAnP+\n" +
    "YMrMG7Bq4ZXYF7RalHs8eg0W6x1HDR0cpH/K7NKSYEA76xjxlc3YQj1/DM8TcB8e\n" +
    "iK2OekLYOfPRF3n9zRtb4Nonbw==\n" +
    "-----END PRIVATE KEY-----";

  // 客户端证书
  private readonly clientCert = "-----BEGIN CERTIFICATE-----\n" +
    "MIIDWzCCAkMCFAd4hTk+2V0twNIleg+RMdJiDf3rMA0GCSqGSIb3DQEBCwUAMFYx\n" +
    "CzAJBgNVBAYTAkNOMRAwDgYDVQQIDAdCZWlqaW5nMRAwDgYDVQQHDAdCZWlqaW5n\n" +
    "MQ4wDAYDVQQKDAVNeSBDQTETMBEGA1UEAwwKTXkgUm9vdCBDQTAeFw0yNTEyMDQw\n" +
    "ODI3NDdaFw0yNjEyMDQwODI3NDdaMH4xCzAJBgNVBAYTAkNOMRAwDgYDVQQIDAdi\n" +
    "ZWlqaW5nMRAwDgYDVQQHDAdiZWlqaW5nMQ8wDQYDVQQKDAZIVUFXRUkxFjAUBgNV\n" +
    "BAsMDWNvbW11bmljYXRpb24xEDAOBgNVBAMMBzAuMC4wLjAxEDAOBgkqhkiG9w0B\n" +
    "CQEWATEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDgm2c4+EvB7fUj\n" +
    "OTMFpZ8nD4bAIjWNKaEklFMQxoQOgcz+674hAbCIM7gfkdcUrV8TFSbGdC7l6m5e\n" +
    "L/8cqbnGozXdfYLi3EoZ4uGtzQnYcu5e8C3NMX6FP1VsBpwHvqsgSOs9CqejFMIA\n" +
    "rzXhfoGBs5d1uF5GXbrfDnI4aD1InxX6rkwdFQbcd6pxe+9jqjUDsaaycI+tIxV+\n" +
    "jwOGIauGbmePpY+peEy1z+rY9MAubrXpgtzH6afd0N7SZX6YKo1focRN9dBPfFAc\n" +
    "Zc2uE0bFLOR/LrV0yCrGJ+ZHRRGr2UK8kMtJw9vUpBajSJTFMEOO6XwreMNwdyOU\n" +
    "ofgjiOnHAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAC+irqFOM+/HQY9K9J2RmxSe\n" +
    "siiIc2Rqh71BFT2OHOmTko8I0D3siSs1kH7x77b2IPWyLUbnDs2IRrt06hHdZt4r\n" +
    "BYNh95U8H25/CMNXgCm5wWC7a23wN6fsmwXk8UK2fm1ZtoLYqLPaXLMUyU/JfdNU\n" +
    "Ziv2RiK4iT+g8p59o6/q/wB7yTY6wdpbUMg0nfus2aqCtVVUsVhvHnQJ1O0lS8cu\n" +
    "fKneyr2zRZf8Irx7yiWeY2+CzHFWIfJ1RHrlvPkGA3UdD0UAssZkyhNuP1HSUCKW\n" +
    "OsdZPnJNON1wyId1KzmGbSsFh6yqMwerYCZkN5McglU6KSxpctGATKC0y1q4/wE=\n" +
    "-----END CERTIFICATE-----";

  private readonly clientCa = "-----BEGIN CERTIFICATE-----\n" +
    "MIIDjTCCAnWgAwIBAgIUOs5K47mhbnfCywd9U9lzPTvOzGMwDQYJKoZIhvcNAQEL\n" +
    "BQAwVjELMAkGA1UEBhMCQ04xEDAOBgNVBAgMB0JlaWppbmcxEDAOBgNVBAcMB0Jl\n" +
    "aWppbmcxDjAMBgNVBAoMBU15IENBMRMwEQYDVQQDDApNeSBSb290IENBMB4XDTI1\n" +
    "MTIwNDA3MzI0MVoXDTM1MTIwMjA3MzI0MVowVjELMAkGA1UEBhMCQ04xEDAOBgNV\n" +
    "BAgMB0JlaWppbmcxEDAOBgNVBAcMB0JlaWppbmcxDjAMBgNVBAoMBU15IENBMRMw\n" +
    "EQYDVQQDDApNeSBSb290IENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC\n" +
    "AQEAqDLENI4F1aqUV1Jqh16yWkgO5fpco5m3m4oT4RSxcAKVc4AfOZIR4EGDk7Lx\n" +
    "mjMsRyYnOrvnEm0olacykajI4sh0K6N6yEIYlAljrZ6wzUsifgWcMnu34iZhlWkq\n" +
    "NQt8jew1T8ThwBc5Q7OT/X3zKcETFmIFqL2iXeKiB4YkFIv2p701ghqJG2q4hToq\n" +
    "uTcSfNW1RmRU6VKXR7iPvAquXRuJG/LQLJIZyYt4lJ/B1ab3iDl+QqeTunmFwc3s\n" +
    "ZzOgUtP3ZEWxm+6kvSlBkQC24kqgd/ALllUWBNxj0ZBncY0UvreQxrmO1CrSs1f3\n" +
    "bvYG75DxCux721pY7/xV5aAJywIDAQABo1MwUTAdBgNVHQ4EFgQUJGV56hcSKnl/\n" +
    "KUKEqN0PD6tMItUwHwYDVR0jBBgwFoAUJGV56hcSKnl/KUKEqN0PD6tMItUwDwYD\n" +
    "VR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAbZ7gzy2xnJX8KXnQabZV\n" +
    "qLh5846x7TrluB1djbxPVzsafez2lmNpSq+JHKAYc2cq9Y5a3waCYrCYs+0VFiyU\n" +
    "+jrCy2LqXrDjMxeGk8Gk3YHj+5lcGi3X8i6ec69KTsqIsY032+y2ihVrDUWvq+iQ\n" +
    "NXi7onaUiyQKo/eN9A83vZbTKLxrtM+Ko3crsG+R9l3nf2J+KnG7l18ZAxWiwS+7\n" +
    "Y/+dzrKNAC+TCwYr8ys+wMgEEKt/BjjgpxgrzLLfi4e7rHS7/3zSDFf5gtYSbcR/\n" +
    "d6J4Xvh/+tfPFqTaVPtGAabvsSIrTWMH7gVOP0GTDwwi3hVhDw5iUGuEiGAboYeq\n" +
    "qA==\n" +
    "-----END CERTIFICATE-----";

  /**
   * 提取公共配置（网络+TLS），减少冗余，统一维护
   * @param port 端口号（区分不同测试模式，避免冲突）
   */
  private getCommonConfig(port: number, proxyType: ProxyType = socket.ProxyTypes.NONE,
    timeout?: number): CommonConfig {
    const netAddress: socket.NetAddress = {
      address: '127.0.0.1',
      port: port
    };

    // TLS 安全配置
    const tlsSecureOptions: socket.TLSSecureOptions = {
      key: `-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAnoncKS+sTY/GjMRQ86LG4/3PbGIxOLUDZFMttzK73wK+hMj6
op/KVJkVl1h3d/vaNReZfPm0PQDdWjXmMw+t6MYgtDmk2WZLvmqfUOizYFpaK9+0
2PMbAcbxwC3g6yrQ8duX2u5gHSm4FmszEf/RDID0/sLFI3kW9s9JhKqwgQUuVsIv
gfDY+wlWY0hRSm2A+XSro8cf8BjdYBcnuTM5RsoMFhAc685nqFffCpktH3iAmVfK
KDd6Sz6+Fko/vdbPDsD1Hf7A0aoO51ZwGUSkjGEhKzJxeIoVNIvBnJZ1eD/lEHSy
Ce6Yot8L7/UCA35j17vm6KzIC5OLiCSB4w/cXwIDAQABAoIBABkOhONli3/+t0zM
QlcfZPvnw37Hziu+QDj9BH6t4A+RKXdnJGXLh3jzcPwomUk3XveBMVsVRC1YE6QM
XMO5OK1Pkx+o9Kr/hf0kcOWiwab64MGKa9TWJ3CSdub+2UuRytBO+qM5hatWSqgQ
bVPs8KdfQll5gxrmKoD7pgz3xUm+vi0tkSE38o0UYEaW1AE8f+dasl/3gBYCgcup
ebKWEGd5s9ijd8Fx4EhY87qV29ijKz28z0L65Qw/C4+ywcOEHEICDvxjxkiz665d
vIbyQk6PIxGTh2jiqs0PU5b3yevo5SR6Rp92wTydGnkscT6CK23Vbz9jp7JBXqre
a+XnBnECgYEAzz3m1h6J4/8Zp0BU79rO+M2MAVMXisASH2wrPR2jjYeEeBU1FJAg
OBlfpPZoByW8pWrkAR8HKKtLaq6Lm2vwGpMYzdYg7lwGXI2h9oueCl6U4fGT7z/Z
hsQvApka3MqAZnIcF1S1YS4KfugzPhlGPbD3m2ezXXzzHVMrOhGk3eMCgYEAw9aT
t4ilZKvisyp8fF+9WSq1Kl93+OabiERpiO6C5LPNIg7P2gTwbeJ5+tHEigKn1wHE
FcHOsXEv4f5Z6oEcPmQSG439SujbS9/GTA98KPaMZGEMw3WWBSDGtXdc7XWTLdC6
5OjLdr4tM8CN87DLs0ZuKRRzx3Bl+yCINtr8EFUCgYAPMCcxvA05A2Ia6tEOvwd6
Hn5LPo60IX1yhhfpI7nvzmW78znvptxloB5tVY2sMGzR5rKNDnwU0/D0AZTDsDZp
jCw+MZo6Pc5NjCe5jOPpOKNKp8zCtPg5MzmKxDO+yKx+VZCPeSrN03T7dgMDYxDN
xqFu5zuy90xN8uFxIQfnJwKBgQCqbfD7xlV5eQS/O3g+nOsh0EL9bzvvRnGQc0kM
u9T5x2f7/bvxVl8OogvZtfg+yvTZ7lWBQbrpPUGYgUwrAtVbjqcbh8QpDuDZ9RKT
Wt6In5eqO7Np3skCCXYkso4SsUG2m3IqiFWZLwQTh72BmBiOGfsAkSX5KN33YGZq
psS6SQKBgAG6c+xTACeh8p7gNFnc6ggqXutVkfvLhBjtpkcvG7rOpKuy5Q+efEoB
aUr8muQ7IKQ0XEg57GKy/E3ySFeOhMyhw4/dF1Scx2nm8/XzuDr7onUY4/uzAUiJ
bNe8gZRkSz8wvWyV04HOCcfTwz9cAfZ/n/k6X0OwpvYRHh9HtMql
-----END RSA PRIVATE KEY-----`,
      cert: `-----BEGIN CERTIFICATE-----
MIICrzCCAZcCFAm/T+dPts7MtyE0zTcLwQ9dejlAMA0GCSqGSIb3DQEBCwUAMBQx
EjAQBgNVBAMMCWxvY2FsaG9zdDAeFw0yNTEwMzEwOTQyNTFaFw0yNjEwMzEwOTQy
NTFaMBQxEjAQBgNVBAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAJ6J3CkvrE2PxozEUPOixuP9z2xiMTi1A2RTLbcyu98CvoTI+qKf
ylSZFZdYd3f72jUXmXz5tD0A3Vo15jMPrejGILQ5pNlmS75qn1Dos2BaWivftNjz
GwHG8cAt4Osq0PHbl9ruYB0puBZrMxH/0QyA9P7CxSN5FvbPSYSqsIEFLlbCL4Hw
2PsJVmNIUUptgPl0q6PHH/AY3WAXJ7kzOUbKDBYQHOvOZ6hX3wqZLR94gJlXyig3
eks+vhZKP73Wzw7A9R3+wNGqDudWcBlEpIxhISsycXiKFTSLwZyWdXg/5RB0sgnu
mKLfC+/1AgN+Y9e75uisyAuTi4gkgeMP3F8CAwEAATANBgkqhkiG9w0BAQsFAAOC
AQEAB42BI8v2TkKObx2pdceI4K3h7c69ahUvyYq2HKSzP39cvtDw2BM0NDsKzs2g
2uKn1w9VreIHg3e811SCteIq18yr3Zrj5eCHX6601zJlsAtbpku4vdciyEv+o9uD
iYTtD/9Z6u/yDiwpJgaU5HrDRC7O/0TipQfuQwxxN+An11UOd81P+bvj+DKoDs3F
E6E2M4vQY33S78RF7P4EZVlrcW3JhcW23l+lAbqcSfL1/X+QYQfGL0Lp3BLOCtBL
y/Hp0zgI2Zq1+paupseHHBjTiORJzEUIQvQyI357pTA+lT5b0Bw7VsBpxYH7vpk9
mSNTffduRuD5KUKprT8t3Nw4FQ==
-----END CERTIFICATE-----`,
      ca: [`-----BEGIN CERTIFICATE-----
MIICrzCCAZcCFAm/T+dPts7MtyE0zTcLwQ9dejlAMA0GCSqGSIb3DQEBCwUAMBQx
EjAQBgNVBAMMCWxvY2FsaG9zdDAeFw0yNTEwMzEwOTQyNTFaFw0yNjEwMzEwOTQy
NTFaMBQxEjAQBgNVBAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAJ6J3CkvrE2PxozEUPOixuP9z2xiMTi1A2RTLbcyu98CvoTI+qKf
ylSZFZdYd3f72jUXmXz5tD0A3Vo15jMPrejGILQ5pNlmS75qn1Dos2BaWivftNjz
GwHG8cAt4Osq0PHbl9ruYB0puBZrMxH/0QyA9P7CxSN5FvbPSYSqsIEFLlbCL4Hw
2PsJVmNIUUptgPl0q6PHH/AY3WAXJ7kzOUbKDBYQHOvOZ6hX3wqZLR94gJlXyig3
eks+vhZKP73Wzw7A9R3+wNGqDudWcBlEpIxhISsycXiKFTSLwZyWdXg/5RB0sgnu
mKLfC+/1AgN+Y9e75uisyAuTi4gkgeMP3F8CAwEAATANBgkqhkiG9w0BAQsFAAOC
AQEAB42BI8v2TkKObx2pdceI4K3h7c69ahUvyYq2HKSzP39cvtDw2BM0NDsKzs2g
2uKn1w9VreIHg3e811SCteIq18yr3Zrj5eCHX6601zJlsAtbpku4vdciyEv+o9uD
iYTtD/9Z6u/yDiwpJgaU5HrDRC7O/0TipQfuQwxxN+An11UOd81P+bvj+DKoDs3F
E6E2M4vQY33S78RF7P4EZVlrcW3JhcW23l+lAbqcSfL1/X+QYQfGL0Lp3BLOCtBL
y/Hp0zgI2Zq1+paupseHHBjTiORJzEUIQvQyI357pTA+lT5b0Bw7VsBpxYH7vpk9
mSNTffduRuD5KUKprT8t3Nw4FQ==
-----END CERTIFICATE-----`],
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    };

    const proxyOptions: socket.ProxyOptions = {
      type: proxyType,
      address: netAddress,
      username: 'proxyUser',
      password: 'proxyPass',
    };

    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false,
      timeout: timeout,
      proxy: proxyOptions,
    };

    return { tlsConnectOptions, proxyOptions };
  }

  listen_callback_2303109(): void {
    const commonConfig = this.getCommonConfig(8085);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.close();
    try {
      tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        }else{
          this.addTestResult(`监听成功`);
        }
      });
    }catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  async listen_promise_2303109(): Promise<void> {
    const commonConfig = this.getCommonConfig(8086);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.close();
    try {
      tlsServer.listen(commonConfig.tlsConnectOptions).then(() => {
        console.info("listen callback success");
        this.addTestResult(`监听成功`);
      }).catch((err: BusinessError) => {
        console.error("failed: " + JSON.stringify(err));
        this.addTestResult(`监听失败：`+ JSON.stringify(err));
      });

    }catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  listen_callback_2303111(): void {
    let port = 10000;
    const maxRetry = 50;
    let retryCount = 0;
    try{
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      const createAndListen = () => {
        const commonConfig = this.getCommonConfig(port++);
        this.addTestResult(`cur port is:[${port}]`);
        tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
          if (err) {
            if (err.code === 2303111 && err.message === "Resource temporarily unavailable. Try again") {
              this.addTestResult(`Callback-资源暂时不可用场景：捕获预期错误 [${err.code}]-${err.message}`);
              return;
            }
          } else {
            if (retryCount < maxRetry) {
              retryCount++;
              this.addTestResult(`cur port is:[${port}]`);
              createAndListen();
            } else {
              this.addTestResult(`Callback-资源暂时不可用场景：未捕获到预期错误`);
            }
          }
        });
      };
      createAndListen();
    } catch(err){
      this.addTestResult(`Callback-预期错误 [${err.code}]-${err.message}`);
    }
  }

  listen_promise_2303111(): void {
    let port = 10000;
    const maxRetry = 50;
    let retryCount = 0;
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const createAndListen = () => {
      const commonConfig = this.getCommonConfig(port++);
      this.addTestResult(`cur port is:[${port}]`);
      tlsServer.listen(commonConfig.tlsConnectOptions).then(() => {
        if (retryCount < maxRetry) {
          retryCount++;
          this.addTestResult(`cur port is:[${port}]`);
          createAndListen();
        } else {
          this.addTestResult(`Promise-资源暂时不可用场景：未捕获到预期错误`);
        }
      }).catch((err: BusinessError) => {
        if (err.code === 2303111 && err.message === "Resource temporarily unavailable. Try again") {
          this.addTestResult(`Promise-资源暂时不可用场景：捕获预期错误 [${err.code}]-${err.message}`);
          return;
        }
      })
    };
    createAndListen();
  }

  listen_callback_2303198(): void {
    let port = 10000;
    const maxRetry = 50;
    let retryCount = 0;
    try{
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      const createAndListen = () => {
        const commonConfig = this.getCommonConfig(port++);
        this.addTestResult(`cur port is:[${port}]`);
        tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
          if (err) {
            if (err.code === 2303198 && err.message === "Resource temporarily unavailable. Try again") {
              this.addTestResult(`Callback-资源暂时不可用场景：捕获预期错误 [${err.code}]-${err.message}`);
              return;
            }
          } else {
            if (retryCount < maxRetry) {
              retryCount++;
              this.addTestResult(`cur port is:[${port}]`);
              createAndListen();
            } else {
              this.addTestResult(`Callback-资源暂时不可用场景：未捕获到预期错误`);
            }
          }
        });
      };
      createAndListen();
    } catch(err){
      this.addTestResult(`Callback-预期错误 [${err.code}]-${err.message}`);
    }
  }

  listen_promise_2303198(): void {
    let port = 10000;
    const maxRetry = 50;
    let retryCount = 0;
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const createAndListen = () => {
      const commonConfig = this.getCommonConfig(port++);
      this.addTestResult(`cur port is:[${port}]`);
      tlsServer.listen(commonConfig.tlsConnectOptions).then(() => {
        if (retryCount < maxRetry) {
          retryCount++;
          this.addTestResult(`cur port is:[${port}]`);
          createAndListen();
        } else {
          this.addTestResult(`Promise-资源暂时不可用场景：未捕获到预期错误`);
        }
      }).catch((err: BusinessError) => {
        if (err.code === 2303198 && err.message === "Resource temporarily unavailable. Try again") {
          this.addTestResult(`Promise-资源暂时不可用场景：捕获预期错误 [${err.code}]-${err.message}`);
          return;
        }
      })
    };
    createAndListen();
  }

  private listen_callback_2303502(): void {
    const commonConfig = this.getCommonConfig(8085);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${JSON.stringify(err)}`);
        return;
      }

      this.addTestResult(`监听成功`);

      tlsServer!.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');

        this.sendLargeDataLoop(client);
        this.sendSpecialBytesData(client);
        this.sendSmallDataWithShortDelay(client);
      });

      tlsServer!.on('error', (err: BusinessError) => {
        this.addTestResult(`服务器错误: ` + JSON.stringify(err));
        console.error('TLSSocketServer error:', JSON.stringify(err));
      });

    });
  }


  private sendLargeDataLoop(client: socket.TLSSocketConnection): void {
    const oneMBString = 'a'.repeat(1024 * 1024);
    for (let i = 0; i < 20; i++) {
      client.send(oneMBString, (err: BusinessError) => {
        if (err) {
          if (err.code === 2303502) {
            this.addTestResult(`成功触发2303502：[${err.code}] ${err.message}`);
          } else {
            this.addTestResult(`获取状态失败 [${err.code}]: ${err.message}`);
          }
        }
      });
    }
  }

  private sendSpecialBytesData(client: socket.TLSSocketConnection): void {
    const buffer = new ArrayBuffer(3);
    const view = new Uint8Array(buffer);
    view[0] = 0x00;
    view[1] = 0xFF;
    view[2] = 0x80;
    client.send(buffer, (err: BusinessError) => {
      if (err) {
        if (err.code === 2303502) {
          this.addTestResult(`成功触发2303502：[${err.code}] ${err.message}`);
        } else {
          this.addTestResult(`获取状态失败 [${err.code}]: ${err.message}`);
        }
      }
    });
  }

  private sendSmallDataWithShortDelay(client: socket.TLSSocketConnection): void {
    const smallData = 'test';
    for (let i = 0; i < 50; i++) {
      setTimeout(() => {
        client.send(smallData, (err: BusinessError) => {
          if (err) {
            if (err.code === 2303502) {
              this.addTestResult(`成功触发2303502：[${err.code}] ${err.message}`);
            } else {
              this.addTestResult(`获取状态失败 [${err.code}]: ${err.message}`);
            }
          }
        });
      }, i * 1);
    }
  }

  private listen_promise_2303502(): void {
    const commonConfig = this.getCommonConfig(8085);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions).then(() => {
      console.info("listen callback success");
      this.addTestResult(`监听成功`);

      tlsServer!.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');

        this.sendLargeDataLoop(client);
        this.sendSpecialBytesData(client);
        this.sendSmallDataWithShortDelay(client);
      });

      tlsServer!.on('error', (err: BusinessError) => {
        this.addTestResult(`服务器错误: ` + JSON.stringify(err));
        console.error('TLSSocketServer error:', JSON.stringify(err));
      });
    }).catch((err: BusinessError) => {
      console.error("failed: " + JSON.stringify(err));
    });

  }


  private listen_callback_2303503(): void {
    const commonConfig = this.getCommonConfig(8085);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${JSON.stringify(err)}`);
        return;
      }

      this.addTestResult(`监听成功`);

      tlsServer!.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');

        this.sendLargeDataInLoop(client);
        this.sendToClosedConnection(client);
        this.sendWithUninitializedTLS();
      });

      tlsServer!.on('error', (err: BusinessError) => {
        this.addTestResult(`服务器错误: ` + JSON.stringify(err));
        console.error('TLSSocketServer error:', JSON.stringify(err));
      });

    });
  }

  private listen_promise_2303503(): void {
    const commonConfig = this.getCommonConfig(8085);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions).then(() => {
      console.info("listen callback success");
      this.addTestResult(`监听成功`);

      tlsServer!.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');

        this.sendLargeDataInLoop(client);
        this.sendToClosedConnection(client);
        this.sendWithUninitializedTLS();
      });

      tlsServer!.on('error', (err: BusinessError) => {
        this.addTestResult(`服务器错误: ` + JSON.stringify(err));
        console.error('TLSSocketServer error:', JSON.stringify(err));
      });
    }).catch((err: BusinessError) => {
      console.error("failed: " + JSON.stringify(err));
    });

  }

  private sendLargeDataInLoop(client: socket.TLSSocketConnection): void {
    const tenMBString = 'a'.repeat(10 * 1024 * 1024);
    for (let i = 0; i < 10; i++) {
      client.send(tenMBString, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`循环发送第${i+1}次10MB数据失败: ${err.code} - ${err.message}`);
        }
      });
    }
  }

  private sendToClosedConnection(client: socket.TLSSocketConnection): void {
    client.close();
    client.send('Data to closed connection', (err: BusinessError) => {
      if (err) {
        this.addTestResult(`向已关闭连接发送数据失败: ${err.code} - ${err.message}`);
      }
    });
  }

  private sendWithUninitializedTLS(): void {
    const emptyTLSSecureOptions: socket.TLSSecureOptions = {};
    const uninitializedServer = socket.constructTLSSocketServerInstance();
    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 0
    };
    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: emptyTLSSecureOptions
    };

    uninitializedServer.listen(tlsConnectOptions, (err: BusinessError) => {
      uninitializedServer!.on('connect', (client: socket.TLSSocketConnection) => {
        client.send('Data before TLS initialization', (err: BusinessError) => {
          if (err) {
            this.addTestResult(`TLS未初始化完成发送数据失败: ${err.code} - ${err.message}`);
          }
        });
      });
    });
  }


  private listen_callback_2303506(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 6666
    };

    const tlsSecureOptions: socket.TLSSecureOptions = {
      key: this.serverKey,
      cert: this.serverCert,
      ca: [this.serverCa],
      password: '88888888',
      protocols: [socket.Protocol.TLSv12],
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    };

    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["spdy/1", "http/1.1"],
    };

    tlsServer.on('error', (err: BusinessError) => {
      if (err.code === 2303506) {
        this.addTestResult(`✅ 服务器触发2303506错误: ${err.message}`);
      }
      this.addTestResult(`服务器错误: ` + JSON.stringify(err));
    });

    tlsServer.listen(tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${JSON.stringify(err)}`);
        return;
      }
      this.addTestResult(`监听成功`);

      tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：检测到客户端连接');
        setTimeout(()=>{
          client.close();

        },1000);
      });
      setTimeout(() => {
        this.startTLSClient();
      }, 1000);
    });
  }

  private startTLSClient(): void {
    let tlsClient: socket.TLSSocket = socket.constructTLSSocketInstance();
    const connectAddr: socket.NetAddress = {
      address: '127.0.0.1',
      port: 6666
    };

    const secureOptions: socket.TLSSecureOptions = {
      key: this.clientKey,
      cert: this.clientCert,
      ca: [this.clientCa],
      password: '88888888',
      protocols: [socket.Protocol.TLSv12],
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    };

    const connectOptions: socket.TLSConnectOptions = {
      address: connectAddr,
      secureOptions: secureOptions,
      ALPNProtocols: ["spdy/1", "http/1.1"],
      skipRemoteValidation: true
    };

    tlsClient.bind(connectAddr);
    tlsClient.connect(connectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`客户端: 连接失败: ${err.message}`);
      } else {
        this.addTestResult('客户端: 发起连接成功');
      }
    });
  }

  private  listen_promise_2303506(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 6666
    };

    const tlsSecureOptions: socket.TLSSecureOptions = {
      key: this.serverKey,
      cert: this.serverCert,
      ca: [this.serverCa],
      password: '88888888',
      protocols: [socket.Protocol.TLSv12],
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    };

    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["spdy/1", "http/1.1"],
    };

    tlsServer.on('error', (err: BusinessError) => {
      if (err.code === 2303506) {
        this.addTestResult(`✅ 服务器触发2303506错误: ${err.message}`);
      }
      this.addTestResult(`服务器错误: ` + JSON.stringify(err));
    });

    tlsServer.listen(tlsConnectOptions).then(() => {
      console.info('listen success');
      this.addTestResult(`监听成功`);
      tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：检测到客户端连接');

      });
      setTimeout(() => {
        this.startTLSClient();
      }, 2000);
    }).catch((err: BusinessError) => {
      console.error('listen fail');
      this.addTestResult(`服务器: 监听失败: ${JSON.stringify(err)}`);
    });

  }

  addTestResult(result: string): void {
    this.testResults = [...this.testResults, result];
    console.info(`[测试结果] ${result}`);
  }

  clearTestResults(): void {
    this.testResults = [];
    this.addTestResult(`测试结果已清空`);
  }

  build() {
    Column({ space: 15 }) {
      Text('TLSSocketServer测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
        .alignSelf(ItemAlign.Center);

      Scroll() {
        Column({ space: 10 }) {
          Button('listen_callback_2303109')
            .onClick(() => this.listen_callback_2303109())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_promise_2303109')
            .onClick(() => this.listen_promise_2303109())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_callback_2303111')
            .onClick(() => this.listen_callback_2303111())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_promise_2303111')
            .onClick(() => this.listen_promise_2303111())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_callback_2303198')
            .onClick(() => this.listen_callback_2303198())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_promise_2303198')
            .onClick(() => this.listen_promise_2303198())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_callback_2303502')
            .onClick(() => this.listen_callback_2303502())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_promise_2303502')
            .onClick(() => this.listen_promise_2303502())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_callback_2303503')
            .onClick(() => this.listen_callback_2303503())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_promise_2303503')
            .onClick(() => this.listen_promise_2303503())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_callback_2303506')
            .onClick(() => this.listen_callback_2303506())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);

          Button('listen_promise_2303506')
            .onClick(() => this.listen_promise_2303506())
            .width('90%')
            .height(45)
            .backgroundColor('#27ae60')
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(8);
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .scrollBar(BarState.On)
      .scrollable(ScrollDirection.Vertical)
      .height('40%')
      .margin({ top: 10 })

      Column() {
        Text('测试结果日志')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 5, bottom: 5 })
          .backgroundColor('#f0f0f0')
          .borderRadius({ topLeft: 8, topRight: 8 })

        Scroll() {
          Column({ space: 6 }) {
            ForEach(this.testResults, (result: string, index: number) => {
              Text(`${index + 1}. ${result}`)
                .fontSize(14)
                .textAlign(TextAlign.Start)
                .padding(10)
                .backgroundColor(index % 2 === 0 ? '#f8f9fa' : '#ffffff')
                .width('100%')
                .borderRadius(4);
            }, (result: string) => `${result}-${Date.now()}`)
          }
          .width('100%')
          .padding(5)
        }
        .scrollBar(BarState.On)
        .scrollable(ScrollDirection.Vertical)
        .height(240)
        .backgroundColor('#ffffff')
        .borderRadius({ bottomLeft: 8, bottomRight: 8 })
        .border({ width: 1, color: '#e0e0e0' })

        Row({ space: 10 }) {
          Button('清空测试结果')
            .onClick(() => this.clearTestResults())
            .width('45%')
            .height(30)
            .backgroundColor('#4ECDC4')
            .fontSize(16)
            .fontWeight(FontWeight.Medium);

          Button('返回主界面')
            .onClick(() => router.back())
            .width('45%')
            .height(30)
            .backgroundColor('#4ECDC4')
            .fontSize(16)
            .fontWeight(FontWeight.Medium);
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .margin({ top: 5, bottom: 5 })
      }
      .width('100%')
      .margin({ top: 0, left: '5%', right: '5%' })
      .flexShrink(0)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}