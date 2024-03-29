[Toc]
## 目的
近年來遊戲產業蓬勃發展，越來越多玩家為了提升遊戲體驗，願意購買遊戲中的付費項目，例如可以獲得強力角色或裝備的轉蛋成果。然而轉蛋作為一種新興的消費方式，法規方面尚未完整規範，導致消費爭議層出不窮。例如消費者轉蛋抽取某角色或某裝備的次數遠高於期望值，遊戲廠商卻經常以抽取轉蛋樣本數不足來搪塞消費者，使消費者無從對證。

本計畫旨在人工智慧的YOLOv5自動辨識轉蛋的角色或裝備，並集結群眾的力量利用區塊鏈去中心化、公開透明、不可竄改及可追溯等特性，並透過星際檔案系統（IPFS）儲存轉蛋畫面，以統計大量轉蛋結果，建立一個可靠的第三方驗證系統(DApp)。這DApp不僅可以用於檢驗遊戲廠商提供的機率是否符合其公布機率，必要時也可作為證據輔助判決。透過這種監督機制，消費者與廠商之間可以建立互信，促進遊戲產業的永續發展，並營造良好的消費環境。

## 實機畫面展示

下圖1至圖9為DApp前端子系統實機操作畫面:

<div style="display: inline-block; width: 45%;">
  <img src="https://github.com/Pin891031/DApp-for-gacha-probability-verification-with-blockchain-and-YOLO/blob/main/img/%E5%81%B5%E6%B8%AC%E7%B3%BB%E7%B5%B1%E9%A6%96%E9%A0%81.png" alt="偵測系統首頁" style="width: 100%; height: auto; margin-right: 10px;" />
    <p style="text-align: center;"><strong>圖1 偵測系統首頁</strong></p>
</div>

<div style="display: inline-block; width: 45%;">
  <img src="https://github.com/Pin891031/DApp-for-gacha-probability-verification-with-blockchain-and-YOLO/blob/main/img/%E7%B5%B1%E8%A8%88%E7%B5%90%E6%9E%9C%E9%A6%96%E9%A0%81.png" alt="統計結果首頁" style="width: 100%; height: auto; margin-left: 10px;" />
    <p style="text-align: center;"><strong>圖2 統計結果首頁</strong></p>
</div>

<div style="display: inline-block; width: 45%;">
  <img src="https://github.com/Pin891031/DApp-for-gacha-probability-verification-with-blockchain-and-YOLO/blob/main/img/%E5%8E%9F%E5%A7%8B%E5%9C%96%E7%89%87%E9%A0%81%E9%9D%A2.png" alt="原始圖片頁面" style="width: 100%; height: auto; margin-right: 10px;" />
    <p style="text-align: center;"><strong>圖3 原始圖片頁面</strong></p>
</div>

<div style="display: inline-block; width: 45%;">
  <img src="https://github.com/Pin891031/DApp-for-gacha-probability-verification-with-blockchain-and-YOLO/blob/main/img/%E5%8E%9F%E5%A7%8B%E5%9C%96%E7%89%87%E5%A4%A7%E5%9C%96.png" alt="原始圖片大圖" style="width: 100%; height: auto; margin-left: 10px;" />
    <p style="text-align: center;"><strong>圖4 原始圖片大圖</strong></p>
</div>

<div style="display: inline-block; width: 45%;">
  <img src="https://github.com/Pin891031/DApp-for-gacha-probability-verification-with-blockchain-and-YOLO/blob/main/img/%E6%87%B8%E6%B5%AE%E8%A6%96%E7%AA%971.png" alt="懸浮視窗1" style="width: 100%; height: auto; margin-right: 10px;" />
    <p style="text-align: center;"><strong>圖5 懸浮視窗1</strong></p>
</div>

<div style="display: inline-block; width: 45%;">
  <img src="https://github.com/Pin891031/DApp-for-gacha-probability-verification-with-blockchain-and-YOLO/blob/main/img/%E6%87%B8%E6%B5%AE%E8%A6%96%E7%AA%972.png" alt="懸浮視窗2" style="width: 100%; height: auto; margin-left: 10px;" />
    <p style="text-align: center;"><strong>圖6 原懸浮視窗2</strong></p>
</div>

<div style="display: inline-block; width: 45%;">
  <img src="https://github.com/Pin891031/DApp-for-gacha-probability-verification-with-blockchain-and-YOLO/blob/main/img/%E5%9C%93%E9%A4%85%E5%9C%96.png" alt="圓餅圖" style="width: 100%; height: auto; margin-right: 10px;" />
    <p style="text-align: center;"><strong>圖7 圓餅圖</strong></p>
</div>

<div style="display: inline-block; width: 45%;">
  <img src="https://github.com/Pin891031/DApp-for-gacha-probability-verification-with-blockchain-and-YOLO/blob/main/img/%E6%9C%9F%E6%9C%9B%E5%80%BC.png" alt="期望值" style="width: 100%; height: auto; margin-left: 10px;" />
    <p style="text-align: center;"><strong>圖8 期望值</strong></p>
</div>

<div style="display: inline-block; width: 45%;">
  <img src="https://github.com/Pin891031/DApp-for-gacha-probability-verification-with-blockchain-and-YOLO/blob/main/img/%E4%B8%8A%E5%82%B3%E9%A0%81%E9%9D%A2.png" alt="上傳頁面" style="width: 100%; height: auto; margin-left: 10px;" />
    <p style="text-align: center;"><strong>圖9 上傳頁面</strong></p>
</div>

## 系統架構

本專案設計的系統包含一個前端子系統及三個後端子系統，希望透過蒐集眾多玩家上傳的轉蛋結果，擴大樣本數以驗證遊戲中獎池實際機率是否符合公告機率。圖 10 為本系統架構圖。
<div style="display: inline-block; width: 100%;">
  <img src="https://github.com/Pin891031/DApp-for-gacha-probability-verification-with-blockchain-and-YOLO/blob/main/img/%E5%9C%8B%E7%A7%91%E6%9C%83%E6%9E%B6%E6%A7%8B%E5%9C%96.png" alt="國科會架構圖" style="width: 100%; height: auto;" />
    <p style="text-align: center;"><strong>圖10 國科會架構圖</strong></p>
</div>

1. **DApp前端子系統**
為了方便使用者對系統的使用，本系統使用flutter製作手機App，並且可以直接使用本系統進行錄影，不需要透過第三方錄影程式。錄影完之後就可以直接上傳至後端伺服器。也可以使用本系統直接觀看目前收集到的數據，本系統會用pie_chart將統計數據畫成圓餅圖，使用者還可以點擊圓餅圖觀看信賴區間，圓餅圖底下也有詳細的每隻角色出現次數。另外本系統也有觀看原始圖片的功能，讓使用者可以看到本計畫蒐集的圖片以及該圖片在IPFS上的CID。

2. **後端伺服器子系統**
後端伺服器主要是透過Flask對後端不同程式及功能間進行調度，並整合網站及DApp拿取資料的API，以滿足不同平台用戶使用本系統的需求，接下來透過Apache伺服器對Flask進行代理，Apache不僅有成熟的SSL及TLS加密功能，當該系統需要處理更為大量的流量時，可以透過Apache中的負載平衡模組，分發到多個Flask伺服器，以應對更為大量的用戶連線。

3. **後端影像辨識子系統**
後端影像辨識子系統主要的功能為簡化使用者上傳結果所需步驟，僅須透過上傳轉蛋時候的錄影，就可以透過自行撰寫的特徵程式將結果畫面擷取出來，並使用透過YOLOv5訓練出來的模型，對結果畫面進行辨識，以獲取轉蛋結果數據。
4. **後端區塊鏈及IPFS子系統**
透過結合區塊鏈及IPFS去中心化及不可竄改等特性，透過IPFS儲存轉蛋結果畫面，並將IPFS回傳的CID及轉蛋結果數據等重要資訊，透過撰寫好的智能合約儲存至區塊鏈，以達到資料的安全性及不可竄改性。

## 安裝步驟
主要分為網站伺服器及開發環境
### 網站伺服器
建議配置:
os:Windows 10 專業版 22H2(OS 組建 19045.3693)
四核心以上CPU
16GB RAM
60GB ROM
如使用虛擬機進行架設建議網卡設定bridge並設定固定ip

安裝Python 310
安裝Flask
安裝XAMPP
安裝IPFS desktop
改httpd.conf(將資料夾內貼到原本XAMPP上的位置)
將CSRS資料夾至於C槽

安裝以下套件

```
pip install torch==2.1.0
pip install pandas==2.1.1
pip install requests==2.31.0
pip install psutil==5.9.5
pip install torchvision==0.16.0
pip install PyYAML==6.0.1
pip install tqdm==4.66.1
pip install ultralytics==8.0.111
pip install matplotlib==3.3
pip install Pillow==9.5
```

啟動IPFS desktop
啟動Apache
啟動web.py
### 開發環境
#### YOLOv5
大於 8GB RAM
如需自行訓練模型建議配備支持 CUDA 的 NVIDIA GPU

安裝Python 38
安裝PyCharm
安裝CUDA
安裝CUDNN
安裝Git

安裝以下套件

```
pip install torch==2.1.0
pip install pandas==2.1.1
pip install requests==2.31.0
pip install psutil==5.9.5
pip install torchvision==0.16.0
pip install PyYAML==6.0.1
pip install tqdm==4.66.1
pip install ultralytics==8.0.111
pip install matplotlib==3.3
pip install Pillow==9.5
```
照官網步驟訓練模型

#### DApp
安裝Git
下載Flutter SDK
在C槽按住shift點滑鼠右鍵，按Git Bash Here
輸入
```
git clone -b stable https://github.com/flutter/flutter.git
```
下載Dart的SDK
新增Path```C:\flutter\bin```
安裝Android Studio
Android Studio安裝Flutter和dart plugin
## 資料夾結構
請將CSRS置於C槽底下
CSRS
├── README.md
├── __pycache__(自動生成的python編譯檔)
├── web.py(Flask伺服器)
├── python
│       ├── __pycache__(自動生成的python編譯檔)
│       ├── start_all.py(彙整程式)
│       ├── 
│       ├── 
│       ├── 
│       ├── 
│       ├── 
│       ├── 
│       ├── 
│       └── constants.py
├── static
├── tmp
├── yoloGPU1
└── totalcount.txt

## 程式碼展示
# DApp-for-gacha-probability-verification-with-blockchain-and-YOLO
# DApp-for-gacha-probability-verification-with-blockchain-and-YOLO
