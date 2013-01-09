#!/bin/bash

python_installed=`python -V 2>&1`
numpy_installed=`pip freeze 2>/dev/null | grep numpy`
hostname=`hostname`

function create_dir ( )
{
	if [[ -d "/var/log/macs2_installation" ]]; then
		echo -e "$hostname:\n  - Log file directory exists ... skip creating dir ... continuing the installation"
		echo ""
	else
		sudo mkdir -p /var/log/macs2_installation
		echo -e "$hostname:	\n  -Log file directory has been created.\n  -You can access log files: /var/log/macs2_installation"
		echo ""
	fi	
}


function python_install ( )
{
	cd 
    #get python
    #mkdir python2.7.3
    #cd python2.7.3
    wget http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2
    tar -xvf Python-2.7.3.tar.bz2
    cd Python-2.7.3
	#install python
	./configure
	make -j
	sudo make install
	#configure some python options
	sudo chmod ag+w /usr/local/lib/python2.7/site-packages
	sudo chmod ag+wx /usr/local/bin
	date=`date`
    echo "$date : Python 2.7.3 is installed" >> /var/log/macs2_installation/python_log
    #remove downloaded files
	cd
	rm -rf Python-2.7.3
}

function numpy_install ( )
{
	#install numpy
	git clone git://github.com/numpy/numpy.git numpy
	cd numpy
	python setup.py build
	python setup.py install
	date=`date`
	echo "$date : python package - numpy 1.3.0 is installed" >> /var/log/macs2_installation/numpy_log
}



#Function calls
#====================================

create_dir

#Python: log installation outputs to logfile and also send them back to main concole to update users
if [ "$python_installed" == "Python 2.7.3" ]; 
then
    date=`date`
    echo -e "$hostname:\n   -Python 2.7.3 has been installed. Don't need to install python!"
    echo ""
    echo "$date : Python 2.7.3 has been installed. Don't need to install python!" >> /var/log/macs2_installation/python_log
else
	echo "Installing $python_installed on $hostname. It may take a few minutes ..."
	echo ""
	#Call python_install function to install dependencies
	python_install >> /var/log/macs2_installation/python_install.log 2>> /var/log/macs2_installation/python_error.log 
	echo "Installation of macs2 dependencies on $hostname completed ..."
	echo ""
fi

#Numpy: log installation outputs to logfile and also send them back to main concole to update users
if [ "$numpy_installed" == "numpy==1.3.0" ]; 
then
	date=`date`
	echo -e "$hostname:\n   -python package - numpy 1.3.0 has been installed. Don't need to install numpy!"
	echo ""
	echo "$date : python package - numpy 1.3.0 has been installed. Don't need to install numpy!" >> /var/log/macs2_installation/numpy_log
else
	echo "Installing $numpy_installed on $hostname. It may take a few minutes ..."
	echo ""
	#Call numpy_install function to install dependencies 
	numpy_install >> /var/log/macs2_installation/numpy_install.log 2>> /var/log/macs2_installation/numpy_error
	echo "Installation of macs2 dependencies on $hostname completed ..."
	echo ""
fi


