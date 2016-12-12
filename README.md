# README

* Ruby version 
    * See .ruby-version and .ruby-gemset. Let's keep it updated.

* System dependencies
    * Ubuntu 14.04, nginx, mysql, rvm.
    * `sudo apt-get install libmysqlclient-dev`
    * Install `therubyracer` manually on the server.
    * Install `imagemagick`
    
* Development instructions
    * We use mailcatcher to handle mails: https://mailcatcher.me/. Other configurations needed:
        * Sign in with an admin user and under `Configurations` tab select `General Settings`
        * Change site url to localhost:3000        

* Deployment instructions
    * We use capistrano to handle deployments.
    * Turn on key forwarding: https://developer.github.com/guides/using-ssh-agent-forwarding/
    * For server setup please follow this: https://www.digitalocean.com/community/tutorials/deploying-a-rails-app-on-ubuntu-14-04-with-capistrano-nginx-and-puma
        
    * [TODO] More detailed description.
    
* Deployment
    * Get hold of `application.yml`. If you have access to server, use: `cap <env> config:pull`
    * After config changes: `cap <env> config:push`
    * deploy: `cap <env> deploy`
