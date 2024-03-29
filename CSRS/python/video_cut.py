import cv2
import os

# 輸入資料夾路徑
input_folder = r'C:\CSRS\tmp\origin_vedio'
# 輸出資料夾路徑
output_folder = r'C:\CSRS\tmp\origin_image'
os.makedirs(output_folder, exist_ok=True)  

# 取得資料夾中的所有影片檔案
video_files = [f for f in os.listdir(input_folder) if f.endswith('.mp4')]

for video_file in video_files:
    # 影片檔案路徑
    video_path = os.path.join(input_folder, video_file)
    video_name = os.path.splitext(os.path.basename(video_path))[0]

    cap = cv2.VideoCapture(video_path)
    is_black_screen = False
    pic = 1

    if not cap.isOpened():
        print(f"無法開啟影片檔案 {video_path}")
        continue  # 如果無法開啟影片，跳過這個影片

    while True:
        ret, frame = cap.read()

        if not ret:
            print(f"影像讀取完畢 {video_path}")
            break

        average_brightness = cv2.mean(frame)[0]

        if average_brightness <= 20:
            is_black_screen = True        
            waiting_frames = int(cap.get(cv2.CAP_PROP_FPS) * 1.67)

            for _ in range(waiting_frames):
                ret, _ = cap.read()
        else:
            if is_black_screen:
                # 刪除之前的截圖
                for i in range(1, pic):
                    previous_screenshot_path = os.path.join(output_folder, f'{video_name}_{i}.jpg')
                    if os.path.exists(previous_screenshot_path):
                        os.remove(previous_screenshot_path)
                        print(f"刪除影像 {previous_screenshot_path}")        

                # 儲存擷取到的影像
                output_path = os.path.join(output_folder, f'{video_name}_{pic}.jpg')
                cv2.imwrite(output_path, frame)
                print(f"已儲存影像 {output_path}")
                pic += 1
                is_black_screen = False

        #cv2.imshow('影片播放', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # 釋放 VideoCapture 物件
    cap.release()

# 關閉所有視窗
cv2.destroyAllWindows()