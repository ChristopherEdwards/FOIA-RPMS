ASUJVALD ; IHS/ITSC/LMH -VALIDATE ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;This routine is called to validate fields
 S ASUV("DDSREFT")=DDSREFT D:$G(ASUSB) CKFLD^ASUJBTCH
 Q
EN(X,E,F,T) ;EP;Validate
 ;X-Entry to validate
 ;E-Error flag
 ;F-Field or line tage name 
 ;T-Type     (If Null, no test)
 I X']"" D CL Q
 K E
 I T="F" D TBF  ;Finance
 I T="R" D TBR  ;Requesitioner 
 I T="N" D NUM  ;Numeric
 I T="$" D DOL  ;Dollar value
 I T="A" D ALP  ;Alpha 
 I T="AN" D AN  ;Alpha/Numeric 
 I $G(E)=1 D
 .D HP  ;Help msg
 E  D
 .D SV  ;Save
 ;I F="BCD" B
 Q
DT(X,E,F) ;EP;date
 ;X-Entry to validate     E-Error flag    F-Field or line tag name
 I X="" D
 .D CL
 E  D
 .I F'="DTR" S %DT="F"
 .S %DT="T"_$G(%DT)
 .D ^%DT
 .I Y<0 D
 ..S E=-1
 ..D HP
 .E  D
 ..D SV
 Q
CL ;
 N Z S Z="D "_F_"^ASUJCLER" X Z Q
SV ;Save
 N Z S Z="D "_F_"^ASUJSAVE(.X)" X Z Q
HP ;Help
 N Z S Z="D "_F_"^ASUJHELP" S:F="VAL" Z=Z_$S($G(ASUT("TRCD"))?1N.1A:"(1)",1:"(0)") X Z Q
TBF ;Finance
 I F="CAN" D CAN^ASUJVALF(.X) Q
 I F="CAT" D CAT^ASUJVALF(.X) Q
 I F="SRC",((ASUT("TRCD")="06")!(ASUT("TRCD")="26")) S X="L"
 N Z S Z="D "_F_"^ASULDIRF(.X)" X Z S:$G(Y)<0 E=1
 Q:$G(ASUT("TYPE"))=0  Q:$G(ASUT("TYPE"))=2  Q:$G(ASUT("TYPE"))>6
 I F="SRC" D
 .I X=1 D  Q
 ..D:$G(ASUSB)'=1 UNED^DDSUTL("VEN","","",1)
 ..N Z S Z="PERRY POINT" D VENLKU^ASUJVALF(.Z),VEN^ASUJSAVE(.Z)
 .I X=4 D  Q
 ..D:$G(ASUSB)'=1 UNED^DDSUTL("VEN","","",1)  ;UNEDITABLE 1or0
 ..N Z S Z="VA SUPPLY DEPOT" D VENLKU^ASUJVALF(.Z),VEN^ASUJSAVE(.Z)
 .D:$G(ASUSB)'=1 UNED^DDSUTL("VEN","","",0)  ;EDITABLE
 .D VEN^ASUJCLER
 Q
TBR ;Requsitioner
 N Z S Z="D "_F_"^ASULDIRR(.X)" X Z S:$G(Y)<0 E=1
 Q:$G(E)]""  ;WAR 3/2/99 DOESN'T MATTER->Q:$G(E)]""
 I F="USR",$G(ASUL(18,"SST","E#"))]"" D REQ^ASULDIRR(.X) S:$G(Y)<0 E=1
 Q:$G(E)]""  ;WAR 3/2/99 DOESN'T MATTER->Q:$G(E)]""
 I F="SST",$G(ASUL(19,"USR","E#"))]"" D
 .S Z=ASUL(19,"USR") D REQ^ASULDIRR(.Z) S:$G(Y)<0 E=1
 ;B
 Q
NUM ;EP     Numeric
 I F="LTM" D
 .I X#.5'=0!(X=0) S E=1
 E  D
 .I X'?1N.N S E=1
 Q
 I X[".",X=+X Q
 I X'?1N.N S E=1
 Q
DOL ;EP     Dollar
 S:X'["." X=X_".00" S:$P(X,".",2)']"" $P(X,".",2)="00" S:$L($P(X,".",2))=1 $P(X,".",2)=$P(X,".",2)_"0"
 I $P(X,".",2)'?2N S E=1 Q
 I $P(X,".")]"",$P(X,".")'?1N.N S E=2  Q
 I X>999999.99 S E=3
 Q
ALP ;Alpha/Char
 I X'?1A.ANP S E=1
 Q
AN ;Alpha/Num
 I X'?1AN.AN S E=1
 Q
