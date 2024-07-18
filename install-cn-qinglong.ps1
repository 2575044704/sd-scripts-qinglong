$Env:HF_HOME = "huggingface"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1
$Env:PIP_NO_CACHE_DIR = 1
$Env:PIP_INDEX_URL = "https://pypi.mirrors.ustc.edu.cn/simple"
$Env:HF_ENDPOINT = "https://hf-mirror.com"
function InstallFail {
    Write-Output "��װʧ�ܡ�"
    Read-Host | Out-Null ;
    Exit
}

function Check {
    param (
        $ErrorInfo
    )
    if (!($?)) {
        Write-Output $ErrorInfo
        InstallFail
    }
}

if (!(Test-Path -Path "venv")) {
    Write-Output "���ڴ������⻷��..."
    python -m venv venv
    Check "�������⻷��ʧ�ܣ����� python �Ƿ�װ����Լ� python �汾�Ƿ�Ϊ64λ�汾��python 3.10����python��Ŀ¼�Ƿ��ڻ�������PATH�ڡ�"
}

.\venv\Scripts\activate
Check "�������⻷��ʧ�ܡ�"

Set-Location .\sd-scripts
Write-Output "��װ������������ (�ѽ��й��ڼ��٣����ڹ�����޷�ʹ�ü���Դ�뻻�� install.ps1 �ű�)"
$install_torch = Read-Host "�Ƿ���Ҫ��װ Torch+xformers? ��������Ϊ�״ΰ�װ��ѡ�� y ��������Ϊ����������װ��ѡ�� n��[y/n] (Ĭ��Ϊ y)"
if ($install_torch -eq "y" -or $install_torch -eq "Y" -or $install_torch -eq ""){
    pip install torch==2.3.0+cu121 torchvision==0.18.0+cu121 -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html
    Check "torch ��װʧ�ܣ���ɾ�� venv �ļ��к��������С�"
    pip install --no-deps xformers==0.0.26.post1
    Check "xformers ��װʧ�ܡ�"
}

pip install --upgrade -r requirements.txt
Check "����������װʧ�ܡ�"
pip install --upgrade dadaptation
Check "Lion��dadaptation �Ż�����װʧ�ܡ�"
pip install --upgrade --pre lycoris-lora -i https://pypi.org/simple
Check "lycoris ��װʧ�ܡ�"
pip install --upgrade fastapi uvicorn scipy
Check "UI ����������װʧ�ܡ�"
pip install --upgrade wandb
Check "wandb ��װʧ�ܡ�"
pip install --upgrade --no-deps pytorch-optimizer
Check "pytorch-optimizer ��װʧ�ܡ�"
pip install --upgrade schedulefree -i https://pypi.org/simple
Check "schedulefree ��װʧ�ܡ�"

Set-Location ../
$download_hy = Read-Host "�Ƿ�����hunyuanģ��? ����Ҫ����ģ��ѡ�� y ��������Ҫѡ�� n��[y/n] (Ĭ��Ϊ n)"
if ($download_hy -eq "y" -or $download_hy -eq "Y"){
    huggingface-cli download --resume-download bdsqlsz/HunYuanDiT-V1.2-fp16-pruned --local-dir Stable-diffusion/HunYuanDiT_fp16 --local-dir-use-symlinks False
}

Write-Output "��װ���"
Read-Host | Out-Null ;
