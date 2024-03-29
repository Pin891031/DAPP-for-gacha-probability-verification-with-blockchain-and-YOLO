import json
import re
from web3 import Web3
import dict
import os
import glob
import shutil

# 變數
infura_url_goerli = ''  #連接節點
account_metamask = '' #錢包帳戶
private_key = '' #錢包私鑰
address='' #合約地址
abi=json.loads('') #合約abi
totalcount_file_path = 'totalcount.txt'
target_folder_path = r"C:\CSRS\yoloGPU1\wordTxt"
destination_path = r"C:\CSRS\yoloGPU1\wordTxt_uploaddone"


#============================#

def setData():
    # 構建交易
    tx = star.functions.setStarData(totalcount, star1, star2, star3, allcname, cid).build_transaction({
        'from': account_metamask,
        'nonce': nonce,
        'gas': 3000000
    })
    #print(totalcount)

    # 簽名並發送交易
    signed_tx = web3.eth.account.sign_transaction(tx, private_key=private_key)
    tx_hash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)

    #獲得 Transaction ID:
    setData_TID = tx_hash.hex()
    print(f"setData 的 Transaction ID: {tx_hash.hex()}")

    receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
    return setData_TID

def uploadData():
    # 構建交易
    tx = star.functions.increaseCounts(uploadAllcname).build_transaction({
        'from': account_metamask,
        'nonce': nonce+1,
        'gas': 3000000
    })

    # 簽名並發送交易
    signed_tx = web3.eth.account.sign_transaction(tx, private_key=private_key)
    tx_hash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)

    #獲得 Transaction ID:
    uploadData_TID = tx_hash.hex()
    print(f"uploadData 的 Transaction ID: {tx_hash.hex()}")

    receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
    return uploadData_TID

def updateTotalCount():
    global totalcount
    totalcount += 1
    with open(totalcount_file_path, 'w') as totalcount_file:
        totalcount_file.write(str(totalcount))

def getCid():
    get_cid = star.functions.getCid(3).call()
    print(f"cid為 : {get_cid}")

#============================#

# 獲取目標資料夾中的所有.txt檔案路徑
txt_files = glob.glob(os.path.join(target_folder_path, "*.txt"))

for txt_file_path in txt_files:
    fileName = os.path.basename(txt_file_path)
    if os.path.isfile(destination_path+"/"+fileName):
        os.remove(txt_file_path)
    else:
        # 讀取.txt檔案
        with open(txt_file_path, 'r', encoding='utf-8', errors='replace') as file:
            content = file.read()
        cid = os.path.splitext(os.path.basename(txt_file_path))[0]
        # 統計
        lines = content.split('\n')
        star_probabilities = {'1Star': 0.0, '2Star': 0.0, '3Star': 0.0}
        name_counts = {}

        for line in lines:
            if '總抽數：' in line:
                total_draws = int(line.split('：')[1])
            elif '1星機率：' in line:
                star_probabilities['1Star'] = float(re.search(r'\d+\.\d+', line).group())
            elif '2星機率：' in line:
                star_probabilities['2Star'] = float(re.search(r'\d+\.\d+', line).group())
            elif '3星機率：' in line:
                star_probabilities['3Star'] = float(re.search(r'\d+\.\d+', line).group())
            elif '出現了' in line:
                parts = line.split(' ')
                name = parts[0]  # 抓角色名稱
                count = int(parts[-2])  # 抓出現幾次
                name_counts[name] = count

        # 統計结果
        star1 = name_counts.get('1Star', 0)
        star2 = name_counts.get('2Star', 0)
        star3 = name_counts.get('3Star', 0)

        allcname = ""  # 存所有角色名稱
        uploadAllcname = ""  # 存所有角色名稱代號
        name_list = []

        for name, count in name_counts.items():
            if name not in star_probabilities and name != '總抽數：':
                name_list.extend([name] * count)  # 讓出現複數次的角色可以重複紀錄

        allcname = ','.join(name_list)  # 每個名子間加上逗號

        # 將 allcname 分割成名字 list
        name_list = allcname.split(',')

        # 名子 => 編號
        card_number_list = [dict.convertNametoCardNumber(name) for name in name_list]

        # 移除錯誤名子
        card_number_list = [card_number for card_number in card_number_list if card_number is not None]

        # 把編號轉list
        uploadAllcname = card_number_list
        uploadAllcname = list(uploadAllcname)

        # 創建 Web3 連接
        web3 = Web3(Web3.HTTPProvider(infura_url_goerli))

        # 讀上次的 totalcount 值 (讀檔)
        try:
            with open(totalcount_file_path, 'r') as totalcount_file:
                totalcount = int(totalcount_file.read())
        except FileNotFoundError:
            totalcount = 1

        nonce = web3.eth.get_transaction_count(account_metamask)

        star = web3.eth.contract(address,abi)

        print(f'connection check: {web3.is_connected()}')
        
                       
        updateTotalCount()
        print(cid)
        setData()
        uploadData()
        getCid()
        shutil.move(txt_file_path, destination_path)
        
        

  