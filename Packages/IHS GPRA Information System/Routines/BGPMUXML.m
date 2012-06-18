BGPMUXML ; IHS/MSC/MGH - MU XML output ;02-Mar-2011 14:07;DU
 ;;11.0;IHS CLINICAL REPORTING;**4**;JAN 06, 2011;Build 84
 ;
 ;
PRINT1 ;EP
 ;if in NGR or GPU now print mu dev measures and divider page
 N BGPGDEV,BGPDEVOR,BGPIC,BGPNOW,BGPXMLB,BGPXMLE,BGPXML,BGPREPD
 S (BGPXMLB,BGPXMLE)=""
 S BGPNOW=$$NOW^XLFDT
 D XMLBEG
 S BGPGDEV=1
 S BGPDEVOR=0 F  S BGPDEVOR=$O(^BGPMUIND(BGPMUYF,"ADO",BGPDEVOR)) Q:BGPDEVOR'=+BGPDEVOR!(BGPQUIT)  D
 .S BGPIC=$O(^BGPMUIND(BGPMUYF,"ADO",BGPDEVOR,0)) Q:BGPIC=""
 .I $D(BGPIND(BGPIC)),$D(^BGPMUIND(BGPMUYF,BGPIC,5)) D
 ..K BGPXML
 ..X ^BGPMUIND(BGPMUYF,BGPIC,5)
 ..D XMLOUT
 K BGPGDEV
 D XMLEND
 K BGPXML
 Q
 ;
SAVEXML ;EP
 ;If screen selected do screen
 I BGPDELT="S" D SCREEN,EXIT Q
 ;call xbgsave to create output file
 S XBGL="BGPDATA"
 L +^BGPDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 K ^TMP($J,"SUMMARYXML")
 K ^BGPDATA($J) ;global for saving
 S X=0 F  S X=$O(^TMP($J,"BGPXML",X)) Q:X'=+X  I ^TMP($J,"BGPXML",X)'="ENDCOVERPAGE" S ^BGPDATA($J,X)=^TMP($J,"BGPXML",X)
 I '$D(BGPGUI) D
 .S XBFLT=1,XBFN=BGPDELF,XBMED="F",XBTLE="MEANINGFUL USE 2011 XML OUTPUT",XBQ="N",XBF=0
 .D ^XBGSAVE
 .K XBFLT,XBFN,XBMED,XBTLE,XBE,XBF,X
 I $D(BGPGUI) D
 .S (C,X)=0 F  S X=$O(^BGPDATA($J,X)) Q:X'=+X  S C=C+1,^BGPGUIT(BGPGIEN,12,C,0)=^BGPDATA($J,X)
 .S ^BGPGUIT(BGPGIEN,12,0)="^90378.0812^"_C_"^"_C_"^"_DT
 L -^BGPDATA($J)
 K ^BGPDATA($J) ;export global
 D EXIT
 Q
XMLBEG ;Create the beginning (fixed) portion for each XML file that will be generated
 S Y="<?xml version=""1.0"" encoding=""UTF-8"" ?>" D S(Y,1,1)
 S Y="<submission type=""PQRI-REGISTRY"" option=""TEST"" version=""2.0"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:noNamespaceSchemaLocation=""Registry_Payment.xsd"">" D S(Y,1,1)
 S Y="<file-audit-data>" D S(Y,1,1)
 S Y="<create-date>"_$$DATE(BGPNOW)_"</create-date>" D S(Y,1,1)
 S Y="<create-time>"_$P($$FMTE^XLFDT(BGPNOW),"@",2)_"</create-time>" D S(Y,1,1)
 S Y="<create-by>"_$$USR^BGPMUEP()_"</create-by>" D S(Y,1,1)
 S Y="<version>1.0</version>" D S(Y,1,1)
 S Y="<file-number>"_1_"</file-number>" D S(Y,1,1)
 S Y="<number-of-files>"_1_"</number-of-files>" D S(Y,1,1)
 S Y="</file-audit-data>" D S(Y,1,1)
 S Y="<registry>" D S(Y,1,1)
 S Y="<registry-name>"_"Sample Registry Name"_"</registry-name>" D S(Y,1,1)
 S Y="<registry-id>"_"123456789"_"</registry-id>" D S(Y,1,1)
 S Y="<submission-method>"_$S(BGPLEN=364:"A",1:"B")_"</submission-method>" D S(Y,1,1)
 S Y="</registry>" D S(Y,1,1)
 S Y="<measure-group ID=""X"">" D S(Y,1,1)
 S Y="<provider>" D S(Y,1,1)
 S Y="<npi>"_$S($G(BGPPROV)'="":$$NPI^BGPMUUT2(BGPPROV),1:"HOSPITAL")_"</npi>" D S(Y,1,1)
 S Y="<tin>"_$S($G(BGPPROV)'="":$$TIN^BGPMUUT2(BGPPROV),1:"HOSPITAL")_"</tin>" D S(Y,1,1)
 S Y="<waiver-signed>Y</waiver-signed>" D S(Y,1,1)
 S Y="<encounter-from-date>"_$$DATE(BGPBD)_"</encounter-from-date>" D S(Y,1,1)
 S Y="<encounter-to-date>"_$$DATE(BGPED)_"</encounter-to-date>" D S(Y,1,1)
 Q
XMLEND ;Create the ending (fixed) portion for each XML file that will be generated
 S Y="</provider>" D S(Y,1,1)
 S Y="</measure-group>" D S(Y,1,1)
 S Y="</submission>"  D S(Y,1,1)
 Q
XMLOUT ;add a <pqri-measure> block for each calculation in the BGPXML array
 N OUTCNT
 S OUTCNT=""
 F  S OUTCNT=$O(BGPXML(OUTCNT)) Q:OUTCNT'=+OUTCNT  D
 .S BGPREPD=BGPXML(OUTCNT)
 .S Y="<pqri-measure>" D S(Y,1,1)
 .S Y="<pqri-measure-number>"_$P(BGPREPD,U)_"</pqri-measure-number>" D S(Y,1,1)
 .;S Y="<collection-method>A</collection-method>"  ;PQRI 2010 addition
 .S Y="<eligible-instances>"_$P(BGPREPD,U,3)_"</eligible-instances>" D S(Y,1,1)
 .S Y="<meets-performance-instances>"_$P(BGPREPD,U,4)_"</meets-performance-instances>" D S(Y,1,1)
 .S Y="<performance-exclusion-instances>"_$P(BGPREPD,U,5)_"</performance-exclusion-instances>" D S(Y,1,1)
 .S Y="<performance-not-met-instances>"_($P(BGPREPD,U,3)-$P(BGPREPD,U,4)-$P(BGPREPD,U,5))_"</performance-not-met-instances>" D S(Y,1,1)
 .S Y="<reporting-rate>100</reporting-rate>" D S(Y,1,1)
 .S Y="<performance-rate>"_$S(($P(BGPREPD,U,3)-$P(BGPREPD,U,5))<1:"0",1:$$ROUND^BGPMUA01(($P(BGPREPD,U,4)/($P(BGPREPD,U,3)-$P(BGPREPD,U,5))),2))_"</performance-rate>" D S(Y,1,1)
 .S Y="</pqri-measure>" D S(Y,1,1)
 Q
SCREEN ;
 S X=0 F  S X=$O(^TMP($J,"BGPXML",X)) Q:X'=+X  W:^TMP($J,"BGPXML",X)'="ENDCOVERPAGE" !,^TMP($J,"BGPXML",X)
 Q
PRINT3 ;
 Q
EXIT ;
 K ^TMP($J)
 Q
CTR(X,Y) ;EP - Center
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return user
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
S(Y,F,P) ;EP set up array
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPXML",0),U)+F,$P(^TMP($J,"BGPXML",0),U)=%
 I '$D(^TMP($J,"BGPXML",%)) S ^TMP($J,"BGPXML",%)=""
 S $P(^TMP($J,"BGPXML",%),U,P)=Y
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"-"_$E(D,6,7)_"-"_$E(D,2,3)
 ; 
