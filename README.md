# MTProto Proxy Install Script

Do you want your own MTProxy for 1 euro per month? Easily, only 3 steps!

1. Go to [Aruba Cloud](https://www.arubacloud.com/), **Register and top-up balance by 1 euro**, Go to the **Control Panel**, Cilck **Create New Server**, choose **Smart Server**, write **Server Name**, choose template **Any Linux x64 (Debian, Centos etc.)**, write **root** password, remember **IP**, wait for server deployment
2. Login SSH with **root** (e.g. [PUTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)), like root@**IP**, Port 22
3. If Linux: RedHat, Centos, Fedora - first install wget(copy `yum install wget -y` and  paste in console). Copy `wget https://raw.githubusercontent.com/CraftedCat/MTProxyInstallScript/master/mtpis.sh && chmod +x mtpis.sh && ./mtpis.sh` and paste in console (PUTTY black window), follow script instructions.


P.S. Please! Publish your proxy in [MTPP 2.0](https://t.me/MTProtoProxiesFree) via [@MTPP2Bot](https://t.me/MTPP2Bot). It's Free!

P.S.S. Please! Share this script for others!


# اسکریپت نصاب ام-تی-پروتو پراکسی

می خواهید پراکسی اختصاصی خودتان را داشته باشید و با دوستان و خانواده خود به اشتراک بگذارید؟
1. از یکی از ارایه دهندگان سرور مجازی یک سرویس لینوکسی با قیمت مناسب تهیه کنید
    -  [تگرا هاست](https://tegrahost.com/cart.php?gid=25)
    - [نیک کلاود](https://my.niccloud.net/cart.php?gid=7)
    - [ابتین وب](https://my.abtinweb.com/cart.php?gid=29)
    - [پایا کلاود](https://client.payacloud.com/cart.php?gid=5) 
2. با اس-اس-اچ و کاربر روت به سرور متصل شوید (روی ویندوز می توانید از [نرم افزار پوتی](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)) استفاده کنید, 
    - اطلاعات اتصال به اس-اس-اچ پس از خرید سرور مجازی برای شما ایمیل خواهد شد 
    - مثال: root@**IP**, Port 22
3. دستورات زیر را به ترتیب در پنجره پوتی کپی و پیست کنید و اجرا کنید 
    - اگر لینوکس سرور شما بر پایه اوبونتو است:
      1. `apt install wget -y`
      2. `wget https://raw.githubusercontent.com/CraftedCat/MTProxyInstallScript/master/mtpis.sh && chmod +x mtpis.sh && ./mtpis.sh`
    - اگر لینوکس سرور شما بر پایه ردهت است:
      1. `yum install wget -y`
      2. `wget https://raw.githubusercontent.com/CraftedCat/MTProxyInstallScript/master/mtpis.sh && chmod +x mtpis.sh && ./mtpis.sh`

پ.ن: لطفا پراکسی خود را با استفاده از [ربات تلگرامی](https://t.me/MTPP2Bot) در [کانال ام-تی-پراکسی رایگان](https://t.me/MTProtoProxiesFree) ثبت کنید و به صورت رایگان به دیگران کمک کنید.

پ.ن.۲: لطفا این اسکریپت را با دوستانتان به اشتراک بگذارید 
