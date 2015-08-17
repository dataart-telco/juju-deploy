#!/bin/bash

root_zone=$1

if [[ -z $root_zone ]]
then
  exit 2
fi

relation-set home_domain=$root_zone
relation-set sprout_domain=sprout.$root_zone
relation-set homestead_domain=homestead.$root_zone:8888
relation-set provisioning_domain=homestead.$root_zone:8889
relation-set homer_domain=homer.$root_zone:7888
relation-set ellis_domain=ellis.$root_zone
relation-set ralf_domain=ralf.$root_zone
relation-set sas_domain=`config-get sas`
relation-set enum_domain=`config-get enum`
