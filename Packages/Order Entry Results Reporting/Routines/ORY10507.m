ORY10507 ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*105) ;OCT 16,2001 at 15:39
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**105**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 D DOT^ORY105ES
 ;
 ;
 K REMOTE,LOCAL,OPCODE,REF
 F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
 .S ^TMP("OCXRULE",$J,$O(^TMP("OCXRULE",$J,"A"),-1)+1)=TEXT
 ;
 G ^ORY10508
 ;
 Q
 ;
DATA ;
 ;
 ;;R^"860.8:",100,17
 ;;D^  ; Q:'$L(OCXLIST) UNAV  Q 1_U_OCXLIST
 ;;R^"860.8:",100,18
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
 ;;KEY^860.8:^GENERATE STRING CHECKSUM
 ;;R^"860.8:",.01,"E"
 ;;D^GENERATE STRING CHECKSUM
 ;;R^"860.8:",.02,"E"
 ;;D^CKSUM
 ;;R^"860.8:",100,1
 ;;D^  ;CKSUM(STR) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; N CKSUM,PTR,ASC S CKSUM=0
 ;;R^"860.8:",100,4
 ;;D^  ; S STR=$TR(STR,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;;R^"860.8:",100,5
 ;;D^  ; F PTR=$L(STR):-1:1 S ASC=$A(STR,PTR)-42 I (ASC>0),(ASC<51) S CKSUM=CKSUM*2+ASC
 ;;R^"860.8:",100,6
 ;;D^  ; Q +CKSUM
 ;;R^"860.8:",100,7
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^GET DATA FROM THE ACTIVE DATA FILE
 ;;R^"860.8:",.01,"E"
 ;;D^GET DATA FROM THE ACTIVE DATA FILE
 ;;R^"860.8:",.02,"E"
 ;;D^GETDATA
 ;;R^"860.8:",100,1
 ;;D^  ;GETDATA(DFN,OCXL,OCXDFI) ;     This Local Extrinsic Function returns runtime data
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; N OCXE,VAL,PC S VAL=""
 ;;R^"860.8:",100,4
 ;;D^  ; F PC=1:1:$L(OCXL,U) S OCXE=$P(OCXL,U,PC) I OCXE S VAL=$G(^TMP("OCXCHK",$J,DFN,OCXE,OCXDFI)) Q:$L(VAL)
 ;;R^"860.8:",100,5
 ;;D^  ; Q VAL
 ;;R^"860.8:",100,6
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^GET ORDERABLE ITEM FROM ORDER NUMBER
 ;;R^"860.8:",.01,"E"
 ;;D^GET ORDERABLE ITEM FROM ORDER NUMBER
 ;;R^"860.8:",.02,"E"
 ;;D^ORDITEM
 ;;R^"860.8:",100,1
 ;;D^ ;ORDITEM(OIEN) ;
 ;;R^"860.8:",100,2
 ;;D^ ;
 ;;R^"860.8:",100,3
 ;;D^ ; Q:'$G(OIEN) ""
 ;;R^"860.8:",100,4
 ;;D^ ; ;
 ;;R^"860.8:",100,5
 ;;D^ ; N OITXT,X S OITXT=$$OI^ORQOR2(OIEN) Q:'OITXT "No orderable item found."
 ;;R^"860.8:",100,6
 ;;D^ ; S X=$G(^ORD(101.43,+OITXT,0)) Q:'$L(X) "No orderable item found."
 ;;R^"860.8:",100,7
 ;;D^ ; Q $P(X,U,1)
 ;;R^"860.8:",100,8
 ;;D^ ; ;
 ;;EOR^
 ;;KEY^860.8:^IN LIST OPERATOR
 ;;R^"860.8:",.01,"E"
 ;;D^IN LIST OPERATOR
 ;;R^"860.8:",.02,"E"
 ;;D^LIST
 ;;R^"860.8:",100,1
 ;;D^  ;LIST(DATA,LIST) ;   IS THE DATA FIELD IN THE LIST
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^T+; W:$G(OCXTRACE) !,"%%%%",?20,"     $$LIST(""",DATA,""",""",LIST,""")"
 ;;R^"860.8:",100,4
 ;;D^  ; S:'($E(LIST,1)=",") LIST=","_LIST S:'($E(LIST,$L(LIST))=",") LIST=LIST_"," S DATA=","_DATA_","
 ;;R^"860.8:",100,5
 ;;D^  ; Q (LIST[DATA)
 ;;R^"860.8:",100,6
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^INPATIENT WARD
 ;;R^"860.8:",.01,"E"
 ;;D^INPATIENT WARD
 ;;R^"860.8:",.02,"E"
 ;;D^INPTWARD
 ;;R^"860.8:",1,1
 ;;D^Returns the ward location for an inpatient.
 ;;R^"860.8:",100,1
 ;;D^ ;INPTWARD(DFN) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; Q:'$G(DFN) "NO LOC"
 ;;R^"860.8:",100,4
 ;;D^  ; N WARD S WARD=$G(^DPT(DFN,.1)) Q:'$L(WARD) "NO LOC"
 ;;R^"860.8:",100,5
 ;;D^  ; Q WARD
 ;;R^"860.8:",100,6
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^LAB THRESHOLD EXCEEDED BOOLEAN
 ;;R^"860.8:",.01,"E"
 ;;D^LAB THRESHOLD EXCEEDED BOOLEAN
 ;;R^"860.8:",.02,"E"
 ;;D^LABTHRSB
 ;;R^"860.8:",1,1
 ;;D^Extrinsic function returns "1" if any entity has a parameter threshold
 ;;R^"860.8:",1,2
 ;;D^value that is exceeded by the lab result.
 ;;R^"860.8:",100,1
 ;;D^  ;LABTHRSB(OCXLAB,OCXSPEC,OCXRSLT,OCXOP)       ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; Q:'$G(OCXLAB)!'$G(OCXSPEC)!'$G(OCXRSLT)!'$L($G(OCXOP)) 0
 ;;R^"860.8:",100,4
 ;;D^  ; ;
 ;;R^"860.8:",100,5
 ;;D^  ; N OCXX,OCXPENT,OCXERR,OCXLABSP,OCXPVAL,OCXEXCD
 ;;R^"860.8:",100,6
 ;;D^  ; S OCXEXCD=0,OCXLABSP=OCXLAB_";"_OCXSPEC
 ;;R^"860.8:",100,7
 ;;D^  ; D ENVAL^XPAR(.OCXX,"ORB LAB "_OCXOP_" THRESHOLD",OCXLABSP,.OCXERR)
 ;;R^"860.8:",100,8
 ;;D^T+; I $G(OCXTRACE) W !,"Lab parameter values:",! ZW OCXX,OCXERR
 ;;R^"860.8:",100,9
 ;;D^  ; Q:+$G(ORERR)'=0 OCXEXCD
 ;;R^"860.8:",100,10
 ;;D^  ; Q:+$G(OCXX)=0 OCXEXCD
 ;;R^"860.8:",100,11
 ;;D^  ; S OCXPENT="" F  S OCXPENT=$O(OCXX(OCXPENT)) Q:'OCXPENT!OCXEXCD=1  D
 ;;R^"860.8:",100,12
 ;;D^  ; .S OCXPVAL=OCXX(OCXPENT,OCXLABSP)
 ;;R^"860.8:",100,13
 ;;D^  ; .I $L(OCXPVAL) D
 ;;R^"860.8:",100,14
 ;;D^  ; ..I $P(OCXPENT,";",2)="VA(200,",@(OCXRSLT_OCXOP_OCXPVAL) S OCXEXCD=1
 ;1;
 ;
