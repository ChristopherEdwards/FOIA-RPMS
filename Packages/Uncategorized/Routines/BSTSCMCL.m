BSTSCMCL ;GDIT/HS/BEE-Standard Terminology Cache Method Calls ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,4,6,7,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
RCODE(BSTSWS,RSLT) ;EP - DTS4 Return all concepts that are in RxNorm subsets (not including RXNO SRCH Drug Ingredients All)
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).getAllRxNormSubsetConcepts(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("SCODE",STS) I +STS Q
 ;
 ;Note - no check for exceeding call timeout since this call
 ;       will take longer to complete
 Q STS
 ;
SCODE(BSTSWS,RSLT) ;EP - DTS4 Return all concepts that are in a subset (not including IHS PROBLEM ALL SNOMED)
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).getAllSubsetConcepts(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("SCODE",STS) I +STS Q
 ;
 ;Note - no check for exceeding call timeout since this call
 ;       will take longer to complete
 Q STS
 ;
ACODE(BSTSWS,RSLT) ;EP - DTS4 Return items that have an ICD10 auto-codable value
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).getICD10AutoCodes(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("ACODE",STS) I +STS Q
 ;
 ;Note - no check for exceeding call timeout since this call
 ;       will take longer to complete
 Q STS
 ;
ACODEQ(BSTSWS,RSLT) ;EP - DTS4 Return items that have equivalent associations
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).getEquivalencyConcepts(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("ACODEDQ",STS) I +STS Q
 ;
 ;Note - no check for exceeding call timeout since this call
 ;       will take longer to complete
 Q STS
 ;
ACODEP(BSTSWS,RSLT) ;EP - DTS4 Return items that have ICD10 auto-codable predicates
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).getICD10AutoCodePreds(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("ACODEP",STS) I +STS Q
 ;
 ;Note - no check for exceeding call timeout since this call
 ;       will take longer to complete
 Q STS
 ;
A9CODE(BSTSWS,RSLT) ;EP - DTS4 Return items that have an ICD10 auto-codable value
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).getICD9AutoCodes(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("A9CODE",STS) I +STS Q
 ;
 ;Note - no check for exceeding call timeout since this call
 ;       will take longer to complete
 Q STS
 ;
CSTMCDST(BSTSWS,RSLT) ;EP - DTS4 Return items in a custom codeset
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).getCustomCodeset(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("CSTMCDST",STS) I +STS Q
 ;
 ;Note - no check for exceeding call timeout since this call
 ;       will take longer to complete
 Q STS
 ;
FSNSRCH(BSTSWS,RSLT) ;EP - DTS4 Fully Specified Name Search
 ;
 ;Perform Concept Search
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).FindConceptsWithNameMatching(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("FSNSRCH",STS) I +STS!($P(STS,U,3)>$G(BSTSWS("TIMEOUT"))) Q
 ;
 ;Check server status
 D SWLCL^BSTSWSV1(.BSTSWS,.STS)
 ;
 Q STS
 ;
CONSRCH(BSTSWS,RSLT) ;EP - DTS4 Concept Search
 ;
 ;Perform Concept Search
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).executeConceptTextSearch(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("CONSRCH",STS) I +STS!($P(STS,U,3)>$G(BSTSWS("TIMEOUT"))) Q
 ;
 ;Check server status
 D SWLCL^BSTSWSV1(.BSTSWS,.STS)
 ;
 Q STS
 ;
DSCSRCH(BSTSWS,RSLT) ;EP - DTS4 Description Id Search
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).findDescWithIdMatch(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("DSCSRCH",STS) I +STS!($P(STS,U,3)>$G(BSTSWS("TIMEOUT"))) Q
 ;
 ;Check server status
 D SWLCL^BSTSWSV1(.BSTSWS,.STS)
 ;
 Q STS
 ;
TRMSRCH(BSTSWS,RSLT) ;EP - DTS4 Term Search
 ;
 ;Perform Concept Search
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).FullTextSearch(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("TRMSRCH",STS) I +STS!($P(STS,U,3)>$G(BSTSWS("TIMEOUT"))) Q
 ;
 ;Check server status
 D SWLCL^BSTSWSV1(.BSTSWS,.STS)
 ;
 Q STS
 ;
SUBLST(BSTSWS,RSLT) ;EP - DTS4 Retrieve Subset List
 ;
 ;Retrieve list of concepts in a specified subset
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).getSubsetList(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("SUBLST",STS) I +STS Q
 ;
 ;Note - do not perform time check - this could be a longer running call
 ;
 Q STS
 ;
ICD2SMD(BSTSWS,RSLT) ;EP - DTS4 Retrieve ICD9 to SNOMED mappings
 ;
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).getICD9toSNOMED(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("ICD2SMD",STS) I +STS Q
 ;
 ;Note - do not perform time check - this could be a longer running call
 ;
 Q STS
 ;
CNCSR(BSTSWS,RSLT) ;EP - DTS4 Lookup on Concept Id
 ;
 ;Perform Concept Id Search
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).findConceptsWithPropMatch(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("CNCSR",STS) I +STS!($P(STS,U,3)>$G(BSTSWS("TIMEOUT"))) Q
 ;
 ;Check server status
 D SWLCL^BSTSWSV1(.BSTSWS,.STS)
 ;
 Q STS
 ;
DETAIL(BSTSWS,RSLT) ;EP - DTS4 Retrieve Concept Detail
 ;
 ;Place call to retrieve detail for a concept
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).GetConceptDetail(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("DETAIL",STS) I +STS!($P(STS,U,3)>$G(BSTSWS("TIMEOUT"))) Q
 ;
 ;Check server status
 D SWLCL^BSTSWSV1(.BSTSWS,.STS)
 ;
 Q STS
 ;
FDESC(BSTSWS) ;EP - DTS4 Retrieve FSN Description Id
 ;
 NEW RSLT,STS,EXEC,TRY
 ;
 ;Place call to retrieve the description id for a FSN
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).findTermsByName(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("FDESC",STS) I +STS!($P(STS,U,3)>$G(BSTSWS("TIMEOUT"))) Q
 ;
 ;Check server status
 D SWLCL^BSTSWSV1(.BSTSWS,.STS)
 ;
 Q STS
 ;
GCDSDTS4(BSTSWS,RESULT) ;EP - DTS4 update codesets
 ;
 ;Place call to retrieve codesets (namespaces)
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).GetNamespaces(.BSTSWS,.RESULT)" X EXEC D:'+STS ER("GCDSDTS4",STS) I +STS!($P(STS,U,3)>$G(BSTSWS("TIMEOUT"))) Q
 ;
 ;Check server status
 D SWLCL^BSTSWSV1(.BSTSWS,.STS)
 ;
 Q STS
 ;
GVRDTS4(BSTSWS) ;EP - DTS4 update versions
 ;
 ;Place call to retrieve versions
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).GetVersions(.BSTSWS)" X EXEC D:'+STS ER("GVRDTS4",STS) I +STS Q
 ;
 ;Note - do not perform server status check because the check
 ;       uses this call
 ;
 Q STS
 ;
PTYDTS4(BSTSWS,RSLT) ;EP - DTS4 Perform Property Search
 ;
 ;Search based on property value
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).propertyLookup(.BSTSWS,.RSLT)" X EXEC D:'+STS ER("PTYDTS4",STS) I +STS!($P(STS,U,3)>$G(BSTSWS("TIMEOUT"))) Q
 ;
 ;Check server status
 D SWLCL^BSTSWSV1(.BSTSWS,.STS)
 ;
 Q STS
 ;
SUBSET(BSTSWS,RESULT) ;EP - DTS4 get subset list
 ;
 ;Place call to retrieve list of subsets
 NEW STS,EXEC,TRY
 F TRY=1:1:+$G(BSTSWS("RETRY")) S STS="",EXEC="S STS=##class(BSTS.SOAP.WebFunctions).getListofSubsets(.BSTSWS,.RESULT)" X EXEC D:'+STS ER("SUBSET",STS) I +STS Q
 ;
 ;Note - do not perform time check - this could be a longer running call
 ;
 Q STS
 ;
ER(TAG,ER) ;Error Handling
 ;
 D ELOG^BSTSVOFL(TAG_"~BSTSCMCL: "_ER)
 ;
 Q
