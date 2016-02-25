#! /usr/bin/python

# To change this template, choose Tools | Templates
# and open the template in the editor.

__author__ = "BiocomputingUP"
__mail__ = "bicomp@bio.unipd.it"
__version__ = "1.0.1"


import urllib
import time
from optparse import OptionParser
import json


# Setup Help page content for general usage 
__usage__ = """
*******************************************
*** MobiDB                              ***
*** Get Data from MobiDB                ***
***                                     ***
*** Author: BiocomputingUP              ***
*** Mail: bicomp@bio.unipd.it           ***
*** Version: 1.0.1                        ***
*** Further information on              *** 
*** mobidb.bio.unipd.it                 ***
*******************************************

1) How to get MobiDB Prediction data:
python mobidb-get.py -i E7ESS1 -m 

2) How to get MobiDB Long Disorder Consensus in a pretty format:
python mobidb-get.py -i E7ESS1 -l -c 
""" 
#
# Setup script options
#
parser = OptionParser(usage=__usage__)
parser.add_option("-i", "--id", dest="id", action="store", default="", help="UniProt Accession Number")
parser.add_option("-m", "--mobidb", dest="mobidb", action="store_true", default=False, help="Get General Info")
parser.add_option("-d", "--disorder", dest="disorder", action="store_true", default=False, help="Get Disorder ")
parser.add_option("-p", "--pfam", dest="pfam", action="store_true", default=False, help="Get PFAM")
parser.add_option("-u", "--uniprot", dest="uniprot", action="store_true", default=False, help="Get Uniprot")
parser.add_option("-s", "--string", dest="string", action="store_true", default=False, help="Get String")
parser.add_option("-c", "--cool", dest="cool", action="store_true", default=False, help="Pretty Print")


def getData(url):
    response = urllib.urlopen(url);
    time.sleep(1)
    data = json.loads(response.read())
    return data
#
# Read input parameters
#
(options, args) = parser.parse_args()


if __name__ == "__main__":
    if options.disorder:
        url = "http://mobidb.bio.unipd.it/ws/entries/%s/disorder"%(options.id)
        data = getData(url)
        if options.cool:
            print json.dumps(data, sort_keys = False, indent = 4)
            
        else:
            print data
    if options.mobidb:
        url = "http://mobidb.bio.unipd.it/ws/entries/%s/mobidb"%(options.id)
        data = getData(url)
        #
        # To print accession number 
        # print data["acc"]
        #
        if options.cool:
            print json.dumps(data, sort_keys = False, indent = 4)
        else:
            print data
    if options.pfam:
        url = "http://mobidb.bio.unipd.it/ws/entries/%s/pfam"%(options.id)
        data = getData(url)
        if options.cool:
            print json.dumps(data, sort_keys = False, indent = 4)
        else:
            print data
    if options.uniprot:
        url = "http://mobidb.bio.unipd.it/ws/entries/%s/uniprot"%(options.id)
        data = getData(url)
        if options.cool:
            print json.dumps(data, sort_keys = False, indent = 4)
        else:
            print data
    if options.string:
        url = "http://mobidb.bio.unipd.it/ws/entries/%s/string"%(options.id)
        data = getData(url)
        if options.cool:
            print json.dumps(data, sort_keys = False, indent = 4)
        else:
            print data
    
