import whisper
import sys
import requests
from nvidia_smi import * 
import time
_GPU = False
_NUMBER_OF_GPU = 0

def check_gpu():
    global _GPU
    global _NUMBER_OF_GPU
    nvmlInit()
    _NUMBER_OF_GPU = nvmlDeviceGetCount()
    if _NUMBER_OF_GPU > 0:
        _GPU = True
check_gpu()
def _bytes_to_megabytes(bytes):
    return round((bytes/1024)/1024,2)
def get_gpu_usage(detailed=False):
    result = []
    if not detailed:
        for i in range(_NUMBER_OF_GPU):
            handle = nvmlDeviceGetHandleByIndex(i)
            deviceName = nvmlDeviceGetName(handle).decode()
            memInfo= nvmlDeviceGetMemoryInfo(handle)
            result.append({
                "name": deviceName,
                "memory": f"{round ( memInfo.total / (1024*1024*1024) )}GB"
            })
    return result

gpuResult = get_gpu_usage()


args = sys.argv
target = args[1]
modelName = args[2]
device = args[3]
print("target: " + target)
print("model: " + modelName)
print("device: " + device)
if(device == "cpu"):
    model = whisper.load_model(modelName, device="cpu", download_root="/model/")
if(device == "cuda"):
    model = whisper.load_model(modelName, device="cuda", download_root="/model/")
if(device == "mgpu"):
    model = whisper.load_model(modelName, device="cpu", download_root="/model/")
    model.encoder.to("cuda:0")
    model.decoder.to("cuda:1")
    model.decoder.register_forward_pre_hook(lambda _, inputs: tuple([inputs[0].to("cuda:1"), inputs[1].to("cuda:1")] + list(inputs[2:])))
    model.decoder.register_forward_hook(lambda _, inputs, outputs: outputs.to("cuda:0"))

time_sta = time.time()
result = model.transcribe(f"/samples/{target}.m4a")
time_end = time.time()
tim = time_end- time_sta


response = requests.post('https://pmqcli47r5xxsa4lvj4onvcmeq0gsyju.lambda-url.ap-northeast-1.on.aws/', json={
    "target": target,
    "model": modelName,
    "device": device,
    "time": tim,
    "gpu": gpuResult
})