---
title: "Setting Up Your Environment"
date: 2025-04-15
permalink: /tutorials/setup/
layout: single
author_profile: true  
classes:
  -inner-page
  -header-image-readability
header:
  overlay_image:  /assets/images/tutorials/tutorials-banner.webp
  overlay_filter: rgba(0, 0, 0, 0.5)
caption: "Photo credit: [**Unsplash**](https://unsplash.com)"
excerpt: " Prerequsites and Installation Guidelines"
toc: true
toc_label: "Setting Up Topics"
toc_icon: "question-circle"
---

# Setting Up Your Environment

This comprehensive guide will walk you through creating the optimal development environment for working with AI and Large Language Models (LLMs).

## Prerequisites

Before you begin, ensure you have:
- A computer with at least 8GB RAM (16GB+ recommended)
- Administrator/sudo access to your system
- Basic familiarity with command line interfaces

## Installing Python

LLM development typically requires Python 3.8 or newer.

### Windows Installation

1. **Download Python:**
   - Visit [python.org](https://python.org)
   - Download the latest Python 3.x installer
   - Ensure you check "Add Python to PATH" during installation

2. **Verify Installation:**
   ```
   python --version
   ```

### macOS Installation

1. **Using Homebrew (recommended):**
   ```
   brew install python
   ```

2. **Alternative Method:**
   - Download from [python.org](https://python.org)
   - Run the installer package

3. **Verify Installation:**
   ```
   python3 --version
   ```

### Linux Installation

Most Linux distributions come with Python pre-installed. If not:

```
sudo apt update
sudo apt install python3 python3-pip
```

Verify with:
```
python3 --version
```

## Setting Up Virtual Environments

Virtual environments keep dependencies organized and prevent conflicts.

### Creating a Virtual Environment

```
# Install virtualenv if not already installed
pip install virtualenv

# Create a new environment
virtualenv llm_env

# Activate the environment
# On Windows:
llm_env\Scripts\activate

# On macOS/Linux:
source llm_env/bin/activate
```

### Using Conda (Alternative)

1. **Install Miniconda:**
   - Download from [conda.io](https://docs.conda.io/en/latest/miniconda.html)
   - Follow installation instructions

2. **Create a Conda Environment:**
   ```
   conda create -n llm_env python=3.10
   conda activate llm_env
   ```

## Installing Essential Libraries

With your environment activated, install these core packages:

```
pip install numpy pandas matplotlib scikit-learn torch transformers datasets
```

For additional LLM-specific tools:

```
pip install accelerate bitsandbytes sentencepiece tokenizers
```

## GPU Setup (Optional but Recommended)

### NVIDIA GPU Setup

1. **Install CUDA Toolkit:**
   - Download from [NVIDIA Developer site](https://developer.nvidia.com/cuda-downloads)
   - Follow installation instructions for your OS

2. **Install cuDNN:**
   - Register at NVIDIA Developer Program
   - Download and install cuDNN

3. **Install PyTorch with CUDA support:**
   ```
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
   ```
   (Adjust CUDA version as needed)

4. **Verify GPU availability:**
   ```python
   import torch
   print(f"CUDA available: {torch.cuda.is_available()}")
   print(f"CUDA device count: {torch.cuda.device_count()}")
   print(f"CUDA device name: {torch.cuda.get_device_name(0)}")
   ```

### AMD GPU Setup

For AMD GPUs, use ROCm:

1. **Install ROCm:**
   - Follow instructions at [ROCm Documentation](https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html)

2. **Install PyTorch with ROCm support:**
   ```
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.4.2
   ```

## IDE Setup

Choose a development environment that suits your workflow:

### VS Code (Recommended)

1. **Install VS Code:**
   - Download from [code.visualstudio.com](https://code.visualstudio.com/)

2. **Install extensions:**
   - Python extension
   - Jupyter extension
   - IntelliCode
   - Pylance

3. **Configure settings:**
   - Set your Python interpreter to your virtual environment
   - Enable linting and formatting

### PyCharm

1. **Install PyCharm:**
   - Download Community Edition from [jetbrains.com](https://www.jetbrains.com/pycharm/)

2. **Configure Python interpreter:**
   - File > Settings > Project > Python Interpreter
   - Add your virtual environment

3. **Install plugins:**
   - Jupyter
   - .env file support

### Jupyter Notebooks

For exploratory work:

```
pip install jupyter
jupyter notebook
```

## Version Control Setup

1. **Install Git:**
   - [git-scm.com](https://git-scm.com/)

2. **Configure Git:**
   ```
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

3. **Connect to GitHub/GitLab:**
   - Generate SSH key:
     ```
     ssh-keygen -t ed25519 -C "your.email@example.com"
     ```
   - Add key to GitHub/GitLab account

## Model Caching and Storage

Configure Hugging Face cache location:

```
# On Windows
setx HF_HOME "D:\AI\huggingface"

# On macOS/Linux
echo 'export HF_HOME="/path/to/storage"' >> ~/.bashrc
source ~/.bashrc
```

## Testing Your Environment

Create a simple test script:

```python
# test_environment.py
import sys
import torch
import transformers

print(f"Python version: {sys.version}")
print(f"PyTorch version: {torch.__version__}")
print(f"Transformers version: {transformers.__version__}")

# Test loading a small model
from transformers import pipeline
classifier = pipeline('sentiment-analysis', device=0 if torch.cuda.is_available() else -1)
result = classifier("This environment setup is working great!")
print(result)
```

Run it:
```
python test_environment.py
```

## Troubleshooting Common Issues

### Package Installation Failures

- Update pip: `pip install --upgrade pip`
- Install build tools:
  - Windows: `pip install wheel`
  - Linux: `sudo apt install build-essential`

### CUDA Not Detected

- Verify CUDA installation: `nvcc --version`
- Check GPU compatibility
- Ensure matching CUDA toolkit and PyTorch versions

### Memory Issues

- Close unnecessary applications
- Use smaller model variants
- Enable model optimization techniques like quantization


## Next Steps

Now that your environment is set up, you're ready to:

- Explore our [Basic Customization](/tutorials/basic-customization/) tutorial
- Learn advanced capabilities in our [Advanced Features](/tutorials/advanced-features/) tutorial

## Happy developing!