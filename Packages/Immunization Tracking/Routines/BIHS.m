BIHS ;IHS/CMI/MWR - DISPLAY HEALTH SUMMARY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CALLS APCH SOFTWARE TO DISPLAY HEALTH SUMMARY.
 ;;  CALLED BY PROTOCOL: BI HEALTH SUMMARY.
 ;
 ;
 ;----------
HS ;EP
 ;---> Called from Protocol to display Health Summary.
 ;
 Q:'$G(BIDFN)
 N DFN,X,Y
 D FULL^VALM1
 ;
 ;---> Set Health Summary Type default.
 D
 .;---> Look for user's last choice.
 .N Y S Y=$G(^DISV($G(DUZ),"^APCHSCTL("))
 .S X=$P($G(^APCHSCTL(+Y,0)),U,1)
 .Q:X]""
 .;
 .;---> Get default from PCC MASTER CONTROL File.
 .I $D(^APCCCTRL($G(DUZ(2)),0))#2 S X=$P(^(0),U,3) Q
 .;
 .S X="ADULT REGULAR"
 ;
 ;---> Select Health Summary Type.
 D DIC^BIFMAN(9001015,"QEMA",.Y,,$G(X))
 Q:Y<0
 ;
 N APCHSPAT,APCHSTYP,APCHSTAT,APCHSMTY,AMCHDAYS,AMCHDOB,APCDHDR
 S APCHSTYP=+Y,(APCHSPAT,DFN)=BIDFN
 S APCDHDR="PCC Health Summary for "_$P(^DPT(DFN,0),U)
 D
 .;---> Preserve BIDFN.
 .N BIDFN
 .;---> Call Viewer.
 .D VIEWR^XBLM("EN^APCHS",APCDHDR)
 .;---> Use next line the instead of the previous if there are problems
 .;---> with Listmanager display of Health Summary.  ;MWRZZZ
 .;D HSOUT^APCHS,DIRZ^BIUTL3()
 ;
 Q
