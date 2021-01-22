sudo cp add_user.sh /home/iek
sudo cp add_admin_user.sh /home/iek
sudo cp update_jupyterhub_config_then_restart.sh /home/iek
sudo cp jupyterhub_config.py /home/iek
sudo chown iek:iek /home/iek/*.sh
sudo chown iek:iek /home/iek/*.py
sudo chmod +x /home/iek/*.sh
sudo chmod +x /home/iek/*.py