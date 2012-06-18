BGP9REF ; IHS/CMI/LAB - measure AHR.A ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
 ;
BETA(P,BDATE,EDATE) ;EP - BETA BLOCKER REFUSAL
 ;P - patient DFN
 ;BDATE - beginning date to search for REFUSAL
 ;EDATE - ending date of search for REFUSAL
 ;bdate - default is edate-365
 ;edate - default is DT
 ;
 ;return value = piece 1 = 1 for yes, refusal found
 ;                         BLANK for no, refusal not found
 ;               piece 2 = text of what was found
 ;logic:
 ;refusal of any med in BGP HEDIS BETA BLOCKER MEDS taxonomy
 ;
 G BETA^BGP9REF1
 ;
ASA(P,BDATE,EDATE) ;EP - ASPIRIN REFUSAL
 ;P - patient DFN
 ;BDATE - beginning date to search for REFUSAL
 ;EDATE - ending date of search for REFUSAL
 ;bdate - default is edate-365
 ;edate - default is DT
 ;
 ;return value = piece 1 = 1 for yes, refusal found
 ;                         BLANK for no, refusal not found
 ;               piece 2 = text of what was found
 ;logic:
 ;refusal of any med in DM AUDIT ASPIRIN DRUGS or BGP ANTI-PLATELET DRUGS taxonomies
 ;
 G ASA^BGP9REF1
 ;
ACEI(P,BDATE,EDATE) ;EP - ACEI REFUSAL
 ;P - patient DFN
 ;BDATE - beginning date to search for REFUSAL
 ;EDATE - ending date of search for REFUSAL
 ;bdate - default is edate-365
 ;edate - default is DT
 ;
 ;return value = piece 1 = 1 for yes, refusal found
 ;                         BLANK for no, refusal not found
 ;               piece 2 = text of what was found
 ;logic:
 ;refusal of any med in BGP HEDIS ACEI MEDS taxonomy
 ;
 G ACEI^BGP9REF1
 ;
ARB(P,BDATE,EDATE) ;EP - ARB REFUSAL
 ;P - patient DFN
 ;BDATE - beginning date to search for REFUSAL
 ;EDATE - ending date of search for REFUSAL
 ;bdate - default is edate-365
 ;edate - default is DT
 ;
 ;return value = piece 1 = 1 for yes, refusal found
 ;                         BLANK for no, refusal not found
 ;               piece 2 = text of what was found
 ;logic:
 ;refusal of any med in BGP HEDIS ARB MEDS
 ;
 G ARB^BGP9REF1
 ;
STATIN(P,BDATE,EDATE) ;EP - STATIN REFUSAL
 ;P - patient DFN
 ;BDATE - beginning date to search for REFUSAL
 ;EDATE - ending date of search for REFUSAL
 ;bdate - default is edate-365
 ;edate - default is DT
 ;
 ;return value = piece 1 = 1 for yes, refusal found
 ;                         BLANK for no, refusal not found
 ;               piece 2 = text of what was found
 ;logic:
 ;refusal of any med in BGP HEDIS STATIN MEDS
 ;
 G STATIN^BGP9REF1
 ;
