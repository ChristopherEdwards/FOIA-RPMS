PXRMLFNF ;SLC/PKR - Routines for logic found/not found text. ;01/06/2003
 ;;1.5;CLINICAL REMINDERS;**13**;Jun 19, 2000
 ;
 ;=======================================================================
FNFTXT(NLINES,TEXT,DFN,DES,FNFTR) ;Process the logic found not found text.
 N LC,TA,X,UID,VSTR
 I $D(^TMP("TIUBOIL",$J)) D
 . K ^TMP("PXRMTIUBOIL",$J)
 . M ^TMP("PXRMTIUBOIL",$J)=^TMP("TIUBOIL",$J)
 . S OBJECT=1
 E  S OBJECT=0
 K ^TMP("TIUBOIL",$J)
 D BLRPLT^TIUSRVD(.TA,"",DFN,"",FNFTR)
 D DIWPK^PXRMUTIL
 S LC=0
 F LC=1:1:$P(^TMP("TIUBOIL",$J,0),U,3) D
 . S X=$G(^TMP("TIUBOIL",$J,LC,0))
 . D ^DIWP
 S LC=0
 F  S LC=$O(^UTILITY($J,"W",0,LC)) Q:LC=""  D
 . S NLINES=NLINES+1
 . S TEXT(NLINES)=^UTILITY($J,"W",0,LC,0)
 . I $D(PXRMDEV) D
 .. S UID=DES_$$NTOAN^PXRMUTIL(LC)
 .. S ^TMP(PXRMPID,$J,PXRMITEM,UID)=TEXT(NLINES)
 D DIWPK^PXRMUTIL
 K ^TMP("TIUBOIL",$J)
 I $G(OBJECT) M ^TMP("TIUBOIL",$J)=^TMP("PXRMTIUBOIL",$J)
 Q
 ;
 ;=======================================================================
PCL(NLINES,TEXT,DFN,PCLOGIC) ;Output Patient Cohort Logic found/not found
 ;text.
 N DES,FNFTR,FOUND,OBJECT
 S FOUND=$P(PCLOGIC,U,1)
 I FOUND D
 . S FNFTR="^PXD(811.9,"_PXRMITEM_",60)"
 . S DES="PCL_FOUND"
 E  D
 . S FNFTR="^PXD(811.9,"_PXRMITEM_",61)"
 . S DES="PCL_NOT FOUND"
 D FNFTXT(.NLINES,.TEXT,DFN,DES,FNFTR)
 Q
 ;
 ;=======================================================================
RESL(NLINES,TEXT,DFN,RESLOGIC) ;Output Resolution Logic found/not found text.
 N DES,FNFTR,FOUND,OBJECT
 S FOUND=$P(RESLOGIC,U,1)
 I FOUND D
 . S FNFTR="^PXD(811.9,"_PXRMITEM_",65)"
 . S DES="RES_FOUND"
 E  D
 . S FNFTR="^PXD(811.9,"_PXRMITEM_",66)"
 . S DES="RES_NOT FOUND"
 D FNFTXT(.NLINES,.TEXT,DFN,DES,FNFTR)
 S FOUND=$P(RESLOGIC,U,1)
 Q
 ;
