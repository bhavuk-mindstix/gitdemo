#!/bin/sh
dir=$(pwd)

printHelp(){
echo "---------"
echo "-f		:	path of jmeter script"
echo "-u		:	path of URL"
echo "-user		:	User name"
echo "-password	:	User password"
echo "---------"
exit 0
}
if [ "$1" = "-h" -o "$1" = "--help" ]; then
printHelp
fi 

while [ "$1" ]; do
  key="$1"

  case $key in
       -f)
      folder_of_jmeter="$2"
      shift
      ;;
      -u)
      url="$2"
      shift
      ;;
      -user)
      user="$2"
      shift
      ;;
      -password)
      password="$2"
      shift
      ;;
  esac
  shift
done 

echo "--------------------------------------------------"
echo ""

##-------Check jmeter is installed or not
type jmeter >/dev/null 2>&1 || { echo >&2 "[Error] Jmeter not found.... \n apache-jmeter-2.13 needs to be installed in the system or under the users default directory. ";  exit 0; }


		##----------UserName --------------#
		if [ $user ];
		then
			echo "Using UserName: " $user
		else 
			echo "UserName was not provided, default 'ogctest' will be used."
		fi
	
		##----------Password --------------#
		if [ $password ];
		then
			echo "Using Password: " $password
		else 
			echo "Password was not provided,default 'ogctest' will be used."
		fi

		##-------Folder of JMeter --------------#
		if [ ! $folder_of_jmeter ];
		then
			folder_of_jmeter=$dir
			echo "Path of jmeter script was not provided then,'Current working Directory' will be used: '$folder_of_jmeter '" 
		else 
			echo "Using path of jmeter script: " '$folder_of_jmeter'
		fi

		##------URL -----------------#
		if [ ! $url ];
		then
			url="http://cite.opengeospatial.org/te2/"
			echo "URL was not provided then default will be used: " $url
		else 
			echo "URL is using: " $url
		fi

		##---------------------------#
echo ""
echo "--------------------------------------------------"

		i=0
		port=""
		testurl=$(echo $url | tr "/" "\n")
		set -- $testurl
		server=$(echo $1 | tr ":" "\n")
		warName=/$3/	
		
		if echo $2 | grep -q ":";
		then
			urlid=$(echo $2 | tr ":" "\n")
			set -- $urlid
			host=$1
			port=$2
			
		else
			host=$2
		fi
		
		#—————— Remove Files if already exist ———————#
		if [ -f "index.html" ]
		then
			rm index.html
		fi

		if [ -f "savedata" ]
		then																																																																						
			rm savedata
		fi

		if [ -d "result" ]
		then
			rm -rf result
		fi
		#rm index.html
		#rm savedata
		#rm -rf result
		#———————————————————————————————————————

		directory=`ls -F1 ${folder_of_jmeter} | grep /`
		
		now=$(date +"%Y/%m/%d  %H:%M:%S")
		echo "<b>TE integration testing - </b>$now" >> index1.html
		echo "<BR/><b>URL :</b> $url<BR/>" >> index1.html

jmeter -n -t $folder_of_jmeter/teamenginePlan.jmx -Juser=$user -Jpassword=$password -Jserver=$server -Jhost=$host -Jport=$port -Jwarname=$warName -Jurl=$url

	#————Get TE-VERSION ———————#
	
		teVersion=$(cat -n $folder_of_jmeter/savedata | grep "&lt;p&gt;" | tail -2)
		teVersion=${teVersion#*&gt;}
		teVersion=${teVersion%&lt;\/p*}
				
		finalresult="PASS"
		echo "<BR/><b>TE version :</b> $teVersion" >> index1.html

	#——————————————————————————-#

	#————— Get the TE-BUILD and Registration Result ————#

		teBuild1=$(cat $folder_of_jmeter/${var}savedata | grep 'lb="teamenginetestResult"')
		teBuild=$(echo $teBuild1 | cut -d " " -f6 )

		#teRegister1=$(cat $folder_of_jmeter/${var}savedata | grep -Po 'lb="registrationTest" rc="\K.*?(?=")')
		teRegister1=$(cat $folder_of_jmeter/${var}savedata | grep 'lb="registrationTest"')
		teRegister=$(echo $teRegister1 | cut -d " " -f6 )
		
		echo "<BR/><b>Default build  :</b> " >> index1.html
		if echo $teBuild | grep -q "200";
		then 
			echo "SUCCESS">> index1.html
		else
			echo "FAILED">> index1.html
			finalresult="FAIL"
		fi

		echo "<BR/><b>User can be created and logins   :</b> " >> index1.html

		if echo $teRegister | grep -q "200";
		then 
			echo "SUCCESS<BR/>">> index1.html
		else
			echo "FAILED<BR/>">> index1.html
			finalresult="FAIL"
		fi
	#————————————————————————————————————————————————————#


	#-----------------GET The Target Platform -----------------------------------------------#

		echo "<BR/><b>Target Platform  :</b> <BR />" >> index1.html
		echo "<BR /> &nbsp;&nbsp;&nbsp;&nbsp; <b> OS : </b> <BR />" >> index1.html
		
		#—————— GET Ubuntu System info —————————
	if hash cat /etc/os-release 2>/dev/null; then
		if echo $(cat /etc/os-release) | grep -iq "ubuntu";
		then

			os_version=$(cat /etc/os-release | grep "NAME\|VERSION" | head -2)
			os_var=$(echo $os_version | awk -F" " '{print $1,$2,$3}')
			set -- $os_var
			echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $1 <BR /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $2 $3  <BR />" >> index1.html

		fi
	fi	
		#—————— GET Mac System info —————————
	if hash sw_vers 2>/dev/null; then
		if echo $(sw_vers) | grep -iq "mac";
		then
			sw_vers >> data
			iname=data
  
		while read line; do  
		if [ -z "$line" ]; then
    			echo "I saw an empty line ... will report this"
		else    
    			echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $line <BR />"  >> index1.html
		fi
		done <"$iname"
		rm data

		else

			echo "Failed  to get system info..."

		fi
	fi
		#———————————Get java version———————————————#

		echo "<BR /> &nbsp;&nbsp;&nbsp;&nbsp; <b> JAVA : </b> <BR />" >> index1.html


		(java -version 2>&1) >> temp

		iname=temp  #Should be no space between = sign
		while read line; do  
		if [ -z "$line" ]; then
    			echo "I saw an empty line ... will report this"
		else    
    			echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $line <BR />"  >> index1.html
		fi
		done <"$iname"
		rm temp

        #------------------GET Target Paltform END--------------------------------------------------#

	#——— Get the list of directory and execute the JMeter script ————————#
  
	for var in $directory
	do
		if [ "$var" != "REST_API/" ]; then
			
			#———Check the ‘savedata’ file is exist ———#	
	
			if [ -f "$folder_of_jmeter/${var}savedata" ]
			then
				rm $folder_of_jmeter/${var}savedata
			fi



jmeter -n -t $folder_of_jmeter/${var}test.jmx -Juser=$user -Jpassword=$password -Jserver=$server -Jhost=$host -Jport=$port -Jwarname=$warName -Jurl=$url

		result1=$(cat $folder_of_jmeter/${var}savedata | grep 'lb="checkResult"')
		result=$(echo $result1 | cut -d " " -f6 )

		formResult1=$(cat $folder_of_jmeter/${var}savedata | grep 'lb="formResult"')
		formResult=$(echo $formResult1 | cut -d " " -f6 )

		testName=$(cat $folder_of_jmeter/${var}savedata | grep 'tn="' | tail -1 | awk -v FS='(tn="|")' '{print $14}' )
		echo "<BR/><b>Test Name :</b> " >> index1.html
		echo $testName |  cut -d " " -f1 >> index1.html

		#——————- Get the Revision Version from the savedata ——————-#

		string=$(xmllint --xpath "//testResults/httpSample[@lb='formResult']/java.net.URL" $folder_of_jmeter/${var}savedata )
		split_string=$(echo $string | awk -F"&amp;" '{print $1,$2,$3}')
		set -- $split_string
		split_string1=$(echo $3 | awk -F"_" '{print $1,$2,$3,$4}')
		set -- $split_string1
		echo " $3 revision $4" >> index1.html
		echo "<BR/><b>Test can be run  :</b> " >> index1.html
		
		#———- Check FormResult is success or fail ———#
 
		if echo $formResult | grep -q "200";
		then 
			echo "SUCCESS">> index1.html
		else
			echo "FAILED">> index1.html
			finalresult="FAIL"
		fi

		echo "<BR/><b>Test run finishes successfully  :</b> " >> index1.html

		#——- Check Test result ————————-#
		
		if echo $result | grep -q "200";
		then 
			echo "SUCCESS<BR/>">> index1.html
		else
			echo "FAILED<BR/>">> index1.html
			finalresult="FAIL"
		fi
		
		#----------Check assertion for GML-test -----------------------

		if echo $var | grep -q "gml" || echo $var | grep -q "kml" && [ "$var" != "gml32-doc/" ] ; then
		
			assertion_status=$(xmllint --xpath "//testResults/httpSample/assertionResult/failure/text()" $folder_of_jmeter/${var}savedata)
			   
			if echo $assertion_status | grep -q "false"; then
				
				echo "<b>Test completed as expected (FAILED) :</b> " >> index1.html 
			else
				if echo $assertion_status | grep -q "true"; then
					echo "<b>Test completed as expected (PASSED) :</b> " >> index1.html
				fi
			fi

			if echo $result | grep -q "200"; then
 
				echo "SUCCESS<BR/>">> index1.html
			else
				echo "FAILED<BR/>">> index1.html
				
			fi
		
		fi
	fi
done

	#----------REST API Testing -----------------------

		echo "<BR />--------------- REST API Testing ----------- <BR />" >> index1.html

		rest_directory=`ls -F1 ${folder_of_jmeter}/REST_API | grep /`

	for rest_var in $rest_directory
	do
		
		#———Check the ‘savedata’ file is exist ———#

		if [ -f "$folder_of_jmeter/REST_API/${rest_var}savedata" ]
		then
			rm $folder_of_jmeter/REST_API/${rest_var}savedata
		fi

		#———Check the ‘testresult’ file is exist ———#

		if [ -f "$folder_of_jmeter/REST_API/${rest_var}testresult" ]
		then
			rm $folder_of_jmeter/REST_API/${rest_var}testresult
		fi


jmeter -n -t $folder_of_jmeter/REST_API/${rest_var}test.jmx -Jserver=$server -Jhost=$host -Jport=$port -Jwarname=$warName

		rest_result=$(cat $folder_of_jmeter/REST_API/${rest_var}savedata | grep 'lb="HTTP_Request"' | awk -v FS='(rc="|")' '{print $12}')

		rest_testname=$(cat -n $folder_of_jmeter/REST_API/${rest_var}savedata |  grep "&lt;suite duration-ms" | tail -2 | awk -v FS='(name=&quot;|&quot;)' '{print $6}')
			
		echo "<BR/><b>REST Test Name :</b> $rest_testname" >> index1.html
		echo "<BR/><b>REST Test run finishes successfully  :</b> " >> index1.html

		#—————— Check the REST Result ———————————————#

		if echo $rest_result | grep -q "200";
		then 
			echo "SUCCESS<BR/>">> index1.html
		else
			echo "FAILED<BR/>">> index1.html
			finalresult="FAIL"
		fi
		
		if [ "$rest_var" = "gml32-POST/" ]; then
		
		#-------------Check expected result is failed or passed -------------------------
		#tr -d "null" < $folder_of_jmeter/REST_API/${rest_var}testresult > $folder_of_jmeter/REST_API/${rest_var}testresults

		#mv -bfv $folder_of_jmeter/REST_API/${rest_var}testresults $folder_of_jmeter/REST_API/${rest_var}testresult >/dev/null 2>&1
		
		sed -i '/null/d' $folder_of_jmeter/REST_API/${rest_var}testresult
		gml32_post=$(xmllint --xpath "string(//test-method/@status)" $folder_of_jmeter/REST_API/${rest_var}testresult)
	
			echo "<b>Test completed as expected (FAIL) :</b> " >> index1.html 
			if echo $gml32_post | grep -q "FAIL"; then
				
				echo "SUCCESS<BR/>">> index1.html
			else
				
				echo "FAILED<BR/>">> index1.html
				
			fi
		
		#----------- Expected Result END -----------#		
		
		echo "<BR/><b>Following is the Result :</b> <BR/> <pre>" >> index1.html

			while read line; do    
		      		encodeData=$(echo "$line" | perl -MHTML::Entities -pe 'encode_entities($_)') 
				echo "$encodeData<br/>" >> index1.html

			done < $folder_of_jmeter/REST_API/${rest_var}testresult

		echo "</pre>" >> index1.html
		fi
	done


	#--------------------------------------------------

		mkdir result
		if echo $finalresult | grep -q "PASS";
		then
			echo "<b>Final Result :</b> SUCCESS<BR/><BR/>" >> index.html
			echo -n "" > result/SUCCESS
		else
			echo "<b>Final Result :</b> FAILED<BR/><BR/>" >> index.html
			echo -n "" > result/FAIL
		fi

		index1=$(cat index1.html)
		echo $index1 >> index.html

		if [ -f "index1.html" ]
		then
			rm index1.html
		fi

#——————————————————————————————— End of Test Script —————————————————————————————————————————————————————#
