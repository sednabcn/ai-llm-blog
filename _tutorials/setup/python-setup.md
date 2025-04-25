---
title: "Python Setup"
date: 2025-04-15
layout: single
permalink: /tutorials/setup/python-setup/
author_profile: true
collection: tutorials
classes:
  - inner-page
  - header-image-readability
header:
    overlay_color: "#333"
    overlay_filter: "0.7"
    overlay_image: /assets/images/tutorials/python-setup-banner.png
#caption: "Photo credit: [**Unsplash**](https://unsplash.com)"
excerpt: "Get your Python environment ready for AI projects with this step-by-step tutorial."
tags:
  - python
  - setup
  - installation
toc: true
toc_label: "Contents"
toc_icon: "list"
---

{% assign category = site.data.tutorial_categories | where: "id", "setup" | first %}
{% assign tutorial = category.items | where: "id", "python-setup" | first %}

<div class="breadcrumbs">
  <a href="{{ site.baseurl }}/">Home</a> &raquo; 
  <a href="{{ site.baseurl }}/tutorials/">Tutorials</a> &raquo; 
  <a href="{{ site.baseurl }}/tutorials/setup/">{{ category.name }}</a> &raquo; 
  <span>{{ tutorial.name }}</span>
</div>

# Python Setup

This comprehensive guide will walk you through creating the optimal development environment for working with AI and Large Language Models (LLMs).

## Prerequisites

Before you begin, ensure you have:

- A computer with at least 8GB RAM (16GB+ recommended)
- Administrator/sudo access to your system
- Basic familiarity with command line interfaces
- At least 5GB of free disk space
- A reliable internet connection

## Installing Python

LLM development typically requires Python 3.8 or newer.

```bash
# For Ubuntu/Debian
sudo apt update
sudo apt install python3.11 python3-pip

# For macOS with Homebrew
brew install python@3.11

# For Windows
# Download from python.org and run the installer
```

## Setting Up Virtual Environments

It's recommended to use virtual environments for your projects:

```bash
# Create a virtual environment
python -m venv myenv

# Activate on Windows
myenv\Scripts\activate

# Activate on macOS/Linux
source myenv/bin/activate
```

## Installing Essential Libraries

With your environment activated, install the necessary packages:

```bash
pip install numpy pandas matplotlib scikit-learn torch transformers
```

## GPU Setup (Recommended)

For optimal performance with machine learning models:

### NVIDIA GPU Setup
```bash
# Install CUDA toolkit and cuDNN
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```

### AMD GPU Setup
```bash
# For ROCm support
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
```

## IDE Setup

### VS Code (Recommended)
1. Download from code.visualstudio.com
2. Install Python extension
3. Configure for your virtual environment

### PyCharm
1. Download Community or Professional edition
2. Set up interpreter pointing to your virtual environment

## Common Issues and Troubleshooting

If you encounter issues during installation, here are some common problems and solutions:

### Path Issues on Windows
Ensure Python is added to your PATH environment variable during installation.

### Package Installation Errors
Try upgrading pip first: `pip install --upgrade pip`
