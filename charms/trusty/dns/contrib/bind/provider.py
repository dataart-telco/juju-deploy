import os
import sys
from random import randint

# Add charmhelpers to the system path.
try:
    sys.path.insert(0, os.path.abspath(os.path.join(os.environ['CHARM_DIR'],
                                                    'lib')))
except:
    sys.path.insert(0, os.path.abspath(os.path.join('..', '..', 'lib')))

from charmhelpers.core.hookenv import unit_get
from charmhelpers.core.host import service_reload
from common import resolve_hostname_to_ip
from zoneparser import ZoneParser

class BindProvider(object):

    def config_changed(self, domain='example.com'):
        zp = ZoneParser(domain)
        # Install a skeleton bind zone, rehashes existing file
        # if it has contents)
        if not os.path.exists('/etc/bind/db.%s' % domain):
            self.first_setup(zp, domain)
            zp.save()
            self.reload_config()

    def add_record(self, record, domain='example.com'):
        zp = ZoneParser(domain)
        if type(record) is dict:
            zp.dict_to_zone(record)
        elif type(record) is list:
            zp.array_to_zone(record)
        else:
            raise TypeError("Unsupported type for resource %d" % type(record))
        zp.save()
        self.reload_config()

    def remove_record(self, record, domain='example.com'):
        zp = ZoneParser(domain)
        zp.zone.remove('alias', record['rr'], record['alias'])
        zp.save()
        self.reload_config()

    def first_setup(self, parser, domain='example.com'):
        # Insert SOA and NS records
        hostname = unit_get('public-address')
        addr = resolve_hostname_to_ip(hostname)
        parser.dict_to_zone({'rr': 'SOA',
                             'addr': 'ns.%s.' % domain,
                             'owner': 'root.%s.' % domain,
                             'serial': randint(12345678, 22345678),
                             'refresh': '12h',
                             'update-retry': '15m',
                             'expiry': '3w',
                             'minimum': '3h'})
        parser.dict_to_zone({'rr': 'NS', 'alias': '@',
                             'addr': 'ns1.%s.' % domain})
        parser.dict_to_zone({'rr': 'A', 'alias': '@', 'addr': addr,
                             'ttl': 300})
        parser.dict_to_zone({'rr': 'A', 'alias': 'ns1', 'addr': addr,
                             'ttl': 300})

    def reload_config(self):
        service_reload('bind9')
