ADEUTL ; IHS/HQT/MJL  - PROGRAM ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
SETTYP ;EP
 ;Called by MUMPS X-ref
 ;Set "AD" Xref on Edit Type field of Dental Edit file
 S ^ADEDIT("AD",$P(^ADEDIT(DA,0),U),X,DA)=""
 Q
 ;
KILTYP ;EP
 ;Called by MUMPS X-ref
 ;Kill "AD" Xref on Edit Type field of Dental Edit file
 K ^ADEDIT("AD",$P(^ADEDIT(DA,0),U),X,DA)
 Q
 ;
SETEDT ;EP
 ;Called by MUMPS X-ref
 ;Set "AC" Xref on Resolution Type field of Dental Edit file
 N ADEJ,ADEGRP
 I $P(^ADEDIT(DA,0),U)'["[" S ^ADEDIT("AC",$P(^ADEDIT(DA,0),U),$E(X,1,30),DA)="" Q
 D GRPEDT
 F ADEJ=1:1:$L(ADEGRP,"|") D
 . S ^ADEDIT("AC",$P(ADEGRP,"|",ADEJ),$E(X,1,30),DA)=""
 Q
 K ADEGRP ;*NE
 ;
KILEDT ;EP
 ;Called by MUMPS X-ref
 ;Kill "AC Xref on Resolution Type field of Dental Edit File
 N ADEJ,ADEGRP
 I $P(^ADEDIT(DA,0),U)'["[" K ^ADEDIT("AC",$P(^ADEDIT(DA,0),U),$E(X,1,30),DA) Q
 D GRPEDT
 F ADEJ=1:1:$L(ADEGRP,"|") D
 . K ^ADEDIT("AC",$P(ADEGRP,"|",ADEJ),$E(X,1,30),DA)
 Q
 ;
GRPEDT ;Called by KILEDT and SETEDT to get list of codes in edit group
 S ADEGRP=$P($P(^ADEDIT(DA,0),U),"[",2)
 S ADEGRP=$O(^ADEDIT("GRP","B",ADEGRP,0))
 S ADEGRP=$P(^ADEDIT("GRP",ADEGRP,1),U)
 Q
 ;
ENABLE(ADECOD,ADENBL)        ;EP
 ;Enables (ADENBL=1) or disables (ADENBL=0) code edit ADECOD
 ;ADECOD is unique entry in ^ADEDIT(
 ;Currently, this sub is only used to toggle the
 ;state of the 1350 sealant code edit.  If it's to be used
 ;on other edits that do not have unique ADEDIT keys, then
 ;a new ADEDIT field will need to be created and initialized
 ;with unique entries.  For now, the 1350 code is unique.
 ;
 Q:ADECOD=""
 Q:'$D(^ADEDIT("B",ADECOD))
 S ADECOD=$O(^ADEDIT("B",ADECOD,0))
 Q:'+ADECOD
 Q:'$D(^ADEDIT(ADECOD,0))
 S DR="1.4///"_$S(ADENBL:"Y",1:"N")
 S DIE="^ADEDIT(",DA=ADECOD
 D ^DIE
 Q
 ;
FY(ADEVDATE)    ;EP
 ;Returns FM-date form of the first day of the fiscal
 ;year in which ADEVDATE falls
 ;ADEVDATE is not in FM-date form
 ;
 N ADEVFM,ADEFY,ADEJ,ADEK,ADECNT,ADENDFY,ADEFV,ADERV
 S %DT="T",X=ADEVDATE D ^%DT S ADEVFM=Y
 ;beginning Y2K fix
 ;S ADEFY=1000
 ;S ADEFY="2"_$S($E(ADEVFM,4,5)<10:$E(ADEVFM,2,3)-1,1:$E(ADEVFM,2,3))_ADEFY
 ;S ADENDFY=ADEFY,$E(ADENDFY,2,3)=$E(ADENDFY,2,3)+1
 Q:ADEVFM=-1 0  ;Y2000
 S ADEFY=$P($$FISCAL^XBDT(ADEVFM),U,2)  ;Y2000
 ;end Y2K fix block
 Q ADEFY
