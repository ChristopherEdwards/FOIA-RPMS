OCXRU007 ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*96) ;JAN 30,2001 at 11:16
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**96**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 D DOT^OCXRULE
 ;
 ;
 K REMOTE,LOCAL,OPCODE,REF
 F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
 .S ^TMP("OCXRULE",$J,$O(^TMP("OCXRULE",$J,"A"),-1)+1)=TEXT
 ;
 G ^OCXRU008
 ;
 Q
 ;
DATA ;
 ;
 ;;R^"860.8:",100,21
 ;;D^  ; Q:'OCXF $E(OCXMON+100,2,3)_"/"_$E(OCXDAY+100,2,3)_$S((OCXCYR=OCXYR):" "_OCXHR_":"_OCXMIN,1:"/"_$E(OCXYR,3,4))
 ;;R^"860.8:",100,22
 ;;D^  ; Q:(OCXHR+OCXMIN+OCXSEC) OCXMON_" "_OCXDAY_","_OCXYR_" at "_OCXHR_":"_OCXMIN_"."_OCXSEC_" "_OCXAP
 ;;R^"860.8:",100,23
 ;;D^  ; Q OCXMON_" "_OCXDAY_","_OCXYR
 ;;R^"860.8:",100,24
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^CREATININE CLEARANCE (ESTIMATED/CALCULATED)
 ;;R^"860.8:",.01,"E"
 ;;D^CREATININE CLEARANCE (ESTIMATED/CALCULATED)
 ;;R^"860.8:",.02,"E"
 ;;D^CRCL
 ;;R^"860.8:",100,1
 ;;D^  ;CRCL(DFN) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; N WT,AGE,SEX,SCR,SCRD,CRCL,UNAV,OCXTL,OCXTLS,OCXT,OCXTS
 ;;R^"860.8:",100,4
 ;;D^  ; S UNAV="0^<Unavailable>"
 ;;R^"860.8:",100,5
 ;;D^  ; S WT=$P($$WT^ORQPTQ4(DFN),U,2)*.454 Q:'WT UNAV
 ;;R^"860.8:",100,6
 ;;D^  ; S AGE=$$AGE^ORQPTQ4(DFN) Q:'AGE UNAV
 ;;R^"860.8:",100,7
 ;;D^  ; S SEX=$P($$SEX^ORQPTQ4(DFN),U,1) Q:'$L(SEX) UNAV
 ;;R^"860.8:",100,8
 ;;D^  ; S OCXTL="" Q:'$$TERMLKUP("SERUM CREATININE",.OCXTL) UNAV
 ;;R^"860.8:",100,9
 ;;D^  ; S OCXTLS="" Q:'$$TERMLKUP("SERUM SPECIMEN",.OCXTLS) UNAV
 ;;R^"860.8:",100,10
 ;;D^  ; S SCR="",OCXT=0 F  S OCXT=$O(OCXTL(OCXT)) Q:'OCXT  D  Q:$L(SCR)
 ;;R^"860.8:",100,11
 ;;D^  ; .S OCXTS=0 F  S OCXTS=$O(OCXTLS(OCXTS)) Q:'OCXTS  D  Q:$L(SCR)
 ;;R^"860.8:",100,12
 ;;D^  ; ..S SCR=$$LOCL^ORQQLR1(DFN,OCXT,OCXTS)
 ;;R^"860.8:",100,13
 ;;D^  ; Q:'$L(SCR) UNAV  S SCRV=$P(SCR,U,3) Q:+$G(SCRV)<.01 UNAV
 ;;R^"860.8:",100,14
 ;;D^  ; S SCRD=$P(SCR,U,7) Q:'$L(SCRD) UNAV
 ;;R^"860.8:",100,15
 ;;D^  ; ;
 ;;R^"860.8:",100,16
 ;;D^  ; S CRCL=(((140-AGE)*WT)/(SCRV*72))
 ;;R^"860.8:",100,17
 ;;D^  ; ;
 ;;R^"860.8:",100,18
 ;;D^  ; I (SEX="M") Q SCRD_U_$J(CRCL,1,2)
 ;;R^"860.8:",100,19
 ;;D^  ; I (SEX="F") Q SCRD_U_$J((CRCL*.85),1,2)
 ;;R^"860.8:",100,20
 ;;D^  ; Q UNAV
 ;;R^"860.8:",100,21
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^ELAPSED ORDER CHECK TIME LOGGER
 ;;R^"860.8:",.01,"E"
 ;;D^ELAPSED ORDER CHECK TIME LOGGER
 ;;R^"860.8:",.02,"E"
 ;;D^TIMELOG
 ;;R^"860.8:",100,1
 ;;D^  ;TIMELOG(OCXMODE,OCXCALL) ; Log an entry in the Elapsed time log.
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; ;
 ;;R^"860.8:",100,4
 ;;D^  ; Q 0
 ;;R^"860.8:",100,5
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^EQUALS TERM OPERATOR
 ;;R^"860.8:",.01,"E"
 ;;D^EQUALS TERM OPERATOR
 ;;R^"860.8:",.02,"E"
 ;;D^EQTERM
 ;;R^"860.8:",100,1
 ;;D^  ;EQTERM(DATA,TERM) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^T+; I $G(OCXTRACE) W !,"%%%%",?20," Execution trace  DATA: ",$G(DATA),"   TERM: ",$G(TERM)
 ;;R^"860.8:",100,4
 ;;D^  ; N OCXF,OCXL
 ;;R^"860.8:",100,5
 ;;D^  ; ;
 ;;R^"860.8:",100,6
 ;;D^  ; S OCXL="",OCXF=$$TERMLKUP(TERM,.OCXL)
 ;;R^"860.8:",100,7
 ;;D^T-; Q:'OCXF 0
 ;;R^"860.8:",100,8
 ;;D^T+; I 'OCXF W:$G(OCXTRACE) !,"%%%%",?20," Term '",TERM,"' not in Order Check National Term File" Q 0
 ;;R^"860.8:",100,9
 ;;D^T+; I '$O(OCXL(0)) W:$G(OCXTRACE) !,"%%%%",?20," There are no local terms listed for the National Term '",TERM,"'." Q 0
 ;;R^"860.8:",100,10
 ;;D^T+; I ($D(OCXL(DATA))!$D(OCXL("B",DATA))) W:$G(OCXTRACE) !,"%%%%",?20," Data equals Term" Q 1
 ;;R^"860.8:",100,11
 ;;D^T-; I ($D(OCXL(DATA))!$D(OCXL("B",DATA))) Q 1
 ;;R^"860.8:",100,12
 ;;D^T-; Q 0
 ;;R^"860.8:",100,13
 ;;D^T+; W:$G(OCXTRACE) !,"%%%%",?20," Data does not equal Term" Q 0
 ;;R^"860.8:",100,14
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^FILE DATA IN PATIENT ACTIVE DATA FILE
 ;;R^"860.8:",.01,"E"
 ;;D^FILE DATA IN PATIENT ACTIVE DATA FILE
 ;;R^"860.8:",.02,"E"
 ;;D^FILE
 ;;R^"860.8:",1,1
 ;;D^  ;FILE(DFN,OCXELE,OCXDFL) ;     This Local Extrinsic Function files data
 ;;R^"860.8:",1,2
 ;;D^  ; ;     in the Order Check Patient Data File
 ;;R^"860.8:",1,3
 ;;D^  ; ;
 ;;R^"860.8:",100,1
 ;;D^  ;FILE(DFN,OCXELE,OCXDFL) ;     This Local Extrinsic Function logs a validated event/element.
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^T+; I $G(OCXTRACE) W !,"%%%%",?20," Execution trace  DFN: ",DFN,"   OCXELE: ",+$G(OCXELE),"   OCXDFL: ",$G(OCXDFL)
 ;;R^"860.8:",100,4
 ;;D^  ; N OCXTIMN,OCXTIML,OCXTIMT1,OCXTIMT2,OCXDATA,OCXPC,OCXPC,OCXVAL,OCXSUB,OCXDFI
 ;;R^"860.8:",100,5
 ;;D^  ; S DFN=+$G(DFN),OCXELE=+$G(OCXELE)
 ;;R^"860.8:",100,6
 ;;D^  ; ;
 ;;R^"860.8:",100,7
 ;;D^  ; Q:'DFN 1 Q:'OCXELE 1 K OCXDATA
 ;;R^"860.8:",100,8
 ;;D^  ; ;
 ;;R^"860.8:",100,9
 ;;D^  ; S OCXDATA(DFN,OCXELE)=1
 ;;R^"860.8:",100,10
 ;;D^  ; F OCXPC=1:1:$L(OCXDFL,",") S OCXDFI=$P(OCXDFL,",",OCXPC) I OCXDFI D
 ;;R^"860.8:",100,11
 ;;D^  ; .S OCXVAL=$G(OCXDF(+OCXDFI)),OCXDATA(DFN,OCXELE,+OCXDFI)=OCXVAL
 ;;R^"860.8:",100,12
 ;;D^T+; .I $G(OCXTRACE) W !,"%%%%",?20,"   ",$P($G(^OCXS(860.4,+OCXDFI,0)),U,1)," = """,OCXVAL,""""
 ;;R^"860.8:",100,13
 ;;D^  ; ;
 ;;R^"860.8:",100,14
 ;;D^  ; M ^TMP("OCXCHK",$J,DFN)=OCXDATA(DFN)
 ;;R^"860.8:",100,15
 ;;D^  ; ;
 ;;R^"860.8:",100,16
 ;;D^  ; Q 0
 ;;R^"860.8:",100,17
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^FOOD-DRUG INTERACTION MED
 ;;R^"860.8:",.01,"E"
 ;;D^FOOD-DRUG INTERACTION MED
 ;;R^"860.8:",.02,"E"
 ;;D^FOODDRG
 ;;R^"860.8:",1,1
 ;;D^Function returns 1^<medication name> if the orderable item is food-drug
 ;;R^"860.8:",1,2
 ;;D^interaction medication.  Otherwise return "0^" (zero).
 ;;R^"860.8:",100,1
 ;;D^    ;FOODDRG(OCXOR) ;func rtns 1^<med name> if OCXOR is food-drug med
 ;;R^"860.8:",100,2
 ;;D^    ; N OCXTL,OCXT,OCXFD,OCXOI
 ;;R^"860.8:",100,3
 ;;D^    ; S OCXOI=$$OI(OCXOR)
 ;;R^"860.8:",100,4
 ;;D^    ; Q:'$L(OCXOI) "0^"
 ;;R^"860.8:",100,5
 ;;D^    ; Q:'$$TERMLKUP("FOOD-DRUG INTERACTION MED",.OCXTL) "0^"
 ;;R^"860.8:",100,6
 ;;D^    ; S OCXFD="",OCXT=0 F  S OCXT=$O(OCXTL(OCXT)) Q:'OCXT  D  Q:$L(OCXFD)
 ;;R^"860.8:",100,7
 ;;D^    ; .I OCXT=OCXOI S OCXFD="1^"_OCXTL(OCXT)
 ;;R^"860.8:",100,8
 ;;D^    ; Q:'$L(OCXFD) "0^"
 ;;R^"860.8:",100,9
 ;;D^    ; Q OCXFD
 ;;R^"860.8:",100,10
 ;;D^    ; ;
 ;;EOR^
 ;;KEY^860.8:^FORMATTED LAB RESULTS
 ;;R^"860.8:",.01,"E"
 ;;D^FORMATTED LAB RESULTS
 ;;R^"860.8:",.02,"E"
 ;;D^FLAB
 ;;R^"860.8:",100,1
 ;;D^  ;FLAB(DFN,OCXLIST,OCXSPEC) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; Q:'$G(DFN) "<Patient Not Specified>"
 ;;R^"860.8:",100,4
 ;;D^  ; Q:'$L($G(OCXLIST)) "<Lab Tests Not Specified>"
 ;;R^"860.8:",100,5
 ;;D^  ; N OCXLAB,OCXOUT,OCXPC,OCXSL,SPEC S OCXOUT="",SPEC=""
 ;;R^"860.8:",100,6
 ;;D^  ; I $L($G(OCXSPEC)) S OCXSL=$$TERMLKUP(OCXSPEC,.OCXSL)
 ;;R^"860.8:",100,7
 ;;D^  ; F OCXPC=1:1:$L(OCXLIST,U) S OCXLAB=$P(OCXLIST,U,OCXPC) I $L(OCXLAB) D
 ;;R^"860.8:",100,8
 ;;D^  ; .N OCXX,OCXY,X,Y,DIC,TEST,SPEC,OCXTL,OCXA,OCXR
 ;;R^"860.8:",100,9
 ;;D^  ; .S OCXTL="" Q:'$$TERMLKUP(OCXLAB,.OCXTL)
 ;;R^"860.8:",100,10
 ;;D^  ; .S OCXX="",TEST=0 F  S TEST=$O(OCXTL(TEST)) Q:'TEST  D
 ;;R^"860.8:",100,11
 ;;D^  ; ..I $L($G(OCXSL)) D
 ;;R^"860.8:",100,12
 ;;D^  ; ...S SPEC=0 F  S SPEC=$O(OCXSL(SPEC)) Q:'SPEC  D
 ;;R^"860.8:",100,13
 ;;D^  ; ....S OCXX=$$LOCL^ORQQLR1(DFN,TEST,SPEC) I $L(OCXX) D
 ;;R^"860.8:",100,14
 ;1;
 ;
