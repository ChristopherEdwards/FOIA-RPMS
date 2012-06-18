AGSSRN ; IHS/ASDS/EFG - REPORT WRITER #2 ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;report SSA matches where data matches but SSNs do not
 K AGSSDT
 Q:'$D(AGSSP("N"))  ;this report not indicated
 ;crossreferences used 3:N
LOAD ;EP - load crossreference into ^AGSTEMP
 ;gather dfns from "AS" cross reference(s)
 K ^AGSTEMP(AGSS("JOBID"),"RN")
 S AGSDFN=0,AGSSC("N")=0 F  S AGSDFN=$O(^AUPNPAT("AS",3,AGSDFN)) Q:'AGSDFN  I $D(^DPT(AGSDFN)) S AGSSC("N")=AGSSC("N")+1 I AGSSP("N")="C" D
 .S AGSCREC=$G(^AGSSTEMP(AGSSITE,"RN",AGSDFN)),^AGSTEMP(AGSS("JOBID"),"RN",$P(^DPT(AGSDFN,0),U),AGSDFN)=AGSCREC
 S ^AGSTEMP(AGSS("JOBID"))=AGSSC("N")
 Q
PRINT ;EP -
 Q:'$D(AGSSP("N"))
 I '$D(AGSSC("N")) S AGSSC("N")=$G(^AGSTEMP(AGSS("JOBID"),"RN"))
 S AGSLVC="N",AGSSPG=1,AGSGLO="RN"
 S AGSSHDR="'SSA SSNs Differ but Patient Data Matches'" D AGSSHDR^AGSSPRT
SPRINT ;
 W !!,"The number of ",AGSSHDR,"  is  ",$G(^AGSSTEMP(AGSSITE,"TOT","RN")),!
 Q:(AGSSP("N")'="C")!(AGSSC("N")=0)
 D AGSSHD^AGSSPRT
 D ^AGSSPRT
 Q
