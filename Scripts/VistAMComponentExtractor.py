#!/usr/bin/env python
#---------------------------------------------------------------------------
# Copyright 2012 The Open Source Electronic Health Record Agent
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

from __future__ import with_statement
import sys
import os
import subprocess
import shutil
import glob
import argparse
# add the current to sys.path
SCRIPTS_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(SCRIPTS_DIR)
from VistATestClient import VistATestClientFactory, createTestClientArgParser
from VistARoutineExport import VistARoutineExport
from VistARoutineImport import VistARoutineImport
from VistAGlobalExport import VistAGlobalExport
from LoggerManager import logger, initConsoleLogging, initFileLogging
from VistATaskmanUtil import VistATaskmanUtil
from MCompReposReadMeGenerator import MCompReposReadMeGenerator
from GitUtils import switchBranch, getStatus
from IntersysCacheUtils import exportAllClassesIndividual

""" List of routine names that are excluded from export process """
ROUTINE_EXTRACT_EXCLUDE_LIST = (
   "ZGO", "ZGI", "xobw.*", "%*", "MPIP*",
   "CHK2LEV", "CHKOP", "GENDASH", "GENOUT",
   "GETPASS", "GTMHELP", "GTMHLPLD", "LOADOP",
   "LOADVX", "MSG", "PINENTRY", "TTTGEN",
   "TTTSCAN"
)

""" Extract routines/globals from a VistA instance and import
    to the git repository
"""
class VistADataExtractor:
  def __init__(self, vistARepoDir, outputResultDir,
               outputLogDir, routineOutDir=None,
               gitBranch=None, generateReadMe=False):
    assert os.path.exists(vistARepoDir)
    assert os.path.exists(outputResultDir)
    assert os.path.exists(outputLogDir)
    self._vistARepoDir = vistARepoDir
    self._outputLogDir = outputLogDir
    self._outputResultDir = outputResultDir
    self._packagesDir = os.path.join(self._vistARepoDir, "Packages")
    assert os.path.exists(self._packagesDir)
    self._packagesCSV = os.path.normpath(os.path.join(SCRIPTS_DIR,
                                                 "../Packages.csv"))
    assert os.path.exists(self._packagesCSV)
    self._routineOutputFile = os.path.join(self._outputResultDir, "Routines.ro")
    self._globalOutputDir = os.path.join(self._outputResultDir, "Globals")
    self._cacheclassesDir = os.path.join(self._outputResultDir, "Classes")
    if not os.path.exists(self._globalOutputDir):
      os.mkdir(self._globalOutputDir)
    if not os.path.exists(self._cacheclassesDir):
      os.mkdir(self._cacheclassesDir)
    if routineOutDir:
      assert os.path.exists(routineOutDir)
    self._routineOutDir = routineOutDir
    self._generateReadMe = generateReadMe
    self._gitBranch = gitBranch
  def extractData(self, vistATestClient):
    self._cache = vistATestClient.isCache()
    self.__setupLogging__(vistATestClient)
    self.__switchBranch__()
    self.__stopTaskman__(vistATestClient)
    self.__extractRoutines__(vistATestClient)
    self.__importZGORoutine__(vistATestClient)
    self.__exportAllGlobals__(vistATestClient)
    self.__exportAllCacheClasses__(vistATestClient)
    self.__chmodGlobalOutput__()
    self.__removePackagesTree__()
    self.__unpackRoutines__()
    self.__copyAllGlobals__()
    self.__splitGlobalFiles__()
    self.__copyAllClasses__()
    self.__populatePackageFiles__()
    self.__generatePackageReadMes__()
    self.__reportGitStatus__()
    self.__cleanup__()

  def __setupLogging__(self, vistATestClient):
    DEFAULT_LOGGING_FILENAME = "VistADataExtractor.log"
    DEFAULT_EXPECT_LOG_FILENAME = "VistAPExpect.log"
    vistATestClient.setLogFile(os.path.join(self._outputLogDir,
                               DEFAULT_EXPECT_LOG_FILENAME))
    initFileLogging(os.path.join(self._outputLogDir,
                                 DEFAULT_LOGGING_FILENAME))

  def __stopTaskman__(self, vistATestClient):
    taskmanUtil = VistATaskmanUtil()
    """taskmanUtil.shutdownAllTasks(vistATestClient)"""

  def __extractRoutines__(self, vistATestClient):
    # do not export ZGO, ZGI and xobw.* routines for now
    excludeList = ROUTINE_EXTRACT_EXCLUDE_LIST
    vistARoutineExport = VistARoutineExport()
    logger.info("Extracting All Routines from VistA instance to %s" %
                self._routineOutputFile)
    vistARoutineExport.exportAllRoutines(vistATestClient,
                                         self._routineOutputFile,
                                         excludeList)

  def __importZGORoutine__(self, vistATestClient):
    logger.info("Import ZGO routine to VistA instance")
    from PackRO import pack
    zgoOutFile = os.path.join(self._outputResultDir, "ZGO.ro")
    zgoRoutine = os.path.join(SCRIPTS_DIR, "ZGO.m")
    assert os.path.exists(zgoRoutine)
    pack([zgoRoutine], open(zgoOutFile, 'w'))
    vistARoutineImport = VistARoutineImport()
    vistARoutineImport.importRoutines(vistATestClient, zgoOutFile,
                                      self._routineOutDir)

  def __exportAllGlobals__(self, vistATestClient):
    """ remove all the zwr files first """
    logger.info("Remove all zwr files under %s" % self._globalOutputDir)
    for file in glob.glob(os.path.join(self._globalOutputDir, "*.zwr")):
      os.remove(file)
    logger.info("Exporting all globals from VistA instance")
    vistAGlobalExport = VistAGlobalExport()
    vistAGlobalExport.exportAllGlobals(vistATestClient, self._globalOutputDir)

  def __exportAllCacheClasses__(self, vistATestClient):
    if not vistATestClient.isCache():
      """ only works for Intersystem Cache """
      return
    """ remove all the xml files first """
    logger.info("Remove all xml files under %s" % self._cacheclassesDir)
    for file in glob.glob(os.path.join(self._globalOutputDir, "*.xml")):
      os.remove(file)
    exportAllClassesIndividual(vistATestClient, self._cacheclassesDir)

  def __removePackagesTree__(self):
    logger.info("Removing all files under %s" % self._packagesDir)
    for dirEntry in os.listdir(self._packagesDir):
      if dirEntry == ".gitattributes": # ignore the .gitattributes
        continue
      if not self._cache: # keep the Classes files
        if dirEntry == 'Classes':
          continue
      fullPath = os.path.join(self._packagesDir, dirEntry)
      if os.path.isdir(fullPath):
        shutil.rmtree(fullPath)
      else:
        os.remove(fullPath)

  def unpackRoutines(self, routinesOutputFile, outputDir):
    from UnpackRO import unpack
    assert os.path.exists(routinesOutputFile)
    assert os.path.exists(outputDir)
    absOutDir = os.path.abspath(outputDir)
    logfile = os.path.join(self._outputLogDir, "unpackro.log")
    logger.info("Unpack routines from %s to %s" %
                (routinesOutputFile, outputDir))
    with open(routinesOutputFile, 'r') as routineFile: # open as txt
      with open(logfile, 'w') as logFile:
        unpack(routineFile, out=logFile, odir=outputDir)

  def __unpackRoutines__(self):
    self.unpackRoutines(self._routineOutputFile, self._packagesDir)

  def __copyAllGlobals__(self):
    logger.info("Copying all files from %s to %s" %
                (self._globalOutputDir, self._packagesDir))
    zwrFiles = glob.glob(os.path.join(self._globalOutputDir, "*.zwr"))
    for zwrFile in zwrFiles:
      logger.debug("Copying %s to %s" % (zwrFile, self._packagesDir))
      shutil.copy2(zwrFile, self._packagesDir)

  def __splitGlobalFiles__(self):
    from SplitZWR import splitZWR
    zwrFiles = glob.glob(os.path.join(self._packagesDir, "*.zwr"))
    maxSize = 64 << 20
    for f in zwrFiles:
      if "DD.zwr" in f:
        continue
      if "XCSV.zwr" in f:
        continue
      if os.stat(f).st_size > maxSize:
        splitZWR(f, maxSize)

  def __copyAllClasses__(self):
    if not self._cache:
      return
    logger.info("Copying all classes file from %s to %s" %
                (self._cacheclassesDir, self._packagesDir))
    xmlFiles = glob.glob(os.path.join(self._cacheclassesDir, "*.xml"))
    for xmlFile in xmlFiles:
      logger.debug("Copying %s to %s" % (xmlFile, self._packagesDir))
      shutil.copy2(xmlFile, self._packagesDir)

  def __populatePackageFiles__(self):
    from PopulatePackages import populate
    curDir = os.getcwd()
    os.chdir(self._packagesDir)
    populate(open(self._packagesCSV, "rb"))
    os.chdir(curDir)

  def __chmodGlobalOutput__(self):
    allZWRFiles = glob.glob(os.path.join(self._globalOutputDir,
                                         "*.zwr"))
    for file in allZWRFiles:
      os.chmod(file, 0644)

  def __generatePackageReadMes__(self):
    # assume runs from the scripts directory
    if not self._generateReadMe:
      return
    curDir = os.getcwd()
    inputDir = os.path.normpath(os.path.join(curDir, "../"))
    readMeGen = MCompReposReadMeGenerator(inputDir,
                                          self._vistARepoDir)
    readMeGen.generatePackageReadMes()

  def __switchBranch__(self):
    if self._gitBranch is None:
      return
    switchBranch(self._gitBranch, self._vistARepoDir)

  def __reportGitStatus__(self):
    logger.info("Reporting git status on Uncategorized dir")
    output = getStatus(self._packagesDir, 'Uncategorized/')
    logger.info(output)
    logger.info("Reporting git status on Packages dir")
    output = getStatus(self._packagesDir)
    logger.info(output)

  def __cleanup__(self):
    pass

def getInputArgumentResult():
  testClientParser = createTestClientArgParser()
  parser = argparse.ArgumentParser(description='VistA M Component Extractor',
                                   parents=[testClientParser])
  parser.add_argument('-o', '--outputDir', required=True,
                      help='output Dir to store global/routine/classes export files')
  parser.add_argument('-r', '--vistARepo', required=True,
                    help='path to the top directory of VistA-M repository')
  parser.add_argument('-l', '--logDir', required=True,
                      help='path to the top directory to store the log files')
  parser.add_argument('-ro', '--routineOutDir', default=None,
                help='path to the directory where GT. M stores routines')
  result = parser.parse_args();
  return result

def main():
  result = getInputArgumentResult()
  outputDir = result.outputDir
  assert os.path.exists(outputDir)
  initConsoleLogging()
  """ create the VistATestClient"""
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  with testClient as vistAClient:
    vistADataExtractor = VistADataExtractor(result.vistARepo,
                                            outputDir,
                                            result.logDir,
                                            result.routineOutDir)
    vistADataExtractor.extractData(testClient)

def test1():
  result = getInputArgumentResult()
  outputDir = result.outputDir
  assert os.path.exists(outputDir)
  initConsoleLogging()
  """ create the VistATestClient"""
  testClient = VistATestClientFactory.createVistATestClientWithArgs(result)
  assert testClient
  with testClient as vistAClient:
    vistADataExtractor = VistADataExtractor(result.vistARepo,
                                            outputDir,
                                            result.logDir,
                                            result.routineOutDir)
    vistADataExtractor.__exportAllCacheClasses__(testClient)
  #vistADataExtractor.__chmodGlobalOutput__()
  #vistADataExtractor.__removePackagesTree__()
  #vistADataExtractor.__unpackRoutines__()
  #vistADataExtractor.__copyAllGlobals__()
  #vistADataExtractor.__splitGlobalFiles__()
  #vistADataExtractor.__populatePackageFiles__()

if __name__ == '__main__':
  #test1()
  main()
