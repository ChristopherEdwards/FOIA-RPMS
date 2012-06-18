OCXRU009 ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*96) ;JAN 30,2001 at 11:16
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
 G ^OCXRU00A
 ;
 Q
 ;
DATA ;
 ;
 ;;R^"860.8:",100,61
 ;;D^T-; ..D SETAP(OCXGR2_")","860.71223P",.OCXDATA,OCXDFI)
 ;;R^"860.8:",100,62
 ;;D^  ; ;
 ;;R^"860.8:",100,63
 ;;D^  ; Q 1
 ;;R^"860.8:",100,64
 ;;D^  ; ;
 ;;R^"860.8:",100,65
 ;;D^T+;SETAP(ROOT,DD,ITEM,ITEMNAME,DATA,DA) ;  Set Rule Event data
 ;;R^"860.8:",100,66
 ;;D^T-;SETAP(ROOT,DD,DATA,DA) ;  Set Rule Event data
 ;;R^"860.8:",100,67
 ;;D^  ; S:(DD&'$D(@ROOT@(0))) @ROOT@(0)=U_DD_U
 ;;R^"860.8:",100,68
 ;;D^  ; S:'$D(@ROOT@(DA,0)) $P(@ROOT@(0),U,3)=$P(@ROOT@(0),U,3)+1,$P(@ROOT@(0),U,4)=DA
 ;;R^"860.8:",100,69
 ;;D^  ; M @ROOT=DATA
 ;;R^"860.8:",100,70
 ;;D^T+; W:$G(OCXTRACE) !,"File Active Data ",ITEM,": ",ITEMNAME
 ;;R^"860.8:",100,71
 ;;D^  ; ;
 ;;R^"860.8:",100,72
 ;;D^  ; Q
 ;;R^"860.8:",100,73
 ;;D^  ; ;
 ;;R^"860.8:",100,74
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^ORDER CANCELING PROVIDER
 ;;R^"860.8:",.01,"E"
 ;;D^ORDER CANCELING PROVIDER
 ;;R^"860.8:",.02,"E"
 ;;D^CANCELER
 ;;R^"860.8:",1,1
 ;;D^Extrinsic function returns DUZ of provider who cancelled the order.
 ;;R^"860.8:",100,1
 ;;D^  ;CANCELER(ORNUM) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; Q:'$G(ORNUM) ""
 ;;R^"860.8:",100,4
 ;;D^  ; S ORNUM=+$G(ORNUM)
 ;;R^"860.8:",100,5
 ;;D^  ; N ORQDUZ
 ;;R^"860.8:",100,6
 ;;D^  ; Q:'$D(^OR(100,ORNUM,6)) ""
 ;;R^"860.8:",100,7
 ;;D^  ; S ORQDUZ=$P(^OR(100,ORNUM,6),U,2)
 ;;R^"860.8:",100,8
 ;;D^  ; Q ORQDUZ
 ;;R^"860.8:",100,9
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^ORDERABLE ITEM
 ;;R^"860.8:",.01,"E"
 ;;D^ORDERABLE ITEM
 ;;R^"860.8:",.02,"E"
 ;;D^OI
 ;;R^"860.8:",1,1
 ;;D^Extrinsic function returns the orderable item for an order number.
 ;;R^"860.8:",100,1
 ;;D^    ;OI(OCXOR) ;func rtns orderable item for an order number (OCXOR)
 ;;R^"860.8:",100,2
 ;;D^    ; Q:+$G(OCXOR)<1 ""
 ;;R^"860.8:",100,3
 ;;D^    ; N OCXOI S OCXOI=""
 ;;R^"860.8:",100,4
 ;;D^    ; S OCXOI=$G(^OR(100,+$G(OCXOR),.1,1,0))
 ;;R^"860.8:",100,5
 ;;D^    ; Q OCXOI
 ;;R^"860.8:",100,6
 ;;D^    ; ;
 ;;EOR^
 ;;KEY^860.8:^ORDERING PROVIDER
 ;;R^"860.8:",.01,"E"
 ;;D^ORDERING PROVIDER
 ;;R^"860.8:",.02,"E"
 ;;D^ORDERER
 ;;R^"860.8:",1,1
 ;;D^Extrinsic function returns DUZ of provider who entered original order.
 ;;R^"860.8:",100,1
 ;;D^  ;ORDERER(ORNUM) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; Q:'$G(ORNUM) ""
 ;;R^"860.8:",100,4
 ;;D^  ; S ORNUM=+$G(ORNUM)
 ;;R^"860.8:",100,5
 ;;D^  ; N ORQDUZ,ORQI S ORQDUZ=""
 ;;R^"860.8:",100,6
 ;;D^  ; I $L($G(^OR(100,ORNUM,8,0))) D
 ;;R^"860.8:",100,7
 ;;D^  ; .S ORQI=0,ORQI=$O(^OR(100,ORNUM,8,"C","NW",ORQI))
 ;;R^"860.8:",100,8
 ;;D^  ; Q:+$G(ORQI)<1 ""
 ;;R^"860.8:",100,9
 ;;D^  ; S ORQDUZ=$P(^OR(100,ORNUM,8,ORQI,0),U,3)
 ;;R^"860.8:",100,10
 ;;D^  ; Q ORQDUZ
 ;;R^"860.8:",100,11
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^PATIENT LOCATION
 ;;R^"860.8:",.01,"E"
 ;;D^PATIENT LOCATION
 ;;R^"860.8:",.02,"E"
 ;;D^PATLOC
 ;;R^"860.8:",1,1
 ;;D^Returns the Inpatient or Outpatient location for the patient.
 ;;R^"860.8:",1,2
 ;;D^ 
 ;;R^"860.8:",1,3
 ;;D^  Input: DFN
 ;;R^"860.8:",1,4
 ;;D^  Output: Patient Status (I/O) Inpatient/Outpatient
 ;;R^"860.8:",1,5
 ;;D^          Patient Location (Free text name)
 ;;R^"860.8:",100,1
 ;;D^  ;PATLOC(DFN) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; N OCXP1,OCXP2
 ;;R^"860.8:",100,4
 ;;D^  ; S OCXP1=$G(^TMP("OCXSWAP",$J,"OCXODATA","PV1",2))
 ;;R^"860.8:",100,5
 ;;D^  ; S OCXP2=$P($G(^TMP("OCXSWAP",$J,"OCXODATA","PV1",3)),"^",1)
 ;;R^"860.8:",100,6
 ;;D^T+; W:$G(OCXTRACE) !,"OCXP2: ",$G(OCXP1)
 ;;R^"860.8:",100,7
 ;;D^T+; W:$G(OCXTRACE) !,"OCXP2: ",$G(OCXP2)
 ;;R^"860.8:",100,8
 ;;D^  ; I OCXP2 D
 ;;R^"860.8:",100,9
 ;;D^  ; .S OCXP2=$P($G(^SC(+OCXP2,0)),"^",1,2)
 ;;R^"860.8:",100,10
 ;;D^  ; .I $L($P(OCXP2,"^",2)) S OCXP2=$P(OCXP2,"^",2)
 ;;R^"860.8:",100,11
 ;;D^  ; .E  S OCXP2=$P(OCXP2,"^",1)
 ;;R^"860.8:",100,12
 ;;D^  ; .S:'$L(OCXP2) OCXP2="NO LOC"
 ;;R^"860.8:",100,13
 ;;D^  ; I $L(OCXP1),$L(OCXP2) Q OCXP1_"^"_OCXP2
 ;;R^"860.8:",100,14
 ;;D^  ; ;
 ;;R^"860.8:",100,15
 ;;D^  ; S OCXP2=$G(^DPT(+$G(DFN),.1))
 ;;R^"860.8:",100,16
 ;;D^  ; I $L(OCXP2) Q "I^"_OCXP2
 ;;R^"860.8:",100,17
 ;;D^  ; Q "O^OUTPT"
 ;;R^"860.8:",100,18
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^RETURN POINTED TO VALUE
 ;;R^"860.8:",.01,"E"
 ;;D^RETURN POINTED TO VALUE
 ;;R^"860.8:",.02,"E"
 ;;D^POINTER
 ;;R^"860.8:",1,1
 ;;D^  ;POINTER(OCXFILE,D0) ;    This Local Extrinsic Function gets the value of the name field
 ;;R^"860.8:",1,2
 ;;D^  ; ;  of record D0 in file OCXFILE
 ;;R^"860.8:",100,1
 ;;D^  ;POINTER(OCXFILE,D0) ;    This Local Extrinsic Function gets the value of the name field
 ;;R^"860.8:",100,2
 ;;D^  ; ;  of record D0 in file OCXFILE
 ;;R^"860.8:",100,3
 ;;D^T+; I $G(OCXTRACE) W !,"%%%%",?20,"   FILE: ",$G(OCXFILE),"  D0: ",$G(D0)
 ;;R^"860.8:",100,4
 ;;D^  ; Q:'$G(D0) "" Q:'$L($G(OCXFILE)) ""
 ;;R^"860.8:",100,5
 ;;D^  ; N GLREF
 ;;R^"860.8:",100,6
 ;;D^  ; I '(OCXFILE=(+OCXFILE)) S GLREF=U_OCXFILE
 ;;R^"860.8:",100,7
 ;;D^  ; E  S GLREF=$$FILE^OCXBDTD(+OCXFILE,"GLOBAL NAME") Q:'$L(GLREF) ""
 ;;R^"860.8:",100,8
 ;;D^T+; I $G(OCXTRACE) W !,"%%%%",?20," GLREF: ",GLREF,"  RESOLVES TO: ",$P($G(@(GLREF_(+D0)_",0)")),U,1)
 ;;R^"860.8:",100,9
 ;;D^  ; Q $P($G(@(GLREF_(+D0)_",0)")),U,1)
 ;;R^"860.8:",100,10
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^STRING CONTAINS ONE OF A LIST OF VALUES
 ;;R^"860.8:",.01,"E"
 ;;D^STRING CONTAINS ONE OF A LIST OF VALUES
 ;;R^"860.8:",.02,"E"
 ;;D^CLIST
 ;;R^"860.8:",100,1
 ;;D^  ;CLIST(DATA,LIST) ;   DOES THE DATA FIELD CONTAIN AN ELEMENT IN THE LIST
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^T+; W:$G(OCXTRACE) !!,"$$CLIST(",DATA,",""",LIST,""")"
 ;;R^"860.8:",100,4
 ;;D^  ; N PC F PC=1:1:$L(LIST,","),0 I PC,$L($P(LIST,",",PC)),(DATA[$P(LIST,",",PC)) Q
 ;;R^"860.8:",100,5
 ;;D^  ; Q ''PC
 ;;EOR^
 ;;KEY^860.8:^WARD ROOM-BED
 ;;R^"860.8:",.01,"E"
 ;;D^WARD ROOM-BED
 ;;R^"860.8:",.02,"E"
 ;;D^WARDRMBD
 ;;R^"860.8:",1,1
 ;;D^Returns the patient's ward and room-bed if they exist.  Can be used to
 ;;R^"860.8:",1,2
 ;;D^determine if the patient is inpatient or outpatient.  Official MAS policy
 ;;R^"860.8:",1,3
 ;;D^indicates that if the patient has a ward (^DPT(DFN,.1)), then they are an
 ;;R^"860.8:",1,4
 ;;D^inpatient.  If the .1 node does not exist, they are an outpatient.
 ;;R^"860.8:",100,1
 ;;D^  ;WARDRMBD(DFN) ;
 ;;R^"860.8:",100,2
 ;;D^  ; ;
 ;;R^"860.8:",100,3
 ;;D^  ; Q:'$G(DFN) 0
 ;;R^"860.8:",100,4
 ;;D^  ; N OUT S OUT=$G(^DPT(DFN,.1)) Q:'$L(OUT) 0
 ;;R^"860.8:",100,5
 ;;D^  ; S OUT=1_"^"_OUT_" "_$G(^DPT(DFN,.101)) Q OUT
 ;;R^"860.8:",100,6
 ;;D^  ; ;
 ;;EOR^
 ;;EOF^OCXS(860.8)^1
 ;;SOF^860.6  ORDER CHECK DATA CONTEXT
 ;;KEY^860.6:^CPRS ORDER PRESCAN
 ;;R^"860.6:",.01,"E"
 ;;D^CPRS ORDER PRESCAN
 ;;R^"860.6:",.02,"E"
 ;;D^OEPS
 ;;R^"860.6:",1,"E"
 ;;D^DATA DRIVEN
 ;;EOR^
 ;;KEY^860.6:^CPRS ORDER PROTOCOL
 ;;R^"860.6:",.01,"E"
 ;;D^CPRS ORDER PROTOCOL
 ;;R^"860.6:",.02,"E"
 ;;D^OERR
 ;;R^"860.6:",1,"E"
 ;;D^DATA DRIVEN
 ;;EOR^
 ;;KEY^860.6:^DATABASE LOOKUP
 ;;R^"860.6:",.01,"E"
 ;;D^DATABASE LOOKUP
 ;;R^"860.6:",.02,"E"
 ;;D^DL
 ;;R^"860.6:",1,"E"
 ;;D^PACKAGE LOOKUP
 ;;EOR^
 ;;KEY^860.6:^GENERIC HL7 MESSAGE ARRAY
 ;1;
 ;
