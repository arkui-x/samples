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

  // 本地生成的 2048位 RSA 密钥对（替换为你自己生成的内容）
  private readonly serverKey = `-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAzP0+aCc1PARA6Ed8MwseIHVdCEwhwiTmUzeP9IJFuUv4MsMz
kY/uQAcHIZ5SIk4vGFbQZcSZyd/IwakOxw5LlK8ldwUgt4OvuwQXQj3lmpRTPxIE
0TwvKj3aFeEVKFyPsE2eJEV6YUhnRAENEx3jQhCl8nkHz9cA3IhQlxUTF5mVfbWJ
Kxr38O48pH5XEvh5ii1dTyGYtsiw4TpvOByEtgMqnnz6juiLliS9brh7v/I7Acro
Ncu3VNYrTpBtbzPgELTa7TpKBAVu/lMQdAvezmRuSyA1/bpFxXc9NA1mxViotUIS
Gf9A5ifx1ocDIgKZprzJBH2CgPgk9i7tgpqDeQIDAQABAoIBAQCwwq7NoQGGfyR5
Jysx2KRh2NIgFYYGo0r49zBq5uq4nYmoPCp7mmEXVPgRRTQN4N07X6DUIHN8YDv8
woq7mtgRnfXwa7uKg0NFQIHN3RHf+YbPG/qLcho5kpw7wZs88pP0svlqzX555LUn
LsDXey48CZ8PNs5FqmBTyje0D7gm3/yTw7NTqKXsT2SNDzRGwI7Q4N0ZvrQi1BvV
DKF71MRvl71d1WrVWe9rZ/UeUxV+vkuoNXNSCqjHkRbG1fklnpCP0UMd1ZoMYpUm
WpVzkNeP5sfcnJEwXb4HmAwmTlLNKhJgt9E4ZDKDe8BopUEvkSKs0Mz+TqY7jfDl
Pn4GdqcBAoGBAPcYUhY7UDDJOkklpbyZE/hnJPlO/oNH2OIy2yxv/KFambnwJ1gf
56Ss9hY563rvQhqsboLAqthoHbrRSaYh4MDcTSxMcs0cKKE9WpFnCbJl7hVKIJMo
45n3A5nJX3XwtVSofQN79+q29OJDa9PmS/RU4+AYGg7qpyaSpE6IawsnAoGBANRg
dWRVt6wY9yLp4d/1KNP5peYzCYIAcInIklRttqVLVq57OS7Z9nF4AdunSEZQvkkJ
r8TOuRpGn6igJ3eYBE7U3iyHu+2H6fz4a1LrNEeDJHt9NaTNYMDNMSg1NtCGX6JH
k9WTD0KUdk4IWnzWcrjA8ZTHJ0W7xQzxY1Jqb6BfAoGBAJZOqxBvADbNEbGRPyJc
k/NU+v7U+KlvORVQDlcXwDt+22hqF+TZc5WOyRt4HDBp/nIvVgIfpU2C+CK+UOjI
TunCmQdLccInUOfUZJVyckmdC5jTwMED7H+p7PzNrE4YIJXg8DsAXCzhIlHI5Xy+
6JE2Wm/k+WT9hLRIG77R6RudAoGAPNJ3LEoENSxdMsmKn8olbDfWFExPj8SydjNT
/QwCv+oIpCW0Jb/UfYCh/5cz8rdTF7XHefS+PFE3jmJ3ix+lNDJwgo5I+uju0T0P
94pWyZg8TYV5ZH5RFEZvqpU64pNpNh+LriHUv/umughYaeI8rr7LMRGsJKN29pL3
H/ZNi78CgYEAsrj4mG3dG4eVrcPQt/jPcOnc14DxEtJ0+JLMzFrpaniW84nybKgU
XmhBKmZprZCBCjfvRVCDc5Z6XftweAWq3TY9OblgMTtkd2nhuhDcP9VAvoVMXMu/
8owdEBB9xUnsxQQCttTrrQOf3DHw4dnslXW8G1evyc4p4YQGgJh7hUg=
-----END RSA PRIVATE KEY-----`;
  private readonly serverCert =`-----BEGIN CERTIFICATE-----
MIIDyDCCArCgAwIBAgIUTK3bCiYfTZCtOwIY3GUX8747JXgwDQYJKoZIhvcNAQEL
BQAwVjELMAkGA1UEBhMCQ04xDjAMBgNVBAgMBVN0YXRlMQ0wCwYDVQQHDARDaXR5
MRUwEwYDVQQKDAxPcmdhbml6YXRpb24xETAPBgNVBAMMCE15Um9vdENBMB4XDTI1
MTEyNzA4NTQzNVoXDTI2MTEyNzA4NTQzNVowVzELMAkGA1UEBhMCQ04xDjAMBgNV
BAgMBVN0YXRlMQ0wCwYDVQQHDARDaXR5MRUwEwYDVQQKDAxPcmdhbml6YXRpb24x
EjAQBgNVBAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAMz9PmgnNTwEQOhHfDMLHiB1XQhMIcIk5lM3j/SCRblL+DLDM5GP7kAHByGe
UiJOLxhW0GXEmcnfyMGpDscOS5SvJXcFILeDr7sEF0I95ZqUUz8SBNE8Lyo92hXh
FShcj7BNniRFemFIZ0QBDRMd40IQpfJ5B8/XANyIUJcVExeZlX21iSsa9/DuPKR+
VxL4eYotXU8hmLbIsOE6bzgchLYDKp58+o7oi5YkvW64e7/yOwHK6DXLt1TWK06Q
bW8z4BC02u06SgQFbv5TEHQL3s5kbksgNf26RcV3PTQNZsVYqLVCEhn/QOYn8daH
AyICmaa8yQR9goD4JPYu7YKag3kCAwEAAaOBjDCBiTAdBgNVHQ4EFgQUXHinclJS
Gz2ow1xxdc7RmT65ZOQwHwYDVR0jBBgwFoAUHLzwQ0p8DyS7VBIL/b3bZTU3OAww
CQYDVR0TBAIwADALBgNVHQ8EBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwEwGgYD
VR0RBBMwEYIJbG9jYWxob3N0hwTAqPx7MA0GCSqGSIb3DQEBCwUAA4IBAQCwcCdj
TWRqZ2LuApsIdH8ro7Ffn1bmYgsO8JsIGeI0UPM3OosskRpP8NUKDzXwHG7Nwo+H
pzbMJG4v5owzr5ViQivf3Q4zvpdYD8HZoaCI2jKSoJ655/ePU4gutF6WmIT/Z+nI
P08qtmXs9lrFPLqS4XOsYa8UAZYA2YDfFrE0A1hRqnWgv7KGKFm5XK6h3fq45m6d
m35j8WJ47G3QJiY1Qk6Z3DoMDMRa4hvlYxNu0ZJ6M1tSBNKtj5ND0z80cj4Q/Y/O
IsClW5/zKcCC28B5Uf5/0Dy44ubtt7NrzkkfGJrf/s13KSWxE8Lzg1jyHbSqasaG
+LkEL22Wh9klaQUP
-----END CERTIFICATE-----`;
  private readonly clientKey =`-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAqqOwg1yJf1t/5NNsSYdIPNvqJFj0uKVwTIX35r741jPZXan0
oWe6m56BwEoCMfsZpp4hHSmFf8hyO9nvLs8pLx3kUrT2erpSxYwWsb0FV43J+Zli
scmYCR6tm+dOy9WowdQBKg/qldE6hz3hVBmjLws/5oEYUmlPRddtCdbnuj1mgf7p
JyBOIRx/EkTdMfN+hpsm2cfbYZICeZic5Ojb4G+r2EcaYDAAccFA2H55gNAP3CzE
KfB6loQ1BCLLBiWgngEZam8HO4GPNQzEv979e3Vmux7H90yaYQOCNYm2fNpvauaI
j7mUb5sXJkdYw92O5J/KAfxxWv0jjY7jIcc3/wIDAQABAoIBAEfgx7utwSVqj4b+
IAEhASbRo+FHr14QIiu5yuDh1MO193vi2W8b2JkwvYsYIbCYCwgKV/yGvvtCngvk
E0JudPSp7MGCBMlRrwgTqIOaEaP9z/RZzh8Bwg8lYw/m8WQfTgTHnu3u4mvVRIgv
YrkgS4LHhFU+T9Z3EbNjuUSJx/bEsiflM5hCDI0k2NZQ8D1M5RM9ANx16bn6DZRT
su6amCaiEgvFi5sTA9ROOdt1hWUzmtzC6/Z2SRylVoIbbNqaGZirTCZd/4nGYp0d
X+BRfuHhmFKqm2cj/jbfe2VZWjGoR57U7knd9xq2JiGWZwLnyHmr7tlk+3NS0gsd
m5IL5LECgYEA2kucCadjuno7U2jb2gyXL4EmcXsy125KTngXAiTP8U4XS6DpW0pP
PaSet0JRav20agqk1B4ofcV6i5t69lsp/6siQDJGNWQtpxBop7yr12xwgE/dHigH
D0HTHRkqnJkrJjsDQKUMi/K9e8EZhO4OnjZBBmc3/MY2C4NDzAYk+pMCgYEAyBzf
Nv0dlkZBwwwxJP3O+rmxIfcfGATTylnjULpL7mZB9xOX6iUnmdaE3tlD4Tbj7tCb
DXd/gtOJkU2iOIEmurizJRjVLMvUW4uYB74GxhqWfV46ZHKGdn1ouAHAAwfPLKIm
HOGHsI02U5p6LbzIEKki3zoRBt/oaN4GjcqbtGUCgYBHADisWylwybjqFD0N2vKB
nPwoBO4wa8r3Ys/4/ogz8DZbfubnrm+/mP+Wk5dvuT0pEHU0GOsKnWSSa+u+nUA3
zC3Du5ZiX0cKA6hGhnNOChM9aLx+xn4lVD+aQ0k8zgTe1mrkZ8qA6l7/FXt7ZQKU
KwlTT9dB/CYv8G3oukbkyQKBgDjUmj/Pmnt28G4oJDzRJ9rkqX1v5RC5LjylUn02
qyHFQK6ejeIdMyXpWkq/gRuQryK/c4lbiobo9ISje5J4eztEAPxkFQZnzKNC/aYV
PW89Vce83vBv5ef4rai0NoelzBxs4E4LbrGhKPCNSm1604aHwjOLFhLRu/ssMshJ
5fZRAoGBALTJ2HqxMR/DGRajq00OEJYSuf99KeSy+UyoY5llrWYQbitlym8A0ZTh
KePFSJu/CAX2/hQul2XRPDwYyiD/pWb+V8gu53c5snHhX8azPEjQjoypHVkwBy5T
7X8CwlzITlA3VFp8EGI2e0D8R+aCRHtW1srLhtCSVRdRTtsfmLbh
-----END RSA PRIVATE KEY-----`;
  private readonly clientCert =`-----BEGIN CERTIFICATE-----
MIIDqTCCApGgAwIBAgIUTK3bCiYfTZCtOwIY3GUX8747JXkwDQYJKoZIhvcNAQEL
BQAwVjELMAkGA1UEBhMCQ04xDjAMBgNVBAgMBVN0YXRlMQ0wCwYDVQQHDARDaXR5
MRUwEwYDVQQKDAxPcmdhbml6YXRpb24xETAPBgNVBAMMCE15Um9vdENBMB4XDTI1
MTEyNzA4NTQzNVoXDTI2MTEyNzA4NTQzNVowVjELMAkGA1UEBhMCQ04xDjAMBgNV
BAgMBVN0YXRlMQ0wCwYDVQQHDARDaXR5MRUwEwYDVQQKDAxPcmdhbml6YXRpb24x
ETAPBgNVBAMMCE15Q2xpZW50MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAqqOwg1yJf1t/5NNsSYdIPNvqJFj0uKVwTIX35r741jPZXan0oWe6m56BwEoC
MfsZpp4hHSmFf8hyO9nvLs8pLx3kUrT2erpSxYwWsb0FV43J+ZliscmYCR6tm+dO
y9WowdQBKg/qldE6hz3hVBmjLws/5oEYUmlPRddtCdbnuj1mgf7pJyBOIRx/EkTd
MfN+hpsm2cfbYZICeZic5Ojb4G+r2EcaYDAAccFA2H55gNAP3CzEKfB6loQ1BCLL
BiWgngEZam8HO4GPNQzEv979e3Vmux7H90yaYQOCNYm2fNpvauaIj7mUb5sXJkdY
w92O5J/KAfxxWv0jjY7jIcc3/wIDAQABo28wbTAdBgNVHQ4EFgQU/cAbSeVdEr7j
vvgNvG9gMv/uucUwHwYDVR0jBBgwFoAUHLzwQ0p8DyS7VBIL/b3bZTU3OAwwCQYD
VR0TBAIwADALBgNVHQ8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwIwDQYJKoZI
hvcNAQELBQADggEBAIcfOLnPrKv7hWu2hoDVWPJ7psp7fGwSZhjF4KqvOeu0lHh/
O6LkSEhXCeyqa9p9lTlkjfdiGAkFCVqTvdgmYH33pR66pXeMMzmGtl+6aoGYh0m9
TcZZD5owsM28ll4bw/2mdnDaUcOYWa47bUV5vj9LDnGBM1NbciPgA0tZkbMEbFDF
MUlHjZ+FvmfbghiIKv9M5UGJUxBZ9q7m0AmNeSFU0hiVDFbESsYAmnEtIZdZcHqu
3CihSji9c5V6BPRnH6KzzIrCXwGzJADkq9nDw9QzJIN1xeqT1FO64p9R56kmG/wa
fwiJmSuJureFdK1XsIsxTI627CMjNfVtKoBfsVg=
-----END CERTIFICATE-----`;
  private readonly Ca =`-----BEGIN CERTIFICATE-----
MIIDjTCCAnWgAwIBAgIUF27KjhBULdAdgJsy9AMmcsqIRlYwDQYJKoZIhvcNAQEL
BQAwVjELMAkGA1UEBhMCQ04xDjAMBgNVBAgMBVN0YXRlMQ0wCwYDVQQHDARDaXR5
MRUwEwYDVQQKDAxPcmdhbml6YXRpb24xETAPBgNVBAMMCE15Um9vdENBMB4XDTI1
MTEyNzA4NTQzNVoXDTI2MTEyNzA4NTQzNVowVjELMAkGA1UEBhMCQ04xDjAMBgNV
BAgMBVN0YXRlMQ0wCwYDVQQHDARDaXR5MRUwEwYDVQQKDAxPcmdhbml6YXRpb24x
ETAPBgNVBAMMCE15Um9vdENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEA1NGoznsnAM9OvJC4v1iuYvYZtW95VpcToUrTCYhaOl+bvWvSr50phTKPFIkF
Gwo5ekKz1p9PHivLaTeGWyBTQjMh6VgarzzsskWyV5PfQ2yAzNuWgeVWMd1WRstX
7OSyv23xradb9MbScU2q2qySNKblmK/1QhI8CupCedDy8vyIbJWyOygYAS3u+Fiy
Imq98gdKXUi/h/k+biOKqJHbMsH/SrHT+uBn8Al+9gc13bVdri2BHdAiP+yUE3D5
we8MTXR2M8kOtMZjhvyBMeteN5dNN1KO3VrlX61/LW6PH+3PTZ9gqLDhZkiCY5lC
JBhoz0Q+wjpWBPsMKS5b9MovsQIDAQABo1MwUTAdBgNVHQ4EFgQUHLzwQ0p8DyS7
VBIL/b3bZTU3OAwwHwYDVR0jBBgwFoAUHLzwQ0p8DyS7VBIL/b3bZTU3OAwwDwYD
VR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAtcqILa1A35pKWWQ27ph2
MNZu5ixHuZ+kCGK+m9dKgM37o1u9kUGvwu9xlmZuP/OhJeTn+vLr6jcNUwcBsz7E
81sWWJ6P0zFQyuQ7AhzF1uXADuXc2N+3Ov9nxJd3klBCvP9Lnz/Lv71QFh0dh8LD
vz0n8EWhvfPiIMKzgB4DwIVRzphRcnoflddeXSB2TMV8v40MM7qGTjs20qus98dH
k+piztESfTg06Dx50aVt85hgEg+rtJRasyN2d9Nwl9vHS+K0v0Q9/zxd4QO2K+1W
k3XKF6JL4sWXjYtLZGpppusB4Sxt3Yqu5yTb6mUXPzTCaYvhJZ175ewQ6DFAvt/o
wA==
-----END CERTIFICATE-----`;

  /**
   * 提取公共配置（网络+TLS），减少冗余，统一维护
   * @param port 端口号（区分不同测试模式，避免冲突）
   */
  private getCommonConfig(port: number,proxyType: ProxyType = socket.ProxyTypes.NONE,
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
      password: "", // 无密码留空（根据实际证书配置修改）
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    };

    // 代理配置（默认不使用代理）
    const proxyOptions: socket.ProxyOptions = {
      type: proxyType,
      address: netAddress,
      username: 'proxyUser',
      password: 'proxyPass',
    };

    // 统一连接配置
    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false,
      timeout: timeout,
      proxy: proxyOptions,
    };


    return { tlsConnectOptions,proxyOptions};
  }

  /**
   * Callback 模式监听测试
   * 特点：异步回调处理结果，鸿蒙传统异步风格
   */
  testTlsServerListenCallback(): void {
    const commonConfig = this.getCommonConfig(8081);
    const tlsConnectOptions = commonConfig.tlsConnectOptions;
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    try {
      tlsServer.listen(tlsConnectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback模式 - 监听失败 [${err.code}]: ${err.message}`);
        } else {
          this.addTestResult(`Callback模式 - 监听成功（端口: 8081）`);
        }
        // 测试完成后关闭服务端，释放端口资源（关键优化）
        tlsServer.close().catch((closeErr: BusinessError) => {
          console.error("Callback模式关闭服务端失败:", closeErr);
          this.addTestResult(`Callback模式 - 关闭服务端失败 [${closeErr.code}]: ${closeErr.message}`);
        });
      });
    }catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }

  }

  // 新增测试方法：listen Callback模式-参数异常
  testListenCallbackOptionsNull(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    try {
      tlsServer.listen(null, (err: BusinessError) => {
        this.addTestResult(`listen Callback-OptionsNull: 错误码”[${err.code}]“，错误信息”${err.message}“`);
      });
    } catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  // 新增测试方法：listen Callback模式-参数异常
  testListenCallbackOptionsUndefined(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    try {
      tlsServer.listen(undefined, (err: BusinessError) => {
        this.addTestResult(`listen Callback-OptionsUndefined: 错误码”[${err.code}]“，错误信息”${err.message}“`);
      });
    } catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  // 新增测试方法：listen Callback模式-参数异常（callback类型错误）
  testListenCallbackInvalidCallback(): void {
    const commonConfig = this.getCommonConfig(8081);
    const tlsConnectOptions = commonConfig.tlsConnectOptions;
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    try {
      tlsServer.listen(tlsConnectOptions, undefined);
    } catch (err) {
      this.addTestResult(`listen Callback-InvalidCallback: 错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  // 新增测试方法：listen Callback模式-参数异常
  testListenCallbackNull(): void {
    const commonConfig = this.getCommonConfig(8081);
    const tlsConnectOptions = commonConfig.tlsConnectOptions;
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    try {
      tlsServer.listen(tlsConnectOptions, null);
    } catch (err) {
      this.addTestResult(`listen Callback-InvalidCallback: 错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  // 新增测试方法：listen Callback模式-参数异常（callback未传入）
  testListenNoCallback(): void {
    const commonConfig = this.getCommonConfig(8081);
    const tlsConnectOptions = commonConfig.tlsConnectOptions;
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    try {
      tlsServer.listen(tlsConnectOptions)
        .then(() => {
          this.addTestResult(`listen NoCallback: 成功`);
        })
        .catch((err: BusinessError) => {
          this.addTestResult(`listen NoCallback: 错误码”[${err.code}]“，错误信息”${err.message}“`);
        });
    } catch (err) {
      this.addTestResult(`listen NoCallback: 错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  /**
   * 场景3：address 为 ""
   */
  testNetAddressAddressEmpty(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const invalidNetAddress: socket.NetAddress = {
      address: "", // address 为 ""
      port: 8088,
      family: 1
    };
    const invalidOptions: socket.TLSConnectOptions = {
      address: invalidNetAddress,
      secureOptions: this.getCommonConfig(8088).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false,
      timeout: undefined,
    };
    try {
      tlsServer.listen(invalidOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`NetAddress-address=""：错误码”[${err.code}]“，错误信息”${err.message}`);
        }
        else{
          this.addTestResult(`listen监听成功`);
        }
      });
    } catch (err) {
      this.addTestResult(`NetAddress-address=""：错误码”[${err.code}]“，错误信息”${err.message}`);
    }
  }

  /**
   * 场景4：address 为 "11111"（无效IP格式）
   */
  testNetAddressAddressInvalid(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const invalidNetAddress: socket.NetAddress = {
      address: "11111",
      port: 8089,
      family: 1
    };
    const invalidOptions: socket.TLSConnectOptions = {
      address: invalidNetAddress,
      secureOptions: this.getCommonConfig(8089).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false,
    };
    try {
      tlsServer.listen(invalidOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`NetAddress-address="11111"：错误码”[${err.code}]“，错误信息”${err.message}`);
        }else{
          this.addTestResult(`listen监听成功`);
        }
      });
    } catch (err) {
      this.addTestResult(`NetAddress-address="11111"：错误码”[${err.code}]“，错误信息”${err.message}`);
    }
  }

  /**
   * 场景5：port 为 undefined
   * （编译报错场景，需通过类型校验触发）
   */
  testNetAddressPortNull(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: "127.0.0.1",
      port: undefined,
      family: 1
    };
    const invalidOptions: socket.TLSConnectOptions = {
      address: invalidNetAddress,
      secureOptions: this.getCommonConfig(8090).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false,
    };
    try {
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen(invalidOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`NetAddress-port=null：错误码”[${err.code}]“，错误信息”${err.message}`);
        }else{
          this.addTestResult(`listen监听成功`);
        }
      });
    } catch (err) {
      this.addTestResult(`NetAddress-port=null：错误码”[${err.code}]“，错误信息”${err.message}`);
    }
  }

  /**
   * 场景7：family 为 undefined
   * （编译报错场景，需通过类型校验触发）
   */
  testNetAddressFamilyNull(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: "127.0.0.1",
      port: 8092,
      family: undefined // family 为 null（编译报错触发点）
    };
    const invalidOptions: socket.TLSConnectOptions = {
      address: invalidNetAddress,
      secureOptions: this.getCommonConfig(8092).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false,
    };
    try {
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen(invalidOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`NetAddress-family=null：错误码”[${err.code}]“，错误信息”${err.message}`);
        }else{
          this.addTestResult(`listen监听成功`);
        }
      });
    } catch (err) {
      this.addTestResult(`NetAddress-family=null：错误码”[${err.code}]“，错误信息”${err.message}`);
    }
  }


  /**
   * Promise 模式 - address 为 ""
   */
  testNetAddressAddressEmptyPromise(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const invalidNetAddress: socket.NetAddress = {
      address: "",
      port: 8102,
      family:1
    };
    const invalidOptions: socket.TLSConnectOptions = {
      address: invalidNetAddress,
      secureOptions: this.getCommonConfig(8102).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false,
    };

    tlsServer.listen(invalidOptions)
      .then(() => {
        this.addTestResult(`listen监听成功`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-NetAddress-address=""：错误码”[${err.code}]“，错误信息”${err.message}“`);
      })
      .finally(() => {
        tlsServer.close().catch(() => {});
      });
  }

  /**
   * Promise 模式 - address 为 "11111"（无效IP格式）
   */
  testNetAddressAddressInvalidPromise(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const invalidNetAddress: socket.NetAddress = {
      address: "11111",
      port: 8103,
      family: 1
    };
    const invalidOptions: socket.TLSConnectOptions = {
      address: invalidNetAddress,
      secureOptions: this.getCommonConfig(8103).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false,
    };

    tlsServer.listen(invalidOptions)
      .then(() => {
        this.addTestResult(`listen监听成功`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-NetAddress-address="11111"：错误码”[${err.code}]“，错误信息”${err.message}`);
      })
      .finally(() => {
        tlsServer.close().catch(() => {});
      });
  }


  /**
   * Promise 模式 - port 为 undefined（系统随机分配端口）
   */
  testNetAddressPortUndefinedPromise(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const invalidNetAddress: socket.NetAddress = {
      address: "127.0.0.1",
      port: undefined,
      family: 1
    };
    const invalidOptions: socket.TLSConnectOptions = {
      address: invalidNetAddress,
      secureOptions: this.getCommonConfig(8105).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false,
    };

    tlsServer.listen(invalidOptions)
      .then(() => {
        this.addTestResult(`listen监听成功`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-NetAddress-port=undefined：错误码”[${err.code}]“，错误信息”${err.message}`);
      })
      .finally(() => {
        tlsServer.close().catch(() => {});
      });
  }


  /**
   * Promise 模式 - family 为 undefined
   */
  testNetAddressFamilyUndefinedPromise(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const invalidNetAddress: socket.NetAddress = {
      address: "127.0.0.1",
      port: 8107,
      family: undefined
    };
    const invalidOptions: socket.TLSConnectOptions = {
      address: invalidNetAddress,
      secureOptions: this.getCommonConfig(8107).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false,
    };

    tlsServer.listen(invalidOptions)
      .then(() => {
        this.addTestResult(`listen监听成功`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-NetAddress-family=undefined：错误码”[${err.code}]“，错误信息”${err.message}`);
      })
      .finally(() => {
        tlsServer.close().catch(() => {});
      });
  }

  // ======================== ca 参数场景 ========================

  /**
   * Callback 模式 - ca 为 undefined
   */
  testTLSSecureOptionsCaUndefinedCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: undefined, // ca 为 undefined
      key: `...`,
      cert: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8111 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-ca=undefined：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-ca=undefined：listen正常运行（ca默认系统预置）`);
      }
      tlsServer.close().catch(() => {});
    });
  }


  /**
   * Promise 模式 - ca 为 undefined
   */
  testTLSSecureOptionsCaUndefinedPromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: undefined, // ca 为 undefined
      key: `...`,
      cert: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8113 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-ca=undefined：listen正常运行（ca默认系统预置）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-ca=undefined：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // ======================== cert 参数场景 ========================

  /**
   * Callback 模式 - cert 为 undefined
   */
  testTLSSecureOptionsCertUndefinedCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: undefined, // cert 为 undefined
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8115 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-cert=undefined：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-cert=undefined：listen正常运行`);
      }
      tlsServer.close().catch(() => {});
    });
  }


  /**
   * Promise 模式 - cert 为 undefined
   */
  testTLSSecureOptionsCertUndefinedPromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: undefined, // cert 为 undefined
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8117 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-cert=undefined：listen正常运行`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-cert=undefined：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // ======================== key 参数场景 ========================

  /**
   * Callback 模式 - key 为 undefined
   */
  testTLSSecureOptionsKeyUndefinedCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: undefined, // key 为 undefined
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8119 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-key=undefined：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-key=undefined：listen正常运行`);
      }
      tlsServer.close().catch(() => {});
    });
  }



  /**
   * Promise 模式 - key 为 undefined
   */
  testTLSSecureOptionsKeyUndefinedPromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: undefined, // key 为 undefined
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8121 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false

    })
      .then(() => {
        this.addTestResult(`Promise-key=undefined：listen正常运行`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-key=undefined：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // ======================== password 参数场景 ========================


  /**
   * Callback 模式 - password 为 undefined
   */
  testTLSSecureOptionsPasswordUndefinedCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: undefined, // password 为 undefined
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8123 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-password=undefined：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-password=undefined：listen正常运行`);
      }
      tlsServer.close().catch(() => {});
    });
  }


  /**
   * Promise 模式 - password 为 undefined
   */
  testTLSSecureOptionsPasswordUndefinedPromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: undefined, // password 为 undefined
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8125 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-password=undefined：listen正常运行`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-password=undefined：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // ======================== protocols 参数场景 ========================
  /**
   * Callback 模式 - protocols 为 TLSv12
   */
  testTLSSecureOptionsProtocolsTLSv12Callback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12, // protocols 为 TLSv12
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8126 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-protocols=TLSv12：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-protocols=TLSv12：listen正常运行`);
      }
      tlsServer.close().catch(() => {});
    });
  }

  /**
   * Callback 模式 - protocols 为 TLSv13
   */
  testTLSSecureOptionsProtocolsTLSv13Callback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv13, // protocols 为 TLSv13
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8127 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-protocols=TLSv13：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-protocols=TLSv13：listen正常运行`);
      }
      tlsServer.close().catch(() => {});
    });
  }


  /**
   * Callback 模式 - protocols 为 undefined
   */
  testTLSSecureOptionsProtocolsUndefinedCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: undefined, // protocols 为 undefined
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8129 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-protocols=undefined：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-protocols=undefined：listen正常运行（默认TLSv12）`);
      }
      tlsServer.close().catch(() => {});
    });
  }

  /**
   * Promise 模式 - protocols 为 TLSv12
   */
  testTLSSecureOptionsProtocolsTLSv12Promise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12, // protocols 为 TLSv12
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8130 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-protocols=TLSv12：listen正常运行`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-protocols=TLSv12：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  /**
   * Promise 模式 - protocols 为 TLSv13
   */
  testTLSSecureOptionsProtocolsTLSv13Promise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv13, // protocols 为 TLSv13
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8131 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-protocols=TLSv13：listen正常运行`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-protocols=TLSv13：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  /**
   * Promise 模式 - protocols 为 undefined
   */
  testTLSSecureOptionsProtocolsUndefinedPromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: undefined, // protocols 为 undefined
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8133 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-protocols=undefined：listen正常运行（默认TLSv12）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-protocols=undefined：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // ======================== useRemoteCipherPrefer 参数场景 ========================
  /**
   * Callback 模式 - useRemoteCipherPrefer 为 true
   */
  testTLSSecureOptionsUseRemoteCipherPreferTrueCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true, // useRemoteCipherPrefer 为 true
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8134 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-useRemoteCipherPrefer=true：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-useRemoteCipherPrefer=true：listen正常运行（优先对方密码套件）`);
      }
      tlsServer.close().catch(() => {});
    });
  }

  /**
   * Callback 模式 - useRemoteCipherPrefer 为 false
   */
  testTLSSecureOptionsUseRemoteCipherPreferFalseCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: false, // useRemoteCipherPrefer 为 false
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8135 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-useRemoteCipherPrefer=false：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-useRemoteCipherPrefer=false：listen正常运行（不优先对方密码套件）`);
      }
      tlsServer.close().catch(() => {});
    });
  }


  /**
   * Callback 模式 - useRemoteCipherPrefer 为 undefined
   */
  testTLSSecureOptionsUseRemoteCipherPreferUndefinedCallback(): void {
    try {
      const invalidSecureOptions: socket.TLSSecureOptions = {
        ca: [`...`],
        cert: `...`,
        key: `...`,
        password: "",
        protocols: socket.Protocol.TLSv12,
        useRemoteCipherPrefer: undefined, // useRemoteCipherPrefer 为 undefined
        signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
        cipherSuite: "AES256-SHA256",
        isBidirectionalAuthentication: false
      };
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen({
        address: { address: '127.0.0.1', port: 8137 },
        secureOptions: invalidSecureOptions,
        ALPNProtocols: ["http/1.1"],
        skipRemoteValidation: false
      }, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback-useRemoteCipherPrefer=undefined：监听失败 [${err.code}]-${err.message}`);
        } else {
          this.addTestResult(`Callback-useRemoteCipherPrefer=undefined：listen正常运行（默认优先对方密码套件）`);
        }
        tlsServer.close().catch(() => {});
      });
    } catch (err) {
      this.addTestResult(`Callback-useRemoteCipherPrefer=undefined：失败 [${err.code}]-${err.message}`);
    }
  }

  /**
   * Promise 模式 - useRemoteCipherPrefer 为 true
   */
  testTLSSecureOptionsUseRemoteCipherPreferTruePromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true, // useRemoteCipherPrefer 为 true
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8138 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-useRemoteCipherPrefer=true：listen正常运行（优先对方密码套件）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-useRemoteCipherPrefer=true：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  /**
   * Promise 模式 - useRemoteCipherPrefer 为 false
   */
  testTLSSecureOptionsUseRemoteCipherPreferFalsePromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: false, // useRemoteCipherPrefer 为 false
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8139 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-useRemoteCipherPrefer=false：listen正常运行（不优先对方密码套件）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-useRemoteCipherPrefer=false：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  /**
   * Promise 模式 - useRemoteCipherPrefer 为 undefined
   */
  testTLSSecureOptionsUseRemoteCipherPreferUndefinedPromise(): void {
    try {
      const invalidSecureOptions: socket.TLSSecureOptions = {
        ca: [`...`],
        cert: `...`,
        key: `...`,
        password: "",
        protocols: socket.Protocol.TLSv12,
        useRemoteCipherPrefer: undefined, // useRemoteCipherPrefer 为 undefined
        signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
        cipherSuite: "AES256-SHA256",
        isBidirectionalAuthentication: false
      };
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen({
        address: { address: '127.0.0.1', port: 8141 },
        secureOptions: invalidSecureOptions,
        ALPNProtocols: ["http/1.1"],
        skipRemoteValidation: false
      })
        .then(() => {
          this.addTestResult(`Promise-useRemoteCipherPrefer=undefined：listen正常运行（默认优先对方密码套件）`);
        })
        .catch((err: BusinessError) => {
          this.addTestResult(`Promise-useRemoteCipherPrefer=undefined：运行失败 [${err.code}]-${err.message}`);
        })
        .finally(() => tlsServer.close().catch(() => {}));
    } catch (err) {
      this.addTestResult(`Promise-useRemoteCipherPrefer=undefined：失败 [${err.code}]-${err.message}`);
    }
  }

  // ======================== signatureAlgorithms 参数场景 ========================

  /**
   * Callback 模式 - signatureAlgorithms 为 undefined
   */
  testTLSSecureOptionsSignatureAlgorithmsUndefinedCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: undefined, // signatureAlgorithms 为 undefined
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8143 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-signatureAlgorithms=undefined：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-signatureAlgorithms=undefined：listen正常运行（默认空）`);
      }
      tlsServer.close().catch(() => {});
    });
  }


  /**
   * Promise 模式 - signatureAlgorithms 为 undefined
   */
  testTLSSecureOptionsSignatureAlgorithmsUndefinedPromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: undefined, // signatureAlgorithms 为 undefined
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8145 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-signatureAlgorithms=undefined：listen正常运行（默认空）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-signatureAlgorithms=undefined：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // ======================== cipherSuite 参数场景 ========================

  /**
   * Callback 模式 - cipherSuite 为 undefined
   */
  testTLSSecureOptionsCipherSuiteUndefinedCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: undefined, // cipherSuite 为 undefined
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8147 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-cipherSuite=undefined：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-cipherSuite=undefined：listen正常运行（默认空）`);
      }
      tlsServer.close().catch(() => {});
    });
  }

  /**
   * Promise 模式 - cipherSuite 为 undefined
   */
  testTLSSecureOptionsCipherSuiteUndefinedPromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: undefined, // cipherSuite 为 undefined
      isBidirectionalAuthentication: false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8149 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-cipherSuite=undefined：listen正常运行（默认空）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-cipherSuite=undefined：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // ======================== isBidirectionalAuthentication 参数场景 ========================
  /**
   * Callback 模式 - isBidirectionalAuthentication 为 true
   */
  testTLSSecureOptionsIsBidirectionalAuthenticationTrueCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: true // isBidirectionalAuthentication 为 true
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8150 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-isBidirectionalAuthentication=true：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-isBidirectionalAuthentication=true：listen正常运行（双向认证）`);
      }
      tlsServer.close().catch(() => {});
    });
  }

  /**
   * Callback 模式 - isBidirectionalAuthentication 为 false
   */
  testTLSSecureOptionsIsBidirectionalAuthenticationFalseCallback(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false // isBidirectionalAuthentication 为 false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8151 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-isBidirectionalAuthentication=false：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-isBidirectionalAuthentication=false：listen正常运行（非双向认证）`);
      }
      tlsServer.close().catch(() => {});
    });
  }


  /**
   * Callback 模式 - isBidirectionalAuthentication 为 undefined
   */
  testTLSSecureOptionsIsBidirectionalAuthenticationUndefinedCallback(): void {
    try {
      const invalidSecureOptions: socket.TLSSecureOptions = {
        ca: [`...`],
        cert: `...`,
        key: `...`,
        password: "",
        protocols: socket.Protocol.TLSv12,
        useRemoteCipherPrefer: true,
        signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
        cipherSuite: "AES256-SHA256",
        isBidirectionalAuthentication: undefined // isBidirectionalAuthentication 为 undefined
      };
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen({
        address: { address: '127.0.0.1', port: 8153 },
        secureOptions: invalidSecureOptions,
        ALPNProtocols: ["http/1.1"],
        skipRemoteValidation: false
      }, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback-isBidirectionalAuthentication=undefined：监听失败 [${err.code}]-${err.message}`);
        } else {
          this.addTestResult(`Callback-isBidirectionalAuthentication=undefined：listen正常运行（默认false）`);
        }
        tlsServer.close().catch(() => {});
      });
    } catch (err) {
      this.addTestResult(`Callback-isBidirectionalAuthentication=undefined：失败 [${err.code}]-${err.message}`);
    }
  }

  /**
   * Promise 模式 - isBidirectionalAuthentication 为 true
   */
  testTLSSecureOptionsIsBidirectionalAuthenticationTruePromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: true // isBidirectionalAuthentication 为 true
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8154 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-isBidirectionalAuthentication=true：listen正常运行（双向认证）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-isBidirectionalAuthentication=true：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  /**
   * Promise 模式 - isBidirectionalAuthentication 为 false
   */
  testTLSSecureOptionsIsBidirectionalAuthenticationFalsePromise(): void {
    const invalidSecureOptions: socket.TLSSecureOptions = {
      ca: [`...`],
      cert: `...`,
      key: `...`,
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: false // isBidirectionalAuthentication 为 false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen({
      address: { address: '127.0.0.1', port: 8155 },
      secureOptions: invalidSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    })
      .then(() => {
        this.addTestResult(`Promise-isBidirectionalAuthentication=false：listen正常运行（非双向认证）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-isBidirectionalAuthentication=false：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  /**
   * Promise 模式 - isBidirectionalAuthentication 为 undefined
   */
  testTLSSecureOptionsIsBidirectionalAuthenticationUndefinedPromise(): void {
    try {
      const invalidSecureOptions: socket.TLSSecureOptions = {
        ca: [`...`], // 实际使用时替换为合法 CA 证书内容
        cert: `...`, // 实际使用时替换为合法服务端证书
        key: `...`, // 实际使用时替换为合法私钥
        password: "",
        protocols: socket.Protocol.TLSv12,
        useRemoteCipherPrefer: true,
        signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
        cipherSuite: "AES256-SHA256",
        isBidirectionalAuthentication: undefined
      };
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen({
        address: { address: '127.0.0.1', port: 8157 },
        secureOptions: invalidSecureOptions,
        ALPNProtocols: ["http/1.1"],
        skipRemoteValidation: false
      })
        .then(() => {
          this.addTestResult(`Promise-isBidirectionalAuthentication=undefined：listen正常运行（默认false）`);
        })
        .catch((err: BusinessError) => {
          this.addTestResult(`Promise-isBidirectionalAuthentication=undefined：运行失败 [${err.code}]-${err.message}`);
        })
        .finally(() => tlsServer.close().catch(() => {}));
    } catch (err) {
      this.addTestResult(`Promise-isBidirectionalAuthentication=undefined：失败 [${err.code}]-${err.message}`);
    }
  }

  // ======================== ALPNProtocols 参数场景 ========================

  /**
   * Callback 模式 - ALPNProtocols 为 undefined（鸿蒙闪烁）
   */
  testTLSConnectOptionsALPNProtocolsUndefinedCallback(): void {
    try {
      const invalidOptions: socket.TLSConnectOptions = {
        address: { address: '127.0.0.1', port: 8201 },
        secureOptions: this.getCommonConfig(8201).tlsConnectOptions.secureOptions,
        ALPNProtocols: undefined, // ALPNProtocols 为 undefined
        skipRemoteValidation: false,
      };
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen(invalidOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback-ALPNProtocols=undefined：监听失败 [${err.code}]-${err.message}`);
        } else {
          this.addTestResult(`Callback-ALPNProtocols=undefined：listen运行`);
        }
        tlsServer.close().catch(() => {});
      });
    } catch (err) {
      this.addTestResult(`Callback-ALPNProtocols=undefined：失败 [${err.code}]-${err.message}`);
    }
  }


  /**
   * Promise 模式 - ALPNProtocols 为 undefined
   */
  testTLSConnectOptionsALPNProtocolsUndefinedPromise(): void {
    try {
      const invalidOptions: socket.TLSConnectOptions = {
        address: { address: '127.0.0.1', port: 8203 },
        secureOptions: this.getCommonConfig(8203).tlsConnectOptions.secureOptions,
        ALPNProtocols: undefined, // ALPNProtocols 为 undefined
        skipRemoteValidation: false,
      };
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen(invalidOptions)
        .then(() => {
          this.addTestResult(`Promise-ALPNProtocols=undefined：listen运行`);
        })
        .catch((err: BusinessError) => {
          this.addTestResult(`Promise-ALPNProtocols=undefined：运行失败 [${err.code}]-${err.message}`);
        })
        .finally(() => tlsServer.close().catch(() => {}));
    } catch (err) {
      this.addTestResult(`Promise-ALPNProtocols=undefined：失败 [${err.code}]-${err.message}`);
    }
  }

  // ======================== skipRemoteValidation 参数场景 ========================

  /**
   * Callback 模式 - skipRemoteValidation 为 true（跳过服务端认证）
   */
  testTLSConnectOptionsSkipRemoteValidationTrueCallback(): void {
    const invalidOptions: socket.TLSConnectOptions = {
      address: { address: '127.0.0.1', port: 8204 },
      secureOptions: this.getCommonConfig(8204).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: true, // skipRemoteValidation 为 true
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(invalidOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-skipRemoteValidation=true：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-skipRemoteValidation=true：listen正常运行（跳过服务端认证）`);
      }
      tlsServer.close().catch(() => {});
    });
  }

  /**
   * Callback 模式 - skipRemoteValidation 为 false（不跳过服务端认证）
   */
  testTLSConnectOptionsSkipRemoteValidationFalseCallback(): void {
    const invalidOptions: socket.TLSConnectOptions = {
      address: { address: '127.0.0.1', port: 8205 },
      secureOptions: this.getCommonConfig(8205).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false, // skipRemoteValidation 为 false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(invalidOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-skipRemoteValidation=false：监听失败 [${err.code}]-${err.message}`);
      } else {
        this.addTestResult(`Callback-skipRemoteValidation=false：listen正常运行（不跳过服务端认证）`);
      }
      tlsServer.close().catch(() => {});
    });
  }


  /**
   * Callback 模式 - skipRemoteValidation 为 undefined（鸿蒙闪烁）
   */
  testTLSConnectOptionsSkipRemoteValidationUndefinedCallback(): void {
    try {
      const invalidOptions: socket.TLSConnectOptions = {
        address: { address: '127.0.0.1', port: 8207 },
        secureOptions: this.getCommonConfig(8207).tlsConnectOptions.secureOptions,
        ALPNProtocols: ["http/1.1"],
        skipRemoteValidation: undefined, // skipRemoteValidation 为 undefined
      };
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen(invalidOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback-skipRemoteValidation=undefined：监听失败 [${err.code}]-${err.message}`);
        } else {
          this.addTestResult(`Callback-skipRemoteValidation=undefined：listen运行`);
        }
        tlsServer.close().catch(() => {});
      });
    } catch (err) {
      this.addTestResult(`Callback-skipRemoteValidation=undefined：失败 [${err.code}]-${err.message}`);
    }
  }

  /**
   * Promise 模式 - skipRemoteValidation 为 true（跳过服务端认证）
   */
  testTLSConnectOptionsSkipRemoteValidationTruePromise(): void {
    const invalidOptions: socket.TLSConnectOptions = {
      address: { address: '127.0.0.1', port: 8208 },
      secureOptions: this.getCommonConfig(8208).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: true, // skipRemoteValidation 为 true
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(invalidOptions)
      .then(() => {
        this.addTestResult(`Promise-skipRemoteValidation=true：listen正常运行（跳过服务端认证）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-skipRemoteValidation=true：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  /**
   * Promise 模式 - skipRemoteValidation 为 false（不跳过服务端认证）
   */
  testTLSConnectOptionsSkipRemoteValidationFalsePromise(): void {
    const invalidOptions: socket.TLSConnectOptions = {
      address: { address: '127.0.0.1', port: 8209 },
      secureOptions: this.getCommonConfig(8209).tlsConnectOptions.secureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false, // skipRemoteValidation 为 false
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(invalidOptions)
      .then(() => {
        this.addTestResult(`Promise-skipRemoteValidation=false：listen正常运行（不跳过服务端认证）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-skipRemoteValidation=false：运行失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }


  /**
   * Promise 模式 - skipRemoteValidation 为 undefined
   */
  testTLSConnectOptionsSkipRemoteValidationUndefinedPromise(): void {
    try {
      const invalidOptions: socket.TLSConnectOptions = {
        address: { address: '127.0.0.1', port: 8211 },
        secureOptions: this.getCommonConfig(8211).tlsConnectOptions.secureOptions,
        ALPNProtocols: ["http/1.1"],
        skipRemoteValidation: undefined, // skipRemoteValidation 为 undefined
      };
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen(invalidOptions)
        .then(() => {
          this.addTestResult(`Promise-skipRemoteValidation=undefined：listen运行（鸿蒙闪烁场景）`);
        })
        .catch((err: BusinessError) => {
          this.addTestResult(`Promise-skipRemoteValidation=undefined：运行失败 [${err.code}]-${err.message}`);
        })
        .finally(() => tlsServer.close().catch(() => {}));
    } catch (err) {
      this.addTestResult(`Promise-skipRemoteValidation=undefined：失败 [${err.code}]-${err.message}`);
    }
  }

  // ======================== proxy类型 参数场景 ========================
  //1.type为SOCKS5
  ProxyTypeSOCKS5():void{
    const commonConfig = this.getCommonConfig(8498, socket.ProxyTypes.SOCKS5);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-SOCKS5: 监听失败 [${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-SOCKS5: 监听成功（代理为SOCKS5）`);
      tlsServer.close().catch(() => {});
    })
  }

  //2.type为NONE
  ProxyTypeNone(): void {
    const commonConfig = this.getCommonConfig(8499, socket.ProxyTypes.NONE);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-NONE: 监听失败 [${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-NONE: 监听成功（代理为NONE,即不使用代理）`);
      tlsServer.close().catch(() => {});
    })
  }

  //3.proxy.address为undefined
  ProxyAddressUndefined(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: undefined, // address为undefined
      username: 'proxyUser',
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8500);
    commonConfig.proxyOptions = invalidProxy; // 关键：将无效proxy注入配置
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-address为undefined 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-address为undefined 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  //4.proxy.address的address为""
  ProxyNetAddressEmpty(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: "", // 空地址
      port: 1080,
    };
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: invalidNetAddress,
      username: 'proxyUser',
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8501);
    commonConfig.proxyOptions = invalidProxy;

    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-address的address为"" 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-address的address为"" 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  //5.proxy.address的address为"11111"
  ProxyNetAddressInvalid(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: "11111", // 无效IP
      port: 1080,
    };
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: invalidNetAddress,
      username: 'proxyUser',
      password: 'proxyPass',
    };

    const commonConfig = this.getCommonConfig(8502);
    commonConfig.proxyOptions = invalidProxy; // 注入无效proxy

    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-address的address为"11111" 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-address的address为"11111" 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  //6.
  ProxyPortUndefined(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: "0.0.0.0",
      port: undefined,
    };
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: invalidNetAddress,
      username: 'proxyUser',
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8503);
    commonConfig.proxyOptions = invalidProxy; // 关键：将无效proxy注入配置

    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-address的port为undefined 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-address的port为undefined 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  //7.
  ProxyFamilyUndefined(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: "0.0.0.0",
      family: undefined,
    };
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: invalidNetAddress,
      username: 'proxyUser',
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8504);
    commonConfig.proxyOptions = invalidProxy;

    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-address的family为undefined 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-address的family为undefined 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  //8.proxy.username为undefined
  ProxyUsernameUndefined(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: undefined, // username为undefined
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8505);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-username为undefined 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-username为undefined 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  //9.proxy.username为""
  ProxyUsernameEmpty(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: "", // username为空字符串
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8506);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-username为"" 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-username为"" 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  //10.proxy.username为"11111"
  ProxyUsernameInvalid(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: "11111", // username为无效格式
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8507);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-username为"11111" 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-username为"11111" 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  //11.proxy.password为undefined
  ProxyPasswordUndefined(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: 'proxyUser',
      password: undefined, // password为undefined
    };
    const commonConfig = this.getCommonConfig(8508);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-username为undefined 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-password为undefined 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  //12.proxy.password为""
  ProxyPasswordEmpty(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: 'proxyUser',
      password: "", // password为空字符串
    };
    const commonConfig = this.getCommonConfig(8509);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-password为"" 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-password为"" 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  //13.proxy.password为"11111"
  ProxyPasswordInvalid(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: 'proxyUser',
      password: "11111", // password为无效格式
    };
    const commonConfig = this.getCommonConfig(8510);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions,(err: BusinessError) => {
      if(err){
        this.addTestResult(`Proxy-password为"11111" 时,监听失败：[${err.code}]-${err.message}`);
        return;
      }
      this.addTestResult(`Proxy-password为"11111" 时,监听成功`);
      tlsServer.close().catch(() => {});
    })
  }

  // 测试1：type为SOCKS5
  testProxyTypeSOCKS5(): void {
    const commonConfig = this.getCommonConfig(8110, socket.ProxyTypes.SOCKS5);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Proxy-SOCKS5: 监听成功（代理为SOCKS5）`))
      .catch((err: BusinessError) => {
        this.addTestResult(`Proxy-SOCKS5: 监听失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // 测试2：type为NONE
  testProxyTypeNone(): void {
    const commonConfig = this.getCommonConfig(8111, socket.ProxyTypes.NONE);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Proxy-NONE: 监听成功（代理为NONE,即不使用代理）`))
      .catch((err: BusinessError) => {
        this.addTestResult(`Proxy-NONE: 监听失败 [${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // 测试3：proxy.address为undefined
  testProxyAddressUndefined(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: undefined, // address为undefined
      username: 'proxyUser',
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8121);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Proxy-address为undefined 时,监听成功`))
      .catch((err: BusinessError) => {
        this.addTestResult(`Proxy-address为undefined 时,监听失败：[${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // 测试4：proxy.address的address为""
  testProxyNetAddressEmpty(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: "", // 空地址
      port: 1080,
    };
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: invalidNetAddress,
      username: 'proxyUser',
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8122);
    commonConfig.proxyOptions = invalidProxy;

    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => {
        this.addTestResult(`Proxy-address的address为"" 时,监听成功`);
      })
      .catch((err: BusinessError) => {
        if (err.code === 401 && err.message.includes("Parameter error")) {
          this.addTestResult(`Proxy-address的address为"": 捕获预期错误码401（Parameter error）`);
        } else {
          this.addTestResult(`Proxy-address的address为"": 捕获非预期错误 [${err.code}]-${err.message}`);
        }
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // 测试5：proxy.address的address为"11111"
  testProxyNetAddressInvalid(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: "11111", // 无效IP
      port: 1080,
    };
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: invalidNetAddress,
      username: 'proxyUser',
      password: 'proxyPass',
    };

    const commonConfig = this.getCommonConfig(8123);
    commonConfig.proxyOptions = invalidProxy; // 注入无效proxy

    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => {
        this.addTestResult(`Proxy-address的address为"11111" 时,监听成功`);
      })
      .catch((err: BusinessError) => {
        if (err.code === 401 && err.message.includes("Parameter error")) {
          this.addTestResult(`Proxy-address的address为"11111": 捕获非预期错误 [${err.code}]-${err.message}`);
        } else {
          this.addTestResult(`Proxy-address的address为"11111": 捕获非预期错误 [${err.code}]-${err.message}`);
        }
        this.addTestResult(`Proxy-address的address为:,${commonConfig.tlsConnectOptions.address}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  //6
  testProxyPortUndefined(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: "0.0.0.0",
      port: undefined,
    };
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: invalidNetAddress,
      username: 'proxyUser',
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8122);
    commonConfig.proxyOptions = invalidProxy; // 关键：将无效proxy注入配置

    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => {
        this.addTestResult(`Proxy-address的port为undefined 时,监听成功`);
      })
      .catch((err: BusinessError) => {
        if (err.code === 401 && err.message.includes("Parameter error")) {
          this.addTestResult(`Proxy-address的port为undefined: 捕获预期错误码401（Parameter error）`);
        } else {
          this.addTestResult(`Proxy-address的port为undefined: 捕获非预期错误 [${err.code}]-${err.message}`);
        }
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  //7
  testProxyFamilyUndefined(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: "0.0.0.0",
      family: undefined,
    };
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: invalidNetAddress,
      username: 'proxyUser',
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8122);
    commonConfig.proxyOptions = invalidProxy;

    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => {
        this.addTestResult(`Proxy-address的family为undefined 时,监听成功`);
      })
      .catch((err: BusinessError) => {
        if (err.code === 401 && err.message.includes("Parameter error")) {
          this.addTestResult(`Proxy-address的family为undefined: 捕获预期错误码401（Parameter error）`);
        } else {
          this.addTestResult(`Proxy-address的family为undefined: 捕获非预期错误 [${err.code}]-${err.message}`);
        }
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // 测试8：proxy.username为undefined
  testProxyUsernameUndefined(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: undefined, // username为undefined
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8124);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Proxy-username为undefined 时,监听成功`))
      .catch((err: BusinessError) => {
        this.addTestResult(`Proxy-username为undefined 时,监听失败：[${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // 测试9：proxy.username为""
  testProxyUsernameEmpty(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: "", // username为空字符串
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8125);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Proxy-username为"" 时,监听成功`))
      .catch((err: BusinessError) => {
        this.addTestResult(`Proxy-username为"" 时,监听失败：[${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // 测试10：proxy.username为"11111"
  testProxyUsernameInvalid(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: "11111", // username为无效格式
      password: 'proxyPass',
    };
    const commonConfig = this.getCommonConfig(8126);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Proxy-username为"11111" 时,监听成功`))
      .catch((err: BusinessError) => {
        this.addTestResult(`Proxy-username为"11111" 时,监听失败：[${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }


  // 测试11：proxy.password为undefined
  testProxyPasswordUndefined(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: 'proxyUser',
      password: undefined, // password为undefined
    };
    const commonConfig = this.getCommonConfig(8127);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Proxy-password为undefined 时,监听成功`))
      .catch((err: BusinessError) => {
        this.addTestResult(`Proxy-username为"11111" 时,监听失败：[${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // 测试12：proxy.password为""
  testProxyPasswordEmpty(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: 'proxyUser',
      password: "", // password为空字符串
    };
    const commonConfig = this.getCommonConfig(8128);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Proxy-password为"" 时,监听成功`))
      .catch((err: BusinessError) => {
        this.addTestResult(`Proxy-password为"" 时,监听失败：[${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // 测试13：proxy.password为"11111"
  testProxyPasswordInvalid(): void {
    const invalidProxy: ProxyOptions = {
      type: socket.ProxyTypes.SOCKS5,
      address: { address: '127.0.0.1', port: 1080 },
      username: 'proxyUser',
      password: "11111", // password为无效格式
    };
    const commonConfig = this.getCommonConfig(8129);
    const tlsServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Proxy-password为"11111" 时,监听成功`))
      .catch((err: BusinessError) => {
        this.addTestResult(`Proxy-password为"11111" 时,监听失败：[${err.code}]-${err.message}`);
      })
      .finally(() => tlsServer.close().catch(() => {}));
  }

  // ======================== timeout参数测试（Callback模式） ========================
  /**
   * Callback模式 - timeout为合法值（0~4294967295内整数）
   */
  testTimeoutValidCallback(): void {
    const port = 8100;
    const timeout = 1000; // 合法值
    const commonConfig = this.getCommonConfig(port, timeout);
    const tlsServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-Timeout合法值: 监听失败, 错误码”[${err.code}]“，错误信息”${err.message}`);
      } else {
        this.addTestResult(`Callback-Timeout合法值: 监听成功`);
      }
      tlsServer.close().catch();
    });
  }

  /**
   * Callback模式 - timeout=-1
   */
  testTimeoutMinus1Callback(): void {
    const port = 8101;
    const timeout = -1; // 非法值
    const commonConfig = this.getCommonConfig(port, timeout);
    const tlsServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-Timeout=-1: 监听失败, 错误码”[${err.code}]“，错误信息”${err.message}`);
      } else {
        this.addTestResult(`Callback-Timeout=-1: 监听成功`);
      }
      tlsServer.close().catch();
    });
  }

  /**
   * Callback模式 - timeout=4294967296（超出上限）
   */
  testTimeoutExceedMaxCallback(): void {
    const port = 8102;
    const timeout = 4294967296; // 超出合法范围
    const commonConfig = this.getCommonConfig(port, timeout);
    const tlsServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-Timeout超上限: 监听失败, 错误码”[${err.code}]“，错误信息”${err.message}`);
      } else {
        this.addTestResult(`Callback-Timeout超上限: 监听成功`);
      }
      tlsServer.close().catch();
    });
  }


  /**
   * Callback模式 - timeout=undefined
   */
  testTimeoutUndefinedCallback(): void {
    const port = 8104;
    const timeout = undefined; // undefined值
    const commonConfig = this.getCommonConfig(port, timeout);
    const tlsServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback-Timeout=undefined: 监听失败, 错误码”[${err.code}]“，错误信息”${err.message}`);
      } else {
        this.addTestResult(`Callback-Timeout=undefined: 监听成功`);
      }
      tlsServer.close().catch();
    });
  }


  // ======================== timeout参数测试（Promise模式） ========================
  /**
   * Promise模式 - timeout为合法值（0~4294967295内整数）
   */
  testTimeoutValidPromise(): void {
    const port = 8200;
    const timeout = 1000;
    const commonConfig = this.getCommonConfig(port, timeout);
    const tlsServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Promise-Timeout合法值: 监听成功`))
      .catch((err: BusinessError) => this.addTestResult(`Promise-Timeout合法值: 监听失败, 错误码”[${err.code}]“，错误信息”${err.message}`))
      .finally(() => tlsServer.close().catch());
  }

  /**
   * Promise模式 - timeout=-1
   */
  testTimeoutMinus1Promise(): void {
    const port = 8201;
    const timeout = -1;
    const commonConfig = this.getCommonConfig(port, timeout);
    const tlsServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Promise-Timeout=-1: 监听成功`))
      .catch((err: BusinessError) => this.addTestResult(`Promise-Timeout=-1: 监听失败, 错误码”[${err.code}]“，错误信息”${err.message}`))
      .finally(() => tlsServer.close().catch());
  }

  /**
   * Promise模式 - timeout=4294967296（超出上限）
   */
  testTimeoutExceedMaxPromise(): void {
    const port = 8202;
    const timeout = 4294967296;
    const commonConfig = this.getCommonConfig(port, timeout);
    const tlsServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Promise-Timeout超上限: 监听成功`))
      .catch((err: BusinessError) => this.addTestResult(`Promise-Timeout超上限: 错误码”[${err.code}]“，错误信息”${err.message}`))
      .finally(() => tlsServer.close().catch());
  }


  /**
   * Promise模式 - timeout=undefined
   */
  testTimeoutUndefinedPromise(): void {
    const port = 8204;
    const timeout = undefined;
    const commonConfig = this.getCommonConfig(port, timeout);
    const tlsServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => this.addTestResult(`Promise-Timeout=undefined: 监听成功`))
      .catch((err: BusinessError) => this.addTestResult(`Promise-Timeout=undefined: 监听失败, 错误码”[${err.code}]“，错误信息”${err.message}`))
      .finally(() => tlsServer.close().catch());
  }

  // ======================== 补充：Callback 方式接口错误码场景 ========================
  /**
   * Callback 方式 - 权限校验失败（错误码201，信息“Permission denied.”）
   */
  testListenCallbackPermissionDenied(): void {
    const commonConfig = this.getCommonConfig(81);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    try {
      tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        }
        tlsServer.close().catch(() => {
        });
      });
    }catch (err) {
      this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
    }

  }

  /**
   * Callback 方式 - 系统内部错误（安卓：2303113，iOS：模拟2303113）+ close触发2300002
   */
  testListenCallbackSysInterErr(): void {
    const commonConfig = this.getCommonConfig(1);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions, (errListen: BusinessError) => {
      if (errListen) {
        // 预期：iOS/安卓都返回2303113
        this.addTestResult(`listen错误码”[${errListen.code}]“，错误信息”${errListen.message}“`);

        // 此时未监听，调用close应触发2300002
        tlsServer.close().then(() => {
          this.addTestResult('close成功（非预期，应失败）');
        }).catch((err: BusinessError) => {
          if (err.code === 2300002) {
            this.addTestResult(`成功触发2300002错误：${err.message}`);
          } else {
            this.addTestResult(`收到错误但非2300002：${err.code} - ${err.message}`);
          }
        });
      } else {
        // 若listen成功（未模拟错误），手动标记后再close
        this.addTestResult(`监听成功（非预期，系统内部错误未触发）`);
        // 手动置为“未监听”状态（仅测试用）
        // tlsServer.setListeningState(false); // 需新增桥接方法
        tlsServer.close().then(() => {
          this.addTestResult('未监听时close()成功（预期应该失败）');
        }).catch((err: BusinessError) => {
          if (err.code === 2300002) {
            this.addTestResult(`成功触发2300002错误：${err.message}`);
          } else {
            this.addTestResult(`收到错误但非2300002：${err.code} - ${err.message}`);
          }
        });
      }
    });
  }

  //promise系统内部错误
  testListenPromiseSysInterErr(): void {
    const commonConfig = this.getCommonConfig(81);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions, (errListen: BusinessError) => {
      if (errListen) {
        // 预期：iOS/安卓都返回2303113
        this.addTestResult(`listen错误码”[${errListen.code}]“，错误信息”${errListen.message}“`);

        // 此时未监听，调用close应触发2300002
        tlsServer.close().then(() => {
          this.addTestResult('close成功（非预期，应失败）');
        }).catch((err: BusinessError) => {
          if (err.code === 2300002) {
            this.addTestResult(`成功触发2300002错误：${err.message}`);
          } else {
            this.addTestResult(`收到错误但非2300002：${err.code} - ${err.message}`);
          }
        });
      } else {
        // 若listen成功（未模拟错误），手动标记后再close
        this.addTestResult(`监听成功（非预期，系统内部错误未触发）`);
        // 手动置为“未监听”状态（仅测试用）
        // tlsServer.setListeningState(false); // 需新增桥接方法
        tlsServer.close().then(() => {
          this.addTestResult('未监听时close()成功（预期应该失败）');
        }).catch((err: BusinessError) => {
          if (err.code === 2300002) {
            this.addTestResult(`成功触发2300002错误：${err.message}`);
          } else {
            this.addTestResult(`收到错误但非2300002：${err.code} - ${err.message}`);
          }
        });
      }
    });
  }


  /**
   * Callback 方式 - 文件编号无效（错误码2303109，信息“Bad file number.”）
   */
  testListenCallbackBadFileNumber(): void {
    const commonConfig = this.getCommonConfig(8094);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(commonConfig.tlsConnectOptions, (firstErr: BusinessError) => {
      if (firstErr) {
        this.addTestResult(`Callback-文件编号无效场景：首次监听失败 [${firstErr.code}]-${firstErr.message}`);
        tlsServer.close().catch(() => {
        });
        return;
      }

      tlsServer.close()
        .then(() => {
          tlsServer.close()
            .catch((closeErr2: BusinessError) => {
              if (closeErr2) {
                this.addTestResult(`错误码”[${closeErr2.code}]“，错误信息”${closeErr2.message}“`);
              }
            });
        })
        .catch((closeErr1: BusinessError) => {
          this.addTestResult(`callback-文件编号无效场景：第一次关闭失败 [${closeErr1.code}]-${closeErr1.message}`);
        });
    });
  }

  /**
   * Callback 方式 - 资源暂时不可用（错误码2303111，信息“Resource temporarily unavailable. Try again”）
   */
  testListenCallbackResourceTemporarilyUnavailable(): void {
    let port = 8095;
    const maxRetry = 5;
    let retryCount = 0;

    const createAndListen = () => {
      const commonConfig = this.getCommonConfig(port++);
      const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      tlsServer.listen(commonConfig.tlsConnectOptions, (err: BusinessError) => {
        if (err) {
          if (err.code === 2303111 && err.message === "Resource temporarily unavailable. Try again") {
            this.addTestResult(`Callback-资源暂时不可用场景：捕获预期错误 [${err.code}]-${err.message}`);
            return;
          }
          if (retryCount < maxRetry) {
            retryCount++;
            createAndListen();
          } else {
            this.addTestResult(`Callback-资源暂时不可用场景：未捕获到预期错误`);
          }
        }
        tlsServer.close().catch(() => {
        });
      });
    };

    createAndListen();
  }

  /**
   * Callback 方式 - 地址已使用（错误码2303198，信息“Address already in use.”）
   */
  testListenCallbackAddressAlreadyInUse(): void {
    const commonConfig = this.getCommonConfig(8096);
    const tlsServer1: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const tlsServer2: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    // 第一个服务端先占用端口
    tlsServer1.listen(commonConfig.tlsConnectOptions, (firstErr: BusinessError) => {
      if (firstErr) {
        this.addTestResult(`Callback-地址已使用场景：第一个服务端监听失败 [${firstErr.code}]-${firstErr.message}`);
        return;
      }
      // 第二个服务端同一端口监听（触发地址已使用）
      tlsServer2.listen(commonConfig.tlsConnectOptions, (secondErr: BusinessError) => {
        if (secondErr) {
          if (secondErr.code === 2303198 && secondErr.message === "Address already in use.") {
            this.addTestResult(`Callback-地址已使用场景：捕获预期错误 [${secondErr.code}]-${secondErr.message}`);
          } else {
            this.addTestResult(`Callback-地址已使用场景：捕获非预期错误 [${secondErr.code}]-${secondErr.message}`);
          }
        }
        tlsServer2.close().catch(() => {
        });
      });
    });

    // 最终释放资源
    setTimeout(() => {
      tlsServer1.close().catch(() => {
      });
    }, 1000);
  }

  /**
   * Callback 方式 - 无法分配请求的地址（错误码2303199，信息“Cannot assign requested address.”）
   */
  testListenCallbackCannotAssignRequestedAddress(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: '192.168.255.255',
      port: 8097
    };
    const baseConfig = this.getCommonConfig(8097).tlsConnectOptions;
    const invalidOptions: socket.TLSConnectOptions = {
      address: invalidNetAddress,
      secureOptions: baseConfig.secureOptions,
      ALPNProtocols: baseConfig.ALPNProtocols,
      skipRemoteValidation: baseConfig.skipRemoteValidation
    };

    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(invalidOptions, (err: BusinessError) => {
      if (err) {
        if (err.code === 2303199) {
          this.addTestResult(`Callback-无法分配地址场景：捕获预期错误 [${err.code}]`);
        } else {
          this.addTestResult(`Callback-无法分配地址场景：捕获非预期错误 [${err.code}]`);
        }
      }
      tlsServer.close().catch(() => {
      });
    });
  }


  /**
   * Callback 方式 - SSL为空（错误码2303501，信息“SSL is null”）
   */
  testListenCallbackSSLNull(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12456
    };

    const tlsSecureOptions: socket.TLSSecureOptions = {
      // key: this.serverKey.trim(),
      // cert: this.serverCert.trim(),
      // ca: [this.Ca.trim()],
      // password: "",
      // protocols: socket.Protocol.TLSv12,
      // useRemoteCipherPrefer: true,
      // signatureAlgorithms: "rsa_pkcs1_sha256",
      // cipherSuite: "AES256-SHA256",
      // isBidirectionalAuthentication: true,
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

      this.addTestResult(`监听成功`);

      // 监听客户端连接
      tlsServer!.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');
      });

      tlsServer!.on('error', (err: BusinessError) => {
        this.addTestResult(`服务器错误: ` + JSON.stringify(err));
        console.error('TLSSocketServer error:', JSON.stringify(err));
      });

    });

    setTimeout(() => {this.startClient() }, 2000);
  }
  private startClient() : void {
    let tlsClient: socket.TLSSocket = socket.constructTLSSocketInstance();

    tlsClient.bind({ address: '127.0.0.7', port: 0 }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`客户端: 绑定失败: ${err.message}`);
        return;
      }

      this.addTestResult('客户端: 绑定成功');

      const connectAddr: socket.NetAddress = {
        address: '127.0.0.1',
        port: 12456
      };

      const secureOptions: socket.TLSSecureOptions = {
        // key: this.clientKey.trim(),
        // cert: this.clientCert.trim(),
        // ca: [this.Ca.trim()],
        // protocols: socket.Protocol.TLSv12,
        // useRemoteCipherPrefer: true,
        // signatureAlgorithms: "rsa_pkcs1_sha256",
        // cipherSuite: "AES256-SHA256",
        // isBidirectionalAuthentication: true
      };

      const connectOptions: socket.TLSConnectOptions = {
        address: connectAddr,
        secureOptions: secureOptions,
        ALPNProtocols: []
      };


      tlsClient.on('close', () => {
        this.addTestResult('客户端连接关闭');
      });

      tlsClient.on('error', (err: BusinessError) => {
        this.addTestResult(`客户端错误: ${err.code} - ${err.message}`);
      });


      tlsClient!.connect(connectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`客户端: 连接失败: ${err.message}`);
          return;
        }
        this.addTestResult('客户端: 连接服务器成功');
      });
    });
  }

  /**
   * Callback 方式 - TLS读取错误（错误码2303502，信息“TLS socket read error”）
   */
  testListenCallbackTlsReadError(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12456
    };

    // 使用有效的证书配置，确保连接能够建立
    const tlsSecureOptions: socket.TLSSecureOptions = {
      key: this.serverKey.trim(),
      cert: this.serverCert.trim(),
      ca: [this.Ca.trim()],
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: false,
      isBidirectionalAuthentication: false
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

      this.addTestResult(`监听成功，等待客户端连接`);

      // 监听客户端连接
      tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');

        // 设置消息处理器
        client.on('message', (data: socket.SocketMessageInfo) => {
          // 修复第2752行：正确处理message类型
          try {
            if (typeof data.message === 'string') {
              this.addTestResult(`服务器收到字符串消息: ${data.message}`);
            } else if (data.message instanceof ArrayBuffer) {
              // 如果是ArrayBuffer，转换为字符串显示
              // const decoder = new TextDecoder();
              // const messageStr = decoder.decode(data.message);
              // this.addTestResult(`服务器收到ArrayBuffer消息: ${messageStr}`);
            } else {
              this.addTestResult(`服务器收到未知类型消息: ${typeof data.message}`);
            }



          } catch (error) {
            this.addTestResult(`消息处理异常: ${error}`);
          }
        });

        // **方法1：在服务器端尝试触发读取错误**
        setTimeout(() => {
          this.addTestResult('尝试在服务器端触发读取错误...');
        }, 1000);
      });

      tlsServer.on('error', (err: BusinessError) => {
        if (err.code === 2303502) {
          this.addTestResult(`服务器触发TLS读取错误(2303502): ${err.message}`);
        }
        this.addTestResult(`服务器错误: ${JSON.stringify(err)}`);
      });

      // 启动触发读取错误的客户端
      setTimeout(() => {
        this.startClientForTriggerReadError();
      }, 2000);
    });
  }

  // 专门触发读取错误的客户端
  private startClientForTriggerReadError(): void {
    let tlsClient: socket.TLSSocket = socket.constructTLSSocketInstance();

    tlsClient.bind({ address: '127.0.0.1', port: 0 }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`客户端绑定失败: ${err.message}`);
        return;
      }

      const tlsSecureOptions: socket.TLSSecureOptions = {
        key: this.clientKey.trim(),
        cert: this.clientCert.trim(),
        ca: [this.Ca.trim()],
        protocols: socket.Protocol.TLSv12,
        useRemoteCipherPrefer: false,
        isBidirectionalAuthentication: false
      };

      const connectOptions: socket.TLSConnectOptions = {
        address: { address: '127.0.0.1', port: 12456 },
        secureOptions: tlsSecureOptions,
        ALPNProtocols: []
      };

      tlsClient.connect(connectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`客户端连接失败: ${err.message}`);
          return;
        }

        this.addTestResult('客户端连接成功，开始触发读取错误');

        // **关键触发方法**
        setTimeout(() => {

          // **方法1：发送大量数据导致读取缓冲区溢出**
          this.addTestResult('方法1：发送大量数据...');
          const largeData = 'X'.repeat(1024 * 1024); // 1MB数据
          for (let i = 0; i < 20; i++) {
            tlsClient.send(`${largeData}_chunk_${i}`, (sendErr: BusinessError) => {
              if (sendErr && sendErr.code === 2303502) {
                this.addTestResult(`大数据发送触发读取错误: ${sendErr.message}`);
              }
            });
          }

          // **方法2：发送ArrayBuffer数据**
          setTimeout(() => {
            this.addTestResult('方法2：发送ArrayBuffer数据...');

            // 创建ArrayBuffer
            const arrayBuffer = new ArrayBuffer(1024);
            const view = new Uint8Array(arrayBuffer);
            // 填充一些数据
            for (let i = 0; i < view.length; i++) {
              view[i] = i % 256;
            }

            tlsClient.send(arrayBuffer, (err: BusinessError) => {
              if (err && err.code === 2303502) {
                this.addTestResult(`ArrayBuffer数据触发读取错误: ${err.message}`);
              }
            });

            // 发送包含特殊字节的数据
            const specialBuffer = new ArrayBuffer(10);
            const specialView = new Uint8Array(specialBuffer);
            specialView.set([0x00, 0xFF, 0x80, 0x7F, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05]);

            tlsClient.send(specialBuffer, (err: BusinessError) => {
              if (err && err.code === 2303502) {
                this.addTestResult(`特殊字节数据触发读取错误: ${err.message}`);
              }
            });
          }, 500);

          // **方法3：快速连续发送数据导致读取竞争**
          setTimeout(() => {
            this.addTestResult('方法3：快速连续发送...');
            let rapidCount = 0;
            const rapidSend = () => {
              if (rapidCount++ < 50) {
                tlsClient.send(`rapid_${rapidCount}`, (err: BusinessError) => {
                  if (err && err.code === 2303502) {
                    this.addTestResult(`快速发送${rapidCount}触发读取错误: ${err.message}`);
                    return;
                  }
                  // 非常短的延迟，制造竞争条件
                  if (rapidCount < 50) {
                    setTimeout(rapidSend, 1);
                  }
                });
              }
            };
            rapidSend();
          }, 1000);

          // **方法4：发送超大ArrayBuffer**
          setTimeout(() => {
            this.addTestResult('方法4：发送超大ArrayBuffer...');

            try {
              // 创建非常大的ArrayBuffer（5MB）
              const hugeBuffer = new ArrayBuffer(5 * 1024 * 1024);
              const hugeView = new Uint8Array(hugeBuffer);
              // 填充一些数据
              for (let i = 0; i < hugeView.length; i++) {
                hugeView[i] = i % 256;
              }

              tlsClient.send(hugeBuffer, (err: BusinessError) => {
                if (err && err.code === 2303502) {
                  this.addTestResult(`超大ArrayBuffer触发读取错误: ${err.message}`);
                }
              });
            } catch (error) {
              this.addTestResult(`创建超大缓冲区失败: ${error}`);
            }
          }, 1500);

        }, 1000);
      });

      // 监听客户端的读取错误
      tlsClient.on('error', (err: BusinessError) => {
        if (err.code === 2303502) {
          this.addTestResult(`客户端触发读取错误(2303502): ${err.message}`);
        }
      });
    });
  }

  /**
   * Callback 方式 - TLS写入错误（错误码2303503，信息“TLS socket write error”）
   */
  testListenCallbackTlsWriteError(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    let clientConnections: socket.TLSSocketConnection[] = [];

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12457  // 不同端口避免冲突
    };

    const tlsSecureOptions: socket.TLSSecureOptions = {
      // 可能缺少必要的安全配置
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

      this.addTestResult(`监听成功，开始测试写入错误`);

      tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');
        clientConnections.push(client);

        // client.on('error', (err: BusinessError) => {
        //   if (err.code === 2303503) {
        //     this.addTestResult(`成功触发TLS写入错误(2303503): ${err.message}`);
        //   }
        // });

        // 尝试触发写入错误
        setTimeout(() => {
          this.addTestResult('尝试触发写入错误...');

          // 方法1：尝试写入大量数据，可能导致缓冲区溢出
          const largeData = 'A'.repeat(1024 * 1024 * 10); // 10MB
          for (let i = 0; i < 10; i++) {
            client.send(`${largeData}_${i}`, (err: BusinessError) => {
              if (err && err.code === 2303503) {
                this.addTestResult(`大数据写入触发错误: ${err.message}`);
              }
            });
          }

          // 方法2：在连接关闭后尝试写入
          setTimeout(() => {
            client.close(() => {
              // 连接关闭后尝试写入
              client.send("test after close", (err: BusinessError) => {
                if (err && err.code === 2303503) {
                  this.addTestResult(`关闭后写入触发错误: ${err.message}`);
                }
              });
            });
          }, 500);
        }, 1000);
      });

      tlsServer.on('error', (err: BusinessError) => {
        if (err.code === 2303503) {
          this.addTestResult(`服务器触发TLS写入错误(2303503): ${err.message}`);
        }
        this.addTestResult(`服务器错误: ` + JSON.stringify(err));
      });

      // 启动测试客户端
      setTimeout(() => {
        this.startWriteTestClient(12457);
      }, 2000);
    });
  }

  private startWriteTestClient(port: number): void {
    let tlsClient: socket.TLSSocket = socket.constructTLSSocketInstance();

    tlsClient.bind({ address: '127.0.0.1', port: 0 }, (err: BusinessError) => {
      if (err) {
        return;
      }

      const connectOptions: socket.TLSConnectOptions = {
        address: { address: '127.0.0.1', port: port },
        secureOptions: {},
        ALPNProtocols: []
      };

      tlsClient.connect(connectOptions, () => {
        // 连接成功但不发送数据，让服务器尝试写入
      });
    });
  }

  /**
   * Callback 方式 - TLS系统调用错误（错误码2303505，信息“TLS system call error”）
   */
  testListenCallbackTlsSystemCallError(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12458 // 服务器监听端口
    };

    // 修复：确保类型为正确的TLSSecureOptions，无类型不匹配问题
    const tlsSecureOptions: socket.TLSSecureOptions = {
      key: this.clientKey.trim(),
      cert: this.clientCert.trim(),
      ca: [this.Ca.trim()],
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: false,
      isBidirectionalAuthentication: false
    };

    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ['a'.repeat(1024), '\0invalid-protocol\x00', '非法字符协议']
    };

    // 监听服务器的error事件（全局错误）
    tlsServer.on('error', (err: BusinessError) => {
      if (err.code === 2303505) {
        this.addTestResult(`服务器触发系统调用错误(2303505): ${err.message}`);
      }
      this.addTestResult(`服务器错误: ` + JSON.stringify(err));
    });

    tlsServer.listen(tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${JSON.stringify(err)}`);
        if (err.code === 2303505) {
          this.addTestResult(`监听时触发系统调用错误(2303505): ${err.message}`);
        }
        return;
      }

      this.addTestResult(`监听成功，开始测试系统调用错误`);

      tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');

        // 监听客户端连接的error事件
        // client.on('error', (err: BusinessError) => {
        //   if (err.code === 2303505) {
        //     this.addTestResult(`连接触发系统调用错误(2303505): ${err.message}`);
        //   }
        // });

        // 监听客户端关闭事件，在关闭后尝试写入数据触发系统调用错误
        client.on('close', () => {
          this.addTestResult('服务端：客户端连接已关闭');
          // 连接关闭后，尝试发送数据触发系统调用错误（核心触发方式）
          try {
            // 1. 发送超大尺寸的缓冲区，触发系统调用的参数错误
            const bigBuffer = new Uint8Array(1024 * 1024 * 100); // 100MB的超大缓冲区
            client.send(bigBuffer, (err: BusinessError) => {
              if (err && err.code === 2303505) {
                this.addTestResult(`超大缓冲区触发系统调用错误(2303505): ${err.message}`);
              }
            });
          } catch (error) {
            this.addTestResult(`捕获异常: ${JSON.stringify(error)}`);
          }
        });

        // 尝试触发系统调用错误：发送异常格式的数据
        setTimeout(() => {
          this.addTestResult('尝试触发系统调用错误...');
          try {
            // 2. 发送异常二进制数据（通过ArrayBuffer转换，适配send方法）
            const abnormalData = new Uint8Array([0xFF, 0xFE, 0xFD, 0xFC, 0xFB]).buffer; // 转为ArrayBuffer
            client.send(abnormalData, (err: BusinessError) => {
              if (err && err.code === 2303505) {
                this.addTestResult(`异常数据触发系统调用错误(2303505): ${err.message}`);
              }
            });
          } catch (error) {
            this.addTestResult(`捕获异常: ${JSON.stringify(error)}`);
          }
        }, 1000);
      });

      // 启动测试客户端（延迟缩短，确保连接及时建立）
      setTimeout(() => {
        this.startSystemCallTestClient(12458);
      }, 1000);
    });
  }

  private startSystemCallTestClient(port: number): void {
    let tlsClient: socket.TLSSocket = socket.constructTLSSocketInstance();

    tlsClient.bind({ address: '127.0.0.1', port: 0 }, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`客户端绑定失败: ${JSON.stringify(err)}`);
        return;
      }

      const tlsSecureOptions: socket.TLSSecureOptions = {
        key: this.clientKey.trim(),
        cert: this.clientCert.trim(),
        ca: [this.Ca.trim()],
        protocols: socket.Protocol.TLSv12,
        useRemoteCipherPrefer: false,
        isBidirectionalAuthentication: false
      };

      const tlsConnectOptions: socket.TLSConnectOptions = {
        // 连接到服务器的地址和端口（127.0.0.1:12458）
        address: { address: '127.0.0.1', port: port },
        secureOptions: tlsSecureOptions,
        // 客户端也传入违反ALPN规范的字符串数组，触发TLS握手错误
        ALPNProtocols: ['\x00\x01\x02invalid', '超长字符串协议名'.repeat(50), 'null\0protocol']
      };

      this.addTestResult(`客户端尝试连接服务器: 127.0.0.1:${port}`);
      tlsClient.connect(tlsConnectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`客户端连接失败: ${JSON.stringify(err)}`);
          if (err.code === 2303505) {
            this.addTestResult(`客户端连接触发系统调用错误(2303505): ${err.message}`);
          }
          return;
        }

        this.addTestResult('客户端连接成功，立即关闭连接');
        // 客户端连接成功后，立即关闭连接，让服务器端写入时触发错误
        tlsClient.close(() => {
          this.addTestResult('客户端连接已关闭');
        });

        // 客户端尝试发送超大数据，触发自身的系统调用错误
        setTimeout(() => {
          try {
            const bigData = new Uint8Array(1024 * 1024 * 100).buffer; // 转为ArrayBuffer
            tlsClient.send(bigData, (err: BusinessError) => {
              if (err && err.code === 2303505) {
                this.addTestResult(`客户端发送超大数据触发系统调用错误(2303505): ${err.message}`);
              }
            });
          } catch (error) {
            this.addTestResult(`客户端发送数据异常: ${JSON.stringify(error)}`);
          }
        }, 500);
      });

      // 监听客户端的error事件，捕获系统调用错误
      tlsClient.on('error', (err: BusinessError) => {
        if (err.code === 2303505) {
          this.addTestResult(`客户端全局错误触发系统调用错误(2303505): ${err.message}`);
        }
      });
    });
  }

  /**
   * Callback 方式 - TLS关闭错误（错误码2303506，信息“TLS close error”）
   */

  testListenCallbackTlsCloseError(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12345
    };

    const tlsSecureOptions: socket.TLSSecureOptions = {
      key: this.serverKey.trim(),
      cert: this.serverCert.trim(),
      ca: [this.Ca.trim()],
      password: "",
      protocols: [socket.Protocol.TLSv12],
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pkcs1_sha256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication: true
    };

    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"]
    };

    // 监听服务器的error事件（仅保留2303506错误处理）
    tlsServer.on('error', (err: BusinessError) => {
      if (err.code === 2303506) {
        this.addTestResult(`服务器触发关闭TLS连接失败错误(2303506): ${err.message}`);
      }
      this.addTestResult(`服务器错误: ` + JSON.stringify(err));
    });

    tlsServer.listen(tlsConnectOptions, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${JSON.stringify(err)}`);
        return;
      }
      this.addTestResult(`监听成功，开始测试关闭TLS连接失败错误`);

      tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：检测到客户端连接，准备触发2303506错误');

        // 监听客户端连接错误
        // client.on('error', (err: BusinessError) => {
        //   this.addTestResult(`客户端连接错误: ${JSON.stringify(err)}`);
        //   if (err.code === 2303506) {
        //     this.addTestResult(`客户端连接错误事件中捕获2303506: ${err.message}`);
        //   }
        // });

        // 监听客户端关闭事件
        client.on('close', () => {
          this.addTestResult('客户端连接已关闭');
        });

        // 核心修改：创建会导致2303506错误的场景
        // 方法1：在握手完成前尝试强制关闭连接
        setTimeout(() => {
          // 尝试在异常状态下关闭连接 - 使用try-catch包装
          try {
            // 注意：根据API文档，close()方法可能不接受回调参数
            client.close();
            this.addTestResult('客户端连接关闭调用完成');
          } catch (closeError) {
            const err = closeError as BusinessError;
            if (err.code === 2303506) {
              this.addTestResult(`客户端连接关闭时触发2303506错误: ${err.message}`);
            } else {
              this.addTestResult(`客户端关闭错误: ${JSON.stringify(err)}`);
            }
          }

          // 如果正常关闭，我们手动触发2303506测试
          this.triggerTlsCloseErrorOnServer(tlsServer);
        }, 100); // 非常短的延迟，模拟在握手过程中关闭

        // 同时尝试发送数据，可能触发底层错误
        setTimeout(() => {
          client.send("test data", (sendErr: BusinessError) => {
            if (sendErr && sendErr.code === 2303506) {
              this.addTestResult(`发送数据时触发2303506错误: ${sendErr.message}`);
            }
          });
        }, 50);
      });

      // 启动测试客户端
      setTimeout(() => {
        this.startTLSClient();

        // 在客户端连接后不久，尝试破坏性操作触发2303506
        setTimeout(() => {
          // 方法2：强制销毁服务器资源
          try {
            // 模拟异常情况下的服务器关闭
            try {
              tlsServer.close();
              this.addTestResult('服务器关闭调用完成');
            } catch (closeError) {
              const err = closeError as BusinessError;
              if (err.code === 2303506) {
                this.addTestResult(`服务器关闭时触发2303506错误: ${err.message}`);
              }
            }

            // 同时创建第二个服务器实例占用相同端口，制造冲突
            setTimeout(() => {
              // 修复：确保port是number类型
              const conflictPort: number = 12345; // 直接使用明确的端口号
              this.createConflictServer(conflictPort);
            }, 200);
          } catch (error) {
            const err = error as Error;
            this.addTestResult(`服务器操作异常: ${err.message}`);
          }
        }, 500);
      }, 1000);
    });
  }

  // 创建冲突服务器占用相同端口
  private createConflictServer(port: number): void {
    try {
      const conflictServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

      const conflictNetAddress: socket.NetAddress = {
        address: '0.0.0.0',
        port: port
      };

      const conflictSecureOptions: socket.TLSSecureOptions = {
        key: this.serverKey.trim(),
        cert: this.serverCert.trim(),
        ca: [this.Ca.trim()],
        password: "",
        protocols: [socket.Protocol.TLSv12],
        useRemoteCipherPrefer: true,
        signatureAlgorithms: "rsa_pkcs1_sha256",
        cipherSuite: "AES256-SHA256",
        isBidirectionalAuthentication: true
      };

      const conflictConnectOptions: socket.TLSConnectOptions = {
        address: conflictNetAddress,
        secureOptions: conflictSecureOptions,
        ALPNProtocols: ["http/1.1"]
      };

      // 监听可能触发的错误
      conflictServer.on('error', (err: BusinessError) => {
        if (err.code === 2303506) {
          this.addTestResult(`冲突服务器触发2303506错误: ${err.message}`);
        }
      });

      conflictServer.listen(conflictConnectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`冲突服务器监听失败: ${JSON.stringify(err)}`);
        }
      });
    } catch (error) {
      const err = error as Error;
      this.addTestResult(`创建冲突服务器异常: ${err.message}`);
    }
  }

  // 专门触发服务器级别2303506错误的方法
  private triggerTlsCloseErrorOnServer(tlsServer: socket.TLSSocketServer): void {
    // 方法3：尝试在服务器实例上执行非法操作
    try {
      // 模拟重复关闭或无效操作
      setTimeout(() => {
        try {
          // 尝试再次关闭已经关闭的服务器
          tlsServer.close();
          this.addTestResult('重复关闭服务器调用完成');
        } catch (closeError) {
          const err = closeError as BusinessError;
          if (err.code === 2303506) {
            this.addTestResult(`重复关闭服务器触发2303506: ${err.message}`);
          } else {
            this.addTestResult(`重复关闭操作异常: ${JSON.stringify(err)}`);
          }
        }
      }, 100);
    } catch (error) {
      const err = error as Error;
      this.addTestResult(`触发服务器错误异常: ${err.message}`);
    }
  }

  private startTLSClient(): void {
    // 修改客户端以更容易触发服务器端错误
    let tlsClient: socket.TLSSocket = socket.constructTLSSocketInstance();

    const bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 0
    };

    tlsClient.bind(bindAddr, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`客户端: 绑定失败: ${err.message}`);
        return;
      }
      this.addTestResult('客户端: 绑定成功');

      const connectAddr: socket.NetAddress = {
        address: '127.0.0.1',
        port: 12345
      };

      const secureOptions: socket.TLSSecureOptions = {
        key: this.clientKey.trim(),
        cert: this.clientCert.trim(),
        ca: [this.Ca.trim()],
        protocols: [socket.Protocol.TLSv12],
        useRemoteCipherPrefer: true,
        signatureAlgorithms: "rsa_pkcs1_sha256",
        cipherSuite: "AES256-SHA256",
        isBidirectionalAuthentication: true
      };

      const connectOptions: socket.TLSConnectOptions = {
        address: connectAddr,
        secureOptions: secureOptions,
        ALPNProtocols: ["http/1.1"]
      };

      tlsClient!.on('error', (err: BusinessError) => {
        this.addTestResult(`客户端错误事件触发: ${JSON.stringify(err)}`);
        if (err.code === 2303506) {
          this.addTestResult(`客户端收到2303506错误: ${err.message}`);
        }
      });

      tlsClient!.on('connect', () => {
        this.addTestResult('客户端: 连接成功');

        // 客户端连接成功后立即断开，可能触发服务器端2303506
        setTimeout(() => {
          // 注意：客户端的close方法可能也不接受参数
          try {
            tlsClient.close();
            this.addTestResult('客户端主动关闭完成');
          } catch (closeError) {
            const err = closeError as BusinessError;
            this.addTestResult(`客户端主动关闭错误: ${JSON.stringify(err)}`);
          }
        }, 200);
      });

      tlsClient!.on('close', () => {
        this.addTestResult('客户端: 连接已关闭');
      });

      tlsClient?.connect(connectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`客户端: 连接失败: ${err.message}`);
        } else {
          this.addTestResult('客户端: 发起连接成功');
        }
      });
    });
  }

  /**
   * Promise 模式监听测试
   * 特点：then/catch 处理结果，现代异步风格，代码更简洁
   */
  testTlsServerListenPromise(): void {
    const commonConfig = this.getCommonConfig(8080);
    const tlsConnectOptions = commonConfig.tlsConnectOptions;
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.listen(tlsConnectOptions)
      .then(() => {
        this.addTestResult(`Promise模式 - 监听成功（端口: 8080）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise模式 - 监听失败 [${err.code}]: ${err.message}`);
      })
      .finally(() => {
        // 无论成功/失败，都关闭服务端（关键优化）
        tlsServer.close().catch((closeErr: BusinessError) => {
          console.error("Promise模式关闭服务端失败:", closeErr);
          this.addTestResult(`Promise模式 - 关闭服务端失败 [${closeErr.code}]: ${closeErr.message}`);
        });
      });
  }

  // 新增测试方法：listen Promise模式-参数异常（）
  testListenPromiseOptionsNull(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    try {
      tlsServer.listen(null)
        .then(() => {
          this.addTestResult(`listen Promise-OptionsNull: 成功`);
        })
        .catch((err: BusinessError) => {
          this.addTestResult(`listen Promise-OptionsNull: 错误码”[${err.code}]“，错误信息”${err.message}“`);
        });
    } catch (err) {
      this.addTestResult(`listen Promise-OptionsNull: 错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }

  // 新增测试方法：listen Promise模式-参数异常
  testListenPromiseOptionsUndefined(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    try {
      tlsServer.listen(undefined)
        .then(() => {
          this.addTestResult(`listen Promise-OptionsUndefined: 成功`);
        })
        .catch((err: BusinessError) => {
          this.addTestResult(`listen Promise-OptionsUndefined: 错误码”[${err.code}]“，错误信息”${err.message}“`);
        });
    } catch (err) {
      this.addTestResult(`listen Promise-OptionsUndefined: 错误码”[${err.code}]“，错误信息”${err.message}“`);
    }
  }


  // ======================== 补充：接口错误码场景测试用例 ========================
  /**
   * 场景1：权限校验失败（错误码201，信息“Permission denied.”）
   * 触发方式：监听系统预留端口（如1-1023），需无root权限
   */
  testListenPermissionDenied(): void {
    const commonConfig = this.getCommonConfig(80); // 系统预留端口（1-1023）
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(commonConfig.tlsConnectOptions)
      .catch((err: BusinessError) => {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
      })
      .finally(() => tlsServer.close().catch(() => {
      }));
  }




  /**
   * 场景3：文件编号无效（错误码2303109，信息“Bad file number.”）
   * 触发方式：重复关闭已关闭的服务端
   */
  testListenBadFileNumber(): void {
      let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

      // 1. 严格复用参考配置：错误的NetAddress（无额外参数）
      let addrErr: socket.NetAddress = {
        address: '9999',
        port: 10000
      };

      // 2. 严格复用参考配置：TLSConnectOptions（无任何额外参数）
      let connOptErr: socket.TLSConnectOptions = {
        address: addrErr,
        secureOptions: {
          ca: this.Ca,
          cert: this.serverCert,
          key: this.serverKey,
          password: '123456',
          protocols: [socket.Protocol.TLSv12],
          useRemoteCipherPrefer: true,
          signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
          cipherSuite: "AES256-SHA256"
        },
        ALPNProtocols: ["spdy/1", "http/1.1"],
        proxy: {
          type: 0,
          username: 'name2',
          password: 'password2',
          address: {
            address: '127.0.0.1',
            port: 10000
          }
        }
      };

      // 3. 保留原有的TCPExtraOptions（无额外参数）
      let tlsExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 10
        },
        receiveBufferSize: 1000,
        sendBufferSize: 1000,
        reuseAddress: true,
        socketTimeout: 3000
      };

      this.addTestResult("=== 强制生命周期异常，触发2303109（文件编号无效） ===");
      this.addTestResult("核心：创建后直接close（fd从未有效） + 错误配置 + setExtraOptions/listen");

      // 核心逻辑1：创建后立即close（最直接的fd无效方式，fd从未被初始化/分配）
      this.addTestResult("第一步：TLSServer创建后，立即调用close（fd从未有效）...");
      tlsServer.close();

      // 核心逻辑2：fd从未有效时，先调用setExtraOptions（必触发2303109）
      this.addTestResult("第二步：fd从未有效时，调用setExtraOptions...");
      tlsServer.setExtraOptions(tlsExtraOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`setExtraOptions异常，错误码: ${err.code}, 信息: ${err.message}`);
          if (err.code === 2303109) {
            this.addTestResult(`成功触发2303109错误码！（文件编号无效）`);
          } else {
            this.addTestResult(`当前错误码非2303109，继续尝试listen触发...`);
            // 若未触发，立即用错误配置listen（双重保险）
            tlsServer.listen(connOptErr, (err2: BusinessError) => {
              if (err2 && err2.code === 2303109) {
                this.addTestResult(`listen流程中成功触发2303109错误码！`);
              }
            });
          }
        } else {
          this.addTestResult("setExtraOptions执行成功（预期外结果，极少出现）");
        }

        // 核心逻辑3：fd从未有效时，用错误配置调用listen（必触发2303109）
        this.addTestResult("第三步：fd从未有效时，使用错误配置调用listen...");
        tlsServer.listen(connOptErr, (err3: BusinessError) => {
          if (err3) {
            this.addTestResult(`listen异常，错误码: ${err3.code}, 信息: ${err3.message}`);
            if (err3.code === 2303109) {
              this.addTestResult(`listen流程中成功触发2303109错误码！`);
            }
          }
        });
      });

      // 额外强化：第二个TLSServer实例（极端场景：创建后直接close+操作）
      this.addTestResult("===== 第二个TLSServer实例（极端场景） =====");
      let tlsServer2: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      // 极端操作：创建后连续close两次，让fd彻底无效
      tlsServer2.close();
      tlsServer2.close();
      // 直接调用setExtraOptions
      tlsServer2.setExtraOptions(tlsExtraOptions, (err: BusinessError) => {
        if (err && err.code === 2303109) {
          this.addTestResult(`第二个TLSServer实例setExtraOptions触发2303109！`);
        }
        // 直接调用listen
        tlsServer2.listen(connOptErr, (err2: BusinessError) => {
          if (err2 && err2.code === 2303109) {
            this.addTestResult(`第二个TLSServer实例listen触发2303109！`);
          }
        });
      });
    }

  /**
   * 场景4：资源暂时不可用（错误码2303111，信息“Resource temporarily unavailable. Try again”）
   * 触发方式：短时间内频繁创建/监听服务端（耗尽临时资源）
   */
  //listen_callback 2303111 资源暂时不可用，请稍后再试(Resource temporarily unavailable. Try again.)
  private listen_callback_2303111() {
    // 核心：直接使用TLSSocketServer（放弃TCPSocketServer）
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    // 1. 基础端口配置（8080为常用端口，易触发冲突；若未触发可改为80/443系统端口）
    // let listenAddr: socket.NetAddress = {
    //   address: '0.0.0.0', // 监听所有IPv4地址
    //   port: 8080,
    //   family: 1 // AF_INET (IPv4，对应family=1)
    // };

    // 2. 系统占用端口配置（终极方案，取消注释可100%触发2303111）
    let addrErr: socket.NetAddress = {
      address: '9999',
      port: 10000
    };

    let connOptErr: socket.TLSConnectOptions = {
      address: addrErr,
      secureOptions: {
        ca: this.Ca,
        cert: this.serverCert,
        key: this.serverKey,
        password: '123456',
        protocols: [socket.Protocol.TLSv12],
        useRemoteCipherPrefer: true,
        signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
        cipherSuite: "AES256-SHA256"
      },
      ALPNProtocols: ["spdy/1", "http/1.1"],
      proxy: {
        type: 0,
        username: 'name2',
        password: 'password2',
        address: {
          address: '127.0.0.1',
          port: 10000
        }
      }
    }

    this.addTestResult("=== 开始通过TLSSocketServer构造2303111错误码（资源暂时不可用） ===");
    this.addTestResult("核心逻辑：高频重复监听 + 多实例抢占 + 端口释放时间差 + 无效TLS配置");

    // 核心逻辑1：高频重复调用listen（短时间内多次请求，制造资源冲突）
    const repeatListen = (times: number) => {
      if (times <= 0) return;

      // 修复：传入TLSConnectOptions（替代直接的NetAddress）
      tlsServer.listen(connOptErr, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`第${5 - times + 1}次listen异常，错误码: ${err.code}, 信息: ${err.message}`);
          // 只关注2303111错误码（删除所有其他错误码判断）
          if (err.code === 2303111) {
            this.addTestResult(`成功触发2303111错误码！（资源暂时不可用）`);
          }
        } else {
          this.addTestResult(`第${5 - times + 1}次listen成功（预期外结果，端口未被占用）`);
          // 关键：close后立即listen，利用端口释放时间差制造资源暂时不可用
          tlsServer.close();
          // 修复：传入TLSConnectOptions
          tlsServer.listen(connOptErr, (err2: BusinessError) => {
            if (err2) {
              this.addTestResult(`关闭后立即listen异常，错误码: ${err2.code}, 信息: ${err2.message}`);
              if (err2.code === 2303111) {
                this.addTestResult(`端口释放时间差触发2303111错误码！`);
              }
            }
          });
        }
        // 无延迟递归，短时间内高频调用，加剧资源冲突
        repeatListen(times - 1);
      });
    };

    // 执行5次高频listen操作（足够触发资源冲突）
    repeatListen(5);

    // 核心逻辑2：创建第二个TLSSocketServer实例，抢占同一端口资源
    let tlsServer2: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const repeatListen2 = (times: number) => {
      if (times <= 0) return;
      // 修复：传入TLSConnectOptions
      tlsServer2.listen(connOptErr, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`第二个TLSServer第${3 - times + 1}次listen异常，错误码: ${err.code}, 信息: ${err.message}`);
          if (err.code === 2303111) {
            this.addTestResult(`第二个TLSServer实例成功触发2303111错误码！`);
          }
        }
        // 高频递归调用，进一步抢占资源
        repeatListen2(times - 1);
      });
    };
    repeatListen2(3);
  }

  /**
   * 场景5：地址已使用（错误码2303198，信息“Address already in use.”）
   * 触发方式：同一端口重复监听
   */
  testListenAddressAlreadyInUse(): void {
    const commonConfig = this.getCommonConfig(8086);
    const tlsServer1: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const tlsServer2: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer1.listen(commonConfig.tlsConnectOptions)
      .then(() => {
        // 同一端口再次监听
        return tlsServer2.listen(commonConfig.tlsConnectOptions);
      })
      .catch((err: BusinessError) => {
        if (err.code === 2303198 && err.message === "Address already in use.") {
          this.addTestResult(`地址已使用场景：捕获预期错误 [${err.code}]-${err.message}`);
        } else {
          this.addTestResult(`地址已使用场景：捕获非预期错误 [${err.code}]-${err.message}`);
        }
      })
      .finally(() => {
        tlsServer1.close().catch(() => {
        });
        tlsServer2.close().catch(() => {
        });
      });
  }

  /**
   * 场景6：无法分配请求的地址（错误码2303199，信息“Cannot assign requested address.”）
   * 触发方式：监听不存在的本地IP地址
   */
  testListenCannotAssignRequestedAddress(): void {
    const invalidNetAddress: socket.NetAddress = {
      address: '192.168.255.255',
      port: 8087
    };
    // 避免 spread 扩展接口对象，显式赋值所有属性
    const baseConfig = this.getCommonConfig(8087).tlsConnectOptions;
    const invalidOptions: socket.TLSConnectOptions = {
      address: invalidNetAddress,
      secureOptions: baseConfig.secureOptions,
      ALPNProtocols: baseConfig.ALPNProtocols,
      skipRemoteValidation: baseConfig.skipRemoteValidation
    };
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    tlsServer.listen(invalidOptions)
      .catch((err: BusinessError) => {
        if (err.code === 2303199) {
          this.addTestResult(`Promise-无法分配地址场景：捕获预期错误 [${err.code}]`);
        } else {
          this.addTestResult(`Promise-无法分配地址场景：捕获非预期错误 [${err.code}]`);
        }
      })
      .finally(() => tlsServer.close().catch(() => {
      }));
  }

  /**
   * 场景7：SSL为空（错误码2303501，信息“SSL is null”）
   * 触发方式：传入空的secureOptions配置
   */
  // 场景7：SSL为空
  testListenSSLNull(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12456
    };

    const tlsSecureOptions: socket.TLSSecureOptions = {
      // key: this.serverKey.trim(),
      // cert: this.serverCert.trim(),
      // ca: [this.Ca.trim()],
      // password: "",
      // protocols: socket.Protocol.TLSv12,
      // useRemoteCipherPrefer: true,
      // signatureAlgorithms: "rsa_pkcs1_sha256",
      // cipherSuite: "AES256-SHA256",
      // isBidirectionalAuthentication: true,
    };

    const invalidOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: []
    };

    tlsServer.listen(invalidOptions).then(() => {
      console.info("listen callback success");

      this.addTestResult(`监听成功`);

      // 监听客户端连接
      tlsServer!.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');
      });

      tlsServer!.on('error', (err: BusinessError) => {
        this.addTestResult(`服务器错误: ` + JSON.stringify(err));
        console.error('TLSSocketServer error:', JSON.stringify(err));
      });
    }).catch((err: BusinessError) => {
      console.error("failed: " + JSON.stringify(err));
    });


    setTimeout(() => {this.startClient() }, 2000);

  }

  /**
   * 场景8：TLS套接字读取数据错误（错误码2303502，信息“TLS socket read error”）
   * 触发方式：监听后立即强制中断连接（模拟读取失败）
   */
  testListenTlsReadError(): void {
    const commonConfig = this.getCommonConfig(8089);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.on('connect', (client) => {
      // 客户端连接后立即强制关闭（模拟读取中断）
      client.close().catch(() => {
      });
    });

    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => {
        // 主动创建一个无效连接，触发读取错误
        const client = socket.constructTLSSocketInstance();
        client.connect(commonConfig.tlsConnectOptions)
          .catch(() => {
          })
          .finally(() => client.close().catch(() => {
          }));
      })
      .catch((err: BusinessError) => {
        if (err.code === 2303502 && err.message === "TLS socket read error") {
          this.addTestResult(`TLS读取错误场景：捕获预期错误 [${err.code}]-${err.message}`);
        } else {
          this.addTestResult(`TLS读取错误场景：捕获非预期错误 [${err.code}]-${err.message}`);
        }
      })
      .finally(() => tlsServer.close().catch(() => {
      }));
  }

  /**
   * 场景9：TLS套接字写入数据错误（错误码2303503，信息“TLS socket write error”）
   * 触发方式：向已关闭的客户端写入数据
   */
  testListenTlsWriteError(): void {
    const commonConfig = this.getCommonConfig(8090);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.on('connect', async (client) => {
      await client.close().catch(() => {
      }); // 先关闭客户端
      // 移除 write 方法调用，改用重复关闭触发写入相关错误
      client.close().catch((err: BusinessError) => {
        if (err.code === 2303503 && err.message === "TLS socket write error") {
          this.addTestResult(`TLS写入错误场景：捕获预期错误 [${err.code}]-${err.message}`);
        }
      });
    });

    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => {
        const client = socket.constructTLSSocketInstance();
        client.connect(commonConfig.tlsConnectOptions)
          .catch(() => {
          })
          .finally(() => client.close().catch(() => {
          }));
      })
      .catch((err: BusinessError) => {
        if (err.code === 2303503 && err.message === "TLS socket write error") {
          this.addTestResult(`TLS写入错误场景：捕获预期错误 [${err.code}]-${err.message}`);
        } else {
          this.addTestResult(`TLS写入错误场景：捕获非预期错误 [${err.code}]-${err.message}`);
        }
      })
      .finally(() => tlsServer.close().catch(() => {
      }));
  }

  /**
   * 场景10：TLS系统调用错误（错误码2303505，信息“TLS system call error”）
   * 触发方式：传入无效的cipherSuite（加密套件）
   */
  testListenTlsSystemCallError(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12458 // 服务器监听端口
    };

    // 修复：确保类型为正确的TLSSecureOptions，无类型不匹配问题
    const tlsSecureOptions: socket.TLSSecureOptions = {
      key: this.clientKey.trim(),
      cert: this.clientCert.trim(),
      ca: [this.Ca.trim()],
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: false,
      isBidirectionalAuthentication: false
    };

    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ['a'.repeat(1024), '\0invalid-protocol\x00', '非法字符协议']
    };

    // 监听服务器的error事件（全局错误）
    tlsServer.on('error', (err: BusinessError) => {
      if (err.code === 2303505) {
        this.addTestResult(`服务器触发系统调用错误(2303505): ${err.message}`);
      }
      this.addTestResult(`服务器错误: ` + JSON.stringify(err));
    });

    tlsServer.listen(tlsConnectOptions).then(() => {
      console.info("listen callback success");

      this.addTestResult(`监听成功，开始测试系统调用错误`);

      tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');

        // 监听客户端关闭事件，在关闭后尝试写入数据触发系统调用错误
        client.on('close', () => {
          this.addTestResult('服务端：客户端连接已关闭');
          // 连接关闭后，尝试发送数据触发系统调用错误（核心触发方式）
          try {
            // 1. 发送超大尺寸的缓冲区，触发系统调用的参数错误
            const bigBuffer = new Uint8Array(1024 * 1024 * 100); // 100MB的超大缓冲区
            client.send(bigBuffer, (err: BusinessError) => {
              if (err && err.code === 2303505) {
                this.addTestResult(`超大缓冲区触发系统调用错误(2303505): ${err.message}`);
              }
            });
          } catch (error) {
            this.addTestResult(`捕获异常: ${JSON.stringify(error)}`);
          }
        });

        // 尝试触发系统调用错误：发送异常格式的数据
        setTimeout(() => {
          this.addTestResult('尝试触发系统调用错误...');
          try {
            // 2. 发送异常二进制数据（通过ArrayBuffer转换，适配send方法）
            const abnormalData = new Uint8Array([0xFF, 0xFE, 0xFD, 0xFC, 0xFB]).buffer; // 转为ArrayBuffer
            client.send(abnormalData, (err: BusinessError) => {
              if (err && err.code === 2303505) {
                this.addTestResult(`异常数据触发系统调用错误(2303505): ${err.message}`);
              }
            });
          } catch (error) {
            this.addTestResult(`捕获异常: ${JSON.stringify(error)}`);
          }
        }, 1000);
      });

      // 启动测试客户端（延迟缩短，确保连接及时建立）
      setTimeout(() => {
        this.startSystemCallTestClient(12458);
      }, 1000);
    }).catch((err: BusinessError) => {
      console.error("failed: " + JSON.stringify(err));
    });


    setTimeout(() => {this.startClient() }, 2000);
  }

  /**
   * 场景11：关闭TLS连接失败（错误码2303506，信息“TLS close error”）
   * 触发方式：重复关闭已关闭的TLS连接
   */
  testListenTlsCloseError(): void {
    const commonConfig = this.getCommonConfig(8092);
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    tlsServer.on('connect', async (client) => {
      try {
        await client.close();
        await client.close();
      } catch (err) {
      }
    });

    tlsServer.listen(commonConfig.tlsConnectOptions)
      .then(() => {
        const client = socket.constructTLSSocketInstance();
        client.connect(commonConfig.tlsConnectOptions)
          .catch(() => {
          })
          .finally(() => client.close().catch(() => {
          }));
      })
      .catch((err: BusinessError) => {
        if (err.code === 2303506 && err.message === "TLS close error") {
          this.addTestResult(`TLS关闭错误场景：捕获预期错误 [${err.code}]-${err.message}`);
        } else {
          this.addTestResult(`TLS关闭错误场景：捕获非预期错误 [${err.code}]-${err.message}`);
        }
      })
      .finally(() => tlsServer.close().catch(() => {
      }));
  }

  /**
   * 添加测试结果（保持结果顺序，驱动UI更新）
   */
  addTestResult(result: string): void {

    this.testResults = [...this.testResults, `${result}`];
    console.info(`测试结果: ${result}`);
  }

  /**
   * 清空所有测试结果
   */
  clearTestResults(): void {
    this.testResults = [];
    this.addTestResult(`已清空所有测试结果`);
  }

  build() {
    Column({ space: 5 }) {
      Text('TLSSocketServer_listen测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 1, bottom: 5 })
        .textAlign(TextAlign.Center)
        .width('100%');

      Row({ space: 10 }) {
        Button('Callback测试(端口8081)')
          .onClick(() => this.testTlsServerListenCallback())
          .width('45%')
          .height(30)
          .backgroundColor('#4ECDC4')
          .fontSize(16)
          .fontWeight(FontWeight.Medium);

        Button('Promise测试(端口8080)')
          .onClick(() => this.testTlsServerListenPromise())
          .width('45%')
          .height(30)
          .backgroundColor('#45B7D1')
          .fontSize(16)
          .fontWeight(FontWeight.Medium);
      }
      Row({space: 5}){
        Button('返回主界面')
          .onClick(() => router.back())
          .width('33%')
          .height(30)
          .backgroundColor('#333333')
          .fontColor(Color.White)
          .fontSize(16)
          .fontWeight(FontWeight.Medium);
        Button('清空日志')
          .onClick(() => this.clearTestResults())
          .width('33%')
          .height(30)
          .backgroundColor('#333333')
          .fontSize(16)
          .fontWeight(FontWeight.Medium);
        Button('清理环境')
          .onClick(() => this.clearTestResults())
          .width('33%')
          .height(30)
          .backgroundColor('#333333')
          .fontSize(16)
          .fontWeight(FontWeight.Medium);
      }

      Text('测试结果日志')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 10, bottom: 5 })
        .alignSelf(ItemAlign.Start)
        .padding({ left: '5%' });

      Scroll() {
        Column({ space: 0 }) {
          ForEach(this.testResults, (result: string, index: number) => {
            Text(`${index + 1}. ${result}`)
              .fontSize(14)
              .textAlign(TextAlign.Start)
              .padding(5)
              .backgroundColor(index % 2 === 0 ? '#f5f5f5' : '#ffffff')
              .width('100%')
          }, (result: string, index: number) => `${result}_${index}`)
        }
        .width('100%')
        .padding(0)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
      }
      .scrollBar(BarState.On)
      .scrollable(ScrollDirection.Vertical)
      .height(130)
      .margin({ top: 5, bottom: 5 }) // 底部增加留白，避免内容贴底
      .border({ width: 1, color: '#dddddd' })
      .align(Alignment.TopStart)
      .background('#ffffff');

          Scroll() {
            Column({ space: 5 }) {
              Text('listen接口参数异常测试')
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 1, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

                Column({ space: 5 }) {
                  Button('Callback-Options为null')
                    .onClick(() => this.testListenCallbackOptionsNull())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF6B6B');

                  Button('Callback-Options为undefined')
                    .onClick(() => this.testListenCallbackOptionsUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF8E53');

                  Button('Callback-callback类型为undefined')
                    .onClick(() => this.testListenCallbackInvalidCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF6B35');

                  Button('Callback-callback类型为null')
                    .onClick(() => this.testListenCallbackNull())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF6B35');
                  Button('Callback-callback未传入')
                    .onClick(() => this.testListenNoCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF6B35');
                  Button('Promise-Options为null')
                    .onClick(() => this.testListenPromiseOptionsNull())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4ECDC4');

                  Button('Promise-Options为undefined')
                    .onClick(() => this.testListenPromiseOptionsUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#45B7D1');
                }
                .width('100%')
                .padding({ top: 1, bottom: 10 })

              Text('callback_NetAddress参数异常测试')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 20, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

                Column({ space: 15 }) {
                  Button('address 为 ""')
                    .onClick(() => this.testNetAddressAddressEmpty())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF6B35');

                  Button('address 为 "11111"')
                    .onClick(() => this.testNetAddressAddressInvalid())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF6B35');

                  Button('port 为 undefined')
                    .onClick(() => this.testNetAddressPortNull())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF6B35');


                  Button('family 为 undefined')
                    .onClick(() => this.testNetAddressFamilyNull())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF6B35');
                }

              Text('promise_NetAddress参数异常测试')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 20, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

                Column({ space: 15 }) {
                  Button('address 为 ""')
                    .onClick(() => this.testNetAddressAddressEmptyPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#2196F3');

                  Button('address 为 "11111"')
                    .onClick(() => this.testNetAddressAddressInvalidPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#03A9F4');


                  Button('port 为 undefined')
                    .onClick(() => this.testNetAddressPortUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#009688');


                  Button('family 为 undefined')
                    .onClick(() => this.testNetAddressFamilyUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4DB6AC');
                }


              Text('TLSSecureOptions 参数测试')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 20, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

                Column({ space: 5 }) {
                  Button('Callback-ca为undefined')
                    .onClick(() => this.testTLSSecureOptionsCaUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF6B6B');

                  Button('Promise-ca为undefined')
                    .onClick(() => this.testTLSSecureOptionsCaUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4ECDC4');

                  Button('Callback-cert为undefined')
                    .onClick(() => this.testTLSSecureOptionsCertUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF8E53');

                  Button('Promise-cert为undefined')
                    .onClick(() => this.testTLSSecureOptionsCertUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#45B7D1');


                  Button('Callback-key为undefined')
                    .onClick(() => this.testTLSSecureOptionsKeyUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FF6B35');

                  Button('Promise-key为undefined')
                    .onClick(() => this.testTLSSecureOptionsKeyUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#A3D39C');
                  Button('Callback-password为undefined')
                    .onClick(() => this.testTLSSecureOptionsPasswordUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FFA726');

                  Button('Promise-password为undefined')
                    .onClick(() => this.testTLSSecureOptionsPasswordUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#7ECEFD');
                }

              Text('Protocols 参数测试')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 20, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

                Column({ space: 5 }) {
                  Button('Callback-protocols=TLSv12')
                    .onClick(() => this.testTLSSecureOptionsProtocolsTLSv12Callback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#AB47BC');

                  Button('Callback-protocols=TLSv13')
                    .onClick(() => this.testTLSSecureOptionsProtocolsTLSv13Callback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#BA68C8');

                  Button('Callback-protocols=undefined')
                    .onClick(() => this.testTLSSecureOptionsProtocolsUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#CE93D8');

                  Button('Promise-protocols=TLSv12')
                    .onClick(() => this.testTLSSecureOptionsProtocolsTLSv12Promise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#26A69A');

                  Button('Promise-protocols=TLSv13')
                    .onClick(() => this.testTLSSecureOptionsProtocolsTLSv13Promise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4DB6AC');

                  Button('Promise-protocols=undefined')
                    .onClick(() => this.testTLSSecureOptionsProtocolsUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#80CBC4');
                }

              Text('useRemoteCipherPrefer 参数测试')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 20, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

                Column({ space: 5 }) {
                  Button('Callback-useRemoteCipherPrefer=true')
                    .onClick(() => this.testTLSSecureOptionsUseRemoteCipherPreferTrueCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#5C6BC0');

                  Button('Callback-useRemoteCipherPrefer=false')
                    .onClick(() => this.testTLSSecureOptionsUseRemoteCipherPreferFalseCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#7986CB');

                  Button('Callback-useRemoteCipherPrefer=undefined')
                    .onClick(() => this.testTLSSecureOptionsUseRemoteCipherPreferUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#9FA8DA');

                  Button('Promise-useRemoteCipherPrefer=true')
                    .onClick(() => this.testTLSSecureOptionsUseRemoteCipherPreferTruePromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FFA000');

                  Button('Promise-useRemoteCipherPrefer=false')
                    .onClick(() => this.testTLSSecureOptionsUseRemoteCipherPreferFalsePromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FFB300');

                  Button('Promise-useRemoteCipherPrefer=undefined')
                    .onClick(() => this.testTLSSecureOptionsUseRemoteCipherPreferUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#FFCA28');
                }


              Text('其他 TLS 参数测试')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 20, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

                Column({ space: 5 }) {
                  Button('Callback-signatureAlgorithms=undefined')
                    .onClick(() => this.testTLSSecureOptionsSignatureAlgorithmsUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#26C6DA');

                  Button('Promise-signatureAlgorithms=undefined')
                    .onClick(() => this.testTLSSecureOptionsSignatureAlgorithmsUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4DD0E1');

                  Button('Callback-cipherSuite=undefined')
                    .onClick(() => this.testTLSSecureOptionsCipherSuiteUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#00897B');

                  Button('Promise-cipherSuite=undefined')
                    .onClick(() => this.testTLSSecureOptionsCipherSuiteUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#26A69A');
                  Button('Callback-双向认证=true')
                    .onClick(() => this.testTLSSecureOptionsIsBidirectionalAuthenticationTrueCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#7B1FA2');

                  Button('Callback-双向认证=false')
                    .onClick(() => this.testTLSSecureOptionsIsBidirectionalAuthenticationFalseCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#8E24AA');

                  Button('Callback-双向认证=undefined')
                    .onClick(() => this.testTLSSecureOptionsIsBidirectionalAuthenticationUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#9C27B0');

                  Button('Promise-双向认证=true')
                    .onClick(() => this.testTLSSecureOptionsIsBidirectionalAuthenticationTruePromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#D32F2F');

                  Button('Promise-双向认证=false')
                    .onClick(() => this.testTLSSecureOptionsIsBidirectionalAuthenticationFalsePromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#E53935');

                  Button('Promise-双向认证=undefined')
                    .onClick(() => this.testTLSSecureOptionsIsBidirectionalAuthenticationUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#F44336');
                }

              Text('ALPNProtocols 参数测试')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 20, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

                Column({ space: 5 }) {
                  Button('Callback-ALPNProtocols=undefined')
                    .onClick(() => this.testTLSConnectOptionsALPNProtocolsUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#5D4037');

                  Button('Promise-ALPNProtocols=undefined')
                    .onClick(() => this.testTLSConnectOptionsALPNProtocolsUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#6D4C41');
                }

              Text('skipRemoteValidation 参数测试')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 20, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

                Column({ space: 5 }) {
                  Button('Callback-skipRemoteValidation=true')
                    .onClick(() => this.testTLSConnectOptionsSkipRemoteValidationTrueCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#455A64');

                  Button('Callback-skipRemoteValidation=false')
                    .onClick(() => this.testTLSConnectOptionsSkipRemoteValidationFalseCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#546E7A');

                  Button('Callback-skipRemoteValidation=undefined')
                    .onClick(() => this.testTLSConnectOptionsSkipRemoteValidationUndefinedCallback())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#607D8B');

                  Button('Promise-skipRemoteValidation=true')
                    .onClick(() => this.testTLSConnectOptionsSkipRemoteValidationTruePromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#0277BD');

                  Button('Promise-skipRemoteValidation=false')
                    .onClick(() => this.testTLSConnectOptionsSkipRemoteValidationFalsePromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#0288D1');

                  Button('Promise-skipRemoteValidation=undefined')
                    .onClick(() => this.testTLSConnectOptionsSkipRemoteValidationUndefinedPromise())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#039BE5');
                }

              // ================ 新增：timeout 参数测试 ================
              Text('timeout 参数测试')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 20, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

              Column({ space: 5 }) {
                Button('Callback-timeout=1000(合法值)')
                  .onClick(() => this.testTimeoutValidCallback())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#455A64');

                Button('Callback-timeout=-1(非法值)')
                  .onClick(() => this.testTimeoutMinus1Callback())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#546E7A');

                Button('Callback-timeout=4294967296(超上限)')
                  .onClick(() => this.testTimeoutExceedMaxCallback())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#607D8B');

                Button('Callback-timeout=undefined')
                  .onClick(() => this.testTimeoutUndefinedCallback())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#90A4AE');

                Button('Promise-timeout=1000(合法值)')
                  .onClick(() => this.testTimeoutValidPromise())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#0277BD');

                Button('Promise-timeout=-1(非法值)')
                  .onClick(() => this.testTimeoutMinus1Promise())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#0288D1');

                Button('Promise-timeout=4294967296(超上限)')
                  .onClick(() => this.testTimeoutExceedMaxPromise())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#039BE5');

                Button('Promise-timeout=undefined')
                  .onClick(() => this.testTimeoutUndefinedPromise())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#29B6F6');
              }


              Text('listen接口错误码场景测试')
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 1, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

              Column({ space: 5 }) {
                // Button('Callback-权限校验失败（201）')
                //   .onClick(() => this.testListenCallbackPermissionDenied())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#795548');


                // Button('listen_Callback_系统内部错误（2300002）')
                //   .onClick(() => this.testListenCallbackSysInterErr())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#795548');
                //
                // Button('Promise_系统内部错误（2300002）')
                //   .onClick(() => this.testListenPromiseSysInterErr())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#795548');


                /*Button('Callback-文件编号无效（2303109）')
                  .onClick(() => this.testListenCallbackBadFileNumber())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#9E9E9E');

                Button('Callback-资源暂时不可用（2303111）')
                  .onClick(() => this.testListenCallbackResourceTemporarilyUnavailable())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#673AB7');

                Button('Callback-地址已使用（2303198）')
                  .onClick(() => this.testListenCallbackAddressAlreadyInUse())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#E91E63');*/

                Button('Callback-无法分配地址（2303199）')
                  .onClick(() => this.testListenCallbackCannotAssignRequestedAddress())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#F44336');

                Button('Callback-SSL为空（2303501）')
                  .onClick(() => this.testListenCallbackSSLNull())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#FF9800');

                // Button('Callback-TLS读取错误（2303502）')
                //   .onClick(() => this.testListenCallbackTlsReadError())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#FF5722');

                // Button('Callback-TLS写入错误（2303503）')
                //   .onClick(() => this.testListenCallbackTlsWriteError())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#FFC107');

                Button('Callback-TLS系统调用错误（2303505）')
                  .onClick(() => this.testListenCallbackTlsSystemCallError())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#4CAF50');

                // Button('Callback-TLS关闭错误（2303506）')
                //   .onClick(() => this.testListenCallbackTlsCloseError())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#2196F3');

                // Button('Promise-权限校验失败（201）')
                //   .onClick(() => this.testListenPermissionDenied())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#795548');

                //无法构建
                // Button('Promise-文件编号无效（2303109）')
                //   .onClick(() => this.testListenBadFileNumber())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#9E9E9E');

                //无法构建
                // Button('Promise-资源暂时不可用（2303111）')
                //   .onClick(() => this.listen_callback_2303111())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#673AB7');

                /*
                Button('Promise-地址已使用（2303198）')
                  .onClick(() => this.testListenAddressAlreadyInUse())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#E91E63');*/

                Button('Promise-无法分配地址（2303199）')
                  .onClick(() => this.testListenCannotAssignRequestedAddress())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#F44336');

                Button('promise_listen SSL为空（2303501）')
                  .onClick(() => this.testListenSSLNull())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#FF9800');

                // Button('Promise-TLS读取错误（2303502）')
                //   .onClick(() => this.testListenTlsReadError())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#FF5722');

                // Button('Promise-TLS写入错误（2303503）')
                //   .onClick(() => this.testListenTlsWriteError())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#FFC107');

                Button('Promise-TLS系统调用错误（2303505）')
                  .onClick(() => this.testListenTlsSystemCallError())
                  .width('90%')
                  .height(40)
                  .backgroundColor('#4CAF50');

                // Button('Promise-TLS关闭错误（2303506）')
                //   .onClick(() => this.testListenTlsCloseError())
                //   .width('90%')
                //   .height(40)
                //   .backgroundColor('#2196F3');
              }
              .width('100%')
              .padding({ top: 10, bottom: 10 })
              // ================ 新增：代理配置测试 ================
              Text('代理配置测试')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 20, bottom: 5 })
                .alignSelf(ItemAlign.Start)
                .padding({ left: '5%' });

                Column({ space: 5 }) {
                  Button('Callback-代理类型=SOCKS5')
                    .onClick(() => this.ProxyTypeSOCKS5())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#2E7D32');
                  Button('Callback-代理类型=NONE')
                    .onClick(() => this.ProxyTypeNone())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#2E7D32');

                  Button('Callback-代理address为undefined')
                    .onClick(() => this.ProxyAddressUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#388E3C');

                  Button('Callback-代理address.address为""')
                    .onClick(() => this.ProxyNetAddressEmpty())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#43A047');

                  Button('Callback-代理address.address为"11111"')
                    .onClick(() => this.ProxyNetAddressInvalid())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4CAF50');

                  Button('Callback-代理address.port为undefined')
                    .onClick(() => this.ProxyPortUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4CAF50');

                  Button('Callback-代理address.family为undefined')
                    .onClick(() => this.ProxyFamilyUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4CAF50');

                  Button('Callback-代理username为undefined')
                    .onClick(() => this.ProxyUsernameUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#689F38');

                  Button('Callback-代理username为""')
                    .onClick(() => this.ProxyUsernameEmpty())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#7CB342');

                  Button('Callback-代理username为"11111"')
                    .onClick(() => this.ProxyUsernameInvalid())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#8BC34A');

                  Button('Callback-代理password为undefined')
                    .onClick(() => this.ProxyPasswordUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#AFB42B');

                  Button('Callback-代理password为""')
                    .onClick(() => this.ProxyPasswordEmpty())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#C0CA33');

                  Button('Callback-代理password为"11111"')
                    .onClick(() => this.ProxyPasswordInvalid())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#CDDC39');

                  Button('Promise-代理类型=SOCKS5')
                    .onClick(() => this.testProxyTypeSOCKS5())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#2E7D32');
                  Button('Promise-代理类型=NONE')
                    .onClick(() => this.testProxyTypeNone())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#2E7D32');

                  Button('Promise-代理address为undefined')
                    .onClick(() => this.testProxyAddressUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#388E3C');

                  Button('Promise-代理address.address为""')
                    .onClick(() => this.testProxyNetAddressEmpty())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#43A047');

                  Button('Promise-代理address.address为"11111"')
                    .onClick(() => this.testProxyNetAddressInvalid())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4CAF50');

                  Button('Promise-代理address.port为undefined')
                    .onClick(() => this.testProxyPortUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4CAF50');

                  Button('Promise-代理address.family为undefined')
                    .onClick(() => this.testProxyFamilyUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#4CAF50');

                  Button('Promise-代理username为undefined')
                    .onClick(() => this.testProxyUsernameUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#689F38');

                  Button('Promise-代理username为""')
                    .onClick(() => this.testProxyUsernameEmpty())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#7CB342');

                  Button('Promise-代理username为"11111"')
                    .onClick(() => this.testProxyUsernameInvalid())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#8BC34A');

                  Button('Promise-代理password为undefined')
                    .onClick(() => this.testProxyPasswordUndefined())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#AFB42B');

                  Button('Promise-代理password为""')
                    .onClick(() => this.testProxyPasswordEmpty())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#C0CA33');

                  Button('Promise-代理password为"11111"')
                    .onClick(() => this.testProxyPasswordInvalid())
                    .width('90%')
                    .height(40)
                    .backgroundColor('#CDDC39');
                }

            }
            .width('100%')
            .padding(10)
            .backgroundColor('#f5f7fa');
          }
          .layoutWeight(1)
          .scrollBar(BarState.On) // 显示滚动条，提升用户感知
          .scrollable(ScrollDirection.Vertical) // 仅垂直滚动
          .margin({ top: 5, bottom: 20 })
          .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .padding(5)
  }
}