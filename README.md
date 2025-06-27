## 💡 Motivation

While working on deep learning projects, I realized that **environment setup** is often the most frustrating and time-consuming part.  

To streamline this process, I built a ready-to-use **Docker environment** based on **Ubuntu 22.04** with **CUDA 11.8** support.  
This setup allows you to skip the hassle of **dependency conflicts** and focus directly on **model development and experimentation**. 😎


## 🚀 Features

- ✅ One-command Docker setup with optional dataset mounting  
- ✅ Automatic image build if not found  
- ✅ Easy volume linking using `___DATASETS___.list`  
- ✅ Automatically links `requirements.txt` into container  
- ✅ CUDA 11.8 + Ubuntu 22.04 base for maximum compatibility  

---


## 🛠️ Usage


### 1️⃣ Add your dataset path  

If you already have datasets stored on your machine, just write their paths in `___DATASETS___.list`
Edit the `___DATASETS___.list` file to include the absolute paths to your datasets(e.g., coco, VOC...), one per line.  

```cmd
___DATASETS___.list
/home/yourname/datasets/my_coco_dataset
/mnt/data/datasets/balloon_dataset
/mnt/data2/VOC_dataset
```

Each will be mounted inside the container under:

```container
/workspace/DATASETS/<dataset_name>
```


---

### 2️⃣ Run the container  

```cmd
bash run.sh -v /path/to/your_project_dir
```

The `-v` option specifies the **host directory** to be mounted as the container’s working directory (`/workspace`).  
This is where your code and project files will be accessible inside the container.  

> 💡 If you omit the `-v` option, your **current working directory** will be mounted by default.


---

### 3️⃣ Access the container  

Once the container is running, you can enter it using:

```bash
docker exec -it ubuntu22.04_cuda11.08_container bash
```

<details>
<strong>📦 Container Structure</strong>

```text
📁 /  # root
└── 📁 workspace
    ├── 📁 DATASETS
    │   ├── 📁 coco_example
    │   └── 📁 <another_dataset>
    │
    ├── 📁 <your_project_dir>   # e.g., Ultralytics, mmdetection
    └── 📄 requirements.txt     # symlinked automatically
```

</details>

- `/workspace` → your working directory  
- `/workspace/DATASETS/<dataset_name>` → dataset mounted via `___DATASETS___.list`  


---

### 4️⃣ Enjoy your deep learning development env! 😎
