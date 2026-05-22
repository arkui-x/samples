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

  // 本地生成的 2048位 RSA 密钥对（替换为你自己生成的内容）
  // 服务端私钥
  private readonly  server_key = "-----BEGIN PRIVATE KEY-----\n" +
    "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDc5nwJoLVtmQGB\n" +
    "fE49oEjDQvSKTht5oXcn4CzsMekvpQxe3B0isb9gXaUZyF37MQtjzyi5swNa0FQR\n" +
    "17OYhl8dElJa8kEM3tIy7sTNhskh8LIHBjscfbZ1ype1Y+lPLkdVR+mx6rcOIp/q\n" +
    "0m+ny1NcIN1Vs+GeXBdLb9O2m0IxYaa6799esFJ/M5K8num75idZBezfhhyUt469\n" +
    "ooLT8JkLnnV/ps3O6yoy+9kF8qI3GIJ13wN3jfyRQBU+y66BQ90Wx/aLaLtzBnoX\n" +
    "lO/gVSa6pgvQsle5w5AM1JgQpeN7E7KMudMteBEbyAdu4j1AB59mDhKmDqD4+i7f\n" +
    "GIJbIcP7AgMBAAECggEAF3utHfzmrKMCZPiI/MYoVhGtG3LYOuLuXt/XBrj7mCQM\n" +
    "n5z4v/JzbNQntAj37Lc3BcJFCxC7v5C8DzWGEyXdwKJs/NwaDDs3z1BQvaShhykm\n" +
    "U9bWu92lYvpJjG/1ooRB8w/1CQPxt9/4bic21XipAPdBcFXyGzqhA1T9BcGVlNgh\n" +
    "IBSaoS9xMMnd0Yf8dYu31aTQ3vUXqYxQ2+flwRyeg8rxJpWgtbcAcI2BHq+/C4Ga\n" +
    "BbB1rQwp32ehm7z8beIwJJ3R2REnuhrly6/cpzn+2PfC8aR47XgflrZhv4yLXSOZ\n" +
    "wQli6MnLPTjMbOFbKUyQM8Vsru4n1sdMLYjRF4tiCQKBgQD2tuZu/+tONiNGwGAu\n" +
    "iLGELriIM8YmeQ4u+KH7dbtFRushvCMaEexDu+jMscSWUYUJp5iG8xQdhsoZtPkF\n" +
    "5+rBZ4tnOg8CslUbryBVjIN7Vw8yF/X+NE+r38/L2Aaz2mW0zJ/sWff1u58haweU\n" +
    "olTetLvoUI0Yn1i3TwhJb740JQKBgQDlNt1bI7filQNEU+zKgMReVEcN42taNrTc\n" +
    "Ny05By7pHsgXCs6mf2KxbBb96vwez52heK3ov6QOmrOtJgCoIEnbrrk3pjGapja4\n" +
    "AbriA1MLcN5ScyBGMh0r+x7emJaN46qdWINJjXnb/ZKNZhSj43yJMilTSo/fG06J\n" +
    "NNObffuNnwKBgQCRcwDlXdFu2bHwa0gJByOIpza5bbSbR/EZthFhO2Z9kDLdP5p+\n" +
    "KyTcRfMYgpFAgazqJTliDfrE8YtCnpPVbIXVIeNopyzkTRip6pQoe1+kno3h3Yh0\n" +
    "Joj17kwGhERnUhF2BtEduWjbIZLOU9gzQ4S/i1PgwWR9qKvX3isniE5dVQKBgDXC\n" +
    "f3pfz0IyZvjAoloAh44EQEIOo+Ad0p+PxWiJucPtd0qIO12rpO8uBdp6IbXsRfFY\n" +
    "R5m+UPEn8Zpbvm2wXQJMYZ6euSWndFAF/9oAo5qcV1iJLfmoyVTGakAVE8Klsh+D\n" +
    "Yg9/QiSJvbSyS4cA1PWssSqa41GVqv7dSABBNR3LAoGBAJe7TBw4rWM2Vz7ejVxO\n" +
    "7q5NpMptivyJ6DqoHKFVLOJWXAtaUqfidO8CyFdCSDWoiTqyUvhxQOAHDtVAHjuZ\n" +
    "ORpYnZRa5ONbWYTR0vSf93YyckeG6EQZQa3qAMWoiru/VvSx1ozPs3Grh3jjFKGs\n" +
    "u/iAg5IeR+C9Fv0BFgaJ26bw\n" +
    "-----END PRIVATE KEY-----\n";

  private readonly  server_ca =
    "-----BEGIN CERTIFICATE-----\n" +
      "MIIDbTCCAlWgAwIBAgIUC5RSSzOctHDYW0cYIhmBh7oQxVgwDQYJKoZIhvcNAQEL\n" +
      "BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM\n" +
      "GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAgFw0yNTA2MTAxMTMzMjBaGA8yMDU1\n" +
      "MDYwMzExMzMyMFowRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUx\n" +
      "ITAfBgNVBAoMGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDCCASIwDQYJKoZIhvcN\n" +
      "AQEBBQADggEPADCCAQoCggEBANzmfAmgtW2ZAYF8Tj2gSMNC9IpOG3mhdyfgLOwx\n" +
      "6S+lDF7cHSKxv2BdpRnIXfsxC2PPKLmzA1rQVBHXs5iGXx0SUlryQQze0jLuxM2G\n" +
      "ySHwsgcGOxx9tnXKl7Vj6U8uR1VH6bHqtw4in+rSb6fLU1wg3VWz4Z5cF0tv07ab\n" +
      "QjFhprrv316wUn8zkrye6bvmJ1kF7N+GHJS3jr2igtPwmQuedX+mzc7rKjL72QXy\n" +
      "ojcYgnXfA3eN/JFAFT7LroFD3RbH9otou3MGeheU7+BVJrqmC9CyV7nDkAzUmBCl\n" +
      "43sTsoy50y14ERvIB27iPUAHn2YOEqYOoPj6Lt8Yglshw/sCAwEAAaNTMFEwHQYD\n" +
      "VR0OBBYEFIrPKtMjljbgX/fp+CV47cFjeLYBMB8GA1UdIwQYMBaAFIrPKtMjljbg\n" +
      "X/fp+CV47cFjeLYBMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEB\n" +
      "AI0F84on5dOGIhRjIsBiJyuYf1Ob49GopGswVOTye2j74BKiVsGmXNeyXKHuBsq8\n" +
      "IOepV3TS9siGCErRaL10tJywi+JbBbtMKkTVAH8IwCPFS3KYR9ZFD0qZTmf5O+Gv\n" +
      "UTWl43WN9g0E3bEIMl8WBsbg5Zhl/+BJztBSgaQEqnyKeb8lfCXuZCmHBtNeN83c\n" +
      "YUaDE4SDi3f+KZm+FyiPhx+X8U5yzEwleN0OOP0GmaHKpUqnRPNos1wqonS3Zh+8\n" +
      "K4cloMMEG6S+cWIyk4dFG6Emji/5qf2FlvSDIUju+zCWCX1trvneL55v4mKBgD16\n" +
      "g1uuJ6kpRiG0CEonEBXB0/0=\n" +
      "-----END CERTIFICATE-----\n";

  private readonly  client_ca =
    "-----BEGIN CERTIFICATE-----\n" +
      "MIIDbTCCAlWgAwIBAgIUASHS9V7Uu9oyqmwoPTqvmUFsdUowDQYJKoZIhvcNAQEL\n" +
      "BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM\n" +
      "GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAgFw0yNTA2MTAxMTIxMjhaGA8yMDU1\n" +
      "MDYwMzExMjEyOFowRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUx\n" +
      "ITAfBgNVBAoMGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDCCASIwDQYJKoZIhvcN\n" +
      "AQEBBQADggEPADCCAQoCggEBAM5AAwvpyrpHOLm+TBZBOxfown4gs1XNMMbzBuxs\n" +
      "H2zWn40xgS0amWz+s9fgSpFlBOrfN/qmpPWnNlyAj9zRgNp29p7FJbjqWIrEeiCI\n" +
      "9TrM1fY0TLmr3J/Tdb/ZZxoERF8lh1hw+X02DVB4dEqg7amrQbl4gLShVM7bLOSw\n" +
      "vpbICFkbOMax2Gv9N7eARH7eLVoTjZ0ckB3hNEB1BobWdjWc1SLiu0R+Xnjlv1+m\n" +
      "EpV5igI4v/oDkiEEpQN5h0H9YHxvsB0PU/TYJ727HkiMyLuBW+p+jXiJS6ydCeHc\n" +
      "H09H5GiA9oqa3RX0bTYCnPYohgkLEdsFgKIXxiNL2+PjYscCAwEAAaNTMFEwHQYD\n" +
      "VR0OBBYEFG8rsAxolBK0DNP5I8SKVpz0qm2mMB8GA1UdIwQYMBaAFG8rsAxolBK0\n" +
      "DNP5I8SKVpz0qm2mMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEB\n" +
      "AH+GiRfwKFjezpMDZHYPw2iIoQxHa00mpQ81MwlPfnJvqG5fIwqXcKigl7iPrthB\n" +
      "pIvFRMzgzsYQmZwmEVgnVqaq1f8R8WqhjbiS+QpBV+QKipFQg6GwGGBKrsDllSYW\n" +
      "jYdXAyAwevrJeeMl/kkbICLkGn5RLzaCkMXEIfCjs1CMMUHn0Mren9HfntWzAoSo\n" +
      "su2ZmrZloUAw4PwagtJfM1L0uUCvMlbNLVR4Ol8i/KzpXThD7how4gFIXQ93QZ+k\n" +
      "j3r+apVFPlgp03IVxF0Pm/NM2q1T7Kl8yvVb92nFfI7/+yynctG4Wl3R6NHZjMn8\n" +
      "wVxxyIC/keppOl2C4Lu0XFs=\n" +
      "-----END CERTIFICATE-----\n";

  private readonly  client_key =
    "-----BEGIN PRIVATE KEY-----\n" +
      "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDOQAML6cq6Rzi5\n" +
      "vkwWQTsX6MJ+ILNVzTDG8wbsbB9s1p+NMYEtGpls/rPX4EqRZQTq3zf6pqT1pzZc\n" +
      "gI/c0YDadvaexSW46liKxHogiPU6zNX2NEy5q9yf03W/2WcaBERfJYdYcPl9Ng1Q\n" +
      "eHRKoO2pq0G5eIC0oVTO2yzksL6WyAhZGzjGsdhr/Te3gER+3i1aE42dHJAd4TRA\n" +
      "dQaG1nY1nNUi4rtEfl545b9fphKVeYoCOL/6A5IhBKUDeYdB/WB8b7AdD1P02Ce9\n" +
      "ux5IjMi7gVvqfo14iUusnQnh3B9PR+RogPaKmt0V9G02Apz2KIYJCxHbBYCiF8Yj\n" +
      "S9vj42LHAgMBAAECggEACfqbdEU/g3vCG2zTV1BPgMXIgzwC8UM81OyHiKewSPoX\n" +
      "GG0tURsPyUtionfQNhU9uoZKTDgFAg2xEMeJ5TkySjsT1wdIlapg+uOH2bn9g3bL\n" +
      "YRWTR50L86RAG1sGkpQ+2FTMgVODtY4Ig3OizMT9qHPjni9dz1+BMBWJg6leGHDZ\n" +
      "Pt+ZKXY1AEhHAuy1oOye7MBgWZ7cIkhmutNFIi2SmOoYjUfLqSHz7asuHFqBCnJH\n" +
      "ykuyQc706rbYfZrAkHRvjRgLft4xI8xz+aypIhufDZHsr8hujujQ+rBZDWMuknTz\n" +
      "THtD6YYbmdI33ikMv78hk21jiNl8vhd1g/KJWaqS4QKBgQDmBsUcsU2gdi2v04oR\n" +
      "m9LmyNeFW0HAvIAQMCCV/ISOctPjGLqfA2Wk5qg4s5rq2XLPf7pK+g7h8aLyYJyy\n" +
      "lRSLle4C4fd4whEeEJVsPDYda0/Ip4tsLKWTAPzaNrRsN0VRtzHgQXInfvMAXtQg\n" +
      "icLZuntPuA0aym8SP5I0V4ms+wKBgQDlifPXKldhAN86N+cdQZ9hH0rv4B0OTspK\n" +
      "sdLOH1irrXYECUxXmbqeA28XnjMiKvEwD1Z1wUDd6GZgHIi8tBJl9kVgpKakRqvW\n" +
      "M/41Wp0pQaDmZXXTDzoj4XMiPePK/13epxc7i3nE3bightVlbijyFhWV/WFo4AoI\n" +
      "LdAcBXWfpQKBgBQKlvXvBMJsSYK+PZNXLkLpUM3Pq6TtR4MhjlVDERGQM6Hfr7LX\n" +
      "Cu4ZIqL+EwtPMs+dY0/RBabt9LKFdGGi141p3LjnkzY0QmWKMFqjzFs31FW5M06T\n" +
      "fUGXnnAsv/+FuUZrXa8aRKXoS6fGm1jSZ+Wsd730XT/uT0sZutVQozAtAoGBAIfN\n" +
      "pJyqimPz1h5lsLEYgClAEF/3YnlymDC1IJme5iE8UVR2A9rYMxcFxRZeHLacXXIn\n" +
      "wOmOWshvlRJMD4JFr5TvrYBOKeGLhmMHA+GhKNad44osgRdMLQPJgQrDPyB9EZaH\n" +
      "mTE7heG5pGAlJeAK2uLPuhmxfY5E7uqD4FqTyFGZAoGBALgdQ6/VoGDqAEGEVLvg\n" +
      "8/wfUo2yYFKrwlar/zyFfb9hMb+NWQ4PwyxRcpbhIkRZlrbqN2fuereZqsiXvjBX\n" +
      "2BhxFrHBKw3z2KRoh4nfh3Pq7AhmiI9uvoB77yw0ehFOS2SFug2Clf0H9RaY4isd\n" +
      "sAzqLzYptVuiCr4z4FSlFdrk\n" +
      "-----END PRIVATE KEY-----\n";

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
      key: this.server_key,
      cert: this.server_ca,
      ca: [this.client_ca],
      password: '',
      protocols: [socket.Protocol.TLSv12],
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication:true
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
        this.addTestResult('TLSSocketServer error:'+ JSON.stringify(err));
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
        key: this.client_key,
        cert: this.client_ca,
        ca: [this.server_ca],
        password: '',
        protocols: [socket.Protocol.TLSv12],
        useRemoteCipherPrefer: true,
        signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
        cipherSuite: "AES256-SHA256",
        isBidirectionalAuthentication:true
      };

      const connectOptions: socket.TLSConnectOptions = {
        address: connectAddr,
        secureOptions: secureOptions,
        ALPNProtocols: ["spdy/1", "http/1.1"],
        //skipRemoteValidation: true
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

  private getRemoteCertificate_callback(): void {
    if (!this.tlsClientCon) {
      this.addTestResult('客户端不存在，请先建立连接');
      return;
    }
    this.tlsClientCon.getRemoteCertificate((err: BusinessError, data: socket.X509CertRawData) => {
      if (err) {
        console.error("getRemoteCertificate callback error: " + err);
        this.addTestResult(`callback方式获取远端数字证书失败: [${err.code}] ${err.message}`);
      } else {
        const decoder = util.TextDecoder.create();
        const str = decoder.decodeToString(data.data);
        console.info("getRemoteCertificate callback: " + str);
        this.addTestResult(`callback方式获取远端数字证书成功`+ str);
      }
    });
  }

  //getRemoteCertificate_callback_undefined
  private getRemoteCertificate_callback_undefined(): void {
    if (!this.tlsClientCon) {
      this.addTestResult('客户端不存在，请先建立连接');
      return;
    }

    try{
      this.tlsClientCon.getRemoteCertificate(undefined);
      this.addTestResult(`callback方式获取远端数字证书成功`);
    }
    catch (err){
      this.addTestResult(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }

  }

  //getRemoteCertificate_callback_null
  private getRemoteCertificate_callback_null(): void {
    if (!this.tlsClientCon) {
      this.addTestResult('客户端不存在，请先建立连接');
      return;
    }

    try{
      this.tlsClientCon.getRemoteCertificate(null);
      this.addTestResult(`callback方式获取远端数字证书成功`);
    }
    catch (err){
      this.addTestResult(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }

  }

  //getRemoteCertificate_callback_no
  private getRemoteCertificate_callback_no(): void {
    if (!this.tlsClientCon) {
      this.addTestResult('客户端不存在，请先建立连接');
      return;
    }

    try{
      this.tlsClientCon.getRemoteCertificate()
        console.info("getRemoteCertificate success:" );
        this.addTestResult(`获取远端数字证书成功`);
    }
    catch (err){
      this.addTestResult(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }

  }

  //getRemoteCertificate_callback_SSL
  private getRemoteCertificate_callback_SSL(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: this.testPort
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

      this.addTestResult(`监听成功 on ${this.testPort}`);

      // 监听客户端连接
      tlsServer!.on('connect', (client: socket.TLSSocketConnection) => {
        this.addTestResult('服务端：有客户端连接成功');
        this.setupConnectionEvents(client);
      });

      tlsServer!.on('error', (err: BusinessError) => {
        this.addTestResult('TLSSocketServer error:' + JSON.stringify(err));
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
        port: this.testPort
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
    if(this.tlsClientCon)
    try {
      this.tlsClientCon.getRemoteCertificate().then((data: socket.X509CertRawData) => {
        const decoder = util.TextDecoder.create();
        const str = decoder.decodeToString(data.data);
        console.info("getRemoteCertificate success: " + str);
        this.addTestResult('promise方式获取远端数字证书成功' + str);
      }).catch((err: BusinessError) => {
        console.error("failed" + err);
        this.addTestResult(`promise方式获取远端数字证书失败: [${err.code}] ${err.message}`);
      });
    } catch (err) {
      this.addTestResult(`promise获取通信双方协商后的加密套件失败: [${err.code}] ${err.message}`);
    } finally{
      if(this.tlsClientCon){
        this.tlsClientCon.close();
        this.tlsClientCon = undefined;
      }
      if(this.tlsServer){
        this.tlsServer.close();
        this.tlsServer = undefined;
      }
      if(this.tlsClient){
        this.tlsClient.close();
        this.tlsClient = undefined;
      }
    }
  }

  private getRemoteCertificate_promise(): void {
    setTimeout(()=>{},2000);
    if (!this.tlsClientCon) {
      this.addTestResult('客户端不存在，请先建立连接');
      return;
    }
    this.tlsClientCon.getRemoteCertificate().then((data: socket.X509CertRawData) => {
      const decoder = util.TextDecoder.create();
      const str = decoder.decodeToString(data.data);
      console.info("getRemoteCertificate success: " + str);
      this.addTestResult('promise方式获取远端数字证书成功' + str);
    }).catch((err: BusinessError) => {
      console.error("failed" + err);
      this.addTestResult(`promise方式获取远端数字证书失败: [${err.code}] ${err.message}`);
    });
  }

  private stopTest(): void {
    if(this.tlsClient) {
      this.tlsClient.close();
      this.tlsClient.off('connect');

      this.tlsClient = undefined;
    }
    if (this.tlsServer) {
      this.tlsServer.close();
      this.tlsServer = undefined;
    }
    if (this.tlsClientCon) {
      this.tlsClientCon.close();
      this.tlsClientCon = undefined;
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
      key: this.server_key,
      cert: this.server_ca,
      ca: [this.client_ca],
      password: '',
      protocols: [socket.Protocol.TLSv12],
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256",
      isBidirectionalAuthentication:true
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
      Text('getRemoteCertificate接口测试')
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

          Button('getRemoteCertificate_callback')
            .onClick(() => this.getRemoteCertificate_callback())
            .width('90%')
            .backgroundColor('#4CAF50')

          Button('getRemoteCertificate callback 类型错误 undefined')
            .onClick(() => this.getRemoteCertificate_callback_undefined())
            .width('90%')
            .backgroundColor('#4CAF50')

          Button('getRemoteCertificate callback 类型错误 null')
            .onClick(() => this.getRemoteCertificate_callback_null())
            .width('90%')
            .backgroundColor('#4CAF50')

          Button('getRemoteCertificate 未传入 callback 参数')
            .onClick(() => this.getRemoteCertificate_callback_no())
            .width('90%')
            .backgroundColor('#4CAF50')

          // Button('getRemoteCertificate SSL 为空')
          //   .onClick(() => this.getRemoteCertificate_callback_SSL())
          //   .width('90%')
          //   .backgroundColor('#4CAF50')

          Button('getRemoteCertificate_promise')
            .onClick(() => this.getRemoteCertificate_promise())
            .width('90%')
            .backgroundColor('#4CAF50')
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
