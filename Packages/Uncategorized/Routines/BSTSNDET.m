BSTSNDET ;GDIT/HS/BEE-Get Concept Detail - Documentation ; 15 Nov 2012  4:26 PM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,5,6,7,8**;Sep 10, 2014;Build 35
 Q
 ;
 ;This routine documents the detail return from various BSTS API calls including
 ;$$SEARCH, $$CNCLKP, $$DSCLKP, $$DTSLKP, $$VALTERM
 ;
 ;Output
 ; Function returns - # Records Returned
 ;
 ; VAR(#) - List of Records
 ;
 ; The VAR(#) list of records returns the following sections
 ;
 ;Concept ID/DTSID
 ; VAR(#,"CON")=Concept Id
 ; VAR(#,"DTS")=Internal DTS Id
 ;
 ;Fully Specified Name
 ; VAR(#,"FSN","DSC")=Description Id of the FSN
 ; VAR(#,"FSN","TRM")=Fully Specified Name
 ; VAR(#,"FSN","XADT")=Date Added
 ; VAR(#,"FSN","XRDT")=Date Retired
 ;
 ;ICD Mapping Information - Multiple Records Returned (CTR)
 ; VAR(#,"ICD",CTR,"COD")=ICD9/ICD10 Code
 ; VAR(#,"ICD",CTR,"TYP")=Code Type(ICD)
 ; VAR(#,"ICD",CTR,"XADT")=Date Added
 ; VAR(#,"ICD",CTR,"XRDT")=Date Retired
 ;
 ;ICD9 Mapping Information - Multiple Records Returned (CTR)
 ; VAR(#,"IC9",CTR,"COD")=ICD9 Code
 ; VAR(#,"IC9",CTR,"TYP")=Code Type(IC9)
 ; VAR(#,"IC9",CTR,"XADT")=Date Added
 ; VAR(#,"IC9",CTR,"XRDT")=Date Retired
 ;
 ;IsA Information - Multiple Records Returned (CTR)
 ; VAR(#,"ISA",CTR,"CON")=Concept Id of IsA Term (may be blank prior to detail lookup)
 ; VAR(#,"ISA",CTR,"DTS")=DTSId of the IsA Term
 ; VAR(#,"ISA",CTR,"TRM")=IsA Term Name
 ; VAR(#,"ISA",CTR,"XADT")=Date Added
 ; VAR(#,"ISA",CTR,"XRDT")=Date Retired
 ;
 ;Association Information (SNOMED) - Multiple Records Returned (CTR)
 ; VAR(#,"ASM",CTR,"CON")=SNOMED Concept CT Association
 ; VAR(#,"ASM",CTR,"DTS")=DTSId of the SNOMED Concept
 ;
 ;Association Information (RxNorm) - Multiple Records Returned (CTR)
 ; VAR(#,"ARX",CTR,"CON")=RxNorm Code Value Association
 ; VAR(#,"ARX",CTR,"DTS")=DTSId of the RxNorm Concept
 ;
 ;Association Information (UNII) - Multiple Records Returned (CTR)
 ; VAR(#,"ASN",CTR,"CON")=UNII Code Value Association
 ; VAR(#,"ASN",CTR,"DTS")=DTSId of the UNII Concept
 ;
 ;Inverse Association Information (RxNorm) - Multiple Records Returned (CTR)
 ; VAR(#,"IAR",CTR,"CON")=RxNorm Code Value of Inverse Association
 ; VAR(#,"IAR",CTR,"DTS")=DTSId of the RxNorm Concept
 ; VAR(#,"IAR",CTR,"TRM")=Inverse Association Term
 ;
 ;Child Information - Multiple Records Returned (CTR)
 ; VAR(#,"CHD",CTR,"CON")=Concept Id of Child Term (may be blank prior to detail lookup)
 ; VAR(#,"CHD",CTR,"DTS")=DTSId of the Child Term
 ; VAR(#,"CHD",CTR,"TRM")=Child Term Name
 ; VAR(#,"CHD",CTR,"XADT")=Date Added
 ; VAR(#,"CHD",CTR,"XRDT")=Date Retired
 ;
 ;Lookup Problem Column Value (Fully Specified Name or a Synonym/Preferred Term)
 ;(Based on Search Type parameter - F/S)
 ; VAR(#,"PRB","DSC")=Description Id of a Pref Term (Type F) or Synonym/Pref Term (S)
 ; VAR(#,"PRB","TRM")=Preferred term of a Concept (F) or a Synonym (S)
 ;
 ;Preferred Term Information
 ; VAR(#,"PRE","DSC")=Description ID of Preferred Term
 ; VAR(#,"PRE","TRM")=Preferred Term
 ; VAR(#,"PRE","XADT")=Date Added
 ; VAR(#,"PRE","XRDT")=Date Retired
 ;
 ;Subset Information - Multiple Records Returned (CTR)
 ; VAR(#,"SUB",CTR,"SUB")=Subset Name
 ; VAR(#,"SUB",CTR,"XADT")=Date Added
 ; VAR(#,"SUB",CTR,"XRDT")=Date Retired
 ;
 ;Synonym Information - Multiple Records Returned (CTR)
 ; VAR(#,"SYN",CTR,"DSC")=Description ID of Synonym
 ; VAR(#,"SYN",CTR,"TRM")=Synonym Term
 ; VAR(#,"SYN",CTR,"XADT")=Date Added
 ; VAR(#,"SYN",CTR,"XRDT")=Date Retired
 ;
 ;Date Concept Added/Retired
 ; VAR(#,"XADT")=Date Added
 ; VAR(#,"XRDT")=Date Retired
 ;
 ;RxNorm Only - TTY
 ; VAR(#,"TTY",CTR,"TTY")=TTY Code
 ; VAR(#,"TTY",CTR,"XADT")=Date Added
 ; VAR(#,"TTY",CTR,"XRDT")=Date Retired
 ;
 ;Equivalent concept children
 ; VAR(#,"EQC",CTR,"CON")=Concept Id of Equivalent Child
 ; VAR(#,"EQC",CTR,"DTS")=DTSId of Equivalent Child
 ; VAR(#,"EQC",CTR,"XADT")=Date Added
 ; VAR(#,"EQC",CTR,"XRDT")=Date Retired
 ;
 ;Equivalent matching concept
 ; VAR(#,"EQM","LAT")=Laterality of exact match
 ; VAR(#,"EQM","DTS")=DTSId of exact match
 ; VAR(#,"EQM","CON")=Concept Id of exact match
 ; VAR(#,"EQM","XADT")=Date Added
 ; VAR(#,"EQM","XRDT")=Date Retired
 ;
 ;Episodicity Required
 ; VAR(#,"EPI")=1/0 - Episodicity required (1)/Not Required (0)
 ;
