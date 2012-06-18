PXRMLOGX ; SLC/PKR - Clinical Reminders cross-reference logic routines. ;01/15/2002
 ;;1.5;CLINICAL REMINDERS;**1,8**;Jun 19, 2000
 ;
 ;=======================================================================
BLDAFL(IEN,KI) ;Build a list of findings that can change the
 ;frequency age range set. This is called by FileMan whenever the
 ;minimum age, maximum age, or frequency fields of the findings
 ;multiple are edited.
 N FREQ,FLIST,IND,NUM
 S FLIST=""
 S (IND,NUM)=0
 F  S IND=$O(^PXD(811.9,IEN,20,IND)) Q:+IND=0  D
 .;If an entry is being deleted skip it.
 . I IND=$G(KI) Q
 . S FREQ=$P(^PXD(811.9,IEN,20,IND,0),U,4)
 . I FREQ'="" D
 .. S NUM=NUM+1
 .. I NUM>1 S FLIST=FLIST_";"
 .. S FLIST=FLIST_IND
 S ^PXD(811.9,IEN,40)=NUM_U_FLIST
 Q
 ;
 ;=======================================================================
BLDALL(IEN,KI) ;Build all the findings lists.
 I '$D(^PXD(811.9,IEN)) Q
 D BLDPCLS^PXRMLOGX(IEN,KI)
 D BLDRESLS^PXRMLOGX(IEN,KI)
 D BLDAFL^PXRMLOGX(IEN,KI)
 D BLDINFL^PXRMLOGX(IEN,KI)
 Q
 ;
 ;=======================================================================
BLDINFL(IEN,KI) ;Build the list of findings that are information only.
 ;This is called by the routines that build the resolution findings
 ;list, the patient cohort findings list, and the age finding list.
 N FIA,FLIST,IND,NUM,TEMP
 S IND=0
 F  S IND=$O(^PXD(811.9,IEN,20,IND)) Q:+IND=0  D
 .;If an entry is being deleted skip it.
 . I IND=$G(KI) Q
 . S FIA(IND)=""
 ;Remove the patient cohort findings.
 S TEMP=$G(^PXD(811.9,IEN,32))
 S NUM=+$P(TEMP,U,1)
 S FLIST=$P(TEMP,U,2)
 F IND=1:1:NUM D
 . S TEMP=$P(FLIST,";",IND)
 . I $D(FIA(TEMP)) K FIA(TEMP)
 ;Remove the resolution findings.
 S TEMP=$G(^PXD(811.9,IEN,36))
 S NUM=+$P(TEMP,U,1)
 S FLIST=$P(TEMP,U,2)
 F IND=1:1:NUM D
 . S TEMP=$P(FLIST,";",IND)
 . I $D(FIA(TEMP)) K FIA(TEMP)
 ;Remove the age findings.
 S TEMP=$G(^PXD(811.9,IEN,40))
 S NUM=+$P(TEMP,U,1)
 S FLIST=$P(TEMP,U,2)
 F IND=1:1:NUM D
 . S TEMP=$P(FLIST,";",IND)
 . I $D(FIA(TEMP)) K FIA(TEMP)
 ;What is left is the information findings.
 S FLIST=""
 S (IND,NUM)=0
 F  S IND=$O(FIA(IND)) Q:IND=""  D
 . S NUM=NUM+1
 . I NUM>1 S FLIST=FLIST_";"
 . S FLIST=FLIST_IND
 S ^PXD(811.9,IEN,42)=NUM_U_FLIST
 Q
 ;
 ;=======================================================================
BLDPCLS(IEN,KI) ;Build the Internal Patient Cohort Logic string for a
 ;reminder. This is called by FileMan whenever the USE IN PATIENT COHORT
 ;LOGIC field is edited or the user defined Patient Cohort Logic is
 ;killed. Also builds the patient cohort logic list.
 ;If there is a user defined PATIENT COHORT LOGIC then don't do anything.
 I $L($G(^PXD(811.9,IEN,30)))>0 Q
 N FLIST,IND,NUM,PCLOG,TEMP,UPCLOG
 S PCLOG="(SEX)&(AGE)"
 S FLIST=""
 S (IND,NUM)=0
 F  S IND=$O(^PXD(811.9,IEN,20,IND)) Q:+IND=0  D
 .;If an entry is being deleted skip it.
 . I IND=$G(KI) Q
 . S TEMP=^PXD(811.9,IEN,20,IND,0)
 . S UPCLOG=$P(TEMP,U,7)
 . I UPCLOG'="" D
 .. S PCLOG=PCLOG_UPCLOG_"FI("_IND_")"
 .. S NUM=NUM+1
 .. I NUM>1 S FLIST=FLIST_";"
 .. S FLIST=FLIST_IND
 ;Save the internal string and the findings list.
 S ^PXD(811.9,IEN,31)=PCLOG
 S ^PXD(811.9,IEN,32)=NUM_U_FLIST
 Q
 ;
 ;=======================================================================
BLDRESLS(IEN,KI) ;Build the Internal Resolution Logic string for a
 ;reminder. This is called by FileMan whenever the USE IN RESOLUTION
 ;LOGIC field is edited or the user defined Resolution Logic is killed.
 ;If there is a user defined RESOLUTION LOGIC then don't do
 ;anything.
 I $L($G(^PXD(811.9,IEN,34)))>0 Q
 N FLIST,IND,NUM,RESLOG,TEMP,URESLOG
 S (FLIST,RESLOG)=""
 S (IND,NUM)=0
 F  S IND=$O(^PXD(811.9,IEN,20,IND)) Q:+IND=0  D
 .;If an entry is being deleted skip it.
 . I IND=$G(KI) Q
 . S TEMP=^PXD(811.9,IEN,20,IND,0)
 . S URESLOG=$P(TEMP,U,6)
 . I URESLOG'="" D
 .. S RESLOG=RESLOG_URESLOG_"FI("_IND_")"
 .. S NUM=NUM+1
 .. I NUM>1 S FLIST=FLIST_";"
 .. S FLIST=FLIST_IND
 ;Save as the internal string and the findings list.
 I RESLOG="" S ^PXD(811.9,IEN,35)=""
 E  D
 . S TEMP=$E(RESLOG,1,1)
 . I TEMP="&" S ^PXD(811.9,IEN,35)="(1)"_RESLOG
 . I TEMP="!" S ^PXD(811.9,IEN,35)="(0)"_RESLOG
 S ^PXD(811.9,IEN,36)=NUM_U_FLIST
 Q
 ;
 ;=======================================================================
CPPCLS(IEN,X) ;Copy the user input Patient Cohort Logic string to the
 ;Internal Patient Cohort Logic string.
 N TEMP S TEMP=$$REPFUN^PXRMLOGF(X)
 S ^PXD(811.9,IEN,31)=$$REPFUN^PXRMLOGF(X)
 ;Get the list of findings.
 N FLIST,IND,NFI,NUM,T1,T2
 S NFI=$L(X,"FI(")
 S FLIST=""
 S NUM=0
 F IND=2:1:NFI D
 . S T1=$P(X,"FI(",IND)
 . S T2=$P(T1,")",1)
 . S NUM=NUM+1
 . I NUM>1 S FLIST=FLIST_";"
 . S FLIST=FLIST_T2
 S ^PXD(811.9,IEN,32)=NUM_U_FLIST
 Q
 ;
 ;=======================================================================
CPRESLS(IEN,X) ;Copy the user input Resolution Logic string to the
 ;Internal Resolution Logic string.
 S ^PXD(811.9,DA,35)=X
 ;Build the list of findings
 N NFI,NUM,FLIST,T1,T2
 S NFI=$L(X,"FI(")
 S FLIST=""
 S NUM=0
 F IND=2:1:NFI D
 . S T1=$P(X,"FI(",IND)
 . S T2=$P(T1,")",1)
 . S NUM=NUM+1
 . I NUM>1 S FLIST=FLIST_";"
 . S FLIST=FLIST_T2
 S ^PXD(811.9,IEN,36)=NUM_U_FLIST
 Q
 ;
 ;=======================================================================
DELNXR(X2) ;For a new style cross-reference check X2 to determine
 ;if a delete is being done. If it is a delete all the X2 elements will
 ;be null.
 N IND,X2NULL
 S X2NULL=1
 S IND=0
 F  S IND=$O(X2(IND)) Q:(+IND=0)!('X2NULL)  D
 . I X2(IND)'="" S X2NULL=0
 Q X2NULL
 ;
 ;=======================================================================
EDITNXR(X1,X2) ;For a new style cross-reference check X1 and X2 to determine
 ;if an edit is being done.
 N ADD,AREDIFF,EDIT,IND,X1NULL,X2NULL
 S AREDIFF=0
 S (X1NULL,X2NULL)=1
 S IND=0
 F  S IND=$O(X1(IND)) Q:+IND=0  D
 . I X1(IND)'="" S X1NULL=0
 . I X2(IND)'="" S X2NULL=0
 . I X1(IND)'=X2(IND) S AREDIFF=1
 I X1NULL&'X2NULL S ADD=1
 E  S ADD=0
 I 'X1NULL&'X2NULL&AREDIFF S EDIT=1
 E  S EDIT=0
 Q (ADD!EDIT)
 ;
