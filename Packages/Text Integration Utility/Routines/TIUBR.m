TIUBR ; SLC/JER - Browse Action Subroutines ;01-Aug-2011 11:25;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**32,87,93,58,100,162,112,173,1007,1009**;Jun 20, 1997;Build 22
 ; Move LOADSIG, XTRASIG, LOADFOR, LOADREC to TIUBR1.
 ;IHS/ITSC/LJF 05/01/2003 - calls to BTIUBR and BTIUPCC to display IHS data
 ;IHS/MSC/MGH 2/25/10 - updated after patch 162 installed.
EN ; Entry code for LM templates TIU BROWSE
 N TIUY
 ;Kill TIUGDATA in CLEAN; don't new it here
 ; -- Set TIUGDATA, which describes the note originally
 ;    selected to be browsed. --
 ; TIUGDATA = 0 or
 ;          = TIUDA^HASIDKID^TIUD21^PRMSORT, where
 ;            PRMSORT = "TITLE" or "REFDT".  See 8925.95, fld .18
 S TIUGDATA=$$IDDATA^TIURECL1(TIUDA)
 D BLDTMP(TIUDA)
 Q
HDR ; Build Header
 N TIUDTYP,DFN
 I '$D(TIUPRM0)!'$D(TIUPRM1) D SETPARM^TIULE
 D:$D(TIU)'>9 GETTIU^TIULD(.TIU,+TIUDA)
 S VALMHDR(1)=$$CENTER^TIULS($P($G(TIU("DOCTYP")),U,2))
 ;  Docmt header line Patname, SSN, [Location, Visit]:
 S VALMHDR(2)=$$SETREC(TIUGDATA)
 Q
BLDTMP(TIUDA) ; Build ^TMP("TIUVIEW",$J,
 ; Requires TIUDA = IFN of note selected to be browsed.
 ; Needs TIUGDATA, set in EN
 N TIUI,TIUL,TIUREC,TIUDADD,ONBROWSE S (TIUDADD,TIUI)=0
 N TIUNAME K ^TMP("TIUVIEW",$J),^TMP("TIU FOCUS",$J)
 I '$D(^TIU(8925,+TIUDA,0)) S VALMQUIT=1 Q
 S ^TMP("TIU FOCUS",$J)=TIUDA
 D INQUIRE^TIUGBR(TIUDA,.TIUREC)
 I $D(TIUREC)>9 W !!,"Opening "_TIUREC(8925,+TIUDA,.01)_" record for review..."
 ; --- if the document has a browse action, execute it ---
 S ONBROWSE=$$ONBROWSE^TIULC1(+$G(^TIU(8925,+TIUDA,0)))
 I $L(ONBROWSE) D LOADSUPP(ONBROWSE,TIUDA,.TIUL)
 ; ---- Load dictation, transcription data, etc.: ----
 D LOADTOP(.TIUREC,TIUDA,.TIUL,TIUGDATA)
 ; ---- Load the remainder of the record: ----
 D LOADREC^TIUBR1(TIUDA,.TIUL,TIUGDATA)
 K ^TMP("TIU FOCUS",$J)
 S ^TMP("TIUVIEW",$J,0)=$G(^TIU(8925,+TIUDA,"TEXT",0))
 S $P(^TMP("TIUVIEW",$J,0),U,3,4)=$G(TIUL)_U_$G(TIUL),VALMCNT=+$G(TIUL)
 Q
LOADSUPP(METHOD,TIUDA,TIUL) ; Execute OnBrowse/Load Supplementary data
 N TIUY,TIUI S TIUI=0
 X METHOD I '$D(@TIUY) Q
 F  S TIUI=$O(@TIUY@(TIUI)) Q:+TIUI'>0  D
 . S TIUL=+$G(TIUL)+1,@VALMAR@(TIUL,0)=$G(@TIUY@(TIUI))
 S TIUL=+$G(TIUL)+1,@VALMAR@(TIUL,0)=" "
 K @TIUY
 Q
LOADTOP(TIUREC,TIUDA,TIUL,TIUGDATA) ; Load dictation, transcription data, etc.
 ; Requires array TIUREC, TIUDA, array TIUL, TIUGDATA
 N TIUY,SHORT,CURCHLD,CURPRNT,SELCHLD,SELPRNT
 ; ---- For ID note, include Title, [Location, & Visit] with each
 ;      entry, since they vary by entry.
 ; ---- Follow with Date, Author, etc.
 ; ---- For ID children in whole note display, shorten top info:
 ;      Instead of Title, Location, Visit, Date, Author, etc.,
 ;      use just Title, followed by just Date and Status:
 S (SHORT,CURCHLD,CURPRNT,SELCHLD,SELPRNT)=0
 I $P(TIUGDATA,U,3) S SELCHLD=1 ; Selected record was IDchild
 I $P(TIUGDATA,U,2) S SELPRNT=1
 I SELCHLD,TIUDA'=$P(TIUGDATA,U,3) S CURCHLD=1 ; Current rec is IDchild
 I SELCHLD,TIUDA=$P(TIUGDATA,U,3) S CURPRNT=1
 I SELPRNT,TIUDA=+TIUGDATA S CURPRNT=1
 I SELPRNT,TIUDA'=+TIUGDATA S CURCHLD=1
 I SELPRNT,CURCHLD S SHORT=1 ;Child in whole note: shorten top info
 I SELCHLD,CURCHLD,$G(TIUGWHOL) S SHORT=1
 I SELCHLD!SELPRNT D
 . D IDTOP^TIUGBR(TIUDA,.TIUL,SHORT,CURPRNT)
 S TIUL=+$G(TIUL)+1,TIUY=""
 I SHORT D
 . S TIUY=$$SETSTR^VALM1("DATE OF NOTE: "_TIUREC(8925,+TIUDA,1301),$G(TIUY),1,39)
 . S TIUY=$$SETSTR^VALM1("STATUS: "_TIUREC(8925,+TIUDA,.05),$G(TIUY),42,38)
 . S @VALMAR@(TIUL,0)=TIUY
 . D LT1^BTIUBR          ;IHS/ITSC/LJF 05/01/2003 display if unsigned, authors class
 I 'SHORT D
 . I $L(TIUREC(8925,+TIUDA,1307)) D  I 1
 . . S TIUY=$$SETSTR^VALM1("DICT DATE: "_TIUREC(8925,+TIUDA,1307),$G(TIUY),4,39)
 . E  S TIUY=$$SETSTR^VALM1("DATE OF NOTE: "_TIUREC(8925,+TIUDA,1301),$G(TIUY),1,39)
 . S TIUY=$$SETSTR^VALM1("ENTRY DATE: "_TIUREC(8925,+TIUDA,1201),$G(TIUY),38,39)
 . S @VALMAR@(TIUL,0)=TIUY
 . S TIUL=TIUL+1,TIUY=""
 . I $L(TIUREC(8925,+TIUDA,1307)) D  I 1
 . . I +$G(^TIU(8925,+TIUDA,0))=$$CHKFILE^TIUADCL(8925.1,"OPERATION REPORT","I $P(^(0),U,4)=""DOC""") S TIUY=$$SETSTR^VALM1("SURGEON: "_TIUREC(8925,+TIUDA,1202),$G(TIUY),6,32) Q
 . . S TIUY=$$SETSTR^VALM1("DICTATED BY: "_TIUREC(8925,+TIUDA,1202),$G(TIUY),2,32)
 . E  D
 . . S TIUY=$$SETSTR^VALM1("AUTHOR: "_TIUREC(8925,+TIUDA,1202),$G(TIUY),7,32)
 . . I +$G(^TIU(8925,+TIUDA,0))=$$CHKFILE^TIUADCL(8925.1,"OPERATION REPORT","I $P(^(0),U,4)=""DOC""") S TIUY=$$SETSTR^VALM1("SURGEON: "_TIUREC(8925,+TIUDA,1202),$G(TIUY),6,32)
 . I $L(TIUREC(8925,+TIUDA,1209)) D  I 1
 . . S TIUY=$$SETSTR^VALM1("ATTENDING: "_TIUREC(8925,+TIUDA,1209),$G(TIUY),39,40)
 . E  S TIUY=$$SETSTR^VALM1("EXP COSIGNER: "_TIUREC(8925,+TIUDA,1208),$G(TIUY),36,40)
 . S @VALMAR@(TIUL,0)=TIUY
 . D LT2^BTIUBR            ;IHS/ITSC/LJF 05/01/2003 display cosigner info
 . S TIUL=TIUL+1,TIUY=""
 . S TIUY=$$SETSTR^VALM1("URGENCY: "_TIUREC(8925,+TIUDA,.09),$G(TIUY),6,36)
 . S TIUY=$$SETSTR^VALM1("STATUS: "_TIUREC(8925,+TIUDA,.05),$G(TIUY),42,38)
 . S @VALMAR@(TIUL,0)=TIUY
 . D LT1^BTIUBR   ;IHS/ITSC/LJF  05/01/2003 display if unsigned, author's class
 S TIUL=TIUL+1,TIUY=""
 I '$L($G(^TIU(8925,+TIUDA,17))) S @VALMAR@(TIUL,0)=TIUY
 E  D
 . S TIUY=$$SETSTR^VALM1("SUBJECT: "_$G(^TIU(8925,+TIUDA,17)),$G(TIUY),6,74)
 . S @VALMAR@(TIUL,0)=TIUY
 . S TIUL=TIUL+1,TIUY="",@VALMAR@(TIUL,0)=TIUY
 I +$$HASADDEN^TIULC1(TIUDA) D
 . S TIUY="   *** "_$$PNAME^TIULC1(+$G(^TIU(8925,TIUDA,0)))_" Has ADDENDA ***"
 . S TIUL=+$G(TIUL)+1,@VALMAR@(TIUL,0)=TIUY
 . S TIUL=+$G(TIUL)+1,@VALMAR@(TIUL,0)=""
 D LT3^BTIUBR   ;IHS/ITSC/LJF 05/01/2003 add visit data to display
 Q
 ;
LOADKIDS(TIUDA,TIUL,TIUGDATA,TIUGWHOL) ; Load ID kids of TIUDA
 ; Requires TIUDA, array TIUL, TIUGDATA
 N TIUK,PRMSORT,KIDDA,TIUD0,TIUD21
 I $G(^TMP("TIUR",$J,"IDDATA",TIUDA)) S PRMSORT=$P(^TMP("TIUR",$J,"IDDATA",TIUDA),U,4)
 E  S TIUD0=$G(^TIU(8925,TIUDA,0)),TIUD21=$G(^TIU(8925,TIUDA,21)),PRMSORT=$P($$IDDATA^TIURECL1(TIUDA,TIUD0,TIUD21),U,4)
 D GETIDKID^TIURECL2(TIUDA,PRMSORT) ; sets array ^TMP("TIUIDKID",$J,
 S TIUK=0
 F  S TIUK=$O(^TMP("TIUIDKID",$J,TIUDA,TIUK)) Q:+TIUK'>0  D
 . S KIDDA=^TMP("TIUIDKID",$J,TIUDA,TIUK)
 . D LOADID^TIUGBR(KIDDA,.TIUL,TIUGDATA,$G(TIUGWHOL))
 K ^TMP("TIUIDKID",$J)
 Q
 ;
ISCOMP(DA) ; Evaluate whether a given record is a component
 N TIUY,TIUTYP
 S TIUTYP=+$G(^TIU(8925,DA,0))
 S TIUY=$S($P($G(^TIU(8925.1,+TIUTYP,0)),U,4)="CO":1,1:0)
 Q TIUY
LOADADD(TIUDADD,TIUL) ; Load addenda
 N TIUDADT,TIUJ,CANSEE
 S CANSEE=$$CANDO^TIULP(+TIUDADD,"VIEW")
 S TIUJ=0,TIUL=+$G(TIUL)+1,@VALMAR@(TIUL,0)=" "
 S TIUDADT=$$DATE^TIULS($P($G(^TIU(8925,+TIUDADD,13)),U),"MM/DD/CCYY")
 S TIUL=TIUL+1,@VALMAR@(TIUL,0)=TIUDADT_" ADDENDUM"_"                      STATUS: "_$$STATUS^TIULF(TIUDADD) ;P162
 I +CANSEE'>0 D  Q
 . S TIUL=+$G(TIUL)+1
 . S @VALMAR@(TIUL,0)=$P(CANSEE,U,2)
 F  S TIUJ=$O(^TIU(8925,+TIUDADD,"TEXT",TIUJ)) Q:+TIUJ'>0  D
 . S TIUL=+$G(TIUL)+1
 . ;S @VALMAR@(TIUL,0)=$G(^TIU(8925,+TIUDADD,"TEXT",TIUJ,0))                 ;IHS/ITSC/LJF 05/01/2003
 . S @VALMAR@(TIUL,0)=$$BLANKS^BTIUBR($G(^TIU(8925,+TIUDADD,"TEXT",TIUJ,0))) ;IHS/ITSC/LJF 05/01/2003
 D LOADSIG^TIUBR1(TIUDADD,.TIUL)
 Q
 ;
SETREC(TIUGDATA) ; Sets docmt header line Patname, SSN, [Location, Visit]
 ; Requires TIUGDATA
 N Y
 S Y=$$SETSTR^VALM1($$NAME^TIULS($G(TIU("PNM")),"LAST,FI MI"),$G(Y),1,15)
 ;S Y=$$SETSTR^VALM1($G(TIU("SSN")),$G(Y),16,12)     ;IHS/ITSC/LJF 05/01/2003
 S Y=$$SETSTR^VALM1("#"_$G(TIU("HRCN")),$G(Y),16,12) ;IHS/ITSC/LJF 05/01/2003
 ; ---- If TIUDA is an ID entry, write ID, ADDENDED? in header
 ;      and leave out entry-specific info (Location, Visit)
 ;      since that goes with each individual entry: ----
 I $P(TIUGDATA,U,2)!$P(TIUGDATA,U,3) D  G SETRX
 . S Y=$$SETSTR^VALM1("Interdisciplinary "_$S($P(TIUGDATA,U,2):"Note",1:"Entry"),$G(Y),29,23)
 . I $P(TIUGDATA,U,2) S Y=$$SETSTR^VALM1("ADDENDED?"_$S($$HASADDEN^TIULC1(+TIUDA,1):" Yes",1:" No"),$G(Y),66,13)
 ;
 S Y=$$SETSTR^VALM1($$DEMOG^BTIUPCC(+TIUDA),$G(Y),35,40) G SETRX   ;IHS/ITSC/LJF 05/01/2003 add sex, dob and age
 ;
 S Y=$$SETSTR^VALM1($P($G(TIU("LOC")),U,2),$G(Y),30,17)
 I $L($G(TIU("WARD"))) D
 . S Y=$$SETSTR^VALM1("Adm: "_$$DATE^TIULS(+TIU("EDT"),"MM/DD/CCYY"),$G(Y),48,15)
 . S Y=$$SETSTR^VALM1("Dis: "_$$DATE^TIULS(+TIU("LDT"),"MM/DD/CCYY"),$G(Y),65,15)
 I '$L($G(TIU("WARD"))) D
 . S Y=$$SETSTR^VALM1("Visit Date: "_$$DATE^TIULS(+$G(TIU("EDT")),"MM/DD/CCYY HR:MIN"),$G(Y),51,28)
SETRX Q Y
 ;
CLEAN ; Die, filthy spawn!!!
 D CLEAN^VALM10 K VALMHDR,TIU,TIUPRM0,TIUPRM1,TIUGDATA
 Q
