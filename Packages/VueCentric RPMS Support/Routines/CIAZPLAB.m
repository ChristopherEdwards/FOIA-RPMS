CIAZPLAB ;CIA/PLS - Laboratory Protocol Event API  ;23-Apr-2004 11:21;PLS
 ;;1.1;VUECENTRIC RPMS SUPPORT;;Sep 14, 2004
 ;;Copyright 2000-2004, Clinical Informatics Associates, Inc.
 ;=================================================================
 ; This routine implements the existing BLRTN logic via Protocols
HOOK ;
 N ZMSG
 M ZMSG=@XQORMSG
 ; Assumes that BLRLOG is already defined
 Q:'$G(BLRLOG,1)  ;PCC logging is turned off
 N SEG,LP,DL1,DL2,ACTION,ORDSTS,TYP,CD,XLRACC,XLRSS,OBR
 S LP=0
 S SEG=$$SEG(XQORMSG,"MSH",.LP)
 Q:'LP
 S DL1=$E(SEG,4),DL2=$E(SEG,5)
 Q:$P(SEG,DL1,3)'="LABORATORY"
 S SEG=$$SEG(XQORMSG,"ORC",.LP)
 Q:'LP
 S ORDSTS=$P(SEG,DL1,6)  ; Order Status
 S ACTION=$P(SEG,DL1,2)  ; Order Control
 S XLRSS=$P($P(SEG,DL1,4),";",4)
 S OBR=$$SEG(XQORMSG,"OBR",.LP)
 Q:'LP
 S XLRACC=$P(OBR,DL1,21)  ;Accession Number - Text Format
 I ACTION?2U,$L($T(@ACTION)) D
 .S TYP=$$GETTYP()
 .S CD=","
 .D:$L(TYP) @ACTION
 Q
 ; Return specified segment, starting at line LP
SEG(MSG,TYP,LP) ;
 F  S LP=$O(@MSG@(LP)) Q:'LP  Q:$E(@MSG@(LP),1,$L(TYP))=TYP
 Q $S(LP:@MSG@(LP),1:"")
 ;
GETTYP() ; Returns message type
 Q $S($G(XQORMSG)["LRCH":"CH",$G(XQORMSG)["LRBB":"BB",$G(XQORMSG)["LRAP":"AP",1:"")
 ;
SET(N) ;
 S $ZE="LRZHOOK LOG_"_N D ^ZTER  ;Temporary
 Q
FIXAA(XAA) ; Perform lookup on LRUID if LRAA is not defined
 Q:+$G(XAA) XAA
 I $L($G(LRUID)) Q +$O(^LRO(68,"C",LRUID,0))
 Q 0
SN ; New Order
 I ORDSTS="IP" D
 .D ^BLREVTQ("C","O","MULTI",,$G(LRODT,"")_CD_$G(LRSN,""))
 I ORDSTS="SC" D
 .D ^BLREVTQ("C","A","ADDACC",,$G(LRODT)_CD_$G(LRSN)_CD_$$FIXAA($G(LRAA))_CD_$G(LRAD)_CD_$G(LRAN))
 Q
SC ;
 ; Make order
 I ORDSTS="IP" D
 .D ^BLREVTQ("M","O","",,$G(LRODT,"")_CD_$G(LRSN,""))
 ; Make accession
 I ORDSTS="SC" D
 .N LRTS
 .S LRTS=$P($P(OBR,DL1,5),DL2,4)  ; Obtain Test IEN for File 60
 .D ^BLREVTQ("C","A","ADDACC",,+$G(LRODT)_CD_+$G(LRSN)_CD_$$FIXAA($G(LRAA))_CD_+$G(LRAD)_CD_+$G(LRAN)_CD_$G(LRACC))
 Q
OH ; Hold Order
 Q
OD ; Order Delete
 ;D ^BLREVTQ("M","D","DELORD","ORDER")   ;"TESTS",+$G(LRAA)_CD_+$G(LRAD)_CD_+$G(LRAN))
 Q
OC ; Order Cancelled
 D ^BLREVTQ("M","D","DELACC","TESTS",$G(LRAA)_CD_$G(LRAD)_CD_$G(LRAN))
 Q
DC ; Discontinue Order
 Q
RE ; Results
 I TYP="CH" D  Q
 .I XLRSS="CH" D    ; Chemistry
 ..D ^BLREVTQ("M","R","",,$S($L($G(LRACC)):LRACC,1:XLRACC))
 .I XLRSS="MI" D    ; Microbiology
 ..D ^BLREVTQ("M","R","MICRO",,+$G(LRAA)_CD_+$G(LRAD)_CD_+$G(LRAN))
 I TYP="BB" D  Q
 .D ^BLREVTQ("M","R","BBANK",,+$G(LRODT)_CD_+$G(LRSN)_CD_+$G(LRAA)_CD_+$G(LRAD)_CD_+$G(LRAN))
 I TYP="AP" Q  ; Lab Package messaging is not enabled for AP
 Q
