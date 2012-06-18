BWMPEXP ;IHS/CIA/PLS - Mammography Project Export ;01-Oct-2003 16:55;PLS
 ;;2.0;WOMEN'S HEALTH;**9**;16-Apr-2003 13:01
 ;=================================================================
EN ;
 N Y,BWBEGDT,BWENDDT,BWPOP,BWSTYLE,BWPATH,BWFILE,BWSPN
 N PCNT
 S BWSTYLE=""
 D TITLE^BWUTL5("Export Mammography Project Data")
 D ASK
 Q:BWPOP
 S BWPATH=$P($G(^BWSITE($G(DUZ(2)),0)),U,14)
 S BWFILE=$P($G(^BWSITE($G(DUZ(2)),0)),U,13)_"mp"_$$DATE_"."_$S(BWSTYLE="X":"xml",1:"txt")
 S BWPOP=$$OPEN^%ZISH(BWPATH,BWFILE,"W")
 I 'BWPOP D
 .D CLOSE^%ZISH()
 E  D
 .D HFSERR S BWPOP=1
 I 'BWPOP D
 .W !!,"Working...  "
 .D LOOP(44,BWBEGDT,BWENDDT,BWSTYLE="X")  ; 44=Mammography Project Procedure Type
 .S Y=$$GTF^%ZISH($NA(^TMP($J,"BWMP",1)),3,BWPATH,BWFILE)
 .I Y D
 ..W !!,"Number of Procedures exported: "_+$G(PCNT)
 ..W !!,"The export data has been successfully saved."
 ..W !,"The '"_BWFILE_"' file was saved in the '"_BWPATH_"' folder."
 E  D
 .D HFSERR S BWPOP=1
 Q
 ; Collect report qualifiers
ASK ;
 N DIRUT,DIR
 D DATEINFO
 D ASKDATES^BWUTL3(.BWBEGDT,.BWENDDT,.BWPOP)
 I 'BWPOP D
 .K DIR
 .S DIR(0)="S^F:Fixed Length Fields;X:XML"
 .S DIR("A")="Which Style"
 .D ^DIR
 .I $D(DIRUT) S BWPOP=1
 .E  S BWSTYLE=Y
 Q
LOOP(BWPTYP,BWBEGDT,BWENDDT,XML) ;
 N BWDT,BWIEN,BWMPARY,CNT,BWENDT,BW0
 ; Build array of active fields
 K ^TMP($J,"BWMP")
 D BLDARY(.BWMPARY)
 S XML=$G(XML,0)
 I XML D
 .D ADD("<?xml version=""1.0"" encoding=""utf-8"" ?>")
 .D ADD("<Procedures>")
 .D ADD("<ExportDateRange>"_$$FMTE^XLFDT(BWBEGDT)_" to "_$$FMTE^XLFDT(BWENDDT)_"</ExportDateRange>")
 S BWDT=BWBEGDT-.00001,BWENDT=BWENDDT+.99999
 F  S BWDT=$O(^BWPCD("D",BWDT)) Q:'BWDT!(BWDT>BWENDT)  D
 .S BWIEN=0
 .F  S BWIEN=$O(^BWPCD("D",BWDT,BWIEN)) Q:'BWIEN  D
 ..I '$D(^BWPCD(BWIEN,0)) K ^BWPCD("D",BWDT,BWIEN)
 ..S BW0=$G(^BWPCD(BWIEN,0))
 ..Q:$P($G(^BWPCD(BWIEN,0)),U,4)'=BWPTYP
 ..D PROC(BWIEN,XML)
 D:XML ADD("</Procedures>")
 Q
 ; Loop thru the field array for a given procedure ien
 ; Input: IEN - Procedure IEN
 ;        XML - Flag indicating output style
 ;              0 - fixed length string per record
 ;              1 - XML record format
PROC(IEN,XML) ;
 N BWMMP,LBLNM,OUT,COL,LEN,BWMMP0
 S BWMMP=0
 ;I $$WORKING(.BWSPN)
 S PCNT=+$G(PCNT)+1
 I 'XML D
 .F  S BWMMP=$O(BWMPARY(BWMMP)) Q:'BWMMP  D
 ..;D ADD($$LBLNM(BWMPARY(BWMMP))_" = "_$$DATA(IEN,(BWMPARY(BWMMP))))
 ..S BWMMP0=$G(^BWMPEXP(BWMPARY(BWMMP),0))
 ..S COL=$P($P(BWMMP0,U,2),","),LEN=$P($P(BWMMP0,U,2),",",2)
 ..S $E(OUT,COL,COL+LEN)=$$DATA(IEN,BWMPARY(BWMMP))
 .D ADD(OUT)
 E  D
 .D ADD("  <Procedure>")
 .F  S BWMMP=$O(BWMPARY(BWMMP)) Q:'BWMMP  D
 ..S LBLNM=$$LBLNM(BWMPARY(BWMMP),1)
 ..D ADD("    <"_LBLNM_">"_$$DATA(IEN,(BWMPARY(BWMMP)))_"</"_LBLNM_">")
 .D ADD("  </Procedure>")
 Q
DATA(PIEN,BWMMP) ;
 N BWMMP0,FILE,FLD,FMT,VAL,FMTJ,FMTJ1,PAD,FMTD
 N EXT,PGM
 S BWMMP0=$G(^BWMPEXP(BWMMP,0))
 S FILE=$P($P(BWMMP0,U,4),",")
 S FLD=$P($P(BWMMP0,U,4),",",2)
 S LEN=$P($P(BWMMP0,U,2),",",2)
 S FMT=$P(BWMMP0,U,5)
 S VAL=""
 S VAL=$$GET1^DIQ(FILE,PIEN,FLD,$S(FMT["I":"I",1:"E"))
 I $F(FMT,"Z")>0 D
 .X:$L($G(^BWMPEXP(BWMMP,1))) ^BWMPEXP(BWMMP,1)
 I $F(FMT,"J")>0 D
 .S FMTJ=$F(FMT,"J"),FMTJ=$E(FMT,FMTJ,FMTJ+1),FMTJ1=$E(FMTJ,1)
 .S PAD=$E(FMTJ,2)
 .S PGM="VAL="_$S(FMTJ1="C":"$$CJ^XLFSTR(VAL,LEN,PAD)",FMTJ1="R":"$$RJ^XLFSTR(VAL,LEN,PAD)",FMTJ1="L":"$$LJ^XLFSTR(VAL,LEN,PAD)",1:"")
 .S:$L(PGM)>4 @PGM
 ; Check for Date format
 I $F(FMT,"D")>0 D
 .S FMTD=$E(FMT,$F(FMT,"D"))
 .S VAL=$TR($$FMTE^XLFDT(VAL,$S(FMTD=2:"7",1:"5")_"Z"),"/","")
 .S:FMTD=3 VAL=$E(VAL,1,2)_$E(VAL,5,8)
 Q $E(VAL,1,LEN)
 ; Return array containing active export fields
BLDARY(ARY) ;
 N IEN,ORDN
 S IEN=0
 F  S IEN=$O(^BWMPEXP(IEN)) Q:'IEN  D
 .S ORDN=+$P($G(^BWMPEXP(IEN,0)),U,3)
 .S:ORDN>0 ARY(ORDN)=IEN
 Q
 ; Return label name for data field
 ; Input: BWMMP - IEN of BW MAMMOGRAPHY EXPORT DEFINITIONS (9002086.26)
 ;        STRIP - 0: do nothing, 1: strip spaces
LBLNM(BWMMP,STRIP) ;
 N LBLNAME
 S STRIP=$G(STRIP,0)
 S LBLNAME=$$GET1^DIQ(9002086.26,BWMMP,.06,"E")
 S:LBLNAME="" LBLNAME=$$GET1^DIQ(9002086.26,BWMMP,.01,"E")
 Q $S(STRIP:$$STRIP(LBLNAME),1:LBLNAME)
 ; Return flag indicating given race is defined for patient
 ; Input: PIEN - Procedure IEN
 ;        RIEN - IEN to BW RACE File (9002086.34) or array of iens
RACE(PIEN,RIEN) ;
 N RARY,FLG,LP,RACE,I,BWDFN,PRIEN
 S BWDFN=+$P($G(^BWPCD(PIEN,0)),U,2)
 Q:'BWDFN 0
 S I=0 F  S I=$O(^BWP(BWDFN,2,I)) Q:'I  D
 .; Build array with patient's race iens
 .S PRIEN=+$G(^BWP(BWDFN,2,I,0))
 .S:PRIEN RARY(PRIEN)=""
 S:$D(RIEN)#2 RIEN(-1)=RIEN
 S FLG=0,RACE="" F  S RACE=$O(RIEN(RACE)) Q:RACE=""!FLG  D
 .S:$D(RARY(RIEN(RACE)))>0 FLG=1
 Q FLG
 ; Return CDC coded values for Ethinicity
 ; (1=Hispanic,2=Not Hispanic,3=Unknown or Declined to answer)
ETHNIC(PIEN) ;
 N BWDFN
 S BWDFN=+$P($G(^BWPCD(PIEN,0)),U,2)
 Q:'BWDFN 3
 Q $$HISPANIC^BWMDEX2
 ; Add a node to the global
ADD(VAL) ;
 S CNT=+$G(CNT)+1
 S ^TMP($J,"BWMP",CNT)=VAL
 Q
 ; Strip out illegal characters for XML output
STRIP(X) ;
 S X=$$STRIP^XLFSTR(X,"#/ <>()")
 Q X
 ; Format current date as YYYYMMDD
DATE() ;
 Q $TR($$FMTE^XLFDT($$DT^XLFDT,"7Z"),"/","")
 ;
DATEINFO ;
 W !?3,"Select date range to export."
 Q
 ; Displays spinning icon to indicate progress
 ; Input: BWAST - Start character position
 ;        BWAP - Suppress printing
 ;        BWAS - List of characters to print
WORKING(BWAST,BWAP,BWAS) ;
 Q 1
 ;Q:'$D(IO(0))!$D(ZTQUEUED) 0
 ;N BWAZ
 ;S BWAZ(0)=$I,BWAS=$G(BWAS,"|/-\"),BWAST=+$G(BWAST)
 ;S BWAST=$S(BWAST<0:0,1:BWAST#$L(BWAS)+1)
 ;U IO(0)
 ;W:'$G(BWAP) *8,*$S(BWAST:$A(BWAS,BWAST),1:32)
 ;R BWAZ#1:0 S BWAZ=$C(BWAZ)
 ;U BWAZ(0)
 ;Q BWAZ=94
 ;
 ; Display Host File Message
HFSERR ;
 W !!?5,"* Save to Host File Server FAILED. Contact your sitemanager."
 D DIRZ^BWUTLP
 Q
