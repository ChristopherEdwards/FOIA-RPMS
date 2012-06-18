ACPT29P2 ; IHS/SD/SDR - ACPT V2.09 patch 2 ;4/21/08  14:11
 ;;2.09;CPT FILES;**2**;JAN 2,2009
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM),!
 ;
 NEW ACPTQUIT
 S ACPTQUIT=0
 I '$$VCHK("XU","8",2) S ACPTQUIT=2
 ;
 I '$$VCHK("XT","7.3",2) S ACPTQUIT=2
 ;
 I '$$VCHK("DI","21",2) S ACPTQUIT=2
 ;
 I '$$VCHK("ACPT","2.09",2) S ACPTQUIT=2
 ;
 NEW DA,DIC
 S X="ACPT",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","ACPT")) D  S ACPTQUIT=2
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""ACPT"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 .Q
 ;
 I ACPTQUIT D SORRY(ACPTQUIT) Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(ACPTPRE,ACPTVER,ACPTQUIT) ; Check versions needed.
 ;  
 NEW ACPTV
 S ACPTV=$$VERSION^XPDUTL(ACPTPRE)
 W !,$$CJ^XLFSTR("Need at least "_ACPTPRE_" v "_ACPTVER_"....."_ACPTPRE_" v "_ACPTV_" Present",IOM)
 I ACPTV<ACPTVER W *7,!,$$CJ^XLFSTR("^^^^**NEEDS FIXED**^^^^",IOM) Q 0
 Q 1
 ;
INSTALLD(ACPTINST) ;EP - Determine if patch ACPTINST was installed, where ACPTINST is
 ; the name of the INSTALL.  E.g "AG*6.0*10".
 ;;^DIC(9.4,D0,22,D1,PAH,D2,0)=
 ;;(#.01) PATCH APPLICATION HISTORY [1F] ^ (#.02)DATE APPLIED [2D] ^ (#.03) APPLIED BY [3P] ^ 
 NEW DIC,X,Y
 S X=$P(ACPTINST,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(ACPTINST,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(ACPTINST,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ;
LAST(PKG,VER) ;EP - returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
LOAD ;
 NEW ACPTDA,ACPTI,ACPTLN,DA,DIE,DR
 F ACPTI=1:1 S ACPTLN=$P($T(DATA+ACPTI^ACPT29P2),";;",2) Q:ACPTLN="END"  D
 .S ACPTCODE=$P(ACPTLN,U)
 .S ACPTSHRT=$P(ACPTLN,U,2)
 .S ACPTDESC=$P(ACPTLN,U,3)
 .S ACPTIEN=$O(^ICPT("B",ACPTCODE,0))  ; find the code's record number
 .I '$D(^ICPT("B",ACPTCODE)) D  ; if there isn't one, create it
 ..S ACPTIEN=$A($E(ACPTCODE,1))_$E(ACPTCODE,2,5)
 ..S ^ICPT(ACPTIEN,0)=ACPTCODE  ; CPT Code field (.01)
 ..S ^ICPT("B",ACPTCODE,ACPTIEN)=""  ; index of CPT Codes
 ..S $P(^ICPT(ACPTIEN,0),U,6)=3090901
 ..I ACPTCODE="Q2023" S $P(^ICPT(ACPTIEN,0),U,6)=3090701
 .;
 .S ACPTNODE=$G(^ICPT(ACPTIEN,0))  ; get record's header node
 .I ACPTSHRT'="" S $P(ACPTNODE,U,2)=ACPTSHRT  ; update it
 .S $P(ACPTNODE,U,7)=""  ; clear Date Deleted field (8)
 .S ^ICPT(ACPTIEN,0)=ACPTNODE  ; update header node
 .;
 .D TEXT(.ACPTDESC) ; convert string to WP array
 .K ^ICPT(ACPTIEN,"D") ; clean out old Description (50)
 .M ^ICPT(ACPTIEN,"D")=ACPTDESC ; copy array to field, incl. header
 .;
 .S ACPTEDT=$O(^ICPT(ACPTIEN,60,"B",9999999),-1)  ; find the last
 .N ACPTEIEN S ACPTEIEN=$O(^ICPT(ACPTIEN,60,"B",+ACPTEDT,0))  ; its IEN
 .;
 .I ACPTEDT=3090901,ACPTEIEN D  ; if there is one for this install date
 ..Q:$P($G(^ICPT(ACPTIEN,60,ACPTEIEN,0)),U,2)  ; if active, we're fine
 ..; otherwise, we need to activate it:
 ..K DIC,DIE,DA,DIR,X,Y
 ..S DA=+ACPTEIEN  ; IEN of last Effective Date
 ..S DA(1)=ACPTIEN  ; IEN of its parent CPT
 ..S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date (60/81.02)
 ..S DR=".02////1"  ; set Status field to ACTIVE
 ..N DIDEL,DTOUT  ; other parameters for DIE
 ..D ^DIE  ; Fileman Data Edit call
 .;
 .E  D  ; if not, then we need one
 ..K DIC,DIE,DA,X,Y,DIR
 ..S DA(1)=ACPTIEN  ; into subfile under new entry
 ..S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date (60/81.02)
 ..S DIC(0)="L"  ; LAYGO
 ..S DIC("P")=$P(^DD(81,60,0),U,2)  ; subfile # & specifier codes
 ..S X="09/01/2009"  ; new entry for 9/1/2009
 ..I ACPTCODE="Q2023" S X="07/01/2009"
 ..S DIC("DR")=".02////1"  ; with Status = 1 (active)
 ..N DLAYGO,Y,DTOUT,DUOUT  ; other parameters
 ..D ^DIC  ; Fileman LAYGO lookup
 Q
TEXT(ACPTDESC) ; convert Description text to Word-Processing data type
 ; input: .ACPTDESC = passed by reference, starts out as long string,
 ; ends as Fileman WP-format array complete with header
 ;
 N ACPTSTRN S ACPTSTRN=ACPTDESC ; copy string out
 K ACPTDESC ; clear what will now become a WP array
 N ACPTCNT S ACPTCNT=0 ; count WP lines for header
 ;
 F  Q:ACPTSTRN=""  D  ; loop until ACPTSTRN is fully transformed
 .;
 .N ACPTBRK S ACPTBRK=0 ; character position to break at
 .;
 .D  ; find the character position to break at
 ..N ACPTRY ; break position to try
 ..S ACPTRY=$L(ACPTSTRN) ; how long is the string?
 ..I ACPTRY<81 S ACPTBRK=ACPTRY Q  ; if 1 full line or less, we're done
 ..;
 ..F ACPTRY=80:-1:2 D  Q:ACPTBRK
 ...I $E(ACPTSTRN,ACPTRY+1)=" " D  Q  ; can break on a space
 ....S $E(ACPTSTRN,ACPTRY+1)="" ; remove the space
 ....S ACPTBRK=ACPTRY ; and let's break here
 ...;
 ...I "&_+-*/<=>}])|:;,.?!"[$E(ACPTSTRN,ACPTRY) D  Q  ; on delimiter?
 ....S ACPTBRK=ACPTRY ; so let's break here
 ..;
 ..Q:ACPTBRK  ; if we found a good spot to break, we're done
 ..;
 ..S ACPTBRK=80 ; otherwise, hard-break on 80 (weird content)
 .;
 .S ACPTCNT=ACPTCNT+1 ; one more line
 .S ACPTDESC(ACPTCNT,0)=$E(ACPTSTRN,1,ACPTBRK) ; copy line into array
 .S $E(ACPTSTRN,1,ACPTBRK)="" ; & remove it from the string
 ;
 S ACPTDESC(0)="^81.01A^"_ACPTCNT_U_ACPTCNT_U_DT ; set WP header
 ;
 Q
DATA ;
 ;;G9141^INFLUENZA A IMM ORDER/ADMIN^Influenza A (H1N1) immunization administration (includes the physician counseling the patient/family)
 ;;G9142^INFLUENZA A VACC^Influenza A (H1N1) vaccine, any route of administration
 ;;Q2023^Xyntha, inj^INJECTION, FACTOR VIII (ANTIHEMOPHILIC FACTOR, RECOMBINANT) (XYNTHA), PER I.U.
 ;;END
