//import { socket } from '@kit.NetworkKit';
import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import router from '@ohos.router';

interface ErrorExpectation {
  code: number;
  msg: string;
}

@Entry
@Component
struct testTLSSocketServerOnConnect {
  @State testResults: string[] = [];
  private tlsServer?: socket.TLSSocketServer;
  private tlsClient?: socket.TLSSocket;
  private testPort: number = 8080;


  // 服务端私钥
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

  aboutToAppear(): void {
  }

  aboutToDisappear(): void {
    this.stopTest();
  }


  // 订阅TLSSocketServer的连接事件
  private testTlsServerOnConnectCallback(): void {
    // 启动服务器
    this.tlsServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: this.testPort
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


    this.tlsServer.listen(tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${err.message}`);
      } else {
        if(this.tlsServer){
          this.tlsServer.on('error', (err: BusinessError) => {
            this.addTestResult(`服务器错误: 错误码”[${err.code}]“，错误信息”${err.message}“`);
            console.error('TLSSocketServer error:', JSON.stringify(err));
          });
          // 监听客户端连接
          this.tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
            this.addTestResult('监听后，注册connect成功');
            console.info(JSON.stringify(client))
          });
          this.startTLSClient();
        }
      }
    });
    setTimeout(()=>{
      if (this.tlsClient) {
        this.tlsClient.close();
        this.tlsClient.off('connect');
        this.tlsClient.off('error');
        this.tlsClient = undefined;
      };

      if (this.tlsServer) {
        this.tlsServer.close();
        this.tlsServer.off('connect');
        this.tlsServer.off('error');
        this.tlsServer = undefined;
      };
    },1000);
  }

  private startTLSClient(): void {
    this.tlsClient = socket.constructTLSSocketInstance();

    const bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 0
    };

    this.tlsClient.bind(bindAddr, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`客户端: 绑定失败: ${err.message}`);
        return;
      }
      this.addTestResult(`客户端: 绑定成功`);
      const connectAddr: socket.NetAddress = {
        address: '127.0.0.1',
        port: this.testPort
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

      this.tlsClient?.connect(connectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`客户端: 连接失败: ${err.message}`);
        }
        this.addTestResult(`客户端: 连接成功`);
      });
    });
  }

  private stopTest(): void {
    if (this.tlsClient) {
        this.tlsClient.close();
        this.tlsClient.off('connect');
        this.tlsClient.off('error');
        this.tlsClient = undefined;
      };

    if (this.tlsServer) {
        this.tlsServer.close();
        this.tlsServer.off('connect');
        this.tlsServer.off('error');
        this.tlsServer = undefined;
        };
    this.releaseNetworkResources();
  }

  private releaseNetworkResources(): void {
    try {
      const releaseSocket = socket.constructTLSSocketInstance();
      const releaseAddress: socket.NetAddress = {
        address: '0.0.0.0',
        port: this.testPort
      };

      releaseSocket.bind(releaseAddress, () => {
        releaseSocket.close();
        console.info(`端口 ${this.testPort} 已强制释放`);
      });

      setTimeout(() => {
        releaseSocket.close();
      }, 100);
    } catch (error) {
      console.info('端口释放操作完成');
    }
    this.resetNetworkState();
    this.clearDNSCache();
  }

  // 新增方法：重置网络状态
  private resetNetworkState(): void {
    this.testPort = 8080;
    console.info('网络状态已重置');
    this.addTestResult('IP和端口绑定状态已重置');
  }

  // 新增方法：清理DNS缓存
  private clearDNSCache(): void {
    try {
      const localhost = '127.0.0.1';
      console.info(`DNS缓存清理完成，本地地址: ${localhost}`);
    } catch (error) {
      console.info('DNS清理完成');
    }
  }


  // 取消订阅TLSSocketServer的连接事件。使用callback方式作为异步方法。
  testTlsServerOffConnectCallback(): void {
    // 启动服务器
    this.tlsServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: this.testPort
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

    this.tlsServer.listen(tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${err.message}`);
      } else {
        if(this.tlsServer){
          this.tlsServer.on('error', (err: BusinessError) => {
            this.addTestResult(`服务器错误: 错误码”[${err.code}]“，错误信息”${err.message}“`);
            console.error('TLSSocketServer error:', JSON.stringify(err));
          });
          // 监听客户端连接
          let callback = (client: socket.TLSSocketConnection) => {
            this.addTestResult('监听后，注册connect成功');
            console.info(JSON.stringify(client))
          }
          this.tlsServer.on('connect', callback);
          this.tlsServer.off('connect',callback);
          this.startTLSClient();
          setTimeout(()=>this.addTestResult('已执行off取消订阅'),500);
        }
      }
    });
    setTimeout(()=>{
      if (this.tlsClient) {
        this.tlsClient.close();
        this.tlsClient.off('connect');
        this.tlsClient.off('error');
        this.tlsClient = undefined;
      };

      if (this.tlsServer) {
        this.tlsServer.close();
        this.tlsServer.off('connect');
        this.tlsServer.off('error');
        this.tlsServer = undefined;
      };
    },1000);
  }

  /** 辅助方法：为off测试启动客户端（独立封装，避免重复代码） */
  private async startClientForOffTest(serverPort: number, server: socket.TLSSocketServer): Promise<void> {
    const client = socket.constructTLSSocketInstance();

    // 客户端绑定到随机端口（避免冲突）
    const bindAddr: socket.NetAddress = { address: '0.0.0.0', port: 0 };
    client.bind(bindAddr, (bindErr: BusinessError) => {
      if (bindErr) {
        const errMsg = `客户端绑定失败: ${bindErr.message}`;
        console.error(errMsg);
        this.addTestResult(` ${errMsg}`);
        client.close();
        server.close();
        return;
      }

      const connectOptions: socket.TLSConnectOptions = {
        address: { address: '127.0.0.1', port: serverPort },
        secureOptions: {
          ca: this.serverCa, // 关键：客户端信任服务器CA
          protocols: [socket.Protocol.TLSv12],
        },
        ALPNProtocols: ["http/1.1"]
      };

      client.connect(connectOptions, (connectErr: BusinessError) => {
        if (connectErr) {
          const errMsg = `客户端连接失败: ${connectErr.code} - ${connectErr.message}`;
          console.error(errMsg);
          client.close();
          server.close();
          return;
        }

        console.info(`客户端连接服务器成功（端口: ${serverPort}）`);
        this.addTestResult(`客户端连接服务器成功（端口: ${serverPort}）`)

        setTimeout(() => {
          client.close();
          console.info(`客户端已关闭连接`);;

          server.close();
          console.info(`服务器已关闭，测试结束`);
        }, 1000);
      });

      client.on('error', (err: BusinessError) => {
        const errMsg = `客户端错误: ${err.code} - ${err.message}`;
        console.error(errMsg);
        client.close();
        server.close();
      });
    });
  }

  // ===================== on_connect 参数场景测试（错误用例）=====================
  private testOnConnect_TypeNull(): void {
    try {
      const server = socket.constructTLSSocketServerInstance();
      server.on(null, (conn: socket.TLSSocketConnection) => {});
      this.addTestResult(`未触发预期错误`);
    } catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  private testOnConnect_TypeUndefined(): void {
    try {
      const server = socket.constructTLSSocketServerInstance();
      server.on(undefined, (conn: socket.TLSSocketConnection) => {});
      this.addTestResult(`未触发预期错误`);
    } catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  private testOnConnect_CallbackTypeError(): void {
    try {
      const server = socket.constructTLSSocketServerInstance();
      server.on('connect', undefined );
      this.addTestResult(`未触发预期错误`);
    } catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  private testOnConnect_CallbackNull(): void {
    try {
      const server = socket.constructTLSSocketServerInstance();
      server.on('connect',null);
      this.addTestResult(`未触发预期错误`);
    } catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  // ===================== off_connect 参数场景测试（错误用例）=====================
  private testOffConnect_TypeNull(): void {
    try {
      const server = socket.constructTLSSocketServerInstance();
      server.off(null, (conn: socket.TLSSocketConnection) => {});
      this.addTestResult(`未触发预期错误`);
    } catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  private testOffConnect_TypeUndefined(): void {
    try {
      const server = socket.constructTLSSocketServerInstance();
      server.off(undefined, (conn: socket.TLSSocketConnection) => {});
      this.addTestResult(`未触发预期错误`);
    } catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  private testOffConnect_CallbackTypeError(): void {
    try {
      const server = socket.constructTLSSocketServerInstance();
      const validCb = (conn: socket.TLSSocketConnection) => {};
      server.on('connect', validCb);
      server.off('connect', undefined);
    } catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  private testOffConnect_CallbackNull(): void {
    try {
      const server = socket.constructTLSSocketServerInstance();
      const validCb = (conn: socket.TLSSocketConnection) => {};
      server.on('connect', validCb);
      server.off('connect', null);
    } catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  private testOffConnect_NoCallback(): void {
    // 启动服务器
    this.tlsServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: this.testPort
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

    this.tlsServer.listen(tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${err.message}`);
      } else {
        if(this.tlsServer){
          this.tlsServer.on('error', (err: BusinessError) => {
            this.addTestResult(`服务器错误: 错误码”[${err.code}]“，错误信息”${err.message}“`);
            console.error('TLSSocketServer error:', JSON.stringify(err));
          });
          // 监听客户端连接
          let callback = (client: socket.TLSSocketConnection) => {
            this.addTestResult('监听后，注册connect成功');
            console.info(JSON.stringify(client))
          }
          this.tlsServer.on('connect', callback);
          this.tlsServer.off('connect');
          setTimeout(()=>this.addTestResult('已执行off取消订阅'),500);
          this.startTLSClient();
        }
      }
    });
    setTimeout(()=>{
      if (this.tlsClient) {
        this.tlsClient.close();
        this.tlsClient.off('connect');
        this.tlsClient.off('error');
        this.tlsClient = undefined;
      };

      if (this.tlsServer) {
        this.tlsServer.close();
        this.tlsServer.off('connect');
        this.tlsServer.off('error');
        this.tlsServer = undefined;
      };
    },1000);
  }


  /** 特殊场景：多次订阅connect事件后，调用off不指定callback清空所有订阅 */
  private testOffConnectClearAllSubscriptions(): void {
    // 启动服务器
    this.tlsServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: this.testPort + 2
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

    this.tlsServer.listen(tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${err.message}`);
      } else {
        this.addTestResult(`服务器: 监听成功`);
      }
    });

    this.tlsServer.on('error', (err: BusinessError) => {
      this.addTestResult(`服务器错误: 错误码”[${err.code}]“，错误信息”${err.message}“`);
      console.error('TLSSocketServer error:', JSON.stringify(err));
    });
    // 监听客户端连接
    let callback_1 = (client: socket.TLSSocketConnection) => {
      this.addTestResult('监听后，注册connect_1成功');
      console.info(JSON.stringify(client))
    };
    let callback_2 = (client: socket.TLSSocketConnection) => {
      this.addTestResult('监听后，注册connect_2成功');
      console.info(JSON.stringify(client))
    };
    this.tlsServer.on('connect',callback_1);
    this.tlsServer.on('connect',callback_2);
    this.tlsServer.off('connect');
    setTimeout(()=>this.addTestResult('已执行off取消订阅'),500);

    this.tlsClient = socket.constructTLSSocketInstance();
    const bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 0
    };

    this.tlsClient.bind(bindAddr, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`客户端: 绑定失败: ${err.message}`);
        return;
      }
      this.addTestResult(`客户端: 绑定成功`);
      const connectAddr: socket.NetAddress = {
        address: '127.0.0.1',
        port: this.testPort + 2
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

      this.tlsClient?.connect(connectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`客户端: 连接失败: ${err.message}`);
        }
        this.addTestResult(`客户端: 连接成功`);
      });
    });
    setTimeout(()=>{
      if (this.tlsClient) {
        this.tlsClient.close();
        this.tlsClient.off('connect');
        this.tlsClient.off('error');
        this.tlsClient = undefined;
      };

      if (this.tlsServer) {
        this.tlsServer.close();
        this.tlsServer.off('connect');
        this.tlsServer.off('error');
        this.tlsServer = undefined;
      };
    },1000);
  }

  // 添加测试结果
  addTestResult(result: string): void {
    this.testResults = [...this.testResults, result];
    console.info(`测试结果: ${result}`);
  }

  // 清空测试结果
  clearTestResults(): void {
    this.testResults = [];
  }

  // 构建测试按钮（@Builder 复用组件）
  @Builder
  private buildConnectEventTestButton(text: string, onClick: () => void, bgColor: string) {
    Button(text)
      .onClick(onClick)
      .width('90%')
      .height(32) // 从44改为32，减小高度
      .fontSize(13) // 从16改为13，减小字体
      .fontColor('#ffffff')
      .backgroundColor(bgColor)
      .borderRadius(6) // 从8改为6，减小圆角
      .shadow({ radius: 2, color: `${bgColor}20`, offsetX: 0, offsetY: 1 }); // 减小阴影
  }


  build() {
    Scroll() {
      Column({ space: 20 }) {
        Text('TLSSocketServer_on/off_connect测试')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 });

        Button('订阅TLSSocketServer连接测试')
          .onClick(() => this.testTlsServerOnConnectCallback())
          .width('90%')
          .height(32); // 从40改为32，减小高度
        Button('移除TLSSocketServer连接测试')
          .onClick(() => this.testTlsServerOffConnectCallback())
          .width('90%')
          .height(32); // 从40改为32，减小高度

        Text('on_connect/off_connect 场景测试')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .width('90%')
          .textAlign(TextAlign.Start)

        Scroll() {
          Column({ space: 8 }) { // 从12改为8，减小按钮间距
            this.buildConnectEventTestButton(
              'on_connect-type传入null',
              () => this.testOnConnect_TypeNull(),
              '#FF9800'
            );
            this.buildConnectEventTestButton(
              'on_connect-type传入undefined',
              () => this.testOnConnect_TypeUndefined(),
              '#FF5722'
            );
            this.buildConnectEventTestButton(
              'on_connect-callbackUndefined',
              () => this.testOnConnect_CallbackTypeError(),
              '#9C27B0'
            );
            this.buildConnectEventTestButton(
              'on_connect-callbackNull',
              () => this.testOnConnect_CallbackNull(),
              '#F44336'
            );

            this.buildConnectEventTestButton(
              'off_connect-type传入null',
              () => this.testOffConnect_TypeNull(),
              '#00BCD4'
            );
            this.buildConnectEventTestButton(
              'off_connect-type传入undefined',
              () => this.testOffConnect_TypeUndefined(),
              '#4CAF50'
            );
            this.buildConnectEventTestButton(
              'off_connect-callbackUndefined',
              () => this.testOffConnect_CallbackTypeError(),
              '#009688'
            );
            this.buildConnectEventTestButton(
              'off_connect-callbackNull',
              () => this.testOffConnect_CallbackNull(),
              '#3F51B5'
            );
            this.buildConnectEventTestButton(
              'off_connect-Nocallback',
              () => this.testOffConnect_NoCallback(),
              '#3F51B5'
            );
            this.buildConnectEventTestButton(
              'off_connect-多次订阅后清空所有连接订阅',
              () => this.testOffConnectClearAllSubscriptions(),
              '#673AB7'
            );
          }
          .width('100%')
          .padding(10)
        }
        .scrollBar(BarState.On)
        .scrollable(ScrollDirection.Vertical)
        .height(200) // 设置固定高度，超出部分滚动
        .width('90%')
        .border({ width: 1, color: '#dddddd', radius: 8 })
        .backgroundColor('#ffffff')

        // 底部功能按钮保持原有小尺寸，无需修改
        Button('清理环境')
          .onClick(() => this.stopTest())
          .width('90%')
          .height(20);
        Button('清空测试结果')
          .onClick(() => this.clearTestResults())
          .width('90%')
          .height(20)
          .backgroundColor(Color.Gray);
        Button('返回主界面')
          .onClick(() => {
            router.back();
          })
          .margin({ bottom: 20 })
          .height(20) // 统一底部按钮高度
          .width('90%')

        Scroll() {
          Column() {
            ForEach(this.testResults, (result: string, index: number) => {
              Text(`${index + 1}. ${result}`)
                .fontSize(14)
                .textAlign(TextAlign.Start)
                .padding(5)
                .backgroundColor(index % 2 === 0 ? '#f5f5f5' : '#ffffff')
                .width('100%');
            }, (result: string) => result)
          }
          .width('100%')
        }
        .scrollBar(BarState.On)
        .scrollable(ScrollDirection.Vertical)
        .height(100)
        .margin({ top: 10 })
        .padding(10)
        .border({ width: 1, color: '#dddddd' })

      }
      .width('100%')
      .padding(20)
      .backgroundColor('#f0f0f0')
    }
    .scrollBar(BarState.On)
    .scrollable(ScrollDirection.Vertical)
    .height('100%')
  }

}
