# 📊 Linux System Monitor

<p align="center">
  <img src="https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=GNU%20Bash&logoColor=white">
  <img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black">
  <img src="https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white">
</p>

**Linux System Monitor** یک ابزار خط فرمان برای پایش لحظه‌ای منابع سیستم است که با **Bash** نوشته شده. این ابزار می‌تواند مصرف **CPU**، **RAM** و **Disk** را با نمودارهای ASCII نمایش دهد و در صورت مصرف بالای ۸۰٪ هشدار بدهد.

---

## 🚀 Features

| قابلیت | توضیح |
|--------|-------|
| 📈 CPU Monitoring | نمایش مصرف پردازنده با نمودار ASCII |
| 🧠 RAM Monitoring | نمایش مصرف حافظه با نمودار ASCII |
| 💾 Disk Monitoring | نمایش مصرف دیسک با نمودار ASCII |
| 🔄 All-in-One | مشاهده همزمان همه منابع |
| ⚠️ Alert System | هشدار خودکار در مصرف بالای ۸۰٪ |
| 🎛️ Interactive Menu | منوی تعاملی ساده با اعداد ۱ تا ۵ |

---

## 📸 Preview

### Main Menu
```
System Resource Monitoring
--------------------------
1) CPU
2) RAM  
3) Disk
4) Show All
5) Exit
```

### CPU Monitoring
```
CPU Usage: [##############] 28%
CPU usage is normal.
```

### Alert (High Usage)
```
CPU Usage: [########################################] 92%
⚠️ WARNING: High CPU usage!
```

---

## 🛠️ Installation

### Prerequisites
```bash
sudo apt update
sudo apt install bc gawk
```

### Clone & Run
```bash
git clone https://github.com/fatemeh-jli/linux-monitor-bash.git
cd linux-monitor-bash
chmod +x monitor.sh
./monitor.sh
```

---

## 📊 How It Works

| Resource | Command | Calculation |
|----------|---------|-------------|
| **CPU** | `top -bn1` | User% + System% |
| **RAM** | `free` | (Used × 100) / Total |
| **Disk** | `df /` | Usage% of `/` |

### ASCII Chart Logic
```bash
COUNT=$(echo "$PERCENT / 2" | bc)
BAR=$(printf "%0.s#" $(seq 1 $COUNT))
# 2% consumption = 1 character
```

---

## 📁 Project Structure

```
linux-monitor-bash/
├── monitor.sh      # Main monitoring script
└── README.md       # Project documentation
```

---

## 👩‍💻 Author

**Fatemeh Jalali**

[![GitHub](https://img.shields.io/badge/GitHub-fatemeh--jli-blue?logo=github)](https://github.com/fatemeh-jli)
[![Gmail](https://img.shields.io/badge/Gmail-fatemehjalali11711-red?logo=gmail)](mailto:fatemehjalali11711@gmail.com)

---

## 🙏 Acknowledgements

- **Professor:** Sajjad Eskandari
- **Course:** Operating Systems Lab
- **University:** Bu-Ali Sina University, Hamedan

---

## 📝 License

MIT © [Fatemeh Jalali](https://github.com/fatemeh-jli)

---

<p align="center">
  ⭐ If this project helped you, please give it a star! ⭐
</p>
