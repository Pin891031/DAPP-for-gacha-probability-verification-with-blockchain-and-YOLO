import os
import subprocess

def vedio_cut():
    subprocess.run(["python", r"C:\CSRS\python\video_cut.py"])
    
def upload_to_IPFS():
    subprocess.run(["python", r"C:\CSRS\python\uploadToIPFS.py"])
    
def image_recognition():
    subprocess.run(["python", r"C:\CSRS\python\image_recognition.py"])
    
def run_result_to_word():
    subprocess.run(["python", r"C:\CSRS\python\result_to_word.py"])
    
def run_delete():
    subprocess.run(["python", r"C:\CSRS\python\delete.py"])
    
def run_delete_w():
    subprocess.run(["python", r"C:\CSRS\python\delete_w.py"])
    
def upload_to_BC():
    subprocess.run(["python", r"C:\CSRS\python\upload_to_BC.py"])  


def main():
    vedio_cut()
    upload_to_IPFS()
    image_recognition()
    run_result_to_word()
    run_delete()
    run_delete_w()
    upload_to_BC()

if __name__ == "__main__":
    main()