# Deep-Visualization-Toolbox-Container
This Respository provides a Dockerfile to create a container for the Deep Visualization Toolbox by Yosinski with the improvements of Poznanski.

## Original Repositories
This Dockerfile directly uses the repository of Arik Poznanski, who improves the Deep Visualization Toolbox of Jason Yosinski.
You can find Poznanskis toolbox at the following link:  
https://github.com/arikpoz/deep-visualization-toolbox  
The original toolbox repository by Yosinski can you find here:  
https://github.com/yosinski/deep-visualization-toolbox

Yosinski has also published a paper on his software:
```
@inproceedings{yosinski-2015-ICML-DL-understanding-neural-networks,
Author = {Jason Yosinski and Jeff Clune and Anh Nguyen and Thomas Fuchs and Hod Lipson},
Booktitle = {Deep Learning Workshop, International Conference on Machine Learning (ICML)},
Title = {Understanding Neural Networks Through Deep Visualization},
Year = {2015}}
```

In contrast to Poznanskis repository this Dockerfile the original caffe repository by BVLC.
The version by Poznanski can you find here:  
https://github.com/arikpoz/caffe/  
The official version by BVLC can you find here:  
https://github.com/BVLC/caffe  

## Why use this Dockerfile or Container
For the docker container we merge current master branch of the official caffe into the master branch of Poznanskis caffe version by using git (without any commit or push, so it's only local).
Cause of this you get the newest caffe version with every modifications needed for the toolbox.
This allows you to use modern Cuda an operating system instead of outdated versions.
So we get a better compatibility for newer networks.

## Get the Docker Container
The explained methods are created for Linux systems (specially for Ubuntu) with full X11-Server installed (like most desktop systems) and Nvidia GPU included.
The use on other systems may vary.

### Prerequirements
You can install every prerequirements of this repository by following the first four steps of section A of this article:  
https://medium.com/@sh.tsang/very-quick-setup-of-caffenet-alexnet-for-image-classification-using-nvidia-docker-2-0-c3b75bb8c7a8  
You don't need to do the steps in section B.  

For method 2 you also need git installed.
On Ubuntu you can easily install ist with:
```
sudo apt-get install git
```

### Method 1: Get prebuilded Docker Container (recommended)
This is the easiest way to install the toolbox.
You only have to run the container with your docker distribution and it will download the ready configured software.
For this use the following command:  
```
docker run --runtime=nvidia -it \
	-p 8888:8888 \
	-e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /home/user/dvtb:/home/developer/work \
	--device /dev/nvidia0:/dev/nvidia0 \
	--device /dev/nvidiactl:/dev/nvidiactl \
	--device /dev/nvidia-uvm:/dev/nvidia-uvm \
	--device /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools \
	--device /dev/nvidia-modeset:/dev/nvidia-modeset \
	--name dvtb-arikpoz \
	holululu/dvtb-arikpoz-gpu
```
The first parameter says docker that it have to run with nvidia runtime, so you can use the GPU for calculating.
The `-p 8888:8888` reserves 8888 as port for localhost to come into the container by using tools like jupyter.
This parameter is optional.
With `-e DISPLAY=$DISPLAY` you set the environment variable DISPLAY of the container to the one of your host system.
In next line `-v /tmp/.X11-unix:/tmp/.X11-unix` we set a volume to mount. In this case it is the .X11-unix directory of the host and mount it in same location in container.
This two steps are needed to get the GUI of the toolbox visible on your screen without installing full X11 in container.
`-v /home/user/dvtb:/home/developer/work` mounts another directory from host to container.
This one is intended for easy data exchange between host system and container, so you get easily get your new models in container by copying the files in /home/user/dvtb on the host.
Then you can use it in container in directory /home/developer/work.
The next block of `--device` options is used to make all parts of the GPU available for the container. This can differ between different devices. So, you should use the command `ls -la /dev | grep nvidia` to get a list of all your nvidia devices and add them instead of this block. This is easy, just add `--device /dev/device:/dev/device` for every device you get in the list.
The `--name dvtb-arikpoz` is just to give the created container a name for a more easy start and exec.
Last but not least you give docker the name of the docker-hub-repository there you want to get the conatiner from.
This is the prebuilded conatiner associated with this github-repository.  
Congratulations, you have installed the toolbox and can now get into your container.  

Tip:
After logout you have to start the container by `docker start dvtb-arikpoz` and then execute the bash to get in by `docker start -it dvtb-arikpoz`.

### Method 2: Build the Docker Container by your own
This method only a bit more complicated than the first one and you can use the newest version of caffe but it's more risky because docker have to download, install and compile many things from the scratch.  

First you have to clone this repository with git:
```
git clone https://github.com/HoLuLuLu/Deep-Visualization-Toolbox-Container
```
Change into it and let docker build the container:
```
cd Deep-Visualization-Toolbox-Container
docker build -t dvtb .
```
You can change the name of the image by using the one you want instead of dvtb.
Now you have to wait while docker builds the new image.
This may take a while.
Don't let you shock by some red lines on the screen, this are mostly warnings or just informations.
If you get an error docker aborts the build process and show you the message.  

After you have build the image completely you can check your docker local image list by:
```
docker images
```
You will see an image named dvtb (or the name you chose above).
You can run a new container using the same command as in method 1:
```
docker run --runtime=nvidia -it \
	-p 8888:8888 \
	-e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /home/user/dvtb:/home/developer/work \
	--device /dev/nvidia0:/dev/nvidia0 \
	--device /dev/nvidiactl:/dev/nvidiactl \
	--device /dev/nvidia-uvm:/dev/nvidia-uvm \
	--device /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools \
	--device /dev/nvidia-modeset:/dev/nvidia-modeset \
	--name dvtb-arikpoz \
	dvtb
```
The explaination of this command can you read in method 1.
Note that the `--device` options may vary in different systems.
So, use `ls -la /dev | grep nvidia` to get all of your nvidia devices to use.
After it you are in the bash of your container.  

Have Fun.

## Run and Configure the Toolbox
Everything in this section happens in the directory /opt/deep-visualization-toolbox of the container.

## First Run
Before you can start the toolbox the first time you have to adjust the user settings (see section "Configure User Settings").
There is an template with default values.
So, you only have to rename it with:
```
cp settings_user.py.example settings_user.py
```
If you want to use the default settings you only have to run the toolbox by:
```
./run_toolbox.py
```
Otherwise you can change it with a texeditor of your choice.
In the container there is no editor installed by default, so you have to do it for your own.  
This are the installation commands for three popular texteditors in Ubuntu, chose one of them:
```
sudo apt-get install gedit # GUI-based easy-to-use editor and userfriendly (requires much memory)
sudo apt-get install nano  # Terminal-based easy-to-use editor without mouse control, basic and efficient
sudo apt-get install vim   # Terminal-based editor with big functionality but hard for beginner
```
For more information about user settings see section "Configure User Settings" below.

### Configure User Settings
The user specific settings are saved in the settings_user.py file in the root folder of the toolbox.
There are some simple options you can configure:  

| Option   |      Values   |  Description |
|------------------------------|:-------------:|----------------------------------------------------|
| caffevis_mode_gpu |  True or False | If True, the toolbox runs on GPU, else on CPU. |
| caffevis_gpu_id |    device number   |   Sets the device id of the computation device (mostly the GPU). |
| model_to_load | String with model name |  This sets the name of the model, which would be loaded by the toolbox. There have to exist also a settings_modelname.py in model_settings directory of the toolbox with model specific settings. |
| input_updater_capture_device | device number or None |  Sets the device id of a camera, which can be used as input stream in the toolbox. If you don't have or want to use it, just set the value to None. |
