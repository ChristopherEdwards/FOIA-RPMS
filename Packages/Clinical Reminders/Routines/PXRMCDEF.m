PXRMCDEF ;SLC/AGP - Computed findings for Reminder Definition. ;01/25/2013
 ;;2.0;CLINICAL REMINDERS;**4,18,24,26**;Feb 04, 2005;Build 404
 ;
 ;======================================================
RDEF(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for returing a Reminder
 ;definition evaluation status
 I TEST="" S TEST=0 Q
 ;New PXRMFFSS and PXRMTDEB so that reminder test function finding
 ;and term output is not corrupted.
 N DEFARR,FIEVAL,NAME,PNAME,RIEN,TEMP,PARAM,PXRMFFSS,PXRMTDEB
 S NAME=$P(TEST,U)
 S PARAM=$P(TEST,U,2),PARAM=$P($G(PARAM),"=",2),TEST=0,DATE=$$NOW^PXRMDATE
 S RIEN=$O(^PXD(811.9,"B",NAME,"")) Q:RIEN'>0
 I +$P(^PXD(811.9,RIEN,0),U,6)=1 Q
 K ^TMP("PXRHM",$J,RIEN)
 S PNAME=$S($P($G(^PXD(811.9,RIEN,0)),U,3)'="":$P(^PXD(811.9,RIEN,0),U,3),1:NAME)
 ;Load the definition into DEFARR.
 D DEF^PXRMLDR(RIEN,.DEFARR)
 D EVAL^PXRM(DFN,.DEFARR,1,0,.FIEVAL,DATE)
 S TEMP=$G(^TMP("PXRHM",$J,RIEN,PNAME))
 K ^TMP("PXRHM",$J,RIEN)
 S TEST=$S(TEMP="":0,TEMP["ERROR":0,TEMP["CNBD":0,1:1)
 Q:'TEST
 S TEXT="Reminder: "_NAME
 S VALUE=$P(TEMP,U)
 S VALUE("STATUS")=VALUE
 S VALUE("DUEDATE")=$P(TEMP,U,2)
 S VALUE("LASTDONE")=$P(TEMP,U,3)
 Q:PARAM=""
 I PARAM="DUE DATE",+VALUE("DUEDATE")>0 S DATE=VALUE("DUEDATE")
 I PARAM="LAST DONE",+VALUE("LASTDONE")>0 S DATE=VALUE("LASTDONE")
 Q
 ;
