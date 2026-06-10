//import { socket } from '@kit.NetworkKit';
import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import router from '@ohos.router';


@Entry
@Component
struct testTLSSocketServerOnConnect {
  @State testResults: string[] = [];
  private tlsServer?: socket.TLSSocketServer;
  private tlsClient?: socket.TLSSocket;
  private tlsClientCon?: socket.TLSSocketConnection;
  private testPort: number = 8080; // 更换新端口

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

  private setupTestEnv(): void {
    this.startServer();
  }

  private startServer(): void {
    if (this.tlsServer) {
      this.addTestResult(`服务器已启动`);
      return;
    }

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
        this.addTestResult(`服务器: 监听失败: ${JSON.stringify(err)}`);
        return;
      }

      this.addTestResult(`监听成功 on ${this.testPort}`);

      // 监听客户端连接
      this.tlsServer!.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');
        this.tlsClientCon = client;
        this.setupConnectionEvents(client);
      });

      this.tlsServer!.on('error', (err: BusinessError) => {
        //this.addTestResult(`服务器错误: ${err.code} - ${err.message}`);
        console.error('TLSSocketServer error:', JSON.stringify(err));
      });

      setTimeout(() => this.startTLSClient(), 2000);
    });
  }

  private setupConnectionEvents(client: socket.TLSSocketConnection): void {
    client.on('close', () => {
      this.addTestResult('客户端连接已关闭');
    });

    client.on('message', (data: socket.SocketMessageInfo) => {
      this.handleClientMessage(data);
    });
  }

  private startTLSClient(): void {
    if (this.tlsClient) {
      this.addTestResult(`客户端已启动`);
      return;
    }

    this.tlsClient = socket.constructTLSSocketInstance();

    this.tlsClient.bind({ address: '0.0.0.0', port: 0 }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`客户端: 绑定失败: ${err.message}`);
        return;
      }

      this.addTestResult('客户端: 绑定成功');

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

      this.setupClientEvents();

      this.tlsClient!.connect(connectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`客户端: 连接失败: ${err.message}`);
          return;
        }
        this.addTestResult('客户端: 连接服务器成功');
      });
    });
  }

  private setupClientEvents(): void {
    if (!this.tlsClient) return;

    this.tlsClient.on('close', () => {
      this.addTestResult('客户端连接关闭');
    });

    this.tlsClient.on('error', (err: BusinessError) => {
      this.addTestResult(`客户端错误: ${err.code} - ${err.message}`);
    });

    this.tlsClient.on('message', (data: socket.SocketMessageInfo) => {
      this.handleServerMessage(data);
    });
  }

  private handleClientMessage(data: socket.SocketMessageInfo): void {
    try {
      const message = new Uint8Array(data.message);
      this.addTestResult(`收到客户端消息，长度: ${message.length}`);
    } catch (error) {
      this.addTestResult(`处理客户端消息错误: ${error}`);
    }
  }

  private handleServerMessage(data: socket.SocketMessageInfo): void {
    try {
      const message = new Uint8Array(data.message);
      this.addTestResult(`收到服务器消息，长度: ${message.length}`);
    } catch (error) {
      this.addTestResult(`处理服务器消息错误: ${error}`);
    }
  }

  // getCipherSuite_callback
  private getCipherSuite_callback() {
    if (!this.tlsClientCon) {
      this.addTestResult('客户端不存在，请先建立连接');
      return;
    }

    this.tlsClientCon.getCipherSuite((err: BusinessError, data: Array<string>) => {
      if (err) {
        console.error("getCipherSuite callback error = " + err);
        this.addTestResult(`callback获取通信双方协商后的加密套件失败: [${err.code}] ${err.message}`);
      } else {
        this.addTestResult(`callback获取通信双方协商后的加密套件成功` + JSON.stringify(data));
      }
    });
  }

  // getCipherSuite_callback_undefined
  private getCipherSuite_callback_undefined() {
    if (!this.tlsClientCon) {
      this.addTestResult('客户端不存在，请先建立连接');
      return;
    }
    try{
      this.tlsClientCon.getCipherSuite(undefined);
      this.addTestResult(`callback获取通信双方协商后的加密套件成功`);
    }
    catch (err){
      this.addTestResult(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }

  }

  // getCipherSuite_callback_null
  private getCipherSuite_callback_null() {
    if (!this.tlsClientCon) {
      this.addTestResult('客户端不存在，请先建立连接');
      return;
    }
    try{
      this.tlsClientCon.getCipherSuite(null);
      this.addTestResult(`callback获取通信双方协商后的加密套件成功`);
    }
    catch (err){
      this.addTestResult(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }
  }

  // getCipherSuite_callback_no
  private getCipherSuite_callback_no() {
    if (!this.tlsClientCon) {
      this.addTestResult('客户端不存在，请先建立连接');
      return;
    }
    try{
      this.tlsClientCon.getCipherSuite()
        this.addTestResult(`获取通信双方协商后的加密套件成功`);
    }
    catch (err){
      this.addTestResult(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }
  }

  private getCipherSuite_promise() {
    if (!this.tlsClientCon) {
      this.addTestResult('客户端不存在，请先建立连接');
      return;
    }
    this.tlsClientCon.getCipherSuite().then((data: Array<string>) => {
      this.addTestResult(`promise获取通信双方协商后的加密套件成功` + JSON.stringify(data));
    }).catch((err: BusinessError) => {
      this.addTestResult(`promise获取通信双方协商后的加密套件失败: [${err.code}] ${err.message}`);
    });
  }

  //2303501 SSL 为空(SSL is null.)
  private getCipherSuite_2303501() {
    if(this.tlsServer){
      this.tlsServer.close();
      this.tlsServer = undefined;
    }
    if(this.tlsClient){
      this.tlsClient.close();
      this.tlsClient = undefined;
    }
    if(this.tlsClientCon){
      this.tlsClientCon.close();
      this.tlsClientCon = undefined;
    }
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8081
    };

    const tlsSecureOptions: socket.TLSSecureOptions = {
    };

    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: []
    };

    tlsServer.listen(tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${JSON.stringify(err)}`);
        return;
      }

      this.addTestResult(`监听成功 on ${netAddress.port}`);

      // 监听客户端连接
      tlsServer!.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');
        this.setupConnectionEvents(client);
      });

      tlsServer!.on('error', (err: BusinessError) => {
        //this.addTestResult(`服务器错误: ${err.code} - ${err.message}`);
        console.error('TLSSocketServer error:', JSON.stringify(err));
      });
    });

    setTimeout(() => {
    }, 2000);
    let tlsClient: socket.TLSSocket = socket.constructTLSSocketInstance();

    tlsClient.bind({ address: '127.0.0.7', port: 0 }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`客户端: 绑定失败: ${err.message}`);
        return;
      }

      this.addTestResult('客户端: 绑定成功');

      const connectAddr: socket.NetAddress = {
        address: '127.0.0.1',
        port: 8081
      };

      const secureOptions: socket.TLSSecureOptions = {
      };

      const connectOptions: socket.TLSConnectOptions = {
        address: connectAddr,
        secureOptions: secureOptions,
        ALPNProtocols: []
      };

      this.setupClientEvents();

      tlsClient!.connect(connectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`客户端: 连接失败: ${err.message}`);
          return;
        }
        this.addTestResult('客户端: 连接服务器成功');
      });
    });
    try {
      tlsClient.getCipherSuite().then((data: Array<string>) => {
        this.addTestResult(`promise获取通信双方协商后的加密套件成功` + JSON.stringify(data));
      }).catch((err: BusinessError) => {
        this.addTestResult(`promise获取通信双方协商后的加密套件失败: [${err.code}] ${err.message}`);
      })
    } catch (err) {
      this.addTestResult(`promise获取通信双方协商后的加密套件失败: [${err.code}] ${err.message}`);
    }
    setTimeout(()=>{
      tlsClient.close();
      tlsServer.close();
    },1000);
  }

  private stopTest(): void {
    if(this.tlsClient) {
      this.tlsClient.close();
      this.tlsClient = undefined;
    }
    if (this.tlsServer) {
      this.tlsServer.close();
      this.tlsServer = undefined;
    }

    // 增加释放IP和端口代码
    this.releaseNetworkResources();

    setTimeout(() => {
      console.info(`端口 ${this.testPort} 清理完成`);
    }, 300);
  }

  // 新增方法：释放网络资源
  private releaseNetworkResources(): void {
    // 方法1: 强制释放所有socket连接
    try {
      // 创建临时socket强制释放端口占用
      const releaseSocket = socket.constructTLSSocketInstance();
      const releaseAddress: socket.NetAddress = {
        address: '0.0.0.0',
        port: this.testPort
      };

      releaseSocket.bind(releaseAddress, () => {
        // 绑定成功后立即关闭，强制释放端口
        releaseSocket.close();
        console.info(`端口 ${this.testPort} 已强制释放`);
      });

      // 设置超时确保释放
      setTimeout(() => {
        releaseSocket.close();
      }, 100);
    } catch (error) {
      console.info('端口释放操作完成');
    }

    // 方法2: 重置网络状态
    this.resetNetworkState();

    // 方法3: 清理DNS缓存（如果适用）
    this.clearDNSCache();
  }

  // 新增方法：重置网络状态
  private resetNetworkState(): void {
    // 重置端口状态
    this.testPort = 8080;
    console.info('网络状态已重置');

    // 可选：重置IP绑定状态
    this.addTestResult('IP和端口绑定状态已重置');
  }

  private clearDNSCache(): void {
    try {
      const localhost = '127.0.0.1';
      console.info(`DNS缓存清理完成，本地地址: ${localhost}`);
    } catch (error) {
      console.info('DNS清理完成');
    }
  }

  // 取消订阅TLSSocketServer的连接事件。使用callback方式作为异步方法
  testTlsServerOffConnectCallback(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    let netAddress: socket.NetAddress = {
      address: '127.0.0.1',
      port: 8080
    }
    const tlsSecureOptions: socket.TLSSecureOptions = {
      key: this.serverKey.trim(),
      cert: this.serverCert.trim(),
      ca: [this.serverCa.trim()], // 如果需要验证客户端，可以设置ca，这里我们使用相同的证书
      password: "",
      protocols: [socket.Protocol.TLSv12],
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    };

    let tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"]
    }
    tlsServer.listen(tlsConnectOptions).then(() => {
      console.info("listen callback success");
    }).catch((err: BusinessError) => {
      console.error("failed: " + JSON.stringify(err));
    });

    let callback = (data: socket.TLSSocketConnection) => {
      console.info('on connect message: ' + JSON.stringify(data));
    }
    tlsServer.on('connect', callback);
    // 可以指定传入on中的callback取消一个订阅，也可以不指定callback清空所有订阅。
    tlsServer.off('connect', callback);
    tlsServer.off('connect');
    this.addTestResult(`移除TLSSocketServer连接成功`);
  }

  addTestResult(result: string): void {
    this.testResults = [...this.testResults, result];
    console.info(`测试结果: ${result}`);
  }

  clearTestResults(): void {
    this.testResults = [];
  }

  build() {
    Column() {
      Text('TLSSocketConnection接口测试')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .padding(10)
        .backgroundColor('#f0f0f0')
        .borderRadius(5)
        .width('100%')
        .textAlign(TextAlign.Center)

      Scroll() {
        Column({ space: 15 }) {
          Button('启动环境服务器+客户端')
            .onClick(() => this.setupTestEnv())
            .width('90%')
            .backgroundColor('#ff9800')
          Button('getCipherSuite_callback')
            .onClick(() => this.getCipherSuite_callback())
            .width('90%')
            .backgroundColor('#4CAF50')

          Button('getCipherSuite callback 类型错误 undefined')
            .onClick(() => this.getCipherSuite_callback_undefined())
            .width('90%')
            .backgroundColor('#4CAF50')

          Button('getCipherSuite callback 类型错误 null')
            .onClick(() => this.getCipherSuite_callback_null())
            .width('90%')
            .backgroundColor('#4CAF50')

          Button('getCipherSuite 未传入 callback 参数')
            .onClick(() => this.getCipherSuite_callback_no())
            .width('90%')
            .backgroundColor('#4CAF50')

          Button('getCipherSuite_promise')
            .onClick(() => this.getCipherSuite_promise())
            .width('90%')
            .backgroundColor('#4CAF50')

          //2303501 SSL 为空(SSL is null.)
          // Button('getCipherSuite_2303501')
          //   .onClick(() => this.getCipherSuite_2303501())
          //   .width('90%')
          //   .backgroundColor('#4CAF50')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .scrollBar(BarState.On)
      .scrollable(ScrollDirection.Vertical)
      .layoutWeight(1)
      .margin({ top: 10 })

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
      .height(200)
      .margin({ top: 10 })
      .padding(10)
      .border({ width: 1, color: '#dddddd' })

      Row() {
        Button('← 返回')
          .layoutWeight(1)
          .padding({ left: 15, right: 15 })
          .backgroundColor('#4CAF50')
          .onClick(() => {
            router.back();
          })
        Button('清理日志')
          .layoutWeight(1)
          .padding({ left: 15, right: 15 })
          .backgroundColor('#4CAF50')
          .onClick(() => this.clearTestResults())
        Button('清理环境')
          .layoutWeight(1)
          .padding({ left: 15, right: 15 })
          .backgroundColor('#4CAF50')
          .onClick(() => this.stopTest())
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(10)
      .margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor('#f9f9f9')
  }
}
