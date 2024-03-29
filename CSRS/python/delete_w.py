import os
import shutil

def move_files(source_folder, destination_folder):
    # 確保目標資料夾存在，如果不存在，則創建
    if not os.path.exists(destination_folder):
        os.makedirs(destination_folder)

    # 遍歷源資料夾中的所有檔案
    for file in os.listdir(source_folder):
        # 檢查檔案擴展名是否為 .txt
        if file.lower().endswith('.txt'):
            # 構建完整的檔案路徑
            source_file_path = os.path.join(source_folder, file)

            # 移動檔案到目標資料夾
            shutil.move(source_file_path, os.path.join(destination_folder, file))
            print(f"Moved: {source_file_path} to {destination_folder}")

# 指定要處理的資料夾路徑
source_folder_to_process = r"C:\CSRS\yoloGPU1\result"

# 指定目標資料夾
destination_folder = r"C:\CSRS\yoloGPU1\all_output\ok_word"

# 呼叫函式移動所有 .txt 檔案
move_files(source_folder_to_process, destination_folder)