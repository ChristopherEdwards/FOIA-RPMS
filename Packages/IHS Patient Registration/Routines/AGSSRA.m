AGSSRA ; IHS/ASDS/EFG - REPORT WRITER #1 ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 K AGSSDT
 Q:'$D(AGSSP("A"))  ;this report not indicated
 ;crossreferences used
LOAD ;EP - load crossreference into ^AGSTEMP
 ;gather dfns from "AS" cross reference(s) "*":2  "A":3
 K ^AGSTEMP(AGSS("JOBID"),"RA")
 S DFN=0,AGSSC("A")=0 F  S DFN=$O(^AUPNPAT("AS",2,DFN)) Q:'DFN  I $D(^DPT(DFN)) S AGSSC("A")=AGSSC("A")+1 I AGSSP("A")="C" D
 .S AGSCREC=$G(^AGSSTEMP(AGSSITE,"RA",DFN)),^AGSTEMP(AGSS("JOBID"),"RA",$P(^DPT(DFN,0),U),DFN)=AGSCREC
 S ^AGSTEMP(AGSS("JOBID"),"RA")=AGSSC("A")
 Q
PRINT ;EP -
 Q:'$D(AGSSP("A"))
 I '$D(AGSSC("A")) S AGSSC("A")=$G(^AGSTEMP(AGSS("JOBID"),"RA"))
 S AGSLVC="A",AGSSPG=1,AGSGLO="RA"
 S AGSSHDR="SSNs added to the data base" D AGSSHDR^AGSSPRT
 W !!,"The number of ",AGSSHDR," is ",$G(^AGSSTEMP(AGSSITE,"TOT","RA")),!
 Q:(AGSSP("A")'="C")!(AGSSC("A")=0)
 D AGSSHD^AGSSPRT
 D ^AGSSPRT
 Q
