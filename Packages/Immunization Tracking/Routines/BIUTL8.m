BIUTL8 ;IHS/CMI/MWR - UTIL: PATLKUP, PRTLST, ZGBL; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: PATIENT LOOKUP, DUPTEST, PRINT LIST, K/ZGBL, KILLALL.
 ;;           HFSPATH, IMMSVDIR.
 ;
 ;
 ;----------
PATLKUP(BIDFN,BIADD,DUZ2,BIPOP) ;EP
 ;---> BI Patient Lookup.
 ;---> Parameters:
 ;     1 - BIDFN       (ret) Patient DFN or -1 if failed.
 ;     2 - BIADD       (opt) ="ADD" If ADD capability during lookup.
 ;     3 - DUZ2=DUZ(2) (opt) If not set, will=User's DUZ(2).
 ;     4 - BIPOP       (ret) BIPOP=1 If DTOUT or DUOUT.
 ;
 ;---> Example: D PATLKUP^BIUTL8(.BIDFN)
 ;              D PATLKUP^BIUTL8(.BIDFN,"ADD") - May ADD Patient to IMM
 ;
 N DFN,DIC,X,Y
 S (BIDFN,BIPOP)=0 D SETVARS^BIUTL5
 S:$G(DUZ2)]"" DUZ(2)=DUZ2
 S DIC="^AUPNPAT(",DIC(0)="AEMQ"
 S DIC("A")="   Select Patient Name or Chart#: "
 D ^DIC
 I $D(DUOUT)!($D(DTOUT)) S BIPOP=1 Q
 S BIDFN=+Y
 ;---> Lookup unsuccessful or aborted.
 Q:Y<0
 ;
 ;---> If Patient does not exist in BI PATIENT File, add.
 I '$D(^BIP(BIDFN,0)) D  Q
 .;
 .;---> If patient is deceased, add as Inactive, Deceased, and quit.
 .I $$DECEASED^BIUTL1(BIDFN) D ADDPAT^BIPATE(BIDFN,DUZ(2),,$G(DT),"d") Q
 .N BIERR
 .;
 .;---> If patient is over 18, or if user does not have BIZ EDIT PATIENTS Key,
 .;---> then add as Inactive, "Never Activated," and quit.
 .I ($$AGE^BIUTL1(BIDFN,1)>18)!($G(BIADD)'="ADD") D  Q
 ..D ADDPAT^BIPATE(BIDFN,DUZ(2),.BIERR,$G(DT),"n")
 ..I $G(BIERR)]"" W !!?3,BIERR D DIRZ^BIUTL3() S BIPOP=1
 .;
 .;---> User may edit.
 .W !!?3,$$NAME^BIUTL1(BIDFN)
 .W " is being added to the Immunization Database",!,"for the first time."
 .W !!?3,"Should this patient be added as Active or Inactive?"
 .N DIR
 .S DIR("?")="     Enter A for Active or I for Inactive."
 .S DIR(0)="SM^A:Active;I:Inactive"
 .S DIR("A")="   Enter A (Active) or I (Inactive)"
 .S DIR("B")="A"
 .;S DIR("B")=$S($$AGE^BIUTL1(BIDFN,1)<19:"A",1:"I")
 .D ^DIR W !
 .I $D(DIRUT) S BIPOP=1 Q
 .N BINACT S BINACT=$S(Y="I":$G(DT),1:"")
 .N BINACTR S BINACTR=$S(BINACT:"n",1:"")
 .D ADDPAT^BIPATE(BIDFN,DUZ(2),.BIERR,BINACT,BINACTR)
 .I $G(BIERR)]"" W !!?3,BIERR D DIRZ^BIUTL3() S BIPOP=1
 ;
 ;
 ;---> If this Patient is already in the Imm Database and <36 months
 ;---> but is Inactive, query.
 Q:$$AGE^BIUTL1(BIDFN,2,$G(DT))>35
 ;Q:'$$INACT^BIUTL1(BIDFN)   ;vvv83
 Q:($$INACT^BIUTL1(BIDFN)="")
 Q:($G(BIADD)'="ADD")
 ;
 W !!?3,"This patient is less than 36 months old and ",$$SEX^BIUTL1(BIDFN,3)
 W !?3,"Immunization Status is INACTIVE."
 W !!?3,"Should this patient's Status be changed to ACTIVE?",!
 N DIR
 S DIR(0)="YA",DIR("A")="   Enter Yes or No: "
 S DIR("?",1)="     Enter YES to change this patient's Status to Active."
 S DIR("?")="     Enter No to leave it Inactive."
 D ^DIR W !
 D:Y=1
 .N BIFLD,BIERR S BIFLD(.08)="",BIFLD(.16)=""
 .D FDIE^BIFMAN(9002084,BIDFN,.BIFLD,.BIERR,1)
 .I $G(BIERR)]"" W !!?3,BIERR D DIRZ^BIUTL3() S BIPOP=1
 Q
 ;
 ;
 ;----------
VFCSET ;EP
 ;---> Load VFC Eligibility.  Called by LOADVIS^BIUTL7.
 ;---> If Patient Ben Type is 01 (Am Indian/AK Native), set VFC default=4.
 Q:$G(BI("P"))]""
 Q:'$G(BIDFN)
 Q:$$BENTYP^BIUTL11(BIDFN,2)'="01"
 N BIDATE S BIDATE=$G(BI("E"))
 Q:'BIDATE
 N BIDOB S BIDOB=$$DOB^BIUTL1(BIDFN)
 Q:'BIDOB
 Q:((BIDOB+190000)'<BIDATE)
 S BI("P")=4
 Q
 ;
 ;
 ;----------
DUPTEST(BIERR,BIDATA,BIOIEN) ;EP
 ;---> Test to be sure a duplicate Immunization  or Skin Test
 ;---> is not being added.
 ;---> Parameters:
 ;     1 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;     2 - BIDATA (req) String of data for the Visit to be added.
 ;     3 - BIOIEN (opt) IEN of V IMM or V SKIN being edited (if
 ;                      not new).
 ;
 ;---> Pieces of BIDATA:
 ;     -----------------
 ;     1 - A  (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;     2 - B  (req) DFN of patient.
 ;     3 - C  (req) Vaccine or Skin Test .01 pointer.
 ;     6 - D  (req) Date of Visit.
 ;
 N A,B,BI31,C,D,V,X S BI31=$C(31)_$C(31),V="|",X=""
 S A=$P(BIDATA,V,1)
 S B=$P(BIDATA,V,2) Q:'B
 S C=$P(BIDATA,V,3) Q:'C
 S D=9999999-$P($P(BIDATA,V,6),".") Q:'D
 ;
 ;---> Check for duplicate visit.
 D
 .;---> If this is a new Immunization or Skin Test,
 .;---> and there exists a duplicate, report the error.
 .I '$G(BIOIEN),A="I",$D(^AUPNVIMM("AA",B,C,D)) S X=423 Q
 .I '$G(BIOIEN),A="S",$D(^AUPNVSK("AA",B,C,D)) S X=424 Q
 .;
 .;---> If the existing xref is not that of the edited visit,
 .;---> and there exists a duplicate, report the error.
 .;---> For an Immunization.
 .I A="I" D  Q
 ..N N S N=0
 ..F  S N=$O(^AUPNVIMM("AA",B,C,D,N)) Q:'N  I N,N'=BIOIEN S X=423
 .;
 .;---> For a Skin Test.
 .I A="S" D  Q
 ..N N S N=0
 ..F  S N=$O(^AUPNVSK("AA",B,C,D,N)) Q:'N  I N,N'=BIOIEN S X=424
 ;
 I X D ERRCD^BIUTL2(X,.BIERR) S BIERR=BI31_BIERR
 Q
 ;
 ;
 ;----------
PRTLST(BITNOD) ;EP
 ;---> Print Listman list instead of displaying it.
 ;---> Parameters:
 ;     1 - BITNOD (req) Node in ^TMP global where list is stored.
 ;
 ;---> Variables:
 ;     1 - VALMHDR (req) Array containing header code.
 ;
 N BICRT S BICRT=$S(($E(IOST)="C")!(IOST["BROWSER"):1,1:0)
 N BIPAGE,BIPOP S BIPAGE=0,BIPOP=0
 N BI31 S BI31=$C(31)_$C(31)
 U IO
 ;---> To eliminate control chars from printouts.
 I BICRT D FULL^VALM1 W @IOF
 D PHEADER(.BIPAGE)
 ;
 ;---> Loop through ^TMP, writing lines of report.
 N N S N=0
 F  S N=$O(^TMP(BITNOD,$J,N)) Q:'N  D  Q:BIPOP
 .N BITEXT S BITEXT=^TMP(BITNOD,$J,N,0)
 .;---> Set BIN=number of lines in this record (=number of $C(30)'s).
 .N BIN S BIN=$P(BITEXT,BI31,2)
 .S BIN=$L(BIN,$C(30))-1
 .;
 .;---> If this is not the very first line, and if this record
 .;---> won't fit on the bottom of this page, do formfeed and header.
 .I N>1 I $Y+BIN+3>IOSL D  Q:BIPOP  W @IOF D PHEADER(.BIPAGE)
 ..D:BICRT DIRZ^BIUTL3(.BIPOP)
 .;
 .W !,$P(BITEXT,BI31)
 ;
 W:'BICRT @IOF D:(BICRT&('BIPOP)) DIRZ^BIUTL3()
 D ^%ZISC
 Q
 ;
 ;
 ;----------
PHEADER(BIPAGE) ;EP
 ;---> Print header for PRTLST above.
 ;---> Parameters:
 ;     1 - BIPAGE (req) Last page# printed.
 ;
 S:'$G(BIPAGE) BIPAGE=0 S BIPAGE=BIPAGE+1
 N N S N=0
 F  S N=$O(VALMHDR(N)) Q:'N  D
 .;---> If this is line 2 of the header, append page#.
 .I N=2 S $E(VALMHDR(2),70,79)=" page "_BIPAGE
 .W !,VALMHDR(N)
 W !,$$SP^BIUTL5(79,"=")
 Q
 ;
 ;
 ;----------
KGBL(BIGBL) ;EP
 ;---> Kill a global.  Global should include leading "^".
 ;---> Parameters:
 ;     1 - BIGBL  (req) Global to be zeroed out (must include "^").
 ;
 S:BIGBL["(" BIGBL=$P(BIGBL,"(")
 F  S BIGBL=$Q(@BIGBL) Q:BIGBL=""  K @BIGBL
 Q
 ;
 ;
 ;----------
ZGBL(BIGBL) ;EP
 ;---> Zero out (delete ALL DATA) in a Fileman file.
 ;---> Parameters:
 ;     1 - BIGBL  (req) Global to be zeroed out.
 ;
 Q:$G(BIGBL)=""
 N N,X S U="^"
 S:$E(BIGBL)'=U BIGBL=U_BIGBL
 S:BIGBL["(" BIGBL=$P(BIGBL,"(")
 Q:'$D(@(BIGBL_"(0)"))
 S N=-1,X=$P(@(BIGBL_"(0)"),U,1,2)
 F  S N=$O(@(BIGBL_"("""_N_""")")) Q:N=""  K @(BIGBL_"("""_N_""")")
 S @(BIGBL_"(0)")=X
 Q
 ;
 ;
 ;----------
KILLALL(BIGLOBS) ;EP
 ;---> Clean up local variables.
 ;---> Parameters:
 ;     1 - BIGLOBS  (opt) If BIGLOBS=1 kill temp globals too.
 ;
 ;---> XB call to kill local variables.
 D EN^XBVK("BI")
 D EN^XBVK("DI")
 ;
 ;---> FILEMAN KILLS.
 D DKILLS^BIFMAN
 D CLEAN^DILF
 K I,M,N,X,Y,Z,ZTRTN,ZTSAVE
 ;
 Q:'$G(BIGLOBS)
 ;---> Clean up temp globals.
 K ^BITMP($J)
 ;
 Q
 ;
 ;---> Other ways:
 ;---> MSM
 ;S X="BI" F  S X=$O(@X) Q:$E(X,1,2)'="BI"  K @X
 ;S X="DI" F  S X=$O(@X) Q:$E(X,1,2)'="BI"  K @X
 ;---> DSM
 ;S X="BI" F  S X=$ZSORT(@X) Q:$E(X,1,2)'="BI"  K @X
 ;S X="DI" F  S X=$ZSORT(@X) Q:$E(X,1,2)'="BI"  K @X
 Q
 ;
 ;
 ;----------
HFSPATH(DUZ2) ;EP
 ;---> Return the Host File Path (directory) as set in the
 ;---> in the BI SITE PARAMETERS File.
 ;---> Parameters:
 ;     1 - DUZ2  (opt) User's DUZ(2), otherwise IEN of Site in
 ;                     RPMS SITE PARAMETERS File.
 ;
 S:'$G(DUZ2) DUZ2=$P($G(^AUTTSITE(1,0)),"^")
 Q $P($G(^BISITE(+DUZ2,0)),"^",14)
 ;
 ;
 ;----------
IMMSVDIR(DUZ2) ;EP
 ;---> Return the MSM Home Directory as set in the
 ;---> in the BI SITE PARAMETERS File.
 ;---> Parameters:
 ;     1 - DUZ2  (opt) User's DUZ(2), otherwise IEN of Site in
 ;                     RPMS SITE PARAMETERS File.
 ;
 S:'$G(DUZ2) DUZ2=$P($G(^AUTTSITE(1,0)),"^")
 Q $P($G(^BISITE(+DUZ2,0)),"^",18)
 ;
 ;
 ;----------
PDSS(BIVIEN,BICOMP,BIPDSS) ;EP
 ;---> Return 1 if this Visit IEN is contained in the ImmServe
 ;---> Problem Dose IEN string; return 0 if not.
 ;---> Parameters:
 ;     1 - BIVIEN (req) Visit IEN of this immunization.
 ;     2 - BICOMP (req) Vaccine Component CVX Code.
 ;     2 - BIPDSS (req) String of ImmServe Problem Dose IENs.
 ;
 Q:'$G(BIVIEN) 0
 Q:'$G(BICOMP) 0
 Q:'$D(BIPDSS) 0
 N I,X,Y,Z S X=0
 S Y=BIVIEN_"%"_BICOMP
 F I=1:1 S Z=$P(BIPDSS,U,I) Q:Z=""  I Y=Z S X=1 Q
 Q X
 ;
 ;
 ;----------
DOVER(X,Z) ;EP
 ;---> Return text of Dose Override Code.
 ;---> Parameters:
 ;     1 - X (req) Code for Dose Override text.
 ;     2 - Z (opt) If Z=1 return Short form (remove "INVALID--" from text).
 ;
 Q:'$G(X) ""
 Q:$G(Z) $P($P($P($G(^DD(9000010.11,.08,0)),X_":",2),";"),"--",2)
 Q $P($P($G(^DD(9000010.11,.08,0)),X_":",2),";")
