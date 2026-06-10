import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';


@Entry
@Component
struct testTLSSocketServerGetProtocol {
  @State testResults: string[] = [];
  private tlsServer: socket.TLSSocketServer | null = null;
  private tlsClient: socket.TLSSocket | null = null;
  private testPort = 12458;

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
  private readonly serverCert = `-----BEGIN CERTIFICATE-----
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
  private readonly clientKey = `-----BEGIN RSA PRIVATE KEY-----
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
  private readonly clientCert = `-----BEGIN CERTIFICATE-----
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
  private readonly Ca = `-----BEGIN CERTIFICATE-----
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
  // 全局TLS配置（复用所有测试方法）
  private tlsSecureConfig: socket.TLSSecureOptions = {
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

  aboutToDisappear(): void {

  }


  // 获取通信的协议版本，使用callback方式作为异步方法
  testTlsServerGetProtocolCallback(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const serverAddr: socket.NetAddress = { address: '0.0.0.0', port: 8080 };

    tlsServer.listen({
      address: serverAddr,
      secureOptions: this.tlsSecureConfig,
      ALPNProtocols: ["http/1.1"]
    })
      .then(() => {
        tlsServer.getProtocol((err: BusinessError, protocol: string) => {
          if (err) {
            this.addTestResult(`获取协议版本失败  错误码”[${err.code}]“，错误信息”${err.message}“`);
          } else {
            this.addTestResult(`callback方式获取通信协议版本成功：协议版本${protocol}`);
          }
          Promise.allSettled([
            tlsServer.close()
          ]);
        });
      })
      .catch((err: BusinessError) => {
        if (err.message === 'CONNECT_FAILED') {
          Promise.allSettled([
            tlsServer.close(),
          ]);
          return;
        }
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
      });
  }

  // 获取通信的协议版本，使用promise方式作为异步方法
  testTlsServerGetProtocolPromise(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    let netAddress: socket.NetAddress = {
      address: '127.0.0.1',
      port: 8080
    };

    let tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: this.tlsSecureConfig,
      ALPNProtocols: ["http/1.1"]
    };


    tlsServer.listen(tlsConnectOptions)
      .then(() => {
        tlsServer.getProtocol().then((protocol: string) => {
          console.info(protocol);
          this.addTestResult(`promise方式获取通信协议版本成功：协议版本${protocol}`);
        }).catch((err: BusinessError) => {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        })
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
      })
      .finally(() => {
        tlsServer.close()
          .catch((closeErr: BusinessError) => console.warn("服务器关闭失败:", closeErr));
      });

  }

  // 新增测试方法：getProtocol Callback模式-参数异常（callback类型错误：undefined）
  testGetProtocolCallbackInvalidType(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const serverAddr: socket.NetAddress = { address: '0.0.0.0', port: 8081 };

    tlsServer.listen({
      address: serverAddr,
      secureOptions: this.tlsSecureConfig,
      ALPNProtocols: ["http/1.1"]
    })
      .then(() => {
        try {
          tlsServer.getProtocol(undefined);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        }
      })
      .catch((err: BusinessError) => {
        if (err.message === 'CONNECT_FAILED') {
          Promise.allSettled([
            tlsServer.close(),
          ]);
          return;
        }
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
      }).finally(() => {
      tlsServer.close();
    });
  }

  // 新增测试方法：getProtocol Callback模式-参数异常（callback类型错误：null）
  testGetProtocolCallbackNullType(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const serverAddr: socket.NetAddress = { address: '0.0.0.0', port: 8082 };

    tlsServer.listen({
      address: serverAddr,
      secureOptions: this.tlsSecureConfig,
      ALPNProtocols: ["http/1.1"]
    })
      .then(() => {
        try {
          tlsServer.getProtocol(null);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        }
      })
      .catch((err: BusinessError) => {
        if (err.message === 'CONNECT_FAILED') {
          Promise.allSettled([
            tlsServer.close(),
          ]);
          return;
        }
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
      }).finally(() => {
      tlsServer.close();
    });
  }

  // 新增测试方法：getProtocol Callback模式-参数异常（未传入callback）
  testGetProtocolCallbackNoParam(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    //const client: socket.TLSSocket = socket.constructTLSSocketInstance();
    const netAddress: socket.NetAddress = { address: '127.0.0.1', port: 0 };

    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: this.tlsSecureConfig,
      ALPNProtocols: ["http/1.1"]
    };

    tlsServer.listen(tlsConnectOptions)
      .then(() => {
        try {
          tlsServer.getProtocol()
          this.addTestResult(`callback方式获取通信协议版本成功`);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        }
      })
      .finally(() => {
        tlsServer.close().catch();
      });
  }

  private cleanupPort(port: number): void {
    //this.addTestResult(`清理端口 ${port}...`);

    // 方法1：使用普通socket清理
    try {
      const udpSocket = socket.constructUDPSocketInstance();
      udpSocket.bind({ address: '0.0.0.0', port: port, family: 1 }, () => {
        udpSocket.close();
        //this.addTestResult(`端口 ${port} 已释放`);
      });

      setTimeout(() => udpSocket.close(), 100);
    } catch (e) {
      // 忽略
    }

    // 方法2：短暂延迟确保端口释放
    setTimeout(() => {
      //this.addTestResult('端口清理完成');
    }, 200);
  }

  // 新增测试方法：getProtocol Callback模式-接口错误（SSL为空）
  testGetProtocolCallbackSslNull(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    this.cleanupPort(12456);

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12456
    };

    const tlsSecureOptions: socket.TLSSecureOptions = {
    };

    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: [],
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
        //this.addTestResult(`服务器错误: ` + JSON.stringify(err));
        console.error('TLSSocketServer error:', JSON.stringify(err));
      });

      tlsServer.getProtocol((err: BusinessError, data: string) => {
        if (err) {
          console.error("getProtocol callback error = " + err);
          this.addTestResult(`callback方式获取协议版本失败 - 错误码: ${err.code}, 消息: ${err.message}`);
        } else {
          console.info("getProtocol callback = " + data);
          this.addTestResult(`callback方式获取协议版本成功` + data);
        }
      });
      setTimeout(() => {
        this.startClient()
      }, 500);
    });
    setTimeout(() => {
      tlsServer.close();
    }, 1000);
  }

  private startClient(): void {
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
        ca: this.Ca,
        key: this.serverKey,
        cert:this.clientCert,
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
          this.addTestResult(`客户端: 连接失败:` + JSON.stringify(err));
          return;
        }
        this.addTestResult('客户端: 连接服务器成功');
      });
    });
  }

  /**
   * Callback 方式 - TLS系统调用错误（错误码2303505，信息“TLS system call error”）
   */
  testGetProtocolCallbackSysCallErr(): void {
    this.tlsServer = socket.constructTLSSocketServerInstance();

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
    this.tlsServer.on('error', (err: BusinessError) => {
      if (err.code === 2303505) {
        this.addTestResult(`服务器触发系统调用错误(2303505): ${err.message}`);
      }
      this.addTestResult(`服务器错误: ` + JSON.stringify(err));
    });

    this.tlsServer.listen(tlsConnectOptions, (err: BusinessError): void => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${JSON.stringify(err)}`);
        if (err.code === 2303505) {
          this.addTestResult(`监听时触发系统调用错误(2303505): ${err.message}`);
        }
        return;
      }

      this.addTestResult(`监听成功，开始测试系统调用错误`);

      this.tlsServer!.getProtocol((err: BusinessError, data: string): void => {
        if (err) {
          console.error("getProtocol callback error = " + err);
          this.addTestResult(`callback方式获取本地的数字证书失败 - 错误码: ${err.code}, 消息: ${err.message}`);
        } else if (data != null) {
          console.info("getProtocol callback = " + data);
          this.addTestResult(`callback方式获取本地的数字证书成功`+data);
        }
      });

      this.tlsServer!.on('connect', (client: socket.TLSSocketConnection): void => {
        this.addTestResult('服务端：有客户端连接成功');

        // 监听客户端关闭事件，在关闭后尝试写入数据触发系统调用错误
        client.on('close', (): void => {
          this.addTestResult('服务端：客户端连接已关闭');
          // 连接关闭后，尝试发送数据触发系统调用错误（核心触发方式）
          try {
            // 1. 发送超大尺寸的缓冲区，触发系统调用的参数错误
            const bigBuffer = new Uint8Array(1024 * 1024 * 100); // 100MB的超大缓冲区
            client.send(bigBuffer, (err: BusinessError): void => {
              if (err && err.code === 2303505) {
                this.addTestResult(`超大缓冲区触发系统调用错误(2303505): ${err.message}`);
              }
            });
          } catch (error) {
            this.addTestResult(`捕获异常: ${JSON.stringify(error)}`);
          }
        });

        // 尝试触发系统调用错误：发送异常格式的数据
        setTimeout((): void => {
          this.addTestResult('尝试触发系统调用错误...');
          try {
            // 2. 发送异常二进制数据（通过ArrayBuffer转换，适配send方法）
            const abnormalData = new Uint8Array([0xFF, 0xFE, 0xFD, 0xFC, 0xFB]).buffer; // 转为ArrayBuffer
            client.send(abnormalData, (err: BusinessError): void => {
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
    this.tlsClient = socket.constructTLSSocketInstance();

    this.tlsClient.bind({ address: '127.0.0.1', port: 0 }, (err: BusinessError) => {
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
      this.tlsClient!.connect(tlsConnectOptions, (err: BusinessError): void => {
        if (err) {
          this.addTestResult(`客户端连接失败: ${JSON.stringify(err)}`);
          if (err.code === 2303505) {
            this.addTestResult(`客户端连接触发系统调用错误(2303505): ${err.message}`);
          }
          return;
        }

        this.addTestResult('客户端连接成功，立即关闭连接');
        // 客户端连接成功后，立即关闭连接，让服务器端写入时触发错误
        this.tlsClient!.close((): void => {
          this.addTestResult('客户端连接已关闭');
        });

        // 客户端尝试发送超大数据，触发自身的系统调用错误
        setTimeout((): void => {
          try {
            const bigData = new Uint8Array(1024 * 1024 * 100).buffer; // 转为ArrayBuffer
            this.tlsClient!.send(bigData, (err: BusinessError): void => {
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
      this.tlsClient!.on('error', (err: BusinessError): void => {
        if (err.code === 2303505) {
          this.addTestResult(`客户端全局错误触发系统调用错误(2303505): ${err.message}`);
        }
      });
    });
  }

  /**
   * Promise模式 - 错误码2303501：SSL为空（无效SSL配置）
   *
   */
  testGetProtocolPromiseSslNull(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    this.cleanupPort(12456);

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12456
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

      this.addTestResult(`监听成功`);

      // 监听客户端连接
      tlsServer!.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');
      });

      tlsServer!.on('error', (err: BusinessError) => {
        //this.addTestResult(`服务器错误: ` + JSON.stringify(err));
        console.error('TLSSocketServer error:', JSON.stringify(err));
      });

      tlsServer.getProtocol().then((data: string) => {
        console.info(data);
        this.addTestResult(`promise方式获取协议版本成功` + data);
      }).catch((err: BusinessError) => {
        console.error("failed" + err);
        this.addTestResult(`promise方式获取协议版本失败 - 错误码: ${err.code}, 消息: ${err.message}`);
      });
      setTimeout(() => {
        this.startClient()
      }, 500);
    });
    setTimeout(()=>{
      tlsServer.close();
    }, 1000);

  }

  /**
   * Promise模式 - 错误码2303505：TLS系统调用错误（关闭实例后非法调用）
   * 核心逻辑：启动服务后关闭实例，再调用getProtocol触发底层系统调用错误
   */
  testGetProtocolPromiseTlsSysCallErr(): void {
    this.tlsServer = socket.constructTLSSocketServerInstance();

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
    this.tlsServer.on('error', (err: BusinessError) => {
      if (err.code === 2303505) {
        this.addTestResult(`服务器触发系统调用错误(2303505): ${err.message}`);
      }
      this.addTestResult(`服务器错误: ` + JSON.stringify(err));
    });

    this.tlsServer.listen(tlsConnectOptions, (err: BusinessError): void => {
      if (err) {
        this.addTestResult(`服务器: 监听失败: ${JSON.stringify(err)}`);
        if (err.code === 2303505) {
          this.addTestResult(`监听时触发系统调用错误(2303505): ${err.message}`);
        }
        return;
      }

      this.addTestResult(`监听成功，开始测试系统调用错误`);

      this.tlsServer!.getProtocol((err: BusinessError, data: string): void => {
        if (err) {
          console.error("getProtocol callback error = " + err);
          this.addTestResult(`callback方式获取本地的数字证书失败 - 错误码: ${err.code}, 消息: ${err.message}`);
        } else if (data != null) {
          console.info("getProtocol callback = " + data);
          this.addTestResult(`callback方式获取本地的数字证书成功`+data);
        }
      });

      this.tlsServer!.on('connect', (client: socket.TLSSocketConnection): void => {
        this.addTestResult('服务端：有客户端连接成功');

        // 监听客户端关闭事件，在关闭后尝试写入数据触发系统调用错误
        client.on('close', (): void => {
          this.addTestResult('服务端：客户端连接已关闭');
          // 连接关闭后，尝试发送数据触发系统调用错误（核心触发方式）
          try {
            // 1. 发送超大尺寸的缓冲区，触发系统调用的参数错误
            const bigBuffer = new Uint8Array(1024 * 1024 * 100); // 100MB的超大缓冲区
            client.send(bigBuffer, (err: BusinessError): void => {
              if (err && err.code === 2303505) {
                this.addTestResult(`超大缓冲区触发系统调用错误(2303505): ${err.message}`);
              }
            });
          } catch (error) {
            this.addTestResult(`捕获异常: ${JSON.stringify(error)}`);
          }
        });

        // 尝试触发系统调用错误：发送异常格式的数据
        setTimeout((): void => {
          this.addTestResult('尝试触发系统调用错误...');
          try {
            // 2. 发送异常二进制数据（通过ArrayBuffer转换，适配send方法）
            const abnormalData = new Uint8Array([0xFF, 0xFE, 0xFD, 0xFC, 0xFB]).buffer; // 转为ArrayBuffer
            client.send(abnormalData, (err: BusinessError): void => {
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
    })
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

  build() {
    // 外层滚动框：修复滚动方向配置，移除构造函数参数，用scrollable设置
    Column() {
      Column({ space: 20 }) {
        // 标题和当前状态
        Text('TLSSocketServe_getProtocol测试')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 });

        // 测试按钮
        Button('获取通信的协议版本callback测试')
          .onClick(() => this.testTlsServerGetProtocolCallback())
          .width('90%')
          .height(35)
          .backgroundColor('#3498db')
          .fontColor(Color.White)
          .borderRadius(8);

        Button('获取通信的协议版本promise测试')
          .onClick(() => this.testTlsServerGetProtocolPromise())
          .width('90%')
          .height(35)
          .backgroundColor('#2980b9')
          .fontColor(Color.White)
          .borderRadius(8);

        Text('getProtocol接口参数异常测试')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 5, bottom: 5 })
          .alignSelf(ItemAlign.Start)
          .padding({ left: '5%' })
          .fontColor('#2980b9');

        Scroll() {
          Column({ space: 8 }) {
            Button('Callback-callback类型为undefined')
              .onClick(() => this.testGetProtocolCallbackInvalidType())
              .width('100%')
              .height(35)
              .backgroundColor('#e74c3c')
              .fontColor(Color.White)
              .fontSize(12)
              .borderRadius(6);
            Button('Callback-callback类型为null')
              .onClick(() => this.testGetProtocolCallbackNullType())
              .width('100%')
              .height(35)
              .backgroundColor('#e74c3c')
              .fontColor(Color.White)
              .fontSize(12)
              .borderRadius(6);
            Button('Callback-未传入callback')
              .onClick(() => this.testGetProtocolCallbackNoParam())
              .width('100%')
              .height(35)
              .backgroundColor('#c0392b')
              .fontColor(Color.White)
              .fontSize(12)
              .borderRadius(6);

            Button('Callback-SSL为空（错误码2303501）')
              .onClick(() => this.testGetProtocolCallbackSslNull())
              .width('100%')
              .height(35)
              .backgroundColor('#e67e22')
              .fontColor(Color.White)
              .fontSize(12)
              .borderRadius(6);

            Button('Callback-TLS系统调用错误（2303505）')
              .onClick(() => this.testGetProtocolCallbackSysCallErr())
              .width('100%')
              .height(35)
              .backgroundColor('#e67e22')
              .fontColor(Color.White)
              .fontSize(12)
              .borderRadius(6);

            Button('Promise-SSL为空（错误码2303501）')
              .onClick(() => this.testGetProtocolPromiseSslNull())
              .width('100%')
              .height(35)
              .backgroundColor('#9b59b6')
              .fontColor(Color.White)
              .fontSize(12)
              .borderRadius(6);

            Button('Promise-TLS系统调用错误（2303505）')
              .onClick(() => this.testGetProtocolPromiseTlsSysCallErr())
              .width('100%')
              .height(35)
              .backgroundColor('#9b59b6')
              .fontColor(Color.White)
              .fontSize(12)
              .borderRadius(6);
          }
        }
        .width('90%')
        .height(180)
        .scrollBar(BarState.Auto)
        .scrollable(ScrollDirection.Vertical)
        .border({ width: 1, color: '#eeeeee' })
        .borderRadius(4);

        Column() {
          Text('测试结果')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 5, bottom: 5 })
            .alignSelf(ItemAlign.Start)
            .padding({ left: '5%' });

          // 测试结果列表
          Scroll() {
            Column() {
              ForEach(this.testResults, (result: string, index: number) => {
                Text(`${index + 1}. ${result}`)
                  .fontSize(14)
                  .textAlign(TextAlign.Start)
                  .padding(5)
                  .backgroundColor(index % 2 === 0 ? '#f5f5f5' : '#ffffff')
                  .width('100%')
                  .borderRadius(4);
              }, (result: string, index: number) => `${result}-${index}-${Date.now()}`)
            }
            .width('100%')
          }
          .scrollBar(BarState.On)
          .scrollable(ScrollDirection.Vertical)
          .height('100%')
          .border({ width: 1, color: '#dddddd' })
          .borderRadius(4);
        }
        .layoutWeight(1)
        .width('100%')
        .backgroundColor('#f0f0f0')

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
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(10)
        .margin({ top: 5 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f0f0f0')
    }
  }
}
