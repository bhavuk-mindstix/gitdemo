# Introduction
The repository contains code and instructions to test TEAM Engine with selected Executable Test Scripts and Reference Implementations and files.

# Test Suites that can be tested

The following test suites can be tested again existing reference implementation or reference implementation files

- CSW 2.0.2 (done)
- CAT 3.0 
- GML 3.2.1 (Partially)
- SOS 1.0.0 (done)
- WCS 2.0
- WFS 1.0
- WFS 1.1
- WFS 2.0
- WMS 1.1.1
- WMS 1.3 (done)

Reference Implementations are listed [here](https://github.com/opengeospatial/cite/wiki/Reference-Implementations)

# Parameters


- -f: path of the jmeter scripts folders. If not provided it will use the current working directory
- -u: path of URL where TEAM Engine is installed
- -user: User name.If not provided will use default *ogctest*
- -password:User password. If not provided will use *ogctest*





# Example

En example invocation of the script is as follows:

	./shellscript.sh -user admin -password admin123 -u http://localhost:8080/teamengine/ -f ~/repo/teamengine-integration-testing/
 
* test.properties : This file contains the xml or sch file path and revision number which user wish to test.<br/>

# Configuration

Under teamengine-integration-testing directory there is a *test.properties* file. These file is a properties file that contains the URL that will be tested and the version of the test. Except for:


- gml32-POST: which you need to provide 3 arguments: GML resource file name, schematron file name and revision of the test. Both GML resource file and schematron file should be located under the gml32-POST directory

**Note-**

- Before executing this script we required the following plugins:

	- Need to install xmllint .
	- Import the "Property File Reader" extension into jmeter package.

 
