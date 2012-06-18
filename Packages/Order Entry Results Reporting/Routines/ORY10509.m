ORY10509 ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*105) ;OCT 16,2001 at 15:39
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
 G ^ORY1050A
 ;
 Q
 ;
DATA ;
 ;
 ;;R^"860.8:",100,71
 ;;D^  ; ;
 ;;R^"860.8:",100,72
 ;;D^  ; Q
 ;;R^"860.8:",100,73
 ;;D^  ; ;
 ;;R^"860.8:",100,74
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
 ;;KEY^860.8:^RECENT CREATININE LAB PROCEDURE
 ;;R^"860.8:",.01,"E"
 ;;D^RECENT CREATININE LAB PROCEDURE
 ;;R^"860.8:",.02,"E"
 ;;D^RECCREAT
 ;;R^"860.8:",100,1
 ;;D^   ;RECCREAT(ORDFN,ORDAYS)  ;extrinsic function to return most recent 
 ;;R^"860.8:",100,2
 ;;D^   ; ;SERUM CREATININE within <ORDAYS> in format:
 ;;R^"860.8:",100,3
 ;;D^   ; ; test id^result units flag ref range collection d/t
 ;;R^"860.8:",100,4
 ;;D^   ; N BDT,CDT,ORY,ORX,ORZ,X,TEST,ORI,ORJ,CREARSLT,LABFILE,SPECFILE
 ;;R^"860.8:",100,5
 ;;D^   ; Q:'$L($G(ORDFN)) "0^"
 ;;R^"860.8:",100,6
 ;;D^   ; Q:'$L($G(ORDAYS)) "0^"
 ;;R^"860.8:",100,7
 ;;D^   ; D NOW^%DTC
 ;;R^"860.8:",100,8
 ;;D^   ; S BDT=$$FMADD^XLFDT(%,"-"_ORDAYS,"","","")
 ;;R^"860.8:",100,9
 ;;D^   ; K %
 ;;R^"860.8:",100,10
 ;;D^   ; Q:'$L($G(BDT)) "0^"
 ;;R^"860.8:",100,11
 ;;D^   ; S LABFILE=$$TERMLKUP("SERUM CREATININE",.ORY)
 ;;R^"860.8:",100,12
 ;;D^   ; Q:$G(LABFILE)'=60 "0^"
 ;;R^"860.8:",100,13
 ;;D^   ; Q:+$G(ORY)<1 "0^"
 ;;R^"860.8:",100,14
 ;;D^   ; S SPECFILE=$$TERMLKUP("SERUM SPECIMEN",.ORX)
 ;;R^"860.8:",100,15
 ;;D^   ; Q:$G(SPECFILE)'=61 "0^"
 ;;R^"860.8:",100,16
 ;;D^   ; Q:+$G(ORX)<1 "0^"
 ;;R^"860.8:",100,17
 ;;D^   ; F ORI=1:1:ORY I +$G(CREARSLT)<1 D
 ;;R^"860.8:",100,18
 ;;D^   ; .S TEST=$P(ORY(ORI),U)
 ;;R^"860.8:",100,19
 ;;D^   ; .Q:+$G(TEST)<1
 ;;R^"860.8:",100,20
 ;;D^   ; .F ORJ=1:1:ORX I +$G(CREARSLT)<1 D
 ;;R^"860.8:",100,21
 ;;D^   ; ..S SPECIMEN=$P(ORX(ORJ),U)
 ;;R^"860.8:",100,22
 ;;D^   ; ..Q:+$G(SPECIMEN)<1
 ;;R^"860.8:",100,23
 ;;D^   ; ..S ORZ=$$LOCL^ORQQLR1(ORDFN,TEST,SPECIMEN)
 ;;R^"860.8:",100,24
 ;;D^   ; ..Q:'$L($G(ORZ))
 ;;R^"860.8:",100,25
 ;;D^   ; ..S CDT=$P(ORZ,U,7)
 ;;R^"860.8:",100,26
 ;;D^   ; ..I CDT'<BDT S CREARSLT=1
 ;;R^"860.8:",100,27
 ;;D^   ; Q:+$G(CREARSLT)<1 "0^"
 ;;R^"860.8:",100,28
 ;;D^   ; Q $P(ORZ,U)_U_$P(ORZ,U,3)_" "_$P(ORZ,U,4)_" "_$P(ORZ,U,5)_" ("_$P(ORZ,U,6)_")  "_$$FMTE^XLFDT(CDT,"2P")_U_$P(ORZ,U,3)
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
 ;;R^"860.6:",.01,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;R^"860.6:",.02,"E"
 ;;D^HL7
 ;;R^"860.6:",1,"E"
 ;;D^DATA DRIVEN
 ;;EOR^
 ;;EOF^OCXS(860.6)^1
 ;;SOF^860.5  ORDER CHECK DATA SOURCE
 ;;KEY^860.5:^DATABASE LOOKUP
 ;;R^"860.5:",.01,"E"
 ;;D^DATABASE LOOKUP
 ;;R^"860.5:",.02,"E"
 ;;D^DATABASE LOOKUP
 ;;EOR^
 ;;KEY^860.5:^HL7 COMMON ORDER SEGMENT
 ;;R^"860.5:",.01,"E"
 ;;D^HL7 COMMON ORDER SEGMENT
 ;;R^"860.5:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;EOR^
 ;;KEY^860.5:^HL7 OBSERVATION REQUEST SEGMENT
 ;;R^"860.5:",.01,"E"
 ;;D^HL7 OBSERVATION REQUEST SEGMENT
 ;;R^"860.5:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;EOR^
 ;;KEY^860.5:^HL7 OBSERVATION/RESULT SEGMENT
 ;;R^"860.5:",.01,"E"
 ;;D^HL7 OBSERVATION/RESULT SEGMENT
 ;;R^"860.5:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;EOR^
 ;;KEY^860.5:^HL7 PATIENT ID SEGMENT
 ;;R^"860.5:",.01,"E"
 ;;D^HL7 PATIENT ID SEGMENT
 ;;R^"860.5:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;EOR^
 ;;KEY^860.5:^OERR ORDER EVENT FLAG PROTOCOL
 ;;R^"860.5:",.01,"E"
 ;;D^OERR ORDER EVENT FLAG PROTOCOL
 ;;R^"860.5:",.02,"E"
 ;;D^CPRS ORDER PROTOCOL
 ;;EOR^
 ;;KEY^860.5:^ORDER ENTRY ORDER PRESCAN
 ;;R^"860.5:",.01,"E"
 ;;D^ORDER ENTRY ORDER PRESCAN
 ;;R^"860.5:",.02,"E"
 ;;D^CPRS ORDER PRESCAN
 ;;EOR^
 ;;EOF^OCXS(860.5)^1
 ;;SOF^860.4  ORDER CHECK DATA FIELD
 ;;KEY^860.4:^ABNORMAL RENAL BIOCHEM RESULTS
 ;;R^"860.4:",.01,"E"
 ;1;
 ;
