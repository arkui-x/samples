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
struct testTLSSocketServerGetCertificate {
  @State testResults: string[] = [];
  aboutToAppear(): void {
  }

  aboutToDisappear(): void {
  }
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


  //使用无效的证书连接，接口能正常调用，无报错。
  private getCertificate_callback_2303504_1() : void{
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    let netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12345
    }
    let tlsSecureOptions: socket.TLSSecureOptions = {
      key: "无效的私钥内容", // 故意设置错误的私钥，触发证书验证失败
      cert: "-----BEGIN CERTIFICATE-----\n" +
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
        "-----END CERTIFICATE-----",
      ca: ["-----BEGIN CERTIFICATE-----\n" +
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
        "-----END CERTIFICATE-----"],
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    }
    let tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"]
    }
    tlsServer.listen(tlsConnectOptions).then(() => {
      console.info("listen callback success");
      tlsServer.getCertificate().then((data: socket.X509CertRawData) => {
        const decoder = util.TextDecoder.create();
        const str = decoder.decodeToString(data.data);
        console.info("getCertificate: " + str);
        this.addTestResult(`callback方式获取本地的数字证书成功` + str);
      }).catch((err: BusinessError) => {
        console.error("failed" + err);
        this.addTestResult(`callback方式获取本地的数字证书失败 - 错误码: ${err.code}, 消息: ${err.message}`);
      });
    }).catch((err: BusinessError) => {
      console.error("failed: " + JSON.stringify(err));
    });

    setTimeout(() => {
      this.startClient()
    }, 500);
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


      tlsClient!.connect(connectOptions, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`客户端连接失败, 错误码：[${err.code}] 错误信息：${err.message}`);
          return;
        }
        this.addTestResult('客户端: 连接服务器成功');
      });
    });
  }

  //不建立连接的情况下直接调用 getCertificate，接口能正常调用，无报错。
  private getCertificate_callback_2303504_2() : void{
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    let netAddress: socket.NetAddress = {
      address: '127.0.0.1',
      port: 12345
    }
    let tlsSecureOptions: socket.TLSSecureOptions = {
      key: "-----BEGIN PRIVATE KEY-----\n" +
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
        "-----END PRIVATE KEY-----",
      cert: "-----BEGIN CERTIFICATE-----\n" +
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
        "-----END CERTIFICATE-----",
      ca: ["-----BEGIN CERTIFICATE-----\n" +
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
        "-----END CERTIFICATE-----"],
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    }
    let tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"]
    }
    tlsServer.listen(tlsConnectOptions).then(() => {
      console.info("listen callback success");
      tlsServer.getCertificate().then((data: socket.X509CertRawData) => {
        const decoder = util.TextDecoder.create();
        const str = decoder.decodeToString(data.data);
        console.info("getCertificate: " + str);
        this.addTestResult(`callback方式获取本地的数字证书成功` + str);
      }).catch((err: BusinessError) => {
        console.error("failed" + err);
        this.addTestResult(`callback方式获取本地的数字证书失败 - 错误码: ${err.code}, 消息: ${err.message}`);
      });
    }).catch((err: BusinessError) => {
      console.error("failed: " + JSON.stringify(err));
    });
  }

  //使用无效的证书连接，接口能正常调用，无报错。
  private getCertificate_promise_2303504_1() : void{
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    let netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 12345
    }
    let tlsSecureOptions: socket.TLSSecureOptions = {
      key: "无效的私钥内容", // 故意设置错误的私钥，触发证书验证失败
      cert: "-----BEGIN CERTIFICATE-----\n" +
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
        "-----END CERTIFICATE-----",
      ca: ["-----BEGIN CERTIFICATE-----\n" +
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
        "-----END CERTIFICATE-----"],
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    }
    let tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"]
    }
    tlsServer.listen(tlsConnectOptions).then(() => {
      console.info("listen callback success");
      tlsServer.getCertificate().then((data: socket.X509CertRawData) => {
        const decoder = util.TextDecoder.create();
        const str = decoder.decodeToString(data.data);
        console.info("getCertificate: " + str);
        this.addTestResult(`promise方式获取本地的数字证书成功` + str);
      }).catch((err: BusinessError) => {
        console.error("failed" + err);
        this.addTestResult(`promise方式获取本地的数字证书失败 - 错误码: ${err.code}, 消息: ${err.message}`);
      });
    }).catch((err: BusinessError) => {
      console.error("failed: " + JSON.stringify(err));
    });

    setTimeout(() => {
      this.startClient()
    }, 500);
  }

  //不建立连接的情况下直接调用 getCertificate，接口能正常调用，无报错。
  private getCertificate_promise_2303504_2() : void{
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    let netAddress: socket.NetAddress = {
      address: '127.0.0.1',
      port: 12345
    }
    let tlsSecureOptions: socket.TLSSecureOptions = {
      key: "-----BEGIN PRIVATE KEY-----\n" +
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
        "-----END PRIVATE KEY-----",
      cert: "-----BEGIN CERTIFICATE-----\n" +
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
        "-----END CERTIFICATE-----",
      ca: ["-----BEGIN CERTIFICATE-----\n" +
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
        "-----END CERTIFICATE-----"],
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    }
    let tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"]
    }
    tlsServer.listen(tlsConnectOptions).then(() => {
      console.info("listen callback success");
      tlsServer.getCertificate().then((data: socket.X509CertRawData) => {
        const decoder = util.TextDecoder.create();
        const str = decoder.decodeToString(data.data);
        console.info("getCertificate: " + str);
        this.addTestResult(`promise方式获取本地的数字证书成功` + str);
      }).catch((err: BusinessError) => {
        console.error("failed" + err);
        this.addTestResult(`promise方式获取本地的数字证书失败 - 错误码: ${err.code}, 消息: ${err.message}`);
      });
    }).catch((err: BusinessError) => {
      console.error("failed: " + JSON.stringify(err));
    });
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

  @Builder
  private buildGetCertTestButton(text: string, onClick: () => void, bgColor: string) {
    Button(text)
      .onClick(onClick)
      .width('90%')
      .height(44)
      .fontSize(16)
      .fontColor('#ffffff')
      .backgroundColor(bgColor)
      .borderRadius(8)
      .shadow({ radius: 3, color: `${bgColor}20`, offsetX: 0, offsetY: 2 });
  }


  build() {
    Column({ space: 20 }) {
      Text('TLSSocketSever测试')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 5 });
      Scroll() {
        Column({ space: 12 }) {
          this.buildGetCertTestButton(
            'getCertificate_callback_2303504_1',
            () => this.getCertificate_callback_2303504_1(),
            '#009688'
          );
          this.buildGetCertTestButton(
            'getCertificate_callback_2303504_2',
            () => this.getCertificate_callback_2303504_2(),
            '#009688'
          );
          this.buildGetCertTestButton(
            'getCertificate_promise_2303504_1',
            () => this.getCertificate_promise_2303504_1(),
            '#009688'
          );
          this.buildGetCertTestButton(
            'getCertificate_promise_2303504_2',
            () => this.getCertificate_promise_2303504_2(),
            '#009688'
          );
        }
        .width('100%')
      }
      .scrollBar(BarState.On)
      .scrollable(ScrollDirection.Vertical)
      .height(250)
      .width('100%')

      Button('清空测试结果')
        .onClick(() => this.clearTestResults())
        .width('90%')
        .height(40)
        .backgroundColor(Color.Gray);

      Button('返回主界面')
        .onClick(() => {
          // 返回上一页（主界面）
          router.back();
        })

      // 测试结果列表
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
        .justifyContent(FlexAlign.Start)
      }
      .scrollBar(BarState.On)
      .scrollable(ScrollDirection.Vertical)
      .height(170)
      .padding(5)
      .border({ width: 1, color: '#dddddd' })

    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#f0f0f0')
  }

}
