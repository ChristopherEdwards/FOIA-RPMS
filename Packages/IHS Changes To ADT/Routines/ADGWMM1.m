ADGWMM1 ; IHS/ADC/PDW/ENM - WARD MEDICARE/MEDICAID PRINT ; [ 09/26/2000  8:42 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**5**;MAR 25, 1999
 ;
WONE ;EP; -- one ward, current inpts
 D INIT,HDH,LDFN,Q Q
 ;
WALL ;EP; -- all wards, current inpts
 D INIT,LWRD,Q Q
 ;
DATE ;EP; -- by discharge date
 D INIT,LDT^ADGWMM2,Q Q
 ;
 ;
INIT ; -- initialize variables
 U IO S DGSTOP="",DGPG=0
 Q
 ;
LWRD ; -- loop wards (current inpatients)
 S DGW="" F  S DGW=$O(^DPT("CN",DGW)) Q:DGW=""!(DGSTOP=U)  D NEWPG,LDFN
 Q
 ;
LDFN ; -- loop patients & check for medicaid/care
 F DFN=0:0 S DFN=$O(^DPT("CN",DGW,DFN)) Q:'DFN!(DGSTOP=U)  D
 . S (DGMCDN,DGMCRN,DGINSN)=""
 . I $D(^AUPNMCR("B",DFN)) S IFN=$O(^(DFN,0)) D MCR
 . I $D(^AUPNMCD("B",DFN)) S IFN=$O(^(DFN,0)) D MCD
 . I $D(^AUPNPRVT("B",DFN)) S IFN=$O(^(DFN,0)) D INS
 . I (DGMCDN]"")!(DGMCRN]"")!(DGINSN]"") D PRINT
 Q
 ;
Q ; -- cleanup
 I DGSTOP="",IOST["C-" D PRTOPT^ADGVAR
 D ^%ZISC
 K W,R,I,D,MCRN,MCDN,INSNM,INSN,ED,EED,DFN,IFN,X,Y,DIC,DIC(0),T,LN
 K DGMCDN,DGMCRN,DGINSN,DGW,DGBD,DGED,DGMD,DGMR,DGPI,DGPG,DGSTOP
 K DGPINM,DGPMCA,DGS,DGT,DGINSNM
 Q
 ;
MCR ; -- medicare
 F ED=0:0 S ED=$O(^AUPNMCR(IFN,"11",ED)) Q:'ED  D
 . S EED=$P(^AUPNMCR(IFN,11,ED,0),U,2),DGMCRN="" I EED>DT!('+EED) D
 .. S DGMCRN=$P(^AUPNMCR(IFN,0),U,3)_$P(^AUTTMCS($P(^(0),U,4),0),U)
 Q
 ;
MCD ; -- medicaid
 F ED=0:0 S ED=$O(^AUPNMCD(IFN,"11",ED)) Q:'ED  D
 . S EED=$P(^AUPNMCD(IFN,11,ED,0),U,2),DGMCDN=""
 . I EED>DT!('+EED) S DGMCDN=$P(^AUPNMCD(IFN,0),U,3)
 Q
 ;
INS ; -- private insurance 
 F ED=0:0 S ED=$O(^AUPNPRVT(IFN,"11",ED)) Q:'ED  D
 . S EED=$P(^AUPNPRVT(IFN,11,ED,0),U,7),DGINSN="" I EED>DT!('+EED) D
 .. S DGINSN=$P(^AUPNPRVT(IFN,"11",ED,0),U,2)
 .. S DGINSNM=$P(^AUTNINS($P(^AUPNPRVT(IFN,"11",ED,0),U,1),0),U,1)
 Q
 ;
SWRD ; -- select ward
 S DIC=42,DIC(0)="AEMQ" D ^DIC Q:Y<1  S DGW=$P(Y,U,2)
 D ZIS G:POP!($D(IO("Q"))) Q
 D HDH,LDFN Q
 ;
PRINT ; -- print
 I $Y>(IOSL-6) D NEWPG Q:DGSTOP=U
 W !,$E($P(^DPT(DFN,0),U),1,20)  ;name
 I $D(DUZ(2))&($D(^AUPNPAT(DFN,41,DUZ(2),0))) W ?22,$J($P(^(0),U,2),6)
 W:$D(^DPT(DFN,.101)) ?30,^(.101)  ;room-bed
 W:$D(^DPT(DFN,.103)) ?39,$P(^DIC(45.7,^(.103),0),U,3)  ;t.s.
 W:$D(^DPT(DFN,.104)) ?47,$E($P(^VA(200,^(.104),0),U),1,15)  ;provider
 S AD=^DPT("CN",DGW,DFN)  ;admission IFN
 S Y=+^DGPM(AD,0) X ^DD("DD") W ?67,$P(Y,"@")  ;admission date/time
 W !?2,"Admit Dx: ",$P(^DGPM(AD,0),U,10)  ;admitting Dx
 ;IHS/ASDST/POC/ENM 09/26/00 NEXT 3 LINES COPIED/MOD
 ;I DGMCDN W ?40,"MCAID #: ",DGMCDN
 I DGMCDN]"" W ?40,"MCAID #: ",DGMCDN
 ;I DGMCRN W ?60,"MCARE #: ",DGMCRN
 I DGMCRN]"" W ?60,"MCARE #: ",DGMCRN
 ;I DGINSN W !?2,"Insurer: ",DGINSNM,"  #",DGINSN
 I DGINSN]"" W !?2,"Insurer: ",DGINSNM,"  #",DGINSN
 W ! Q
 ;
HDH ; -- heading
 I DGPG>0!(IOST["C-") W @IOF
 D CONF^ADGUTIL(12)
 W !?20,"MEDICARE/MEDICAID/INSURANCE LIST"
 S DGPG=DGPG+1
 S Y=DT X ^DD("DD") W ?69,Y
 W !?20,"CURRENT INPATIENTS ON WARD: ",DGW
 W !?2,"Patient Name",?23,"HRCN",?30,"Room",?39,"Srv"
 W ?47,"Provider",?67,"Admit Date"
 S LN="",$P(LN,"-",IOM)="" W !,LN Q
 ;
NEWPG ; -- end of page control
 I IOST["C-",DGPG>0 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X Q:X=U
 D HDH Q
 ;
ZIS ; -- select device    
 S %ZIS="PQ" D ^%ZIS G:POP Q I $D(IO("Q")) D TM
 Q
 ;
TM ; -- queued outputs
 S ZTRTN=$S(T:"QONE^ADGWMM",1:"QALL^ADGWMM")
 S ZTIO=ION,ZTDESC="WARD MEDICAID/MEDICARE REPORT"
 S:T ZTSAVE("W")="" D ^%ZTLOAD
 D HOME^%ZIS G Q
 ;
QONE ; -- entry point queued one ward
 D HDH,LDFN,Q Q
 ;
QALL ; -- entry point queued all wards
 D LWRD,Q Q
