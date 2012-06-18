BEHORMCV ;MSC/IND/DKM - Cover Sheet: PCC Reminders ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;*041001;Mar 20, 2007
 ;=================================================================
 ; Return pt's currently due PCC clinical reminders
 ; Format: ien (811.9)^reminder print name^date due^last occur
LIST(DATA,DFN,LOC,SRV) ;
 N CNT,LP,LST,MIEN,NAM,DUE,LAST,X
 S DATA=$$TMPGBL^CIAVMRPC,(CNT,LP)=0
 Q:'DFN
 S:'$G(LOC) LOC=+$G(^DIC(42,+$G(^DPT(DFN,.1)),44))
 S:'$G(SRV) SRV=+$G(^VA(200,DUZ,5))
 D REMLIST(.LST,LOC,SRV)
 F  S LP=$O(LST(LP)) Q:'LP  D
 .S MIEN=$P(LST(LP),U,2),NAM=""
 .K ^TMP("PXRHM",$J)
 .D MAIN^PXRM(DFN,MIEN,0)
 .F  S NAM=$O(^TMP("PXRHM",$J,MIEN,NAM)) Q:NAM=""  D
 ..S X=^TMP("PXRHM",$J,MIEN,NAM),DUE=$P(X,U,2),LAST=$P(X,U,3),LAST=$S(LAST>0:LAST,1:"")
 ..D ADD(MIEN_U_NAM_U_DUE_U_LAST)
 K ^TMP("PXRHM",$J)
 Q
 ; Return detail for a pt's clinical reminder
DETAIL(DATA,DFN,IEN) ;
 N CNT,LP,NAM
 S DATA=$$TMPGBL^CIAVMRPC,CNT=0,NAM=""
 K ^TMP("PXRHM",$J)
 D MAIN^PXRM(DFN,IEN,5)     ; 5 returns all reminder info
 F  S NAM=$O(^TMP("PXRHM",$J,IEN,NAM)),LP=0 Q:NAM=""  D
 .F  S LP=$O(^TMP("PXRHM",$J,IEN,NAM,"TXT",LP)) Q:LP=""  D ADD(^(LP))
 K ^TMP("PXRHM",$J)
 Q
 ; Add data to output global
ADD(X) S CNT=CNT+1,@DATA@(CNT)=$G(X)
 Q
 ; Returns true if new cover sheet parameters are in effect
NEWCVOK() ;
 N SRV,TMP
 S SRV=$P($G(^VA(200,DUZ,5)),U)
 D GETLST^XPAR(.TMP,"USR^SRV.`"_SRV_"^DIV^SYS^PKG","ORQQPX NEW REMINDER PARAMS","Q")
 Q $S(TMP:$P($G(TMP(1)),U,2),1:0)
 ; Returns a list of all cover sheet reminders
REMLIST(DATA,LOC,SRV) ;
 N LP,LST,CODE,IDX,IEN
 I '$$NEWCVOK D  Q
 .D GETLST^XPAR(.DATA,"USR^LOC.`"_LOC_"^SRV.`"_SRV_"^DIV^SYS^PKG","ORQQPX SEARCH ITEMS","Q")
 D REMACCUM(.LST,"PKG",1000)
 D REMACCUM(.LST,"SYS",2000)
 D REMACCUM(.LST,"DIV",3000)
 D:SRV REMACCUM(.LST,"SRV.`"_SRV,4000)
 D:LOC REMACCUM(.LST,"LOC.`"_LOC,5000)
 D REMACCUM(.LST,"CLASS",6000)
 D REMACCUM(.LST,"USR",7000)
 S LP=0
 F  S LP=$O(LST(LP)) Q:'LP  D
 .S IDX=$P(LST(LP),U)
 .F  Q:'$D(DATA(IDX))  S IDX=IDX+1
 .S CODE=$E($P(LST(LP),U,2),2)
 .S IEN=$E($P(LST(LP),U,2),3,999)
 .D:CODE="R" ADDREM(.DATA,IDX,IEN)
 .D:CODE="C" ADDCAT(.DATA,IDX,IEN)
 K DATA("B")
 Q
 ; Accumulates TMP into DATA
 ; Format of entries in ORQQPX COVER SHEET REMINDERS:
 ;   L:Lock;R:Remove;N:Normal / C:Category;R:Reminder / Cat or Rem IEN
REMACCUM(DATA,LVL,SORT,CLASS) ;
 N IDX,LP,J,K,M,FOUND,ERR,TMP,FLAG,IEN
 N FFLAG,FIEN,OUT,P2,ADD,DOADD,CODE
 I LVL="CLASS" D
 .N LST,CLS,CLSPRM,WP
 .S CLSPRM="ORQQPX COVER SHEET REM CLASSES"
 .D GETLST^XPAR(.LST,"SYS",CLSPRM,"Q",.ERR)
 .S LP=0,M=0,CLASS=$G(CLASS)
 .F  S LP=$O(LST(LP)) Q:'LP  D
 ..S CLS=$P(LST(LP),U)
 ..I +CLASS S ADD=CLS=+CLASS
 ..E  S ADD=$$ISA^USRLM(DUZ,CLS,.ERR)
 ..I +ADD D
 ...D GETWP^XPAR(.WP,"SYS",CLSPRM,CLS,.ERR)
 ...S K=0
 ...F  S K=$O(WP(K)) Q:'K  D
 ....S M=M+1
 ....S J=$P(WP(K,0),";")
 ....S TMP(M)=J_U_$P(WP(K,0),";",2)
 E  D GETLST^XPAR(.TMP,LVL,"ORQQPX COVER SHEET REMINDERS","Q",.ERR)
 S LP=0,IDX=$O(DATA(999999),-1)+1,ADD=SORT=""
 F  S LP=$O(TMP(LP)) Q:'LP  D
 .S (FOUND,J)=0,P2=$P(TMP(LP),U,2)
 .S FLAG=$E(P2),IEN=$E(P2,2,999)
 .I ADD S DOADD=1
 .E  D
 ..S DOADD=0
 ..F  S J=$O(DATA(J)) Q:'J  D  Q:FOUND
 ...S P2=$P(DATA(J),U,2)
 ...S FIEN=$E(P2,2,999)
 ...I FIEN=IEN S FOUND=J,FFLAG=$E(P2)
 ..I FOUND D
 ...I FLAG="R",FFLAG'="L" K DATA(FOUND)
 ...I FLAG'=FFLAG,(FLAG_FFLAG)["L" S $E(P2)="L",$P(DATA(FOUND),U,2)=P2
 ..E  S:FLAG'="R" DOADD=1
 .I DOADD D
 ..S OUT(IDX)=TMP(LP)
 ..S $P(OUT(IDX),U)=$P(OUT(IDX),U)_SORT
 ..S:SORT="" OUT(IDX)=$$ADDNAME(OUT(IDX))
 ..S IDX=IDX+1
 M DATA=OUT
 Q
 ; Add Reminder or Category Name as 3rd piece
ADDNAME(NAM) ;
 N CAT,IEN
 S CAT=$E($P(NAM,U,2),2)
 S IEN=$E($P(NAM,U,2),3,99)
 I +IEN D
 .S:CAT="R" $P(NAM,U,3)=$P($G(^PXD(811.9,IEN,0)),U,3)
 .S:CAT="C" $P(NAM,U,3)=$P($G(^PXRMD(811.7,IEN,0)),U)
 Q NAM
 ; Add Reminder to DATA list
ADDREM(DATA,IDX,IEN) ;
 I $D(DATA("B",IEN)) Q               ; See if it's in the list
 I '$D(^PXD(811.9,IEN)) Q           ; Check if Exists
 I $P(^PXD(811.9,IEN,0),U,6)'="" Q  ; Check if Active
 S DATA(IDX)=IDX_U_IEN
 S DATA("B",IEN)=""
 Q
 ; Add Category Reminders to DATA list
ADDCAT(DATA,IDX,IEN) ;
 N REM,I,IDX2,NREM
 D CATREM^PXRMAPI0(IEN,.REM)
 S I=0
 F  S I=$O(REM(I)) Q:'I  D
 .S IDX2="00000"_I
 .S IDX2=$E(IDX2,$L(IDX2)-5,99)
 .D ADDREM(.DATA,+(IDX_"."_IDX2),$P(REM(I),U))
 Q
 ; XPAR value screen for ORQQPX SEARCH ITEMS
ACT(REM) Q:'REM 0
 Q:$G(^PXD(811.9,REM,0))="" 0
 I $L($T(INACTIVE^PXRM)),$$INACTIVE^PXRM(REM) Q 0
 Q 1
