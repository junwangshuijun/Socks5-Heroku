> Fork [shadowsocks-heroku](https://github.com/mrluanma/shadowsocks-heroku)

# shadowsocks-heroku
[Heroku](https://www.heroku.com/) is a cloud platform as a service that supports multiple programming languages, and shadowsocks-heroku is an ss service that can be deployed on the Heroku platform.
Unlike [shadowsocks](https://github.com/clowwindy/shadowsocks), shadowsocks-heroku uses WebSocket instead of original sockets.

## If you encounter problems
1. Please check if you follow the steps first (read the tutorial again)
2. Please find the answer through Google/[Github](https://github.com/itahseen/socks5-heroku/search?utf8=%E2%9C%93&q=&type=)
3. If it has not been resolved, please feel free to ask questions via [issue](https://github.com/onplus/shadowsocks-heroku/issues?q=is%3Aissue+is%3Aclosed+label%3Asolved) (posted log and configuration Pay attention to hiding the password & personal ip when)

## Prepare

### 1. Sign up for a Heroku account
Heroku provides free accounts, some of which are as follows:
-512 MB RAM per dyno
-Free apps sleep automatically after 30 mins of inactivity to conserve your dyno hours
-Free apps wake automatically when a web request is received
-https://devcenter.heroku.com/articles/limits
-https://devcenter.heroku.com/articles/free-dyno-hours#usage

Registration address: https://signup.heroku.com/ (The registration and deployment process may require a ladder[#10](https://github.com/onplus/shadowsocks-heroku/issues/10), [#14]( https://github.com/onplus/shadowsocks-heroku/issues/14))

## Deployment
1. Click on [![](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/syedtahseen/socks5-heroku/tree/re)，[One-click deployment to heroku](https://heroku.com/deploy?template=https://github.com/itahseen/socks5-heroku/tree/re)
  
 You can also choose another version of the server [shadowsocks-websocket-python](https://github.com/onplus/shadowsocks-websocket-python/blob/deploy/README.md); **Mobile users are recommended to deploy cross-platform Support better [v2ray](https://github.com/onplus/v2hero)**
1. Set the encryption algorithm and app password

![deploy](https://user-images.githubusercontent.com/31188782/31343896-ab0a868a-ad43-11e7-8a83-369cf5e385b0.jpg)

[](https://user-images.githubusercontent.com/31188782/31310674-e783c9e4-abce-11e7-87d2-48f328e74169.JPG)

The supported encryption algorithm types are as follows: https://github.com/mrluanma/shadowsocks-heroku#supported-ciphers

## Start local Client
1. Download the release https://github.com/onplus/shadowsocks-heroku/releases ([backup](https://github.com/onplus/archive/tree/master/tool))

2. Modify the config.json parameters and run ss-h.exe or start.vbs (or [win tray tool taskbar.exe](https://github.com/onplus/shadowsocks-heroku/issues/39))

5. The startup is successful and the command line displays: `server listening at {address: '127.0.0.1', family:'IPv4', port: 1080 }`

## Configure proxy
1. Download: Chrome browser [SwitchyOmega](https://github.com/FelisCatus/SwitchyOmega/releases) plug-in ([reference tutorial](https://github.com/FelisCatus/SwitchyOmega/wiki/GFWList), import Backup file [SSHeroku.Bak.zip](https://github.com/onplus/shadowsocks-heroku/files/1371313/SSHeroku.zip))

2. Installation: Open the browser extension page `chrome://extensions`, drag and drop the file `SwitchyOmega.crx` to the browser extension page to install

3. Configuration: add SwitchyOmega proxy server
```
    Proxy agreement: SOCKS5
 Proxy server local_address: 127.0.0.1
    Proxy port local_port: 1080
```
    
## Optional:
1. Use pollution-free DNS https://www.zhihu.com/question/32229915
2. cow/meow smart proxy https://github.com/cyfdecyf/cow#cow-climb-over-the-wall-proxy
```
 #Rc configuration file
 Listen = http://127.0.0.1:7777
    proxy = socks5://127.0.0.1:1080
```
3. Website navigation http://www.ipv6daohang.com/
