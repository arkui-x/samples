import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';


@Entry
@Component
struct testTLSSocketServerClose {
  @State testResults: string[] = [];
  @State private tlsServer: socket.TLSSocketServer | null = null;
  @State private isListening: boolean = false;

  // 补充缺失的属性定义（复用合法的密钥、证书、CA证书）
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
    this.closeTlsServer();
  }

  private closeTlsServer(): void {
    if (this.tlsServer && this.isListening) {
      this.tlsServer.close()
        .then(() => {
          const msg = `服务器已关闭`;
          console.info(msg);
          this.addTestResult(msg);
          this.isListening = false;
          this.tlsServer = null;
        })
        .catch((err: BusinessError) => {
          const errMsg = `服务器关闭失败: [${err.code}] ${err.message}`;
          console.error(errMsg);
          this.addTestResult(errMsg);
        });
    }
  }

  testTlsServerClosePromise(): void {
    if (this.isListening) {
      this.addTestResult(`服务器已在监听，正在重启...`);
      this.closeTlsServer();
      setTimeout(() => this.startServer(), 500);
      return;
    }
    this.startServer();
  }

  private startServer(): void {
    if (!this.tlsServer) {
      this.tlsServer = socket.constructTLSSocketServerInstance();
    }

    const netAddress: socket.NetAddress = {
      address: '127.0.0.1',
      port: 8080
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

    this.tlsServer.listen(tlsConnectOptions)
      .then(() => {
        const successMsg = `服务器启动监听成功`;
        console.info(successMsg);
        this.addTestResult(successMsg);
        this.isListening = true;
        this.listenClientConnection();
      })
      .catch((err: BusinessError) => {
        const errMsg = `服务器启动监听失败: [${err.code}] ${err.message}`;
        console.error(errMsg);
        this.addTestResult(errMsg);
        this.tlsServer = null;
      });
  }

  private listenClientConnection(): void {
    if (!this.tlsServer) return;

    this.tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
      const connectMsg = `客户端连接建立成功（客户端ID: ${client.toString()}）`;
      this.addTestResult(connectMsg);

      client.close()
        .then(() => {
          this.addTestResult(`客户端连接关闭成功`);
        })
        .catch((err: BusinessError) => {
          this.addTestResult(`客户端连接关闭失败: [${err.code}] ${err.message}`);
        });
    });
  }

  private testClose(): void {
    const server = socket.constructTLSSocketServerInstance();
    const netAddress: socket.NetAddress = {
      address: '127.0.0.1',
      port: 8084
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

    server.listen(tlsConnectOptions).then(() => {
        server.close().then(() => {
          this.addTestResult(`close调用成功 → 验证端口释放和连接保留`);
          }).catch((err: BusinessError) => {
            this.addTestResult(`端口未释放 → 错误码=${err.code}，错误信息=${err.message}`);
          });
        }).catch((err: BusinessError) => {
          this.addTestResult(`listen调用失败 → 错误码=${err.code}，错误信息=${err.message}`);
        });
  }

  // 模拟权限校验失败（错误码201）
  private testPermissionDenied(): void {
    const mockServer = socket.constructTLSSocketServerInstance();
    const validOptions: socket.TLSConnectOptions = {
      address: { address: '127.0.0.1', port: 8081 },
      secureOptions: {
        key: this.serverKey.trim(),
        cert: this.serverCert.trim(),
        ca: [this.serverCa.trim()],
        password: "",
        protocols: [socket.Protocol.TLSv12],
        useRemoteCipherPrefer: true,
        signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
        cipherSuite: "AES256-SHA256"
      },
      ALPNProtocols: ["http/1.1"]
    };
    mockServer.listen(validOptions).catch((err: BusinessError) => {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    });

    setTimeout(() => {
      mockServer.close().catch(() => {});
      this.addTestResult(`服务器正常关闭`);
    }, 1000);
  }


  /** 特殊场景：多次调用listen后调用close，验证端口释放和连接保留 */
  private testCloseAfterMultipleListen(): void {
    const server = socket.constructTLSSocketServerInstance();
    const netAddress: socket.NetAddress = {
      address: '127.0.0.1',
      port: 8083 // 新端口避免冲突
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

    // 多次调用listen
    server.listen(tlsConnectOptions).then(() => {
      server.listen(tlsConnectOptions).then(() => {
        this.addTestResult(`特殊场景：多次listen调用成功`);
        // 调用close
        server.close().then(() => {
          this.addTestResult(`特殊场景：close调用成功 → 验证端口释放和连接保留`);
          // 验证端口是否释放（尝试再次监听同端口）
          server.listen(tlsConnectOptions).then(() => {
            this.addTestResult(`特殊场景：端口已释放（再次监听成功）`);
            server.close().catch(() => {});
          }).catch((err: BusinessError) => {
            this.addTestResult(`特殊场景：端口未释放 → 错误码=${err.code}，错误信息=${err.message}`);
          });
        }).catch((err: BusinessError) => {
          this.addTestResult(`特殊场景：close调用失败 → 错误码=${err.code}，错误信息=${err.message}`);
        });
      }).catch((err: BusinessError) => {
        this.addTestResult(`特殊场景：第二次listen调用失败 → 错误码=${err.code}，错误信息=${err.message}`);
      });
    }).catch((err: BusinessError) => {
      this.addTestResult(`特殊场景：第一次listen调用失败 → 错误码=${err.code}，错误信息=${err.message}`);
    });
  }

  /**
   * close- 系统内部错误（错误码2300002，信息“System internal error.”）
   */
  testCloseCallbackSysInterErr(): void {
    //const commonConfig = this.getCommonConfig(81);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    try {
      tlsServer.close().then(() => {
        this.addTestResult('未监听时close()成功（预期应该失败）');
      }).catch((err: BusinessError) => {
        if (err.code === 2300002) {
          this.addTestResult(`成功触发2300002错误：${err.message}`);
        } else {
          this.addTestResult(`收到错误但非2300002：${err.code} - ${err.message}`);
        }
      });

    }catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  addTestResult(result: string): void {
    const fullResult = ` ${result}`;
    this.testResults = [...this.testResults, fullResult];
    console.info(`测试结果: ${fullResult}`);
  }

  clearTestResults(): void {
    this.testResults = [];
    this.addTestResult(`测试结果已清空`);
  }

  build() {
    Column({ space: 20 }) {
      Text('TLSSocketServer_close')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: 10 })
        .padding(12)
        .backgroundColor('#ffffff')
        .borderRadius(12)
        .shadow({ radius: 4, color: '#00000010', offsetX: 0, offsetY: 2 });

      Column({ space: 12 }) {
        // Button('启动/重启 TLS 连接测试')
        //   .onClick(() => this.testTlsServerClosePromise())
        //   .width('90%')
        //   .height(44)
        //   .fontSize(16)
        //   .backgroundColor('#2196F3')
        //   .fontColor('#ffffff')
        //   .borderRadius(8)
        //   .shadow({ radius: 3, color: '#2196F320', offsetX: 0, offsetY: 2 })

        Button('TLSSocketServer_close_normal')
          .onClick(() => this.testClose())
          .width('90%')
          .height(44)
          .fontSize(16)
          .backgroundColor('#7B1FA2')
          .fontColor('#ffffff')
          .borderRadius(8);


        // Button('模拟权限校验失败（错误码201）')
        //   .onClick(() => this.testPermissionDenied())
        //   .width('90%')
        //   .height(44)
        //   .fontSize(16)
        //   .backgroundColor('#FF9800')
        //   .fontColor('#ffffff')
        //   .borderRadius(8);

        Button('特殊场景：多次listen后调用close')
          .onClick(() => this.testCloseAfterMultipleListen())
          .width('90%')
          .height(44)
          .fontSize(16)
          .backgroundColor('#7B1FA2')
          .fontColor('#ffffff')
          .borderRadius(8);

        Button('close-系统内部错误（2300002）')
          .onClick(() => this.testCloseCallbackSysInterErr())
          .width('90%')
          .height(40)
          .backgroundColor('#795548');

        Button('清空测试结果')
          .onClick(() => this.clearTestResults())
          .width('90%')
          .height(44)
          .fontSize(16)
          .backgroundColor('#607D8B')
          .fontColor('#ffffff')
          .borderRadius(8)
          .shadow({ radius: 3, color: '#607D8B20', offsetX: 0, offsetY: 2 });

        // Button('手动关闭服务器')
        //   .onClick(() => this.closeTlsServer())
        //   .width('90%')
        //   .height(44)
        //   .fontSize(16)
        //   .backgroundColor('#FF5722')
        //   .fontColor('#ffffff')
        //   .borderRadius(8)
        //   .shadow({ radius: 3, color: '#FF572220', offsetX: 0, offsetY: 2 });

        Button('返回主界面')
          .onClick(() => router.back())
          .width('90%')
          .height(44)
          .fontSize(16)
          .backgroundColor('#4CAF50')
          .fontColor('#ffffff')
          .borderRadius(8)
          .shadow({ radius: 3, color: '#4CAF5020', offsetX: 0, offsetY: 2 });
      }
      .width('100%')

      Text('测试结果日志')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .width('90%')
        .textAlign(TextAlign.Start)

      Scroll() {
        Column({ space: 6 }) {
          ForEach(
            this.testResults,
            (result: string, index: number) => {
              Text(`${index + 1}. ${result}`)
                .fontSize(14)
                .textAlign(TextAlign.Start)
                .padding(8)
                .backgroundColor(index % 2 === 0 ? '#f5f5f5' : '#ffffff')
                .width('100%')
                .borderRadius(6)
                .shadow({ radius: 2, color: '#00000008', offsetX: 0, offsetY: 1 });
            },
            (result: string, index: number) => `${result}-${index}`
          );

          if (this.testResults.length === 0) {
            Text('暂无测试结果，点击按钮开始测试')
              .fontSize(14)
              .textAlign(TextAlign.Start)
              .padding(15)
              .width('100%')
              .fontColor('#999999');
          }
        }
        .width('100%')
        .padding(4)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }
      .scrollBar(BarState.On)
      .scrollable(ScrollDirection.Vertical)
      .height(180)
      .width('90%')
      .backgroundColor('#ffffff')
      .borderRadius(10)
      .border({ width: 1, color: '#eeeeee' })
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#f5f5f7');
  }
}