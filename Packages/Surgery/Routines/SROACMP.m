SROACMP ;BIR/ADM-M&M Verification Report ; [ 07/27/98   2:33 PM ]
 ;;3.0; Surgery ;**47,50**;24 Jun 93
 S DFN=0 F  S DFN=$O(^TMP("SR",$J,DFN)) Q:'DFN  S SRTN=0 F  S SRTN=$O(^TMP("SR",$J,DFN,SRTN)) Q:'SRTN  D UTIL
 I SRFORM=1,SRSP D SS
 D HDR^SROACMP1 I $D(^TMP("SR",$J)) S SRPAT="" F  S SRPAT=$O(^TMP("SRPAT",$J,SRPAT)) Q:SRPAT=""  D  Q:SRSOUT  S SRNM=0 I $Y+7<IOSL W !! F LINE=1:1:132 W "-"
 .S SRX=^(SRPAT),SRNAME=">>> "_SRPAT_" ("_$P(SRX,"^",2)_")",SRDEATH=$P(SRX,"^",3)
 .I SRDEATH S SRNAME=SRNAME_" - DIED "_$E(SRDEATH,4,5)_"/"_$E(SRDEATH,6,7)_"/"_$E(SRDEATH,2,3) S X=$E(SRDEATH,9,12) I X S X=X_"000",SRNAME=SRNAME_"@"_$E(X,1,2)_":"_$E(X,3,4)
 .I $Y+9>IOSL D HDR^SROACMP1 I SRSOUT Q
 .W !,SRNAME S SRNM=1,DFN=$P(SRX,"^"),SRTN=0 F  S SRTN=$O(^TMP("SR",$J,DFN,SRTN)) Q:'SRTN!SRSOUT  D SET
 G:SRSOUT END^SROACMP1 I '$D(^TMP("SR",$J)) W !!,"There are no perioperative occurrences or deaths recorded for ",$S(SRFORM=1:"surgeries performed in the selected date range.",1:"completed assessments not yet transmitted.")
 D HDR2^SROACMP1,END^SROACMP1
 Q
UTIL ; list all cases within 90 days prior to postop occurrence and/or death
 S SRPOST=0 F  S SRPOST=$O(^SRF(SRTN,16,SRPOST)) Q:'SRPOST  S SRDATE=$E($P(^SRF(SRTN,16,SRPOST,0),"^",7),1,7) I SRDATE S SRBACK=-30 D PRIOR
 D DEM^VADPT S ^TMP("SRPAT",$J,VADM(1))=DFN_"^"_VA("PID")_"^"_$P(VADM(6),"^")
 S SRDATE=$P(VADM(6),"^") I SRDATE S SRBACK=-90 D PRIOR
 Q
PRIOR ; list cases in 30 days before this occurrence or 90 days before death
 S X1=SRDATE,X2=SRBACK D C^%DTC S SDATE=X,SRCASE=0 F  S SRCASE=$O(^SRF("B",DFN,SRCASE)) Q:'SRCASE  I '$D(^TMP("SR",$J,DFN,SRCASE)) D
 .I $D(^XUSEC("SROCHIEF",+DUZ)) Q:'$$MANDIV^SROUTL0(SRINSTP,SRTN)
 .I '$D(^XUSEC("SROCHIEF",+DUZ)) Q:'$$DIV^SROUTL0(SRTN)
 .I '$P($G(^SRF(SRCASE,.2)),"^",12)!$P($G(^SRF(SRCASE,30)),"^")!($P($G(^SRF(SRCASE,"NON")),"^")="Y") Q
 .S SRX=$E($P(^SRF(SRCASE,0),"^",9),1,7) I SRX<SDATE!(SRX>SRDATE) Q
 .S ^TMP("SR",$J,DFN,SRCASE)=$P(^SRF(SRCASE,0),"^",4)
 Q
SET ; set variables to print
 S SR(0)=^SRF(SRTN,0),(SRD,Y)=$P(SR(0),"^",9),SRSDATE=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3),Y=$P(SR(0),"^",4) I Y S SRSS=$E($P($P(^SRO(137.45,Y,0),"^")," "),1,13),SRSS=$P(SRSS," "),SRSS=$P(SRSS,"(")
OPS S SROPER=$P(^SRF(SRTN,"OP"),"^"),OPER=0 F  S OPER=$O(^SRF(SRTN,13,OPER)) Q:OPER=""  D OTHER
 K SRP,Z S:$L(SROPER)<40 SRP(1)=SROPER I $L(SROPER)>39 S SROPER=SROPER_"  " F M=1:1 D OPER Q:Z=""
 S SRCHK=0 I SRDEATH S X1=SRDEATH,X2=-90 D C^%DTC I SRD<X S SRCHK=1,SRREL="N/A"
 I 'SRCHK S X=$P($G(^SRF(SRTN,.4)),"^",7),SRREL=$S(SRDEATH="":"N/A",X="U":"NO",X="R":"YES",1:" ?")
COMP ; perioperative occurrences
 K SRC S (SRFG,SRIC)=0 F  S SRIC=$O(^SRF(SRTN,10,SRIC)) Q:SRIC=""  S SRFG=SRFG+1,SRO=^SRF(SRTN,10,SRIC,0),SRICD=$P(SRO,"^",3) D
 .S Y=SRD D DATE S SRCAT=$P(SRO,"^",2) Q:'SRCAT  S SRC(SRFG)=$P(^SRO(136.5,SRCAT,0),"^")_" "_SRY
 .I SRICD S SRFG=SRFG+1,SRC(SRFG)="  ICD: "_$P(^ICD9(SRICD,0),"^")_"  "_$P(^ICD9(SRICD,0),"^",3)
 S SRPC=0 F  S SRPC=$O(^SRF(SRTN,16,SRPC)) Q:SRPC=""  S SRFG=SRFG+1,SRO=^SRF(SRTN,16,SRPC,0),SRICD=$P(SRO,"^",3) D
 .S Y=$E($P(SRO,"^",7),1,7) D DATE S SRCAT=$P(SRO,"^",2) Q:'SRCAT  S SRC(SRFG)=$P(^SRO(136.5,SRCAT,0),"^")_" * "_SRY
 .I SRICD S SRFG=SRFG+1,SRC(SRFG)="  ICD: "_$P(^ICD9(SRICD,0),"^")_"  "_$P(^ICD9(SRICD,0),"^",3)
RA ; risk assessment type and status
 S SRA=$G(^SRF(SRTN,"RA")),SRSTATUS=$P(SRA,"^"),SRTYPE=$P(SRA,"^",2),SRYN=$P(SRA,"^",6),SRE=$P(SRA,"^",7) D
 .I SRTYPE="" S SRA="NON-ASSESSED" Q
 .S SRA=$S(SRTYPE="C":"CARDIAC",SRYN="Y":"NON-CARD",1:"EXCLUDED")_"/"_SRSTATUS
PRINT ; print case information
 I $Y+8>IOSL D HDR^SROACMP1 I SRSOUT Q
 W !!,SRSDATE,?11,SRSS,?25,SRP(1),?69,SRREL W:$D(SRC(1)) ?75,SRC(1) W ?120,SRA
 F SRC=2:1 Q:'$D(SRP(SRC))&'$D(SRC(SRC))  D  Q:SRSOUT
 .I $Y+6>IOSL D HDR^SROACMP1 I SRSOUT Q
 .W ! W:$D(SRP(SRC)) ?25,SRP(SRC) W:$D(SRC(SRC)) ?75,SRC(SRC)
 Q
OTHER ; other operations
 S SRLONG=1 I $L(SROPER)+$L($P(^SRF(SRTN,13,OPER,0),"^"))>250 S SRLONG=0,OPER=999,SROPERS=" ..."
 I SRLONG S SROPERS=$P(^SRF(SRTN,13,OPER,0),"^")
 S SROPER=SROPER_$S(SROPERS=" ...":SROPERS,1:", "_SROPERS)
 Q
OPER ; break procedure if greater than 40 characters
 S SRP(M)="" F LOOP=1:1 S Z=$P(SROPER," ") Q:Z=""  Q:$L(SRP(M))+$L(Z)'<40  S SRP(M)=SRP(M)_Z_" ",SROPER=$P(SROPER," ",2,200)
 Q
DATE S SRY=$S(Y:" ("_$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)_")",1:" (NO DATE)")
 Q
SS ; set up ^TMP for selected specialties
 K ^TMP("SRSP",$J) S SRQ=0,SRNAME="" F  S SRNAME=$O(^TMP("SRPAT",$J,SRNAME)) Q:SRNAME=""  S DFN=$P(^TMP("SRPAT",$J,SRNAME),"^"),(SRQ,SRTN)=0 D
 .F  S SRTN=$O(^TMP("SR",$J,DFN,SRTN)) Q:'SRTN  D  Q:SRQ
 ..S Y=$P(^SRF(SRTN,0),"^",4) S:'Y Y="ZZ" I $D(SRSP(Y)) S ^TMP("SRSP",$J,DFN)="",SRQ=1 Q
 S SRNAME="" F  S SRNAME=$O(^TMP("SRPAT",$J,SRNAME)) Q:SRNAME=""  S DFN=$P(^TMP("SRPAT",$J,SRNAME),"^") I '$D(^TMP("SRSP",$J,DFN)) K ^TMP("SR",$J,DFN),^TMP("SRPAT",$J,SRNAME)
 Q
