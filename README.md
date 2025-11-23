# 🇧🇭 abuyasser-esx-helpme  
**Advanced ESX Arabic Command Logger with Discord Webhooks (RTL Friendly)**  
by **Mohammed AbuYasser**

---

## 📌 Overview  
**abuyasser-esx-helpme** هو نظام تسجيل أوامر (Command Logger) مخصص لسيرفرات  
**ESX Legacy / es_extended**  
مع دعم كامل للغة العربية، تنسيق RTL، وتكامل احترافي مع **Discord Webhooks**.

يهدف السكربت لتوثيق نشاط اللاعبين وإرسال تنبيه فوري لكل أمر مهم يتم استخدامه داخل السيرفر،  
مع سجل تفصيلي (Steam / Discord mention / Identifiers / Job from DB / Coordinates).

---

## 🚀 Features  
- ✨ **تعريب كامل + دعم RTL (Right To Left)**  
- 🔥 **Webhook لكل أمر** مع منشن @everyone  
- 📝 **سبب اختياري** `/خارج [السبب]`  
- 🗺️ إرسال **الإحداثيات** داخل بلوك منسق  
- 🧩 جلب الوظيفة من قاعدة البيانات:
  - jobs  
  - job_grades  
- 🎮 جلب كامل الـ identifiers:
  - Steam  
  - Discord (mention)  
  - license  
  - license2  
  - FiveM ID  
  - XBL  
  - Live  
- ⚙️ إعدادات سهلة في config.lua  
- 🛡️ صلاحيات لكل أمر: user / vip / admin / superadmin  
- 🎨 Embed منسق بطريقة “Outstanding”  

---

## 📦 Installation  
###1️⃣ ضع الملفات داخل مجلد 
```
resources/[esx]/abuyasser-esx-helpme/
```

### 2️⃣ أضف السكربت في server.cfg  

```
ensure abuyasser-esx-helpme
```

### 3️⃣ عدّل webhooks والصلاحيات من:  
```
config.lua
```

---

## 🔧 Configuration  
مثال تعديل أمر معيّن:

```lua
Config.Commands = {
    ["خارج"] = {
        webhook = "YOUR_WEBHOOK_URL",
        groups  = { "user", "vip", "admin", "superadmin" }
    },

    ["تخريب"] = {
        webhook = "YOUR_WEBHOOK_URL",
        groups  = { "admin", "superadmin" }
    }
}
```
###أضف أمر جديد بسهولة:
```lua
Config.Commands["نداء"] = {
    webhook = "WEBHOOK",
    groups  = { "user", "vip" }
}
```
### اللاعب ينفذ الأمر عبر:
```
/نداء السبب
```
