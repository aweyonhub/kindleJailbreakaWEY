
# kindleJailbreakaWEY
Kindle jailbreak settings&backup

reference:
http://wiki.mobileread.com/wiki/Kindle_Hacks_Information
https://wzyboy.im/post/736.html
https://www.chiphell.com/thread-932614-1-1.html

Structure:

    /
    README.md
    fonts/
        font.properties-2
        fonts-conf-wzyboy.tar.gz
        Lorem-ipsum-wzyboy.mobi_.tar.gz
        华文中宋x2.7z
        方正准雅宋_GBK.rar
        方正特雅宋_GBK.rar
        fonts/
            CJK_Bold.ttf
            CJK_BoldItalic.ttf
            CJK_Italic.ttf
            CJK_Regular.ttf
            Serif_Bold.ttf
            Serif_BoldItalic.ttf
            Serif_Italic.ttf
            Serif_Regular.ttf
        fonts-conf-wzyboy/
            font.properties
            font.properties-3
            font.properties-3-nocondensed
    hack/
        kindle-fonts-5.16.N-k2.zip
        kindle-fonts-5.16.N-k3.zip
        kindle-jailbreak-0.13.N.zip
        kindlepdfviewer-v2013.1.zip
        kindlevncviewer.zip
        KUAL_k3_later/
            kindle-mkk-20141129.zip
            kual-helper-0.5.N.zip
            KUAL-kindlePDFviewer-extension-kpdf.zip
            KUAL-v2.6.zip
            vncviewer_kuai.zip
            extensions/
                helper/
                    config.xml
                    menu.json
                    bin/
                        411.sh
                        device_id.sh
                        kill-kterm.sh
                        setorientation.sh
                        ssallow.sh
                        ssprevent.sh
                        start_update.sh
                kpdf/
                    config.xml
                    menu.json
                    README.txt
                vncviewer/
                    config.xml
                    menu.json
                    README.txt
        launchpad_dxg/
            lpad-pkg-001d.zip

# Jailbreak
hack/kindle-jailbreak-0.13.N.zip

# Font Settings
kindle input:

    ;debugOn				#打开 debug 模式
    ~changeLocale zh-CN.utf8		#更改 Local 为 zh-CN.utf8
    ;debugOff				#关闭 debug 模式，可以不输入

kindle-fonts-5.16.N-k2.zip for dxg
kindle-fonts-5.16.N-k3.zip for k3
fonts-conf-wzyboy replace to linkfont/etc
fonts/fonts/*.ttf to linkfont/font


#Install apps
##launcher

KUAL for kindle 3 Launchpad for kindle dxg

###KUAL for kindle 3 

 1. Install kindle-mkk-20141129.zip
 2. copy kual to document dict
 3. copy extensions to root dict

###Launchpad for kindle dxg

 1. install lpad-pkg-001d.zip
 2. unpluge reset launchpad with shift+shift+space

##kindlepdfviewer

 1. unzip kindlepdfviewer to root dict
 2. cp launchpad kpv ini to launchpad
 3. open kindlepdfviewer with shift+p+d
 4. press f and choose chinese font to fix Garbled
