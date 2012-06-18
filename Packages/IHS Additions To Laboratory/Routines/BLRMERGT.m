BLRMERGT ; IHS/ISD/EDE - MANUAL PROCESS MERGE BLRMERG ; [ 12/21/1998  3:56 PM ]
 ;;5.2;BLR;**1005,1030**;NOV 01, 1997
 ;
 ; NOTE:  This routine was originally just for testing.  It has been
 ; modified to work correctly for merging Lab Data since previous
 ; versions of the Lab Merge routines would sometimes fail during 
 ; the merge.
 ; 
START ;
 S DIC=2,DIC(0)="AQEM",DIC("A")="Select Patient to be PURGED:  " D ^DIC Q:+Y<1  S BLRP1=+Y
 I '$D(^DPT(+Y,"LR")) W !,"This patient has no lab data to purge.  ",!! G START
 S DIC=2,DIC(0)="AQEM",DIC("A")="Select Patient to RECEIVE lab data:  " D ^DIC Q:+Y<1  S BLRP2=+Y
OK W !,"Is everything OK" S %=2 D YN^DICN Q:%<0  W:%=0 !,"Answer NO if you are unsure, or '^' to quit.",! G:%=0 OK
 I %=2 G START
 W !!,"This will take about one minute..."
 S XDRMRG("FR")=BLRP1,XDRMRG("TO")=BLRP2
 K ^TMP("XDRMRGFR",$J)
 K ^TMP("XDRMRGTO",$J)
 S ^TMP("XDRMRGFR",$J,XDRMRG("FR"),"LR")=^DPT(BLRP1,"LR")
 ; S:$D(^DPT(P2,"LR")) ^TMP("XDRMRGTO",$J,XDRMRG("TO"),"LR")=^DPT(BLRP2,"LR")
 ; ----- BEGIN IHS/OIT/MKK -- LR*5.2*1030 -- Fix ^DPT(P2 typo
 S:$D(^DPT(BLRP2,"LR")) ^TMP("XDRMRGTO",$J,XDRMRG("TO"),"LR")=^DPT(BLRP2,"LR")
 ; ----- END IHS/OIT/MKK -- LR*5.2*1030
 D ^BLRMERG
 W !!,"Done..." H 2
 Q
 ;
TEST ; EP -- LR*5.2*1030 Note: OLD, DEAD CODE -- All lines commented out
 ; D SETDPT
 ; S XDRMRG("FR")=222
 ; S XDRMRG("TO")=333
 ; S ^TMP("XDRMRGFR",$J,XDRMRG("FR"),"LR")=^DPT(222,"LR")
 ; S ^TMP("XDRMRGTO",$J,XDRMRG("TO"),"LR")=^DPT(333,"LR")
 ; D ^BLRMERG
 Q
 ;
SETDPT ; SET ^DPT "LR" NODES -- LR*5.2*1030 Note: OLD, DEAD CODE -- All lines commented out
 ; S ^DPT(222,"LR")=8
 ;;S ^DPT(222,"LR")=10
 ; S ^DPT(333,"LR")=9
 Q
 ;
 ; ======================================================================
 ; Two LRDFNs point to SAME Patient. Merge the Lab Data
 ; 
 ; Note that this routine should only be run in programmer mode by
 ; a person extremely knowledgeable with the RPMS Lab Module.
TWOLRDFN ; EP
 NEW LRDFN1,LRDFN2,DPTIEN,FIXLRDFN,QFLG
 W !!
 D ^XBFMK
 S DIR(0)="PO^63"
 S DIR("A")="FROM LRDFN"
 D ^DIR
 I +$G(Y)<1 D  Q
 . W !,"No or invalid Entry.  Routine Stops.",!!
 ;
 S LRDFN1=+$G(Y)
 ;
 W !!
 D ^XBFMK
 S DIR(0)="PO^63"
 S DIR("A")="TO LRDFN"
 D ^DIR
 I +$G(Y)<1 D  Q
 . W !,"No or invalid Entry.  Routine Stops.",!!
 ;
 S (FIXLRDFN,LRDFN2)=+$G(Y)
 ;
 W !!
 D ^XBFMK
 S DIR(0)="NO"
 S DIR("A")="DPT IEN"
 D ^DIR
 I +$G(Y)<1 D  Q
 . W !,"No or invalid entry.  Routine Stops.",!!
 ;
 S DPTIEN=+$G(Y)
 ;
 W !!,"Variables Setup:",!
 W ?5,"FROM LRDFN:",LRDFN1,!
 W ?5,"TO LRDFN:",LRDFN2,!
 W ?5,"DPT IEN:",DPTIEN,!
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("A")="Continue"
 S DIR("B")="NO"
 D ^DIR
 I +$G(Y)<1 D  Q
 . W !,"NO or invalid entry.  Routine Stops.",!!
 ;
 S XDRMRG("FR")=DPTIEN
 S XDRMRG("TO")=DPTIEN
 K ^TMP("XDRMRGFR",$J)
 K ^TMP("XDRMRGTO",$J)
 S ^TMP("XDRMRGFR",$J,XDRMRG("FR"),"LR")=LRDFN1
 S ^TMP("XDRMRGTO",$J,XDRMRG("TO"),"LR")=LRDFN2
 ;
 D ^BLRMERG
 ;
 S:$G(^DPT(DPTIEN,"LR"))="" ^DPT(DPTIEN,"LR")=FIXLRDFN
 Q
 ; ----- END IHS/OIT/MKK -- LR*5.2*1030
 ;
WALTCHEK ; EP
 ;This SubRtn checks for BAD Ptrs in ^LR subsequent to PtMerge processes
 ;This Rtn does not change anything currently... it just displays.
 NEW CNT,CNTIEN,IEN,TOIEN,LRIEN,LRREC,PTR,MREC
 S (CNT,CNTIEN,IEN)=0
 F  S IEN=$O(^DPT(IEN)) Q:'IEN  D
 . S CNTIEN=CNTIEN+1
 . W:CNT<1 $$LJ^XLFSTR(CNTIEN,20),$C(13)
 . ;
 . S TOIEN=$G(^DPT(IEN,-9))  ;-9 indicates this record has been merged.
 . I TOIEN D                 ;if it has a value it has the 'to' pointer
 .. S LRIEN=$G(^DPT(TOIEN,"LR"))  ;get the Lab Ptr
 .. I LRIEN D                     ;If the Ptr exists
 ... S LRREC=$G(^LR(LRIEN,0))     ;attempt to get the record
 ... I LRREC D                    ;If the Lab record exists
 .... I $P(LRREC,U,3)'=TOIEN D
 ..... S PTR=$P(LRREC,U,3)_";DPT("  ;setup to get date merged
 ..... S MREC=$O(^XDRM("B",PTR,0))  ;ditto
 ..... W !!,"Merged On:",$P(^XDRM(MREC,0),U,3),"   PatNam= ",$P(^DPT(IEN,0),"^",1)
 ..... W !," ^DPT(",IEN,",-9) PointsTo:",TOIEN,"   the DPT 'LR' Ptr=",LRIEN
 ..... W !," LR ptr Back To DPT=",$P(LRREC,U,3)," it should be->",TOIEN
 ..... S CNT=CNT+1
 ;
 W !!,"Total Number of ^DPT IENs = ",CNTIEN,!
 W !,?5,"# of BAD ^LR Ptrs = ",CNT,!!
 Q
