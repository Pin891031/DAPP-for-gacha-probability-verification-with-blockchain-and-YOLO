import requests
import json
import os
import glob
import shutil

def upload_file_to_ipfs(file_path):
    try:
        # 透過發送 POST 請求上傳文件
        upload_url = 'http://127.0.0.1:5001/api/v0/add'
        files = {'file': (os.path.basename(file_path), open(file_path, 'rb'))}
        response = requests.post(upload_url, files=files)

        if response.status_code == 200:
            response_data = json.loads(response.text)
            return response_data['Hash']
        else:
            print(f"上傳文件到 IPFS 失敗: {response.text}")
            return None
    except Exception as e:
        print(f"上傳文件到 IPFS 失敗: {str(e)}")
        return None

# 將文件重命名為 CID 並保留檔案擴展名
def rename_file_to_cid(file_path, cid):
    try:
        file_dir, file_name = os.path.split(file_path)
        base_name, file_extension = os.path.splitext(file_name)
        new_file_name = f"{cid}.jpg"
        return new_file_name
    except Exception as e:
        print(f"重命名文件失敗: {str(e)}")
        return None

# 上傳文件到 IPFS 並移動並重命名
def upload_move_and_rename_file(file_path, destination_folder):
    cid = upload_file_to_ipfs(file_path)
    if cid:
        new_file_name = rename_file_to_cid(file_path, cid)
        if new_file_name:
            new_file_path = os.path.join(destination_folder, new_file_name)
            shutil.move(file_path, new_file_path)
            return new_file_path
    return None

# 上傳文件夾中的所有圖片文件
def upload_all_images_in_folder(folder_path, destination_folder):
    image_files = glob.glob(os.path.join(folder_path, '*'))  # 更改擴展名以匹配您的圖片文件
    for image_file in image_files:
        new_file_path = upload_move_and_rename_file(image_file, destination_folder)
        if new_file_path:
            print(f"文件已上傳到 IPFS，並移動到 {destination_folder}，CID 為: {os.path.basename(new_file_path)}")
        else:
            print(f"文件 {image_file} 上傳到 IPFS 失敗。")

# 示範使用
if __name__ == "__main__":
    source_folder = r"C:\CSRS\tmp\origin_image"  # 替換為您的源文件夾路徑
    destination_folder = r"C:\CSRS\yoloGPU1\pic_in"  # 替換為您的目標文件夾路徑
    upload_all_images_in_folder(source_folder, destination_folder)
