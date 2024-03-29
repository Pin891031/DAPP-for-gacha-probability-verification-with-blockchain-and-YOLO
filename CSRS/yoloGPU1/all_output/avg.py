def calculate_average(log_file_path):
    try:
        with open(log_file_path, 'r') as log_file:
            lines = log_file.readlines()

        # 儲存每個功能的執行時間
        run_all_output_times = []
        run_vedio_cut_times = []
        upload_to_IPFS_times = []
        run_pic_in_start_times = []
        run_result_to_word_times = []
        run_delete_times = []
        run_delete_w_times = []
        uploadToBC_times = []
        all_times = []

        for line in lines:
            if "run_all_output spend time" in line:
                run_all_output_times.append(float(line.split(":")[1].split(" ")[1]))
            elif "run_vedio_cut spend time" in line:
                run_vedio_cut_times.append(float(line.split(":")[1].split(" ")[1]))
            elif "upload_to_IPFS spend time" in line:
                upload_to_IPFS_times.append(float(line.split(":")[1].split(" ")[1]))
            elif "run_pic_in_start spend time" in line:
                run_pic_in_start_times.append(float(line.split(":")[1].split(" ")[1]))
            elif "run_result_to_word spend time" in line:
                run_result_to_word_times.append(float(line.split(":")[1].split(" ")[1]))
            elif "run_delete spend time" in line:
                run_delete_times.append(float(line.split(":")[1].split(" ")[1]))
            elif "run_delete_w spend time" in line:
                run_delete_w_times.append(float(line.split(":")[1].split(" ")[1]))
            elif "uploadToBC spend time" in line:
                uploadToBC_times.append(float(line.split(":")[1].split(" ")[1]))
            elif "all spend time" in line:
                all_times.append(float(line.split(":")[1].split(" ")[1]))

        # 計算平均值
        avg_run_all_output = sum(run_all_output_times) / len(run_all_output_times)
        avg_run_vedio_cut = sum(run_vedio_cut_times) / len(run_vedio_cut_times)
        avg_upload_to_IPFS = sum(upload_to_IPFS_times) / len(upload_to_IPFS_times)
        avg_run_pic_in_start = sum(run_pic_in_start_times) / len(run_pic_in_start_times)
        avg_run_result_to_word = sum(run_result_to_word_times) / len(run_result_to_word_times)
        avg_run_delete = sum(run_delete_times) / len(run_delete_times)
        avg_run_delete_w = sum(run_delete_w_times) / len(run_delete_w_times)
        avg_uploadToBC = sum(uploadToBC_times) / len(uploadToBC_times)
        avg_all = sum(all_times) / len(all_times)

        # 列印結果
        print("Average run_all_output spend time:", avg_run_all_output, "seconds")
        print("Average run_vedio_cut spend time:", avg_run_vedio_cut, "seconds")
        print("Average upload_to_IPFS spend time:", avg_upload_to_IPFS, "seconds")
        print("Average run_pic_in_start spend time:", avg_run_pic_in_start, "seconds")
        print("Average run_result_to_word spend time:", avg_run_result_to_word, "seconds")
        print("Average run_delete spend time:", avg_run_delete, "seconds")
        print("Average run_delete_w spend time:", avg_run_delete_w, "seconds")
        print("Average uploadToBC spend time:", avg_uploadToBC, "seconds")
        print("Average all spend time:", avg_all, "seconds")

    except Exception as e:
        print("Error:", e)

# 呼叫函數計算平均值
calculate_average("log.txt")
