APCLSILU ; IHS/CMI/LAB - utilities for ili/h1n1 ; 13 Aug 2014  3:00 PM
 ;;3.0;IHS PCC REPORTS;**24,26,27,29,30**;FEB 05, 1997;Build 27
 ;----------
ICD(VAL,TAXIEN,TYP) ;EP -- check to see if value is in taxonomy in ^TMP("BDMTMP",$J,Taxonomy Name
 ;add 3rd param with pass type
 ;WILL ALWAYS BE ATXAX, NOT LAB
 NEW TAXNM
 S TAXNM=$P($G(^ATXAX(TAXIEN,0)),U,1)
 I TAXNM="" Q $$ICD^ATXCHK(VAL,TAXIEN,TYP)
 I '$D(^XTMP("APCLILITAX",$J,TAXNM)) Q $$ICD^ATXCHK(VAL,$O(^ATXAX("B",TAXNM,0)),TYP)
 I $D(^XTMP("APCLILITAX",$J,TAXNM,VAL)) Q 1
 Q 0
 ;
ICDDX(C,D,I) ;PEP - CHECK FOR ICD10
 I $T(ICDDX^ICDEX)]"" Q $$ICDDX^ICDEX(C,$G(D),,$G(I))
 Q $$ICDDX^ICDCODE(C,$G(D))
 ;
ICDOP(C,D,I) ;PEP - CHECK FOR ICD10
 I $G(I)="" S I="I"
 I $T(ICDOP^ICDEX)]"" Q $$ICDOP^ICDEX(C,$G(D),,I)
 Q $$ICDOP^ICDCODE(C,$G(D))
 ;
VSTD(C,D) ;EP - CHECK FOR ICD10
 I $T(VSTD^ICDEX)]"" Q $$VSTD^ICDEX(C,$G(D))
 Q $$VSTD^ICDCODE(C,$G(D))
 ;
VSTP(C,D) ;EP - CHECK FOR ICD10
 I $T(VSTP^ICDEX)]"" Q $$VSTP^ICDEX(C,$G(D))
 Q $$VSTP^ICDCODE(C,$G(D))
 ;
ICDD(C,A,D) ;EP - CHECK FOR ICD10
 I $T(ICDD^ICDEX)]"" Q $$ICDD^ICDEX(C,A,$G(D))
 Q $$ICDD^ICDCODE(C,A,$G(D))
DOB(DFN) ;EP
 ;---> Return Patient's Date of APCLrth in Fileman format.
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q:'$P($G(^DPT(DFN,0)),U,3) "NOT ENTERED"
 Q $P(^DPT(DFN,0),U,3)
 ;
 ;
 ;
 ;----------
AGE(DFN,APCLZ,APCLDT) ;EP
 ;---> Return Patient's Age.
 ;---> Parameters:
 ;     1 - DFN  (req) IEN in PATIENT File.
 ;     2 - APCLZ  (opt) APCLZ=1,2,3  1=years, 2=months, 3=days.
 ;                               2 will be assumed if not passed.
 ;     3 - APCLDT (opt) Date on which Age should be calculated.
 ;
 N APCLDOB,X,X1,X2,D,E  S:$G(APCLZ)="" APCLZ=2
 Q:'$G(DFN) ""
 S APCLDOB=$$DOB(DFN)
 Q:'APCLDOB ""
 S:'$G(DT) DT=$$DT^XLFDT
 S:'$G(APCLDT) APCLDT=DT
 Q:APCLDT<APCLDOB ""
 ;
 ;---> Age in Years.
 N APCLAGEY,APCLAGEM,APCLD1,APCLD2,APCLM1,APCLM2,APCLY1,APCLY2
 S APCLM1=$E(APCLDOB,4,7),APCLM2=$E(APCLDT,4,7)
 S APCLY1=$E(APCLDOB,1,3),APCLY2=$E(APCLDT,1,3)
 S APCLAGEY=APCLY2-APCLY1 S:APCLM2<APCLM1 APCLAGEY=APCLAGEY-1
 S:APCLAGEY<1 APCLAGEY="<1"
 Q:APCLZ=1 APCLAGEY
 ;
 ;---> Age in Months.
 S APCLD1=$E(APCLM1,3,4),APCLM1=$E(APCLM1,1,2)
 S APCLD2=$E(APCLM2,3,4),APCLM2=$E(APCLM2,1,2)
 S APCLAGEM=12*APCLAGEY
 I APCLM2=APCLM1&(APCLD2<APCLD1) S APCLAGEM=APCLAGEM+12
 I APCLM2>APCLM1 S APCLAGEM=APCLAGEM+APCLM2-APCLM1
 I APCLM2<APCLM1 S APCLAGEM=APCLAGEM+APCLM2+(12-APCLM1)
 S:APCLD2<APCLD1 APCLAGEM=APCLAGEM-1
 Q:APCLZ=2 APCLAGEM
 ;
 ;---> Age in Days.
 S X1=APCLDT,X2=APCLDOB
 D ^%DTC
 Q X
 ;
 ;
 ;----------
AGEF(DFN,APCLDT) ;EP
 ;---> Age formatted "35 Months" or "23 Years"
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - APCLDT (opt) Date on which Age should be calculated.
 ;
 N Y
 S Y=$$AGE(DFN,2,$G(APCLDT))
 Q:Y["DECEASED" Y
 Q:Y["NOT BORN" Y
 ;
 ;---> If over 60 months, return years.
 I Y>60 S Y=$$AGE(DFN,1,$G(APCLDT)) Q Y_$S(Y=1:"year",1:" yrs")
 ;
 ;---> If under 1 month return days.
 I Y<1 S Y=$$AGE(DFN,3,$G(APCLDT)) Q Y_$S(Y=1:" day",1:" days")
 ;
 ;---> Return months
 Q Y_$S(Y=1:" mth",1:" mths")
 ;
 ;
 ;----------
DECEASED(DFN,APCLDT) ;EP
 ;---> Return 1 if patient is deceased, 0 if not deceased.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - APCLDT (opt) If APCLDT=1 return Date of Death (Fileman format).
 ;
 Q:'$G(DFN) 0
 N X S X=+$G(^DPT(DFN,.35))
 Q:'X 0
 Q:'$G(APCLDT) 1
 Q X
 ;
 ;
UNFOLDTX ;EP -- unfold all taxes for ili export into ^TMP("APCLILITAX",$J,Taxonomy Name
 ;lets go through all the taxonomies needed here and put them in above location
 K ^XTMP("APCLILITAX",$J)
 I '$D(^ICDS(0)) Q  ;icd10 isn't there so don't bother
 NEW APCLDA,APCLTAX,APCLFL,APCLTAXI,APCLVAL,APCLTYP,APCLTGT
 S APCLDA=0 F  S APCLDA=$O(^APCLILIT(APCLDA)) Q:'APCLDA  D
 . S APCLTAX=$P($G(^APCLILIT(APCLDA,0)),U)
 . S APCLFL=$P($G(^APCLILIT(APCLDA,0)),U,2)
 . S APCLTYP=$S(APCLFL=60:"L",1:"")
 . S APCLTAXI=$O(^ATXAX("B",APCLTAX,0))
 . I APCLTYP="L" D
 .. S APCLTAXI=$O(^ATXLAB("B",APCLTAX,0))
 . S APCLTGT="^XTMP("_"""APCLILITAX"""_","_$J_","_""""_APCLTAX_""""_")"
 . D BLDTAX^ATXAPI(APCLTAX,APCLTGT,APCLTAXI,APCLTYP)
 Q
COMM ;EP
 K ^APCLDATA($J)
 NEW APCLX,APCLC,APCLCNT,APCLASUF,XBGL,XBFN,XBF,XBE,XBFLT,XBMED,XBCON,XBS1,XBQ,APCLDBID,C,APCLI
 ;export community taxonomy
 S APCLDBID=$P(^AUTTSITE(1,0),U,1)
 S APCLDBID=$$VAL^XBDIQ1(9999999.06,APCLDBID,.32)
 S APCLX=0,APCLCNT=0 F  S APCLX=$O(^BGPSITE(APCLX)) Q:APCLX'=+APCLX  D
 .S APCLC=$P($G(^BGPSITE(APCLX,0)),U,5)
 .Q:APCLC=""
 .S APCLASUF=$P($G(^AUTTLOC(APCLX,0)),U,10)
 .Q:APCLASUF=""
 .;K ^TMP($J,"COMM")
 .S APCLI=0 F  S APCLI=$O(^ATXAX(APCLC,21,APCLI)) Q:APCLI'=+APCLI  D
 ..S C=$P($G(^ATXAX(APCLC,21,APCLI,0)),U,1)
 ..S C=$O(^AUTTCOM("B",C,0))
 ..I 'C Q
 ..S APCLCNT=APCLCNT+1
 ..S ^APCLDATA($J,APCLCNT)=APCLDBID_U_APCLASUF_U_$P(^AUTTCOM(C,0),U,8)_U_$P(^AUTTCOM(C,0),U,1)
 .NEW TST
 .S TST=0
 .;I '$$PROD^XUPROD() S TST=1
 .I $P($G(^APCLILIC(1,0)),U,5)="T" S TST=1
 .S XBFN="COMM"_$S(TST:"Z",1:"F")_"_"_APCLASUF_"_"_$$DATE^APCLSILI(APCLZHSD)_".txt"
 .S XBGL="APCLDATA",XBMED="F",XBQ="N",XBFLT=1,XBF=$J,XBE=$J
 .S XBCON=1
 .S XBS1="SURVEILLANCE ILI SEND"
 .S XBQ="N"
 .D ^XBGSAVE
 .K ^APCLDATA($J)
 Q
INSTALLD(APCLSTAL) ;EP - Determine if patch APCLSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW APCLY,DIC,X,Y
 S X=$P(APCLSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(APCLSTAL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(APCLSTAL,"*",3)
 D ^DIC
 S APCLY=Y
 Q $S(APCLY<1:0,1:1)
LASTPRCT(P,BD,ED,T,F) ;EP
 I '$G(P) Q ""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(F)="" S F="D"
 S T=$G(T)
 NEW A,B,C,D,E,TIEN,R,I
 S TIEN="" I T]"" S TIEN=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I TIEN="" Q ""
 S R=""  ;return value
 S B=9999999-BD,E=9999999-ED  ;get inverse date and begin at edate-1 and end when greater than begin date
 S D=E-1 F  S D=$O(^AUPNVPRC("AA",P,D)) Q:D=""!(D>B)!(R]"")  D
 .S I=0 F  S I=$O(^AUPNVPRC("AA",P,D,I)) Q:I'=+I!(R]"")  D
 ..S C=$P($G(^AUPNVPRC(I,0)),U)
 ..Q:C=""  ;bad xref
 ..Q:'$D(^ICD0(C))
 ..I TIEN Q:'$$ICD^ATXAPI(C,TIEN,0)
 ..S R=(9999999-D)_"^PROC: "_$P($$ICDOP(C,(9999999-D),"I"),U,2)_"^"_$$VAL^XBDIQ1(9000010.08,I,.04)_"^"_$P(^AUPNVPRC(I,0),U,3)_"^9000010.08^"_I
 ..Q
 .Q
 I R="" Q ""
 I F="D" Q $P(R,U)
 Q R
