PXRMOPT ; SLC/PKR - Prepare the final reminder output. ;14-Apr-2008 15:12;MGH
 ;;1.5;CLINICAL REMINDERS;**2,13,1005**;Jun 19, 2000
 ;
 ;=======================================================================
ACTFT() ;Add the standard "condition false" text to the output string.
 ;Q " - VALUE DOES NOT MEET CRITERIA"
 Q ""
 ;
 ;=======================================================================
ADDTXT(NTXT,TXT) ;
 I $L(TXT)>DIWR D
 . N IC,X
 . D DIWPK^PXRMUTIL
 . S X=TXT
 . D ^DIWP
 . S IC=0
 . F  S IC=$O(^UTILITY($J,"W",0,IC)) Q:IC=""  D
 .. S NTXT=NTXT+1
 .. S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM,"TXT",NTXT)=^UTILITY($J,"W",0,IC,0)
 . D DIWPK^PXRMUTIL
 E  D
 . S NTXT=NTXT+1
 . S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM,"TXT",NTXT)=TXT
 Q
 ;
 ;=======================================================================
FERROR(NTXT) ; Check for a fatal error and output a message.
 I '$D(^TMP(PXRMPID,$J,PXRMITEM,"FERROR")) Q 0
 N ERROR,TEXT
 ;Error trap
 I $D(^TMP(PXRMPID,$J,PXRMITEM,"FERROR","ERROR TRAP")) D
 . S TEXT="There was an error processing this reminder, it could not be properly evaluated, see the error trap."
 . D ADDTXT(.NTXT,TEXT)
 ;Reminder errors
 I $D(^TMP(PXRMPID,$J,PXRMITEM,"FERROR","NO REMINDER")) D
 . S TEXT=^TMP(PXRMPID,$J,PXRMITEM,"FERROR","NO REMINDER")
 . D ADDTXT(.NTXT,TEXT)
 ;
 ;Patient errors
 I $D(^TMP(PXRMPID,$J,PXRMITEM,"FERROR","PATIENT")) D
 . S ERROR=$O(^TMP(PXRMPID,$J,PXRMITEM,"FERROR","PATIENT",""))
 . I ERROR="NOPAT" S TEXT=^TMP(PXRMPID,$J,PXRMITEM,"FERROR","PATIENT","NOPAT")
 . I ERROR="NO LOCK" S TEXT="COULD NOT GET A LOCK FOR PATIENT "_DFN_" TRY AGAIN"
 . D ADDTXT(.NTXT,TEXT)
 ;
 ;Expanded taxonomy errors
 I $D(^TMP(PXRMPID,$J,PXRMITEM,"FERROR","EXPANDED TAXONOMY")) D
 . S ERROR=$O(^TMP(PXRMPID,$J,PXRMITEM,"FERROR","EXPANDED TAXONOMY",""))
 . I ERROR="NO LOCK" S TEXT="COULD NOT GET A LOCK FOR EXPANDED TAXONOMY "_+PXRMXTLK_" TRY AGAIN"
 . D ADDTXT(.NTXT,TEXT)
 Q 1
 ;
 ;=======================================================================
FNFTXT(NLINES,TEXT,DFN,FINDING,FIEVAL) ;Load the finding found not found text.
 N DES,FI,FNFTR,FOUND,LC,TA,X,UID,VSTR
 S FOUND=FIEVAL(FINDING)
 I $D(FIEVAL(FINDING,"VIEN")) D
 . N TEMP,VDATE,VLOC,VSC
 . S TEMP=^AUPNVSIT(FIEVAL(FINDING,"VIEN"),0)
 . S VDATE=$P(TEMP,U,1)
 . S VLOC=$P(TEMP,U,22)
 . S VSC=$P(TEMP,U,7)
 . S VSTR=VLOC_";"_VDATE_";"_VSC
 E  S VSTR=""
 I FOUND S FI=1,DES="FINDING "_FINDING_"_FOUND"
 E  S FI=2,DES="FINDING "_FINDING_" NOT_FOUND"
 S FNFTR="^PXD(811.9,"_PXRMITEM_",20,"_FINDING_","_FI_")"
 I $D(^TMP("TIUBOIL",$J)) D
 . K ^TMP("PXRMTIUBOIL",$J)
 . M ^TMP("PXRMTIUBOIL",$J)=^TMP("TIUBOIL",$J)
 . S OBJECT=1
 K ^TMP("TIUBOIL",$J)
 D BLRPLT^TIUSRVD(.TA,"",DFN,VSTR,FNFTR)
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
INFO(NTXT) ;Output INFO text. An INFO node has the structure:
 ;(PXRMPID,$J,PXRMITEM,"INFO",DESCRIPTION)=TEXT
 N DES,TXT
 ;We don't put errors or warnings into the final output, they are for debugging
 ;new reminders.
 S DES=""
 F  S DES=$O(^TMP(PXRMPID,$J,PXRMITEM,"INFO",DES)) Q:DES=""  D
 . I (DES'="ERROR")&(DES'="WARNING") D
 .. S TXT=^TMP(PXRMPID,$J,PXRMITEM,"INFO",DES)
 .. D ADDTXT(.NTXT,TXT)
 Q
 ;
 ;=======================================================================
OUTPUT(PCLOGIC,RESLOGIC,RESDATE,FIEVAL) ;Prepare the clinical maintenance
 ; output.
 ;
 ;Establish the formatting parameters.
 N DIWF,DIWL,DIWR
 D DIWPS^PXRMUTIL(.DIWF,.DIWL,.DIWR)
 ;
 N AGE,IC,IND,INFO,FIDATA,FINDING,FLIST,FTYPE
 N HDR,NHDR,NLINES,NTXT,NUM,OBJECT,PCL,RES,TEMP,TYPE,TEXT
 ;Process the findings in the order: patient cohort, resolution,
 ;age, and informational.
 S NTXT=0
 ;Check for a fatal error
 I $$FERROR(.NTXT) Q
 ;Check for a dead patient
 I +$G(^XTMP(PXRMDFN,"DOD"))>0 D
 . S TEXT="Patient is deceased, date of death: "_$P(^XTMP(PXRMDFN,"DOD"),U,2)
 . D ADDTXT(.NTXT,TEXT)
 M FIDATA=FIEVAL
 S RES=$G(^PXD(811.9,PXRMITEM,36))_U_"RES"
 S PCL=$G(^PXD(811.9,PXRMITEM,32))_U_"PCL"
 S AGE=$G(^PXD(811.9,PXRMITEM,40))_U_"AGE"
 S INFO=$G(^PXD(811.9,PXRMITEM,42))_U_"INFO"
 F TYPE=PCL,RES,AGE,INFO D
 . S (NHDR,NLINES)=0
 . S NUM=+$P(TYPE,U,1)
 . S FLIST=$P(TYPE,U,2)
 . F IND=1:1:NUM D
 .. S FINDING=$P(FLIST,";",IND)
 ..;Make sure each finding is processed only once.
 .. I '$D(FIDATA(FINDING)) Q
 ..;
 ..;If there are no nodes below the top all we need to do is the
 ..;found not found text.
 .. I $D(FIEVAL(FINDING))=1 G FNF
 ..;
 .. S TEMP=FIEVAL(FINDING,"FINDING")
 .. S FTYPE=$P(TEMP,";",2)
 .. I $D(FIEVAL(FINDING,"TERM")) D OUTPUT^PXRMTERM(.NLINES,.TEXT,FINDING,.FIEVAL)
 .. I FTYPE="AUTTEDT(" D OUTPUT^PXRMEDU(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="AUTTEXAM(" D OUTPUT^PXRMEXAM(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="AUTTHF(" D OUTPUT^PXRMHF(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="AUTTIMM(" D OUTPUT^PXRMIMM(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="AUTTSK(" D OUTPUT^PXRMSKIN(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="GMRD(120.51," D OUTPUT^PXRMMEAS(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="LAB(60," D OUTPUT^PXRMLAB(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="ORD(101.43," D OUTPUT^PXRMORDR(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="PS(50.605," D OUTPUT^PXRMDRCL(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="PSDRUG(" D OUTPUT^PXRMDRUG(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="PSNDF(50.6," D OUTPUT^PXRMDGEN(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="PXD(811.2," D OUTPUT^PXRMTAX(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="PXRMD(811.4," D OUTPUT^PXRMCF(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="RAMIS(71," D OUTPUT^PXRMRAD(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="YTT(601," D OUTPUT^PXRMMH(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. ;IHS/MSC/MGH Added the following lines for additional findings globals
 .. I FTYPE="AUTTREFT(" D OUTPUT^BPXRMREF(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 .. I FTYPE="AUTTMSR(" D OUTPUT^BPXRMEA(.NLINES,.TEXT,FINDING,.FIEVAL) G FNF
 ..;
FNF .. D FNFTXT(.NLINES,.TEXT,DFN,FINDING,.FIEVAL)
 ..;Make sure each finding is processed only once.
 .. K FIDATA(FINDING)
 .;If there was some text do the header.
 . S FTYPE=$P(TYPE,U,3)
 . I FTYPE="PCL" D PCL^PXRMLFNF(.NLINES,.TEXT,DFN,PCLOGIC)
 . I FTYPE="RES" D RESL^PXRMLFNF(.NLINES,.TEXT,DFN,RESLOGIC)
 .;
 . I (FTYPE="PCL") D
 .. I PCLOGIC D
 ... S NHDR=2
 ... S HDR(1)=" "
 ... S HDR(2)="Applicable: "_$G(^TMP(PXRMPID,$J,PXRMITEM,"zFREQARNG"))_" within cohort."
 .. E  S NHDR=0
 .;
 . I (FTYPE="RES")&(+RESDATE>0) D
 .. S NHDR=2
 .. S HDR(1)=" "
 .. S HDR(2)="Resolution: Last done "_$$EDATE^PXRMDATE(RESDATE)
 .;
 . I (FTYPE="AGE")&(NLINES>0) D
 .. S NHDR=2
 .. S HDR(1)=" "
 .. S HDR(2)="Age:  "
 .;
 . I (FTYPE="INFO")&(NLINES>0) D
 .. S NHDR=2
 .. S HDR(1)=" "
 .. S HDR(2)="Information:  "
 .;
 . F IC=1:1:NHDR D ADDTXT(.NTXT,HDR(IC))
 . F IC=1:1:NLINES D ADDTXT(.NTXT,TEXT(IC))
 ;
 ;Output the AGE match/no match text.
 D MNMT^PXRMAGE(.NTXT,.FIEVAL)
 ;Output INFO nodes
 D INFO(.NTXT)
 Q
 ;
