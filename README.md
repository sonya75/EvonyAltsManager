# EvonyAltsManager

To use this you will need a webserver and MySQL database. In windows, you can install xampp to get them.

Once you have a webserver and a MySQL database running, create a user for the MySQL database and a database for this app to use and give the user full permission to the database.

Clone this repository or download it as a zip and extract it in some folder in your webserver. For this app to work, all the files in this repository will need to be in a folder named EvonyAltsManager-master. Once you have done it, open the link to the index.php file in the folder in your browser. There you will first have to create an admin username and a password which this app will store and when you want to change its settings, you will have to use that username and password. Once the username and password is created, you will be refirected to a page where you will need to enter the MySQL database name, the name of the user you created in the MySQL database and its password.

Once you are done, open the link to the update.php file in your browser. It will update it to the current version using GitHub and update the RE script in the REscript folder to make it usable.

At last, you will need to run the following script in RE to send updates to your server and you can see the updates by opening the link to the index.html file your browser.

```
//In the following line replace url_here by the link to the generatestatus.as file in the 
//REscript folder without http or https at the beginning, like 
//for example:- http://www.example.com/EvonyAltsManager-master/REscript/generatestatus.as

includeurl url_here
```
