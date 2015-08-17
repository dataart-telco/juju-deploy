# Overview

This is a [Juju charm](https://jujucharms.com/about), which allows deployment and scaling of the [clearwater-sip-stress](http://clearwater.readthedocs.org/en/latest/Clearwater_stress_testing/index.html) stress testing tool for a [Project Clearwater](http://projectclearwater.org) IMS core.

# Deployment

## Initial deployment

The clearwater-sip-stress service should be initially deployed as part of a Clearwater bundle, following the instructions in [our main README](https://github.com/Metaswitch/clearwater-juju/blob/local_charms/README.md).

Note that the clearwater-sipp charm can only be deployed on the `amd64` architecture.

## Scale out Usage

clearwater-sipp can be scaled up through the normal Juju mechanism of `juju add-unit clearwater-sipp`.

This will create a new clearwater-sipp instance, and trigger the DNS server charm to add a DNS record for it.

# Using clearwater-sip-stress

Once installed, clearwater-sip-stress will generate SIP traffic to TCP port 5060 of the home domain. `Status is reported in /var/log/clearwater-sip-stress/sipp.1.out`.

# Configuration

-  `zone:` The home domain of this IMS deployment - this could be a real domain that you own, or an internal-only name like "clearwater.local".
-  `repo`: The URL of the Clearwater package repository server. Our latest relese, updated roughly every two weeks, is at http://repo.cw-ngv.com/stable.

# Files downloaded

When the charm is being installed, several files are downloaded:

- Our standard Chef setup scripts, checked out from https://github.com/Metaswitch/chef.
- The clearwater-sip-stress Debian packages, from our package repository server at repo.cw-ngv.com.
- Any dependencies of those Debian packages, from the standard Ubuntu repository servers.

# Contact and Upstream Project Information

Project Clearwater is an open-source IMS core, developed by [Metaswitch Networks](http://www.metaswitch.com) and released under the [GNU GPLv3](http://www.projectclearwater.org/download/license/). You can find more information about it on [our website](http://www.projectclearwater.org/) or [our documentation site](https://clearwater.readthedocs.org).

Clearwater source code and issue list can be found at https://github.com/Metaswitch/. Bono's source code can be found at https://github.com/Metaswitch/sprout/.

If you have problems when using Project Clearwater, read [our troubleshooting documentation](http://clearwater.readthedocs.org/en/latest/Troubleshooting_and_Recovery/index.html) for help, or see [our support page](http://clearwater.readthedocs.org/en/latest/Support/index.html) to find out how to ask mailing list questions or raise issues.
