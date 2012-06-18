AGSSRR ; IHS/ADC/PDW - REPORT WRITER #1 ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 K AGSSDT
 Q:'$D(AGSSP("R"))  ;this report not indicated
 ;crossreferences used
LOAD ;EP - load crossreference into ^AGSTEMP
 ;gather dfns from "AS" cross reference(s) "*":2  "A":3
 K ^AGSTEMP(AGSS("JOBID"),"RR")
 S DFN=0,AGSSC("R")=0 F  S DFN=$O(^AUPNPAT("AS",2,DFN)) Q:'DFN  I $D(^DPT(DFN)) S AGSSC("R")=AGSSC("R")+1 I AGSSP("R")="C" S ^AGSTEMP(AGSS("JOBID"),"RR",$P(^DPT(DFN,0),U),DFN)=""
 S ^AGSTEMP(AGSS("JOBID"),"RR")=AGSSC("R")
 Q
PRINT ;EP -
 Q:'$D(AGSSP("R"))
 I '$D(AGSSC("R")) S AGSSC("R")=$G(^AGSTEMP(AGSS("JOBID"),"RR"))
 S AGSLVC="R",AGSSPG=1,AGSGLO="RR"
 S AGSSHDR="Redundant 'adds'" D AGSSHDR^AGSSPRT
 W !!,"The number of ",AGSSHDR," is ",$G(^AGSSTEMP(AGSSITE,"TOT","RR")),!
 Q:(AGSSP("R")'="C")!(AGSSC("R")=0)
 D AGSSHD^AGSSPRT
 D ^AGSSPRT
 Q
