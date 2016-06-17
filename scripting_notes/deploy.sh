#!/bin/sh

##############################################################
##  
##  
##  
##  
##############################################################


echo "Changing directory to /opt/webapps/clearboxstudios"
cd /opt/webapps/clearboxstudios


echo ""
echo "Clearing tmp"
bundle exec rake tmp:clear
echo ""
echo "Clearing log"
bundle exec rake log:clear
echo ""
echo "Cleaning assets"
bundle exec rake assets:clean
echo ""
echo "Precompiling"
bundle exec rake assets:precompile RAILS_ENV=production
echo ""
echo "Restarting nginx"
sudo /etc/init.d/nginx restart
echo ""
echo "Restarting Phusion"
touch ./tmp/restart.txt

