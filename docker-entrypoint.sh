#!/bin/bash

test ! -s $FITNESSE_DATA/plugins.properties && cp $FITNESSE_DEFAULT/plugins.properties $FITNESSE_DATA
test ! -s $FITNESSE_DATA/config.xml && cp $FITNESSE_DEFAULT/config.xml $FITNESSE_DATA
test ! -s $FITNESSE_DATA/netcore-fixtures && cp -R $FITNESSE_DEFAULT/netcore-fixtures $FITNESSE_DATA
test ! -s $FITNESSE_WIKI && cp -R $FITNESSE_DEFAULT/FitNesseRoot $FITNESSE_WIKI 

java -Xmx256m -jar $FITNESSE_APP/$FITNESSE_JARFILE -p $FITNESSE_PORT -d $FITNESSE_DATA -e 0
