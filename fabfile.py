#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import *
from fabric.contrib.files import exists, upload_template

# CONFIGURATION -----------------------------------------------------------------

# User to login as when installing to server.
env.user = 'ryanshaw'

# Path to install directory.
env.path = '/db/projects/linkedevents'

# Path to Apache virtualhosts config directory.
env.vhosts_path = '/etc/httpd/sites.d'

# Email address of server administrator.
env.admin_email = 'ryanshaw@ischool.berkeley.edu'

# TASKS -------------------------------------------------------------------------

def deploy():
    """
    Deploy the latest version of the site to the servers, install any
    required third party modules, install the virtual host and then
    restart the webserver.
    """
    if not exists(env.path):
        run('mkdir -p %(path)s' % env)
        with cd(env.path):
            run('virtualenv --no-site-packages .')
            run('mkdir -p packages')
    import time
    env.release = time.strftime('%Y%m%d%H%M%S')
    upload_tar_from_git()
    install_requirements()
    install_site()
    
# Helpers. These are called by other functions rather than directly. ------------

def upload_tar_from_git():
    "Create an archive from the current Git master branch and upload it."
    require('release', provided_by=[deploy])
    local('git archive --format=tar master | gzip > %(release)s.tar.gz' % env)
    put('%(release)s.tar.gz' % env, '%(path)s/packages/' % env)
    run('cd %(path)s && tar zxf packages/%(release)s.tar.gz' % env)
    local('rm %(release)s.tar.gz' % env)

def install_requirements():
    "Install the required packages from the requirements file using pip"
    run('export SAVED_PIP_VIRTUALENV_BASE=$PIP_VIRTUALENV_BASE; unset PIP_VIRTUALENV_BASE; ' +
        'cd %(path)s; ./bin/pip install -E . -r requirements.txt; ' % env +
        'export PIP_VIRTUALENV_BASE=$SAVED_PIP_VIRTUALENV_BASE; unset SAVED_PIP_VIRTUALENV_BASE')

def install_site():
    "Add the virtualhost file to apache."
    upload_template('linkedevents.conf.template', '%(path)s/linkedevents.conf' % env, env)
    with cd(env.vhosts_path):
        sudo('rm -f linkedevents.conf' % env, pty=True)
        sudo('ln -s %(path)s/linkedevents.conf' % env, pty=True)

