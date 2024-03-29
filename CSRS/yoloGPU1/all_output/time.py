import os
import subprocess
import time
import shutil

def run_all_output():
    subprocess.run(["python", r"C:\yoloGPU1\all_output\all_output.py"])

def run_vedio_cut():
    subprocess.run(["python", r"C:\yoloGPU1\all_output\video_cut.py"])
    
def upload_to_IPFS():
    subprocess.run(["python", r"C:\yoloGPU1\all_output\uploadToIPFS.py"])
    
def run_pic_in_start():
    subprocess.run(["python", r"C:\yoloGPU1\all_output\pic_in_start.py"])
    
def run_result_to_word():
    subprocess.run(["python", r"C:\yoloGPU1\all_output\result_to_word.py"])

def run_result_to_word_all():
    subprocess.run(["python", r"C:\yoloGPU1\all_output\result_to_word_all.py"])
    
def run_delete():
    subprocess.run(["python", r"C:\yoloGPU1\all_output\delete.py"])
    
def run_delete_w():
    subprocess.run(["python", r"C:\yoloGPU1\all_output\delete_w.py"])
    
def uploadToBC():
    subprocess.run(["python", r"C:\uploadToBC\test.py"])  

def write_to_log(message):
    with open("log.txt", "a") as log_file:
        log_file.write(message + "\n")

def write_to_log(message):
    with open("log.txt", "a") as log_file:
        log_file.write(message + "\n")

def clear_folder(folder_path):
    try:
        # 使用 shutil.rmtree 來移除資料夾及其內容
        shutil.rmtree(folder_path)
        # 再次建立空的資料夾
        os.makedirs(folder_path)
        print(f"資料夾 {folder_path} 已成功清空。")
    except Exception as e:
        print(f"清空資料夾 {folder_path} 時發生錯誤：{e}")
        
def main():
    for number in range(100):
        write_to_log("times: {}".format(number + 1))

        all_start_time = time.time()
        
        start_time = time.time()
        run_all_output()
        run_vedio_cut()
        spend_time = time.time() - start_time
        write_to_log("影片分離並將影片擷取結果: {:.2f} seconds".format(spend_time))

        start_time = time.time()
        upload_to_IPFS()
        spend_time = time.time() - start_time
        write_to_log("上傳至IPFS: {:.2f} seconds".format(spend_time))

        start_time = time.time()
        run_pic_in_start()
        spend_time = time.time() - start_time
        write_to_log("影像辨識: {:.2f} seconds".format(spend_time))

        start_time = time.time()
        run_result_to_word()
        spend_time = time.time() - start_time
        write_to_log("將影像辨識結果轉換為文字檔: {:.2f} seconds".format(spend_time))

        # Repeat the above pattern for the remaining functions

        start_time = time.time()
        run_delete()
        run_delete_w()
        spend_time = time.time() - start_time
        write_to_log("清理完成檔案並將原始圖片緩存: {:.2f} seconds".format(spend_time))

        start_time = time.time()
        uploadToBC()
        spend_time = time.time() - start_time
        write_to_log("將抽卡結果上傳至區塊鏈: {:.2f} seconds".format(spend_time))
        
        all_spend_time = time.time() - all_start_time
        write_to_log("總花費時間: {:.2f} seconds".format(all_spend_time))

        clear_folder(r"C:\yoloGPU1\picture")
        clear_folder(r"C:\yoloGPU1\wordTxt_uploaddone")
        clear_folder(r"C:\yoloGPU1\all_output\ok_word")
        shutil.move(r"C:\final\ok_pv\QmWAgP6K1m4NfED37hwro2C8BhsoBwFdb6BP8ngoSFZ85z.jpg", r"C:\yoloGPU1\all_in")

if __name__ == "__main__":
    main()
