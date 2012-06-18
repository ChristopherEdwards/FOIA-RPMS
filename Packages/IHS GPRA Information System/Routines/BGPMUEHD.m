BGPMUEHD ; IHS/MSC/MMT - EH Report Driver;02-Mar-2011 16:33;MGH
 ;;11.0;IHS CLINICAL REPORTING;**4**;JAN 06, 2011;Build 84
 ;Eligible Hospital CQM evaluation driver
PROC ;EP
 S BGPBT=$H
 D JRNL^BGPMUUTL
 S BGPJ=$J,BGPH=$H
 S BGPCHWC=0
 K ^XTMP("BGPMUHOS",BGPJ,BGPH) ; not sure if I need this Timestamp stuff or if it should be Provider Specific
 D XTMP^BGPMUUTL("BGPMUHOS","Meaningful Use Hospital CQM Report")
 ;calculate 3 years before end of each time frame
 S BGP3YE=$$FMADD^XLFDT(BGPED,-1096)
 S BGPB3YE=$$FMADD^XLFDT(BGPBED,-1096)
 D PROCCY,PROCPY,PROCBY
N ;
 S BGPET=$H
 Q
 ;
PROCCY ;EP - current time period
 S BGPBDATE=BGPBD,BGPEDATE=BGPED,BGPTIME=1
 S BGP365=BGPBDATE
 S BGPMUTF="C"
 D CALCMEAS
 Q
PROCPY ;
 S BGPBDATE=BGPPBD,BGPEDATE=BGPPED,BGPTIME=2
 S BGP365=BGPBDATE
 S BGPMUTF="P"
 D CALCMEAS
 Q
PROCBY ;
 S BGPBDATE=BGPBBD,BGPEDATE=BGPBED,BGPTIME=3
 S BGP365=BGPBDATE
 S BGPMUTF="B"
 D CALCMEAS
 Q
CALCMEAS ;
 D CALCMEAS^BGPMUDCI
 Q
ACTUPAP(P,BDATE,EDATE,B) ;EP - is this patient in user pop? - NO EXPIRED CHECKS
 I B=1,$$BEN^AUPNPAT(P,"C")'="01" Q 0  ;must be Indian/Alaskan Native
 I B=2,$$BEN^AUPNPAT(P,"C")="01" Q 0  ;must not be I/A
 Q 1
V2(P,BDATE,EDATE) ;EP
 N A,B,V,X,G,E
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G>2)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .S G=G+1
 .Q
 Q $S(G<2:"",1:1)
 ;
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
BQI(BQIGREF) ;PEP - iCARE
 ; Input parameters
 ; BQIGREF = Global reference to store data
 Q:BQIGREF=""
 N BGPICARE,BGPIMEAS,BGPUMTF,BGPIIEN,BGPIDATA
 S BGPBT=$H
 D JRNL^BGPMUUTL
 S BGPJ=$J,BGPH=$H
 S BGPCHWC=0
 K ^XTMP("BGPMUHOS",BGPJ,BGPH) ; not sure if I need this Timestamp stuff or if it should be Provider Specific
 D XTMP^BGPMUUTL("BGPMUHOS","Meaningful Use Hospital CQM Report")
 ;calculate 3 years before end of each time frame
 S BGP3YE=$$FMADD^XLFDT(BGPED,-1096)
 S BGPB3YE=$$FMADD^XLFDT(BGPBED,-1096)
 K BGPICARE
 D PROCCY,PROCPY
 ;Move patient data for all requested measures from array to the passed in global reference
 S BGPIMEAS=""
 F  S BGPIMEAS=$O(BGPICARE(BGPIMEAS)) Q:BGPIMEAS=""  D
 .S BGPMUTF=""
 .F  S BGPMUTF=$O(BGPICARE(BGPIMEAS,BGPMUTF)) Q:BGPMUTF=""  D
 ..S DFN=""
 ..F  S DFN=$O(BGPICARE(BGPIMEAS,BGPMUTF,DFN)) Q:DFN=""  D
 ...S BGPIDATA=$G(BGPICARE(BGPIMEAS,BGPMUTF,DFN))
 ...;Lookup indicator ID
 ...S BGPIIEN=$O(^BGPMUIND(90596.11,"C",BGPIMEAS,0))
 ...;Store into global
 ...S @BQIGREF@(DFN,BGPMUTF,BGPIIEN)=BGPIDATA
 D BQIKILL
 K BGPICARE,BGPIMEAS,BGPUMTF,BGPIIEN,BGPIDATA
 Q
BQIKILL ; TEMPORARY Subroutine to kill off ^TMP globals created by running measure evals without printing
 ;This routine should be removed once a better system for killing off ^TMP globals has been implemented
 K ^TMP("BGPMU0495",$J)
 K ^TMP("BGPMU0497",$J)
 K ^TMP("BGPMU0435",$J)
 K ^TMP("BGPMU0436",$J)
 K ^TMP("BGPMU0437",$J)
 K ^TMP("BGPMU0438",$J)
 K ^TMP("BGPMU0439",$J)
 K ^TMP("BGPMU0440",$J)
 K ^TMP("BGPMU0441",$J)
 K ^TMP("BGPMU0371",$J)
 K ^TMP("BGPMU0372",$J)
 K ^TMP("BGPMU0373",$J)
 K ^TMP("BGPMU0374",$J)
 K ^TMP("BGPMU0375",$J)
 K ^TMP("BGPMU0376",$J)
 Q
