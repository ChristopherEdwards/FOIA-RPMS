AGTXALL ;IHS/ASDS/EFG - EXPORT ALL REG DATA ;9:58 AM  19 Oct 2010
 ;;7.1;PATIENT REGISTRATION;**1,2**;JAN 31, 2007
 ;
 Q:'$$CHK^AGTXALL1
 D HOME^%ZIS,HELP^XBHELP("INTRO","AGTXALL"),HIST
 Q:'$$DIR^XBDIR("YO","Proceed","N","","Do you want to proceed with the extract of patient demographics for the NPIRS re-load (Y/N)")
 NEW AGIN01
 S AGIN01=$$NOW^XLFDT
 S AGTMP="^AGTXDATA" K @AGTMP
 NEW DFN,AGDONE,AGID,AGP3,DX,DY,AGSITE,AGN11,AGDPT0,AGPAT0,T,AGZTQUED
 NEW AG,AGRCT,AGOUTFLG,AGROUT,AGTXRGSV,AGIN03,AGIN06,AGBAD16,AGBAD26,AGBAD51
 S (AGIN03,AGIN06,AGLDAT,AGROUT,AGOUTFLG,AG("TOT"),DFN,AGBAD16,AGBAD26,AGBAD51)=0,AGFDAT=9999999,AGP3=$P(^AUPNPAT(0),U,3),(AGTXALL,AG("MODCODE"))=1
 S AGTXRGSV=$P(^AUTTAREA($P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,4),0),U,3),AGTXSITE=$P(^AUTTSITE(1,0),U)
 F %=1:1:8 S AG("TOT",%)=0
 S DX=$X,DY=$Y+1
 F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D  I '(DFN#1000),'$D(ZTQUEUED) X IOXY W "On IEN ",DFN," of ",AGP3," in ^AUPNPAT(..."
 . Q:'$D(^DPT(DFN))
 . Q:$P(^DPT(DFN,0),U,19)  ;merged pt
 . S (AGDONE,AGSITE)=0
 . F  S AGSITE=$O(^AUPNPAT(DFN,41,AGSITE)) Q:'AGSITE  D  Q:AGDONE
 .. I $L($P(^AUPNPAT(DFN,41,AGSITE,0),U,5)) Q:"DM"[$P(^(0),U,5)  ; deleted or merged patient
 .. KILL T
 .. S AG("SITE")=AGSITE,AGRCT=DFN,AGID=$$UID^AGTXID(DFN)
 .. I $D(^AGFAC("AC",AGTXSITE)),$D(^AUPNPAT(DFN,41,AGTXSITE,0)) S %=$P(^(0),U,5) I ((%="")!(%="I")) S AG("SITE")=AGTXSITE
 .. Q:'$D(^AGFAC("AC",AG("SITE")))
 .. ;IHS/SD/TPF AG*7.1*1 IM19329
 .. S FIXLIST(DFN)="",NOMSG=1
 .. D FIXALL^AGDATA(.FIXLIST,NOMSG)
 .. K NOMSG
 .. ;END NEW CODE
 .. D ALL^AGTX1
 .. S AGDPT0=$G(^DPT(DFN,0)),AGPAT0=$G(^AUPNPAT(DFN,0)),AGN11=$G(^AUPNPAT(DFN,11))
 .. D RG6,RG7,RG8
 .. S AGDONE=1 ;pt is done, one and only one time
 .. S AGIN03=AGIN03+1
 .. I $P(AGPAT0,U,2),$P(AGPAT0,U,2)<AGFDAT S AGFDAT=$P(AGPAT0,U,2)
 .. I $P(AGPAT0,U,2)>AGLDAT S AGLDAT=$P(AGPAT0,U,2)
 ..Q
 .Q
 KILL T
 S AG("T")=AGIN03,AG("TOT")=AGROUT,AGFDATE=AGFDAT,AGLDATE=AGLDAT
 D ALL^AGTX4,^AGVAR,EN^XBVK("XB")
 S AGZTQUED=$D(ZTQUEUED),ZTQUEUED=1,AGOPT(17)="N"
 S XBQTO="-il regftp:sa3df4gh "_$P($T(DW),";",3)
 D ^AGTXTAPE
 KILL:'AGZTQUED ZTQUEUED
 I $G(XBFLG)=-1 W:'$D(ZTQUEUED) !!,XBFLG(1)
 E  W:'$D(ZTQUEUED) !,"Comprehensive Export file queued to be sent to ",$P($T(DW),";",3),"...",!
 D EN^XBVK("AG"),EN^XBVK("XB")
 S AGTMP="^AGTXDATA" K @AGTMP
 Q
RG6 ;
 NEW I
 S I=0
 F  S I=$O(^AUPNPAT(DFN,51,I)) Q:'I  S %=^(I,0),T(6)="RG6"_U_U_($P(%,U,1)+17000000)_U,%=$P(%,U,3) S:% %=$P($G(^AUTTCOM(%,0)),U,8),T(6)=T(6)_$E(%,5,7)_$E(%,3,4)_$E(%,1,2) D SET(6)
 Q
RG7 ;
 NEW I
 S I=0,T(7)="RG7"
 F  S I=$O(^DPT(DFN,.01,I)) Q:'I  S $P(T(7),U,3,5)=$P($$NAMECVT($P(^(I,0),U)),U,1,3) D SET(7)
 Q
RG8 ;EP - To export RG8s for regular exports.
 I '$G(AGTXALL) S AGDPT0=$G(^DPT(DFN,0)),AGPAT0=$G(^AUPNPAT(DFN,0)),AGN11=$G(^AUPNPAT(DFN,11))
 NEW C,D,I,O,S,N
 ;MediCARE
 S I=0
 F  S I=$O(^AUPNMCR(DFN,11,I)) Q:'I  S %=^(I,0),D(9999999-$P(%,U,2),I)=%
 D XI(.D)
 S D=0,AG0=$G(^AUPNMCR(DFN,0)),AG21=$G(^AUPNMCR(DFN,21))
 F  S D=$O(D(D)) Q:'D  S I=0 F  S I=$O(D(D,I)) Q:'I  D  D SET(8)
 . ;S %=^AUPNMCR(DFN,11,I,0)
 . ;BEGIN NEW CODE IHS/SD/TPF AG*7.1*1 IM19329
 . S %=$G(^AUPNMCR(DFN,11,I,0))
 . Q:%=""!($P(%,U)="")
 . ;END NEW CODE
 . S T(8)="RG8"_U_U_"MCR"_U_$S($P(%,U,1):($P(%,U,1)+17000000),1:"")_U_$S($P(%,U,2):($P(%,U,2)+17000000),1:"")_U_$P(%,U,3)
 . Q:'(D(D,I)="ALL")
 . I $P(AG0,U,2) S $P(T(8),U,7)=$P($G(^AUTNINS($P(AG0,U,2),0)),U,1),$P(T(8),U,8)=$P($G(^AUTNINS($P(AG0,U,2),0)),U,7)
 . S $P(T(8),U,9)=$P(AG0,U,3)
 . I $P(AG0,U,4) S $P(T(8),U,10)=$P($G(^AUTTMCS($P(AG0,U,4),0)),U,1)
 . S $P(T(8),U,11,13)=$P($$NAMECVT($P(AGDPT0,U)),U,1,3)
 . I $L($P(AG21,U,1)),'($P(AG21,U,1)="SAME") S $P(T(8),U,19,21)=$P($$NAMECVT($P(AG21,U,1)),U,1,3),$P(T(8),U,29)=$P(AG21,U,1) I 1
 . E  S $P(T(8),U,19,21)=$P(T(8),U,11,13)
 . I $P(AG21,U,2) S $P(T(8),U,14)=$P(AG21,U,2)+17000000
 . I $P(AG0,U,5) S $P(T(8),U,26)=$P(AG0,U,5)+17000000
 .Q
 KILL AG0,AG21
 ;Railroad
 KILL D
 S I=0
 F  S I=$O(^AUPNRRE(DFN,11,I)) Q:'I  S %=^(I,0),D(9999999-$P(%,U,2),I)=%
 D XI(.D)
 S D=0,AG0=$G(^AUPNRRE(DFN,0)),AG21=$G(^AUPNRRE(DFN,21))
 F  S D=$O(D(D)) Q:'D  S I=0 F  S I=$O(D(D,I)) Q:'I  D  D SET(8)
 . ;S %=^AUPNRRE(DFN,11,I,0)
 . ;BEGIN NEW CODE IHS/SD/TPF AG*7.1*1 IM19329
 . S %=$G(^AUPNRRE(DFN,11,I,0))
 . Q:%=""!($P(%,U)="")
 . ;END NEW CODE
 . S T(8)="RG8"_U_U_"RRE"_U_$S($P(%,U,1):($P(%,U,1)+17000000),1:"")_U_$S($P(%,U,2):($P(%,U,2)+17000000),1:"")_U_$P(%,U,3)
 . Q:'(D(D,I)="ALL")
 . I $P(AG0,U,2) S $P(T(8),U,7)=$P($G(^AUTNINS($P(AG0,U,2),0)),U,1),$P(T(8),U,8)=$P($G(^AUTNINS($P(AG0,U,2),0)),U,7)
 . S $P(T(8),U,9)=$P(AG0,U,4)
 . I $P(AG0,U,3) S $P(T(8),U,10)=$P($G(^AUTTRRP($P(AG0,U,3),0)),U,1)
 . S $P(T(8),U,11,13)=$P($$NAMECVT($P(AGDPT0,U)),U,1,3)
 . I $L($P(AG21,U,1)),'($P(AG21,U,1)="SAME") S $P(T(8),U,19,21)=$P($$NAMECVT($P(AG21,U,1)),U,1,3),$P(T(8),U,29)=$P(AG21,U,1) I 1
 . E  S $P(T(8),U,19,21)=$P(T(8),U,11,13)
 . I $P(AG21,U,2) S $P(T(8),U,14)=$P(AG21,U,2)+17000000
 .Q
 KILL AG0,AG21
 ;Private
 KILL D
 S I=0
 F  S I=$O(^AUPNPRVT(DFN,11,I)) Q:'I  S %=$P(^(I,0),U,6,7),D(9999999-$P(%,U,2),I)=%
 S D=0
 F  S D=$O(D(D)) Q:'D  S I=0 F  S I=$O(D(D,I)) Q:'I  D  D SET(8)
 . S %=^AUPNPRVT(DFN,11,I,0)
 . ;BEGIN NEW CDEO IHS/SD/TPF AG*7.1*1 IM19329
 . S %=$G(^AUPNPRVT(DFN,11,I,0))
 . Q:%=""!($P(%,U)="")!($P(%,U,8)="")
 . ;END NEW CODE
 . S T(8)="RG8"_U_U_"PVT"_U_$S($P(%,U,6):($P(%,U,6)+17000000),1:"")_U_$S($P(%,U,7):($P(%,U,7)+17000000),1:""),S=$P(%,U,8)
 . I S S S=$P($G(^AUPN3PPH(S,0)),U,5) I S S $P(T(8),U,6)=$P($G(^AUTTPIC(S,0)),U,1)
 . S $P(T(8),U,7)=$P($G(^AUTNINS($P(%,U,1),0)),U,1)
 . S $P(T(8),U,8)=$P($G(^AUTNINS($P(%,U,1),0)),U,7)
 . I $P(%,U,8) S $P(T(8),U,9)=$P($G(^AUPN3PPH($P(%,U,8),0)),U,4)
 . I '$L($P(T(8),U,9)) S $P(T(8),U,9)=$P(%,U,2)
 . S $P(T(8),U,11,13)=$P($$NAMECVT($P(AGDPT0,U)),U,1,3)
 . I $P(%,U,8),$P($G(^AUPN3PPH($P(%,U,8),0)),U,2) S $P(T(8),U,11,13)=$P($$NAMECVT($P(^DPT($P(^AUPN3PPH($P(%,U,8),0),U,2),0),U)),U,1,3)
 . S $P(T(8),U,19,21)=$P(T(8),U,11,13)
 . I $P(%,U,8) S $P(T(8),U,19,21)=$P($$NAMECVT($P($G(^AUPN3PPH($P(%,U,8),0)),U,1)),U,1,3)
 . I $P(%,U,9) S $P(T(8),U,17)=$P(%,U,9)+17000000
 . S $P(T(8),U,18)=$P(%,U,12)
 . I $P(%,U,5) S $P(T(8),U,27)=$P($G(^AUTTRLSH($P(%,U,5),0)),U,1)
 .Q
 ;MediCAID
 KILL D
 S S=0
 F  S S=$O(^AUPNMCD("AB",DFN,S)) Q:'S  S N="" D
 . F  S N=$O(^AUPNMCD("AB",DFN,S,N)) Q:'$L(N)  S D=0 D
 .. F  S D=$O(^AUPNMCD("AB",DFN,S,N,D)) Q:'D  S %=D KILL D S D=%,I=0 D
 ... F  S I=$O(^AUPNMCD(D,11,I)) Q:'I  S %=^(I,0),D(9999999-$P(%,U,2),I)=%
 ... D XI(.D)
 ... S O=0
 ... F  S O=$O(D(O)) Q:'O  S I=0 F  S I=$O(D(O,I)) Q:'I  D  D SET(8)
 .... S %=^AUPNMCD(D,11,I,0)
 .... S T(8)="RG8"_U_U_"MCD"_U_$S($P(%,U,1):($P(%,U,1)+17000000),1:"")_U_$S($P(%,U,2):($P(%,U,2)+17000000),1:"")_U_$P(%,U,3)
 .... Q:'(D(O,I)="ALL")
 .... S %=^AUPNMCD(D,0)
 .... I $P(%,U,2) S $P(T(8),U,7)=$P($G(^AUTNINS($P(%,U,2),0)),U,1),$P(T(8),U,8)=$P($G(^AUTNINS($P(%,U,2),0)),U,7)
 .... S $P(T(8),U,9)=$P(%,U,3)
 .... I $P(%,U,9),$P($G(^AUPN3PPH($P(%,U,9),0)),U,2) S $P(T(8),U,11,13)=$P($$NAMECVT($P(^DPT($P(^AUPN3PPH($P(%,U,9),0),U,2),0),U)),U,1,3) I 1
 .... E  S $P(T(8),U,11,13)=$P($$NAMECVT($P(AGDPT0,U)),U,1,3)
 .... I $L($P($G(^AUPNMCD(D,21)),U,1)),'($P(^(21),U,1)="SAME") S $P(T(8),U,19,21)=$P($$NAMECVT($P(^(21),U,1)),U,1,3),$P(T(8),U,29)=$P(^AUPNMCD(D,21),U,1) I 1
 .... E  S $P(T(8),U,19,21)=$P(T(8),U,11,13)
 .... I $P($G(^AUPNMCD(D,21)),U,2) S $P(T(8),U,14)=$P(^(21),U,2)+17000000
 .... S $P(T(8),U,15)=$P(%,U,7)
 .... I $P(%,U,4) S $P(T(8),U,16)=$P($G(^DIC(5,$P(%,U,4),0)),U,3)
 .... I $P(%,U,10) S $P(T(8),U,22)=$P($G(^AUTNINS($P(%,U,10),0)),U,1)
 .... S $P(T(8),U,23)=$P(%,U,13)
 .... S $P(T(8),U,24)=$P(%,U,11)
 .... I $P(%,U,8) S $P(T(8),U,25)=$P(%,U,8)+17000000
 .... I $P(%,U,6) S $P(T(8),U,27)=$P($G(^AUTTRLSH($P(%,U,6),0)),U,1)
 ....Q
 ...Q
 ..Q
 .Q
 Q
XI(D) ;Determine what RG8s should contain all data.
 ;D is passed array D(xd,IEN)=BD^ED^CT, where xd=9999999-ED
 NEW C,E,I
 S (C,E)=0
 F  S E=$O(D(E)) Q:'E  S I=0 F  S I=$O(D(E,I)) Q:'I  D
 . I 'C S D(E,I)="ALL",C=1 Q
 . I E=9999999 S D(E,I)="ALL" Q
 . I $P(D(E,I),U,2)>DT S D(E,I)="ALL"
 .Q
 Q:$G(AGTXALL)
 ;For regular exports, only send the "ALL" RG8s.
 S E="D"
 F  S E=$Q(@E) Q:E=""  I @E'="ALL" KILL @E
 Q
SET(%) ;EP - Write the RG record to ^AGTXDATA(.
 I "5678"[% S $P(T(%),U,$S(%=5:20,%=6:5,%=7:6,%=8:28))=$P(^AUTTLOC(AGTXSITE,0),U,10)
 S T=$S(%=1:21,%=2:35,%=3:9,%=4:10,%=5:20,%=6:5,%=7:6,%=8:29)
 S $P(T(%),U,2)=AGID,$P(T(%),U,T)=$P(T(%),U,T)
 S AGROUT=AGROUT+1,^AGTXDATA(AGROUT)=T(%),AG("TOT")=AG("TOT")+1,AG("TOT",%)=AG("TOT",%)+1
 Q:'$G(AGTXALL)
 S AGIN06=AGIN06+$L(^AGTXDATA(AGROUT))+$L(AGROUT)+11
 Q
NAMECVT(%) ;% is the string containing the name.
 S %=$P(%,",",1)_U_$P($P(%,",",2)," ",1)_U_$P($P(%,",",2)," ",2)_U_$P(%,",",3)
 I $P(%,U,4)]"" S $P(%,U,1)=$P(%,U,1)_" "_$P(%,U,4) ;Suffix
 Q %  ;LN^FN^MN
INTRO ;;
 ;;This option extracts all patient demographics for all patients into
 ;;an export global for sending to NPIRS for the reload.  It is similar
 ;;to the Patient Registration export in format, but differs in kind,
 ;;because no quality checks are performed for missing or inconsistent
 ;;data.  The resulting export global, ^AGTXDATA(, will be sent to:
DW ;;www.ihs.gov
 ;;where the data will be used to re-load NPIRS with PtReg information.
 ;;
 ;;Historical comprehensive extract info (max 5):
 ;;
 ;;Performed              Time (sec)  Patients  Records  File Size (bytes)
 ;;---------------------  ----------  --------  -------  -----------------
 ;;###
HIST ;
 NEW AG,DA
 S AG=0
 F DA=9999999999:0  S DA=$O(^AGTXST(DUZ(2),1,DA),-1)  Q:((DA=0)!(+DA<1))  D  Q:AG=5
 . S AG(1)=DA_","_DUZ(2)_","
 . Q:'$L($$GET1^DIQ(9009063.01,AG(1),23))
 . W !?4,$$GET1^DIQ(9009063.01,AG(1),23),?27,$J($$GET1^DIQ(9009063.01,AG(1),24.1),8),$J($$GET1^DIQ(9009063.01,AG(1),21),12),$J($$GET1^DIQ(9009063.01,AG(1),4),9),$J($$GET1^DIQ(9009063.01,AG(1),22),13)
 . S AG=AG+1
 .Q
 Q
