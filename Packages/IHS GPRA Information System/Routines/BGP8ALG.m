BGP8ALG ; IHS/CMI/LAB - measure AHR.A ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
BETA(P,EDATE) ;EP - BETA BLOCKER ALLERGY/ADR
 ;P - patient DFN
 ;EDATE - ending date of search for ALLERGY/ADR
 ;
 ;return value = piece 1 = 1 for yes, ALLERGY/ADR found
 ;                         blank for no, ALLERGY/ADR not found
 ;               piece 2 = text of what was found
 ;Logic: any pov 995.0-995.3 or V14.8 with a narrative of BETA BLOCK,
 ;       BBLOCK or B BLOCK
 ;       any problem list entry of 995.0-995.3 or V14.8 with
 ;       a narrative of BETA BLOCK, BBLOCK or B BLOCK
 ;       any pov 995.0-995.3 with ECODE E942.0
 ;       allergy tracking entry containing BETA BLOCK
 ;
 G BETA^BGP8ALG1
 ;
 ;
 ;
ASA(P,EDATE) ;does patient have an aspirin ALLERGY/ADR
 ;P - PATIENT DFN
 ;EDATE - ENDING DATE TO LOOK FOR DATA
 ;
 ;return value = piece 1 = 1 for yes, ALLERGY/ADR found
 ;                         blank for no, ALLERGY/ADR not found
 ;               piece 2 = text of what was found
 ;
 ;Logic: any pov 995.0-995.3 or V14.8 with a narrative of ASPIRIN or ASA
 ;       any problem list entry of 995.0-995.3 or V14.8 with
 ;       a narrative of ASPIRIN or ASA
 ;       any pov 995.0-995.3 with ecode E935.3
 ;       allergy tracking entry containing ASPIRIN or ASA
 ;
 ;
 G ASA^BGP8ALG1
 ;
ACEI(P,EDATE) ;EP does patient have an ACEI ALLERGY/ADR
 ;P - patient DFN
 ;EDATE - ending date of search for ALLERGY/ADR
 ;
 ;return value = piece 1 = 1 for yes, ALLERGY/ADR found
 ;                         BLANK for no, ALLERGY/ADR not found
 ;               piece 2 = text of what was found
 ;Logic: any pov 995.0-995.3 or V14.8 with a narrative of ACEI or ACE INHIBITOR
 ;       any problem list entry of 995.0-995.3 or V14.8 with
 ;       a narrative of ASPIRIN or ASA
 ;       any pov 995.0-995.3 with ecode E942.6
 ;       allergy tracking entry containing ACE I or ACEI
 ;
 G ACEI^BGP8ALG1
 ;
ARB(P,EDATE) ;EP does patient have an ARB ALLERGY/ADR
 ;P - patient DFN
 ;EDATE - ending date of search for ALLERGY/ADR
 ;
 ;return value = piece 1 = 1 for yes, ALLERGY/ADR found
 ;                         BLANK for no, ALLERGY/ADR not found
 ;               piece 2 = text of what was found
 ;Logic: any pov 995.0-995.3 or V14.8 with a narrative of ARB or ANGIOTENSIN RECEPTOR BLOCKER
 ;       any problem list entry of 995.0-995.3 or V14.8 with
 ;       a narrative of ASPIRIN or ASA
 ;       any pov 995.0-995.3 with ecode E942.6
 ;       allergy tracking entry containing ARB or ANGIOTENSIN RECEPTOR BLOCKER
 ;
 G ARB^BGP8ALG1
 ;
STATIN(P,BDATE,EDATE) ;EP does patient have an STATIN ALLERGY/ADR
 ;P - patient DFN
 ;
 ;return value = piece 1 = 1 for yes, ALLERGY/ADR found
 ;                         blank for no, ALLERGY/ADR not found
 ;               piece 2 = text of what was found
 ;LOGIC:
 ;       ANY OF THE FOLLOWING DOCUMENTED EVER BEFORE EDATE
 ;       any pov 995.0-995.3 or V14.8 with a narrative of STATIN or STATINS
 ;       any problem list entry of 995.0-995.3 or V14.8 with
 ;       a narrative of STATIN or STATINS
 ;       any pov 995.0-995.3 with ecode E942.9
 ;       allergy tracking entry containing STATIN or STATINS
 ;
 ;       ANY OF THE FOLLOWING DOCUMENTED BETWEEN BDATE AND EDATE
 ;       ALT and/or AST > 3x upper limit of normal on 2 or more consecutive
 ;       visits between bdate and edate
 ;       creatine kinase levels >10x ULN or CK>10,000 IU/L between bdate and edate
 ;       pov in BGP MYOPATHY/MYALGIA taxonomy between BDATE and EDATE
 ;
 G STATIN^BGP8ALG1
 ;
