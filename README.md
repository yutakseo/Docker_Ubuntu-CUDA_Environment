## 💡 Motivation

While working on deep learning projects, I realized that **environment setup** is often the most frustrating and time-consuming part.  

To streamline this process, I built a ready-to-use **Docker environment** based on **Ubuntu 22.04** with **CUDA 11.8** support.  This setup allows you to skip the hassle of **dependency conflicts** and focus directly on **model development and experimentation**. 😎


## 🚀 Features
- ✅ One-command Docker setup with optional dataset mounting
- ✅ Automatic image build if not found
- ✅ Easy volume linking using `___DATASETS___.list`
- ✅ Automatically links `requirements.txt` into container
- ✅ CUDA 11.8 + Ubuntu 22.04 base for maximum compatibility

---

## 🛠️ Usage

### 1. Add your dataset path
If you already have datasets stored on your machine, just write their paths in `___DATASETS___.list`
Edit the `___DATASETS___.list` file to include the absolute paths to your datasets(e.g., coco, VOC...), one per line.  
```___DATASETS___.list
/home/yourname/datasets/my_coco_dataset
/mnt/data/datasets/balloon_dataset
```
Each will be mounted under `/workspace/DATASETS/<dataset_name>` in the container.


### 2. Run the container
```bash
bash run.sh -v /path/to/your_project_dir
```
The -v option specifies the host directory you want to mount as the container’s working directory (/workspace).
This is where your project files will live inside the container. if you don't specify your host working directory, It would automatically mount on your present working directory.


### 3. Inside the container
```bash
docker exec -it ubuntu22.04_cuda11.08_container bash
```
Container Structure
📁 / #root
└── 📁 workspace
    ├── 📁 DATASETS
    │ ├─── 📁 coco_example
    │ └─── 📁 <another_dataset>
    │
    ├── 📁 <your_project_dir> # e.g., Ultralytics, mmdetection
    └── 📄 requirements.txt # symlinked automatically
    
- `/workspace` → your working directory  
- `/workspace/DATASETS/<dataset_name>` → dataset mounted via `___DATASETS___.list`

### 4. Enjoy your deep-learning Development Env 😎



