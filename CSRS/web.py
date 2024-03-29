from flask import Flask, render_template, jsonify, request, send_file
from web3 import Web3
from concurrent.futures import ThreadPoolExecutor
from scipy.stats import binom
import os
import subprocess
import numpy as np

app = Flask(__name__)

infura_url = '' #Infura節點
account_metamask = '' # metamask 合約帳號address
contract_address = '' #合約地址
contract_abi = [] #智能合約的ABI

ALLOWED_EXTENSIONS = {'jpg', 'jpeg', 'png', 'mp4'} 
UPLOAD_FOLDER = r'C:\CSRS\tmp\uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
IMAGE_DIRECTORY = "C:/CSRS/static/IPFSTmp"
ROLE_IMAGE_DIRECTORY = "C:/CSRS/static/RoleImg"

web3 = Web3(Web3.HTTPProvider(infura_url))

contract = web3.eth.contract(address=contract_address, abi=contract_abi)
   
def allowed_file(filename): #檢查副檔名
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route("/api/starCount", methods=["GET"]) #從區塊鏈提取星數出貨量
def get_starCount():
    data = {
        "one_star_count": contract.functions.totalOneStarCount().call(),
        "two_star_count": contract.functions.totalTwoStarCount().call(),
        "three_star_count": contract.functions.totalThreeStarCount().call(),
    }
    return jsonify(data)
 
@app.route("/api/upload", methods=["POST"]) #上傳檔案到伺服器
def upload_file():
    if 'file[]' not in request.files:
        return render_template('upload.html', message='No file part')

    files = request.files.getlist('file[]')

    for file in files:
        if file.filename == '':
            return render_template('upload.html', message='請選擇檔案')

        if file and allowed_file(file.filename):
            if not os.path.exists(app.config['UPLOAD_FOLDER']):
                os.makedirs(app.config['UPLOAD_FOLDER'])
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], file.filename))
        else:
            return render_template('upload.html', message='檔案格式錯誤，請確認上傳檔案為jpg、jpeg、png、mp4')

    subprocess.Popen(["python", "C:/CSRS/python/start_all.py"])
    return render_template('upload.html', message='檔案成功上傳，數據進入區塊鏈需要三到五分鐘請耐心等待')

@app.route("/api/cids", methods=["GET"]) #從區塊鏈提取全部CID
def get_cid():
    
    all_cids = contract.functions.getAllCids().call()

    return jsonify(all_cids)
      
@app.route('/api/getImage', methods=['GET']) #從伺服器提取IPFS緩存
def getImage():
    image_id = request.args.get('id')
    if image_id == "":
        image_path = os.path.join(IMAGE_DIRECTORY, f"wrong.jpg")
    else:
        image_path = os.path.join(IMAGE_DIRECTORY, f"{image_id}.jpg")

    if os.path.exists(image_path):
        return send_file(image_path, mimetype='image/jpg')
    else:
        return jsonify({'error': 'Image not found'}), 404
        
@app.route('/api/getRolesImage', methods=['GET']) #從伺服器提取角色頭像
def getRolesImage():
    image_id = request.args.get('id')
    if image_id == "":
        image_path = os.path.join(ROLE_IMAGE_DIRECTORY, f"wrong.jpg")
    else:
        image_path = os.path.join(ROLE_IMAGE_DIRECTORY, f"{image_id}.jpg")

    if os.path.exists(image_path):
        return send_file(image_path, mimetype='image/jpg')
    else:
        return jsonify({'error': 'Image not found'}), 404

@app.route('/api/allRolesCount') #從區塊鏈提取全部角色出貨量
def getAllCounts():
    getUploaddata = contract.functions.getAllCounts().call()
    return jsonify(getUploaddata)


@app.route("/api/bino") #二項分布累積函數
def get_bino():

    one_star_count = contract.functions.totalOneStarCount().call()
    two_star_count = contract.functions.totalTwoStarCount().call()
    three_star_count = contract.functions.totalThreeStarCount().call()

    ans=''
    time =  int(one_star_count) + int(two_star_count) + int(three_star_count)
    success = int(three_star_count)
    success_chance = 0.03
    #輸出高於中獎n+1次機率
    
    if binom.cdf(success, time, success_chance)>=0.05:
        ans+="在可接受範圍內\n"
    else:
        ans+="低於給定機率\n"
           
    ans+="根據二項分布，每"+str(time)+"抽\n"    
    ans+="剛好抽出"+str(success)+"次的機率為"+str(np.format_float_positional(binom.pmf(success, time, success_chance)*100,trim = '-'))+"%\n"
    ans+="小於等於"+str(success)+"次的機率為"+str(np.format_float_positional(binom.cdf(success, time, success_chance)*100,trim = '-'))+"%\n"
    
    return jsonify(ans)


if __name__ == '__main__':
    app.run(debug=True)