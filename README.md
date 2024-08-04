# Bash Script - Backend Project

That is a simple script in bash for setting up a backend nodejs and express folders in a fast way

## While installing it, you will be prompted to decide which dependencies you'd like to use for your project. Including:

-  Eslint
-  Modules or commonJS
-  ORMs: Mongoose (noSQL) / Prisma (SQL) 

Do not forget to give it execution permissions with chmod +x

~~~
chmod +x setup.sh
~~~

After doing so, you can create an alias or add it to your binaries for easing execution from any folder

~~~
sudo mv setup.sh /usr/local/bin/setup
~~~


*For execution you should change the name my-app for the name of your application or project*

~~~
setup my-app
~~~

*In case, you prefer to set an alias (change .bashrc to .zshrc in case your terminal is a ZSH)*
**Be aware that /path/to/ needs to be modified according to your local routes and preferences**

~~~
nano ~/.bashrc
~~~

~~~
alias setup="~/path/to/setup.sh"
~~~

*You can rename setup alias for the one more convenient to you.*

~~~
source ~/.bashrc
~~~
