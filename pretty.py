#!/usr/bin/python

import pprint
import sys

stuff = eval(sys.argv[1])
pp = pprint.PrettyPrinter(indent=2)
pp.pprint(stuff)
