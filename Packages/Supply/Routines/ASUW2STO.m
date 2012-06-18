ASUW2STO ; IHS/ITSC/LMH -EXTRACT TRANS-CVRT DDPS FORMAT ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;This routine extracts SAMS transactions for export to STORES
 G BEGIN
MO(X) ;EP;
 S ASUP("MO")=X
BEGIN ;EP;FOR RE-EXTRACT
 D:'$D(U) ^XBKVAR
 I '$D(IO(0)) S IOP=$I D ^%ZIS
 S ASUP("TYP")=$G(ASUP("TYP")) S:ASUP("TYP")']"" ASUP("TYP")=0
 S ASUW("TY RUN")=^ASUSITE(1,0)
 ;I $P(ASUW("TY RUN"),U,2)=8 G REXT2^ASUW2ST1
 D:'$D(ASUK("DT","FM")) DATE^ASUUDATE
 S ASUW("DT EXT")=ASUK("DT","FM")
 K ^ASUPDATA ;DFM P1 8/28/98 - Blanket exception for AIB global?
OPNHFS ;EP;FOR RE-EXTRACT
 D TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S. Extract data for STORES Procedure Begun "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 S ASUW("TY RUN")=^ASUSITE(1,0)
 S ASUW("SV MED")=$P(ASUW("TY RUN"),U,9)
 S ASUW("SV DIR")=$P(ASUW("SV MED"),":",2)
 S ASUW("SV MED")=$P(ASUW("SV MED"),":")
 S ASUL(1,"AR","WHSE")=$G(ASUL(1,"AR","WHSE"))
 I ASUL(1,"AR","WHSE")<3 D ^ASUW2ST1
 S ASUV("PADLN")=""
 S (ASUC(0),ASUC("RECTOT"),ASUC("REC"),ASUC("TOTPRC"))=0
 F ASUG("FL#")=1:1:7 D
 .S ASUC(0)=ASUC(0)+1
 .S ASUG("TRGBL")="^TMP(""ASUW"",$J,"_ASUG("FL#")_",",ASUG("PC#","TR")=1,ASUG("PC#","AR")=2,ASUW("FL","NM")=$P(^ASUT(ASUG("FL#"),0),U)
 .S DIE="^ASUH"
 .S ASURX="W !,""Now Processing "_ASUW("FL","NM")_" Records"",!"
 .D ^ASUUPLOG
 .D ASUW2ST7^ASUW2ST1
 .F  S ASUHDA=$O(@ASUG("E#")) Q:ASUHDA=""  D  ;DFM P1 8/28/98
 ..S DA=ASUHDA,ASUW("XTR-F")=1 ;DFM P1 8/28/98
 ..I ASUL(1,"AR","WHSE")<3 D ASUWXT1
 ..S ASUC("TOTPRC")=ASUC("TOTPRC")+1
 .S ASUC(ASUG("FL#"))=ASUC("RECTOT")-ASUC("REC")
 .S $P(^ASUL(30,ASUG("FL#"),0),U,5)=ASUC(ASUG("FL#")) ;DFM P1 8/28/98
 .S $P(^ASUL(30,ASUG("FL#"),0),U,6)=ASUW("DT EXT") ;DFM P1 8/28/98
 .S ASUC("REC")=ASUC("RECTOT")
 .I ASUL(1,"AR","WHSE")<3 S ASURX="W !,"""_ASUW("FL","NM")_" Record Count : "","_$P(^ASUL(30,ASUG("FL#"),0),U,5) D ^ASUUPLOG
 S ASURX="W !,*7,""Conversion Completed"",*7" D ^ASUUPLOG
 S ASURX="W !,""Total records processed: "","_ASUC("TOTPRC") D ^ASUUPLOG
 I ASUC("RECTOT")=0 D
 .S ASURX="W !,""There were no current records converted"",*7,!"
 .D ^ASUUPLOG
 .I 1
 E  D
 .S ASURX="W !,""Total records converted "","_ASUC("RECTOT")
 .D SETAREA^ASULARST
 .S ^ASUPDATA(0)=$G(ASUK("ASUFAC"))_U_ASUL(1,"AR","NM")_U_ASUW("DT EXT")_U_ASUW("DT EXT")_U_ASUW("DT EXT")_U_U_ASUC("RECTOT")
 .I ASUL(1,"AR","WHSE")<3 D
 ..I ASUP("TYP") S $P(^ASUSITE(1,0),U,8)=ASUW("DT EXT") D LOGNTRY^ASUW2SAM(ASUP("MO"))
 .E  D
 ..S $P(^ASUSITE(1,0),U,8)=ASUW("DT EXT") D LOGNTRY^ASUW2SAM(ASUP("MO"))
 .S XBMED=$S(ASUW("SV MED")]"":ASUW("SV MED"),1:"F") D ASUW2ST9^ASUW2ST1
 I ($G(IOST)'["C-")&($G(ASUK("PTR-Q"))'=1) K DIR S DIR(0)="E" D ^DIR
 D TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S. Extract data for DDPS Procedure Ended "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 K ASUX,ASULA("X"),ASUU,ASUC,ASUG,ASUT,ASUF("TAPE"),XBGL,XBMED,XBUF
 K DA,DR,DIE,DTOUT,DUOUT,DIROUT
 K ^ASUW(4),^ASUW(5)
 K:$G(ASUP("TYP"))="" ASUV,ASUW
 Q
ASUWXT1 ;Conversion sub-routine
 S (ASUT("OUT"),ASUT(0),ASUW("FIL"))=""
 S ASUG("TRN")=ASUG("TRGBL")_ASUHDA_"," ;DFM P1 8/28/98
 S ASUG("TRN",ASUG("FL#"))=ASUG("TRN")_ASUG("FL#")_")"
 S ASUG("TRN",1)=ASUG("TRN")_1_")"
 S ASUG("TRN",0)=ASUG("TRN")_0_")"
 S:ASUG("FL#")>1 ASUT(ASUG("FL#"))=$G(@ASUG("TRN",ASUG("FL#")))
 S ASUT(0)=@ASUG("TRN",0)
 S ASUT(1)=@ASUG("TRN",1)
 I ASUL(1,"AR","AP")'=$P(ASUT(0),U,ASUG("PC#","AR")) S ASUW("XTR-F")=0 Q
 S ASUT("TRCDE")=$P(ASUT(1),U)
 Q:ASUT("TRCDE")="3J"
 Q:ASUT("TRCDE")=""
 I ASUT("TRCDE")="31" S ASUT("TRCDE")="32",$P(ASUT(1),U)=ASUT("TRCDE")
 S ASUG("FLD","#")=0
 F  S ASUG("FLD","#")=$O(^ASUL(30,ASUG("FL#"),1,1,1,ASUG("FLD","#"))) Q:ASUG("FLD","#")'?1N.N  D  ;DFM P1 8/28/98
 .S ASUW("FLD","CTRL")=^ASUL(30,ASUG("FL#"),1,1,1,ASUG("FLD","#"),0) ;DFM P1 8/28/98
 .S ASUW("FLD","NM")=$P(ASUW("FLD","CTRL"),U)
 .S ASUW("FLD","STRT")=$P(ASUW("FLD","CTRL"),U,2)
 .S ASUW("FLD","LEN","OUT")=$P(ASUW("FLD","CTRL"),U,3)
 .S ASUW("PC#","FLD")=$P(ASUW("FLD","CTRL"),U,4)
 .S ASUW("FLD","TY")=$P(ASUW("FLD","CTRL"),U,5)
 .S ASUW("NODE")=$P(ASUW("FLD","CTRL"),U,6)
 .D ASUWXT3
 D UPDTHIST^ASUW2SAM ;DFM P1 8/28/96
 S ASUC("RECTOT")=ASUC("RECTOT")+1
 S ^ASUPDATA(ASUC("RECTOT"))="ST1"_U_ASUT("OUT")
 S ASUT("OUT")=""
 I $G(ASUK("PTR-Q"))=1 Q
 S X=ASUC("RECTOT")#10
 I X>0 Q
 S X="",X=X_$J("",8-$L(ASUC("RECTOT")))_ASUC("RECTOT")
 S ASURX="W *13,?30,"""_X_"""" D ^ASUUPLOG
 Q
ASUWXT3 ;Determine field Type
 I ASUW("NODE")]"" D
 .S ASUW("PCIN")=$P(ASUT(ASUW("NODE")),U,ASUW("PC#","FLD"))
 E  D
 .S ASUW("PCIN")=""
 I ASUW("FLD","TY")']"" D ALPHA Q
 I ASUW("FLD","TY")["D" D DATE Q
 I ASUW("FLD","TY")["*" D DESC Q
 I ASUW("FLD","TY")["V" D VALUE Q
 I ASUW("FLD","TY")["A" D ALPHA Q
 I ASUW("FLD","TY")["N" D NUM Q
 I ASUW("FLD","TY")["B" D  Q
 .I $E(ASUT("TRCDE"))=3 D
 ..I ASUW("FLD","NM")]"SUB" D  Q
 ...I $E(ASUT("TRCDE"),2)>3 S ASUW("PCIN")=""
 .I ASUW("PCIN")]"" D NUM Q
 .D ALPHA
 D ALPHA
 Q
DATE ;FORMAT FROM VA FILEMAN DATE
 I ASUW("FLD","TY")["4" D
 .I ASUW("PCIN")?7N D  Q
 ..I ASUW("FLD","NM")["EXPIRATION DATE" S ASUW("DT")=$E(ASUW("PCIN"),4,5)_$E(ASUW("PCIN"),2,3) Q
 ..I ASUG("TRGBL")]"(5" S ASUW("DT")=$E(ASUW("PCIN"),2,3)_$E(ASUW("PCIN"),4,5) Q
 ..S ASUW("DT")=$E(ASUW("PCIN"),4,5)_$E(ASUW("PCIN"),2,3)
 .S ASUW("DT")="    "
 E  D
 .I $E(ASUT("TRCDE"))=3 D
 ..I $E(ASUT("TRCDE"),2)?1A S ASUW("PCIN")="" Q
 ..I $E(ASUT("TRCDE"),2)>3 S ASUW("PCIN")=""
 .I ASUW("PCIN")?7N D  Q
 ..S ASUW("DT")=$E(ASUW("PCIN"),4,5)_$E(ASUW("PCIN"),6,7)_$E(ASUW("PCIN"),2,3)
 .S ASUW("DT")="      " Q
 S ASUT("OUT")=ASUT("OUT")_ASUW("DT")
 K ASUW("DT")
 Q
DESC ;DESCRIPTIONS
 S ASUW("FLD","TY")=ASUW("FLD","TY")_"L"
 I ASUW("FLD","TY")["2" D
 .S ASUW("PCIN")=$P(ASUW("PCIN"),"*",2)
 E  D
 .S ASUW("PCIN")=$P(ASUW("PCIN"),"*")
ALPHA ;FILL WITH SPACES
 I ASUG("TRGBL")["(0",ASUW("FLD","NM")="SUB STATION",ASUW("PCIN")="PL" S ASUW("PCIN")=""
 I ASUG("TRGBL")["(2",ASUW("FLD","NM")="FORP CODE",ASUW("PCIN")="P" S ASUW("PCIN")="F"
 I ASUW("FLD","NM")["SUBOBJECT" S ASUW("PCIN")=$P(ASUW("PCIN"),".")_$P(ASUW("PCIN"),".",2)
 I ASUW("FLD","TY")["L" D  ;LEFT JUSTIFY WITH SPACES
 .S ASUW("FLD","LEN","IN")=$L(ASUW("PCIN"))
 .S ASUW("FLD","LEN","PAD")=ASUW("FLD","LEN","OUT")-ASUW("FLD","LEN","IN")
 .I ASUW("FLD","LEN","PAD")<0 D
 ..S ASUW("PCIN")=$E(ASUW("PCIN"),1,ASUW("FLD","LEN","OUT")),ASUW("FIL")=""
 .E  D
 ..S ASUW("FIL")=$J("",ASUW("FLD","LEN","PAD"))
 .S ASUT("OUT")=ASUT("OUT")_ASUW("PCIN")_ASUW("FIL")
 E  D  ;RIGHT JUSTIFY WITH SPACES
 .S ASUW("FIL")=$J(ASUW("PCIN"),ASUW("FLD","LEN","OUT"))
 .S ASUT("OUT")=ASUT("OUT")_ASUW("FIL")
 Q
VALUE ;REMOVE DECIMAL PAD WITH ZEROS
 I $E(ASUT("TRCDE"))=3 D
 .I ASUW("FLD","NM")="VALUE" D  Q
 ..I $E(ASUT("TRCDE"),2)'?1A S ASUW("PCIN")=""  ;Mainframe will compute it's own value on issues, but not reversal issues
 I ASUW("FLD","LEN","OUT")=8 D  ;Value fields
 .I ASUW("PCIN")'?1N.PN D
 ..S ASUW("VAL")="        "
 .E  D
 ..S X=ASUW("PCIN")*.000001,X=$FN(X,"T",8),X=$P(X,".",2),ASUW("VAL")=$E(X,1,8)
 E  D  ;Unit price fields
 .I ASUW("FLD","LEN","OUT")=6 D
 ..I ASUW("PCIN")'?1N.PN D
 ...S ASUW("VAL")="      "
 ..E  D
 ...S X=ASUW("PCIN")*.0001,X=$FN(X,"T",6),X=$P(X,".",2),ASUW("VAL")=$E(X,1,6)
 .E  D
 ..I ASUW("PCIN")'?1N.PN D
 ...S ASUW("VAL")="       "
 ..E  D
 ...S X=ASUW("PCIN")*.00001,X=$FN(X,"T",6),X=$P(X,".",2),ASUW("VAL")=$E(X,1,6)
 S ASUT("OUT")=$G(ASUT("OUT"))_ASUW("VAL")
 K ASUW("VAL")
 Q
NUM ;FILL WITH ZEROS
 I ASUW("FLD","NM")["VOUCH" S ASUW("PCIN")=$TR(ASUW("PCIN"),"-")
 I ASUG("FL#")=4,ASUT("TRCDE")'["D",ASUW("FLD","NM")="ACCOUNT" D
 .S:ASUW("PCIN")'="1" $P(ASUT(4),U,4)="" Q
 .S ASUT("CAT")=$P(ASUT(4),U,4)
 .I ASUT("CAT")'="N"&(ASUT("CAT")'="R") S $P(ASUT(4),U,4)="0"
 .K ASUT("CAT")
 S ASUW("ZROS")=""
 S ASUW("FLD","LEN","IN")=$L(ASUW("PCIN"))
 I ASUW("FLD","LEN","IN")<ASUW("FLD","LEN","OUT") D
 .S ASUU(12)=ASUW("FLD","LEN","OUT")-ASUW("FLD","LEN","IN")
 .F ASUU(10)=1:1:ASUU(12) D
 ..S ASUW("ZROS")=ASUW("ZROS")_0
 ..I ASUU(10)=ASUU(12) S ASUW("PCIN")=ASUW("ZROS")_ASUW("PCIN")
 ;WAR 10/13/99 added next line for Stat. Mst records (5's) remove "."
 I ASUW("FLD","NM")["LEAD TIME MONTHS" S ASUW("PCIN")=$TR(ASUW("PCIN"),".")
 ;WAR 10/13/99 added next line for Index Mst records (4's) remove "."
 I ASUW("FLD","NM")["OBJECT SUB OBJECT" S ASUW("PCIN")=$TR(ASUW("PCIN"),".")
 I ASUG("TRGBL")["ASUT(2",ASUW("FLD","NM")="FORP CODE",ASUW("PCIN")["F" S ASUW("PCIN")=""
 I ASUW("FLD","TY")["L" S ASUT("OUT")=ASUT("OUT")_ASUW("PCIN")_ASUW("ZROS") Q
 S ASUT("OUT")=ASUT("OUT")_ASUW("PCIN") S ASUW("ZROS")=""
 Q
