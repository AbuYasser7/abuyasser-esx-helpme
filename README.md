# abuyasser-esx-helpme  
**Advanced ESX Arabic Command Logger with Discord Webhooks (RTL Friendly)**  
by **Mohamed AbuYasser**

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
### 1️⃣ ضع الملفات داخل مجلد  
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

أضف أمر جديد بسهولة:

```lua
Config.Commands["نداء"] = {
    webhook = "WEBHOOK",
    groups  = { "user", "vip" }
}
```

اللاعب ينفذ الأمر عبر:
```
/نداء السبب
```

---

## 🖼️ Discord Embed Preview  
```
🚨 تم استخدام أمر /خارج
تنبيه عام — في لاعب استخدم أمر داخل السيرفر.

👤 بيانات اللاعب
رقم اللاعب: 34
الرتبة: user
الكود: GDT23
الاسم: محمد القحطاني

💼 الوظيفة
Police Officer (grade 3)

📍 الإحداثيات
X: 123.45
Y: 234.56
Z: 21.00

💬 Discord / Steam
@player (938493843984)
steam: 11000014AABBCC

🔐 Identifiers
license:
license2:
fivem:
xbl:
live:
```

---

## 🛠️ Commands Usage Examples  
```
/خارج
/خارج برجع بعد شوي
/تخريب لاعب قاعد يخرب
/help محتاج مساعدة
```

---

## 🧠 How It Works  
1. اللاعب يستخدم أمر (مثلاً `/خارج`).  
2. السكربت يتحقق من **صلاحياته**.  
3. يتم جلب:
   - بيانات اللاعب من ESX  
   - الوظيفة من DB  
   - Steam / Discord / IDs  
   - موقع اللاعب  
4. إرسال رسالة Discord Embed منظمة RTL.  

---

## 📚 Files Structure  
```
abuyasser-esx-helpme/
 ├─ fxmanifest.lua
 ├─ config.lua
 ├─ Client/main.lua
 └─ Server/main.lua
```

---

## 📜 License  
Released under the **MIT License**.  
يسمح باستخدام السكربت بحرية مع الحفاظ على حقوق المطور **AbuYasser**.

---

## ❤️ Credits  
Developed & designed by **Mohammed AbuYasser**  
For ESX Legacy — Bahrain / KSA Community.
