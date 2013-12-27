########################################
# some definitions to clean up the logic
########################################

# call command on karaf shell
karaf () {
    if [ "$LOCAL" = "FALSE" ]
    then
        ssh -oStrictHostKeyChecking=no script@${TARGET_HOST} sshpass -p smx ssh smx@localhost -p 8101 "$@"
    else
        sshpass -p smx ssh -oStrictHostKeyChecking=no smx@localhost -p 8101 "$@"
    fi
}


# print installed version of a feature passed as argument
installed_version () { karaf features:list | grep $1 | perl -n -e 's/\[installed.*?(\d\.\S*).*/$1/ && print'; }

# get latest available version for given groupId and artefactId
latest_version() {
    GROUP_ID=`echo $1 | tr '.' '/'`;
    wget -O - http://nexus.colo.elex.be:8081/nexus/content/groups/public-snapshots$MAVEN_REPO_ROOT/${GROUP_ID}/$2/maven-metadata.xml | grep '<latest>' | perl -n -p -e 's/.*<latest>(.*)<\/latest>.*/$1/';
}

# get installed repository URL for given groupId and artefactId
installed_url() {
      karaf features:listUrl | perl -n -e "s#(mvn:$1/$2/\d\.\S*/xml/features).*#\$1# && print"    ;
}

# display the content of the log after installation
display_karaf_log () {
   karaf log:display | grep -v sshd
}


# check if a bundle passed as parameter was successfully started
check_bundle_started() {
   karaf list \
   | perl -n -e 'm/^\[\s*(\d*)\] \[(\S*)\s*\] \[(\S*)\s*\] \[(\S*)\s*\] \[\s*(\d*)\] (.*) \((\S*)\)\s*$/ && $4 eq "Started" && print "$1, $2, $3, $4, $5, $6, $7\n"' \
   | grep "$1";
}

# check if a bundle passed as parameter was successfully activated
check_bundle_active() {
   karaf list \
   | perl -n -e 'm/^\[\s*(\d*)\] \[(\S*)\s*\] \[(\S*)\s*\] \[(\S*)\s*\] \[\s*(\d*)\] (.*) \((\S*)\)\s*$/ && $2 eq "Active" && print "$1, $2, $3, $4, $5, $6, $7\n"' \
   | grep "$1";
}

# check if a bundle passed as parameter was successfully activated
check_bundle_resolved() {
   karaf list \
   | perl -n -e 'm/^\[\s*(\d*)\] \[(\S*)\s*\] \[(\S*)\s*\] \[(\S*)\s*\] \[\s*(\d*)\] (.*) \((\S*)\)\s*$/ && $2 eq "Resolved" && print "$1, $2, $3, $4, $5, $6, $7\n"' \
   | grep "$1";
}


# get installed version of a bundle
get_bundle_version () {
   karaf list \
   | grep $1  \
   | grep $2  \
   | perl -n -e 'm/^\[\s*(\d*)\] \[(\S*)\s*\] \[(\S*)\s*\] \[(\S*)\s*\] \[\s*(\d*)\] (.*) \((\S*)\)\s*$/ && print "$1"'
}

# unistall a specific version of a bundle
uninstall_bundle() {
   bundle_id=`get_bundle_version $1 $2`;
   karaf uninstall $bundle_id;
}

# install karaf feature and verify it has  given version
install_feature () {
   if karaf features:install $1
   then
      # only display the log when useful: very verbose
      # display_karaf_log

      # get the currently installed version of the feature
      NEW_INSTALLED_VERSION=`installed_version $1`

      # Test if the newly deployed version is the correct one
      test  "$2" = "$NEW_INSTALLED_VERSION"

      echo
      echo ****************************************
      echo DEPLOYMENT SUCCEEDED
      echo ****************************************

   else
      echo ****************************************
      echo DEPLOYMENT FAILED : BUNDLE Status
      echo ****************************************
      karaf list


      echo
      echo ****************************************
      echo DEPLOYMENT FAILED : Las Log Lines
      echo ****************************************
      display_karaf_log



      echo
      echo ****************************************
      echo DEPLOYMENT FAILED
   echo ****************************************

      # fail the build
      false
   fi
}


function get_feature_url() {                   
   karaf features:listUrl | grep "mvn:$1/$2"  | cut -b11-
}


# update the feature url to the specified version
function update_feature_url() {
   NEW_FEATURE_URL="mvn:$1/$2/$3/xml/features"
   OLD_FEATURE_URL=`get_feature_url $1 $2`
   echo $OLD_FEATURE_URL
   if [ "$NEW_FEATURE_URL" != "$OLD_FEATURE_URL" ] 
   then
      if [ "$OLD_FEATURE_URL" != "" ] 
      then
         karaf features:removeUrl $OLD_FEATURE_URL
      fi
      karaf features:addUrl $NEW_FEATURE_URL
   fi
}

#----------------- nothing to change above this line ----------------


LOCAL=FALSE
TARGET_HOST=esb-a-test.sofia.elex.be
VERSION=`latest_version com.melexis.ape rasco-feature`

update_feature_url  com.melexis.ape rasco-feature $VERSION
karaf features:refreshUrl


INSTALLED_VERSION_LIBS=`installed_version rasco-svcs`
if [ "$INSTALLED_VERSION_LIBS" != "$VERSION" ]
then 
  if [ "$INSTALLED_VERSION_LIBS" != "" ]
  then 
    # uninstall the feature if different version
    karaf features:uninstall rasco-libs
  fi
fi

INSTALLED_VERSION_SVCS=`installed_version rasco-svcs`
if [ "$INSTALLED_VERSION_SVCS" != "" ]
then 
  # uninstall the feature when any version is installed
  karaf features:uninstall rasco-svcs
fi

# make sure the bundles are uninstalled
# There is a timeout of 300s before the routes are forcibly shutdown
# when there are inflight messages.
# add 10% to stay away of rounding errors
#
# This is crap on a stick but no other choice atm.
#
# TODO: configure the modules so the routes are stopped faster and that it
# can be easily verified that they have actually stopped. see camel shutdown
# rules
#
sleep 330

#display_karaf_log

# install the feature when the bundles are uninstalled

INSTALLED_VERSION_LIBS=`installed_version rasco-svcs`
if [ "$INSTALLED_VERSION_LIBS" != "$VERSION" ]
then 
  # uninstall the feature if different version
  karaf features:install rasco-libs
fi

install_feature rasco
install_feature rasco-svcs $VERSION

