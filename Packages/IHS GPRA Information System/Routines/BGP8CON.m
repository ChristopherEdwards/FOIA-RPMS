BGP8CON ; IHS/CMI/LAB - measure AHR.A ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
BETA(P,BDATE,EDATE,NMIB,NMIE) ;EP - BETA BLOCKER CONTRAINDICATION
 ;P - patient DFN
 ;BDATE - beginning date to search for contraindication
 ;EDATE - ending date of search for contraindication
 ;NMIB - beginning date to search for NMI refusal (not medically indicated)
 ;NMIE - ending date to search for NMI refusal (not medically indicated)
 ;
 ;return value = piece 1 = 1 for yes, contraindication found
 ;                         BLANK for no, contraindication not found
 ;               piece 2 = text of what was found
 ;logic:
 ;2 different asthma diagnoses on 2 different dates between bdate and edate
 ;Hypotension dx between bdate and edate
 ;heart block >1 degree diagnosis between bdate and edate
 ;sinus bradycardia 1 dx between bdate and edate
 ;COPD - 2 diagnoses between bdate and edate on different dates
 ;NMI refusal documented for beta blocker between NMIB and NMIE
 ;CPT G8011 between NMIB and NMIE
 ;
 G BETA^BGP8CON1
 ;
 ;
ASA(P,BDATE,EDATE,NMIB,NMIE) ;EP - does patient have an aspirin CONTRAINDICATION
 ;P - PATIENT DFN
 ;BDATE - BEGINNING DATE TO LOOK FOR DATA
 ;EDATE - ENDING DATE TO LOOK FOR DATA
 ;NMIB - nmi beginning date
 ;NMIE - ending date to look for nmi
 ;
 ;return value = piece 1 = 1 for yes, contraindication found
 ;                         blank for no, contraindication not found
 ;               piece 2 = text of what was found
 ;
 ;Non-discontinued Prescription for warfarin between bdate and edate.
 ;Diagnosis 459.0 - Hemorrage DX EVER before EDATE
 ;NMI Refusal between NMIB and NMIE
 ;CPT G8008 between NMIB and NMIE
 ;
 G ASA^BGP8CON1
 ;
ACEI(P,BDATE,EDATE,NMIB,NMIE) ;EP does patient have an ACEI contraidication
 ;P - patient DFN
 ;BDATE - beginning date to search for contraindication
 ;EDATE - ending date of search for contraindication
 ;NMIBD - beginning date to search for NMI refusal (not medically indicated)
 ;NMIED - ending date to search for NMI refusal (not medically indicated)
 ;
 ;return value = piece 1 = 1 for yes, contraindication found
 ;                         blank for no, contraindication not found
 ;               piece 2 = text of what was found
 ;LOGIC:
 ;diagnosis between BDATE and EDATE in BGP CMS AORTIC STENOSIS DXS
 ;NMI refusal for drug in BGP HEDIS ACEI MEDS taxonomy between NMIB and NMIE
 ;NMI refusal for drug in BGP HEDIS ARB MEDS taxonomy between NMIB and NMIE
 G ACEI^BGP8CON1
 ;
STATIN(P,BDATE,EDATE,NMIB,NMIE) ;EP does patient have an STATIN contraidication
 ;P - patient DFN
 ;BDATE - beginning date to search for contraindication
 ;EDATE - ending date of search for contraindication
 ;NMIBD - beginning date to search for NMI refusal (not medically indicated)
 ;NMIED - ending date to search for NMI refusal (not medically indicated)
 ;
 ;return value = piece 1 = 1 for yes, contraindication found
 ;                         blank for no, contraindication not found
 ;               piece 2 = text of what was found
 ;LOGIC:
 ;PREGNANCY diagnosis between BDATE and EDATE 
 ;NMI refusal for drug in BGP HEDIS STATIN MEDS taxonomy between NMIB and NMIE
 ;BREASTFEEDING education between BDATE and EDATE
 ;BREASTFEEDING POV between BDATE and EDATE
 ;alchohol hepatitis pov between BDATE and EDATE
 ;
 G STATIN^BGP8CON1
 ;
