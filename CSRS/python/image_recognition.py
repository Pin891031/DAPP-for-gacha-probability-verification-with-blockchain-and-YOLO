import os
#import time

#while True:
    # 切換到 yolov5 資料夾
os.chdir(r"C:\CSRS\yoloGPU1\yolov5")

    # 執行 detect.py
os.system("python detect.py --weight /runs/train/exp8/weights/best.pt --source C:/CSRS/yoloGPU1/pic_in/*.jpg")

    # 切換回原始工作目錄
os.chdir(r"C:\CSRS\python")

    # 暫停 5 秒
    #time.sleep(60)