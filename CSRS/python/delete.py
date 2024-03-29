import os
import shutil

def move_files_with_extensions(source_folders, destination_folder, extensions):
    # 確保目標資料夾存在，如果不存在，則創建
    if not os.path.exists(destination_folder):
        os.makedirs(destination_folder)

    for source_file in source_folders:
        for root, dirs, files in os.walk(source_file):
            for file in files:
                # 取得檔案的完整路徑
                file_path = os.path.join(root, file)

                # 檢查檔案擴展名是否在指定的擴展名清單中
                if any(file.lower().endswith(ext) for ext in extensions):
                    # 移動檔案到目標資料夾
                    shutil.move(file_path, os.path.join(destination_folder, file))
                    print(f"Moved: {file_path} to {destination_folder}")

# 指定要移動的擴展名清單
extensions_to_move = ['.png', '.jpg', '.jpeg', '.mp4', '.txt']

# 指定要處理的資料夾路徑
source_folders_to_process = [
    r"C:\CSRS\yoloGPU1\pic_in",
    r"C:\CSRS\tmp\origin_vedio",
]

# 指定目標資料夾
destination_folder = r"C:\CSRS\static\IPFSTmp"

# 呼叫函式移動指定擴展名的檔案
move_files_with_extensions(source_folders_to_process, destination_folder, extensions_to_move)