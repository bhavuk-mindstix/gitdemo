# User Guide

This document provides some general guidance about how to use *teamengine-integration-testing* to 
execute a shell script through command line.

##Steps

1. Start the WEB Server 
       
            $ ./catalina.sh 
    
2. Open terminal and navigate to the directory "teamengine-integration-testing"/directory created by you 

            for ex - $ cd ~/repo/teamengine-inregration-testing
     
3. To execute shell script we have to pass following parameters :

# Parameters


- -f: path of the jmeter scripts folders. If not provided it will use the current working directory
- -u: path of URL where TEAM Engine is installed
- -user: User name.If not provided will use default *ogctest*
- -password:User password. If not provided will use *ogctest*

            for ex - $ ./run-test.sh -user admin -password admin123 -u http://localhost:8080/teamengine/ -f ~/repo/teamengine-integration-testing/
    
In the end of execution shell script writes the final result in index.html. 
