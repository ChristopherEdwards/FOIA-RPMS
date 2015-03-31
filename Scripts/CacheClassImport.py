#---------------------------------------------------------------------------
# Copyright 2014 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------

import os, sys

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.normpath(os.path.join(CURRENT_DIR, "../../Scripts"))
if SCRIPTS_DIR not in sys.path:
  sys.path.append(SCRIPTS_DIR)

from LoggerManager import initConsoleLogging
from IntersysCacheUtils import importDir

def importCacheClass(vistATestClient, srcDir):
  clsDirs=set()
  src = os.path.abspath(srcDir)
  for (root, dirs, files) in os.walk(src):
    for fileName in files:
      if fileName.endswith(".xml"):
         clsDirs.add(root)
         break;
  for clsDir in clsDirs:
    importDir(vistATestClient, clsDir)

def main():
  initConsoleLogging()
  import argparse
  from VistATestClient import createTestClientArgParser
  from VistATestClient import VistATestClientFactory
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='Intersystem Cache Classes Importer',
                                   parents=[testClientParser])
  parser.add_argument('srcDir', help='source directory that stores all exported classes')
  result = parser.parse_args()
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  with testClient:
    importCacheClass(testClient, result.srcDir)

if __name__ == '__main__':
  main()
