ASDAIU ; IHS/ADC/PDW/ENM - ADDRESS & INSURANCE UPDATE ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
 D SP Q:'$D(DFN)
 D DEV I POP!($D(IO("Q"))) D END Q
 D SET,END Q
 ;
SP ; -- select patient
 N DIC,Y,X S DIC="^DPT(",DIC(0)="AEQMZ"
 D ^DIC K DIC Q:Y'>0  S DFN=+Y Q
 ;
DEV ; select device
 K IOP,POP S %ZIS="PQ" D ^%ZIS Q:POP  D QUE:$D(IO("Q")) Q
 ;
QUE ; -- queued output
 S ZTRTN="SET^ASDAIU",ZTDESC="ADDRESS/INSURANCE FORM",ZTSAVE("DFN")=""
 D ^%ZTLOAD Q
 ;
SET ;EP; called by ZTLOAD and by RS/HS prints
 NEW SDDPTN0,SSN,SDELIG,SDDPTN13,NAME,HRCN,DOB,ADDR,SITE,Y
 S SDDPTN0=^DPT(DFN,0),SSN=$P(SDDPTN0,U,9),NAME=$P(SDDPTN0,U)
 S PNODE=^AUPNPAT(DFN,0)
 D EMPY,SEMPY
 S FMBIRTH=$G(^AUPNPAT(DFN,26)) D PARENT
 S PBIRTH=$P(SDDPTN0,U,11)
 S SDELIG=$S($P($G(^AUPNPAT(DFN,11)),U,12)]"":$P($G(^(11)),U,12),1:"")
 S SDDPTN13=$G(^DPT(DFN,.13)),SITE=$P(^DIC(4,DUZ(2),0),U)
 S ADDR=$G(^DPT(DFN,.11)),HRCN=$$HRCN^ASDUT
 S EPHONE=$P($G(^DPT(DFN,.311)),U,9)
 S SPHONE=$P($G(^DPT(DFN,.25)),U,8)
 S MNAME=$P($G(^DPT(DFN,.24)),U,3),FNAME=$P($G(^DPT(DFN,.24)),U)
 S NKNODE=$G(^DPT(DFN,.21)),NKNAME=$P(NKNODE,U),NKREL=$P(NKNODE,U,2)
 S NKPHONE=$P(NKNODE,U,9),NKADD=$P(NKNODE,U,3),NKCITY=$P(NKNODE,U,6)
 S NKSTP=$P(NKNODE,U,7),NKST=$P($G(^DIC(5,+NKSTP,0)),U)
 S NKZIP=$P(NKNODE,U,8)
 S Y=$P(SDDPTN0,U,3) I Y X ^DD("DD") S DOB=Y
 ;
BEGIN ;-- begin
 D DEM,TRIBE,PRVT,MCR,MCD,PRT2
 Q
 ;
END ;-- kill variables
 D ^%ZISC
END1 ;EP; called by ASDFORM
 K NKADD,NKCITY,NKNAME,NKNODE,NKPHONE,NKREL,NKST,NKSTP,NKZIP
 K PBIRTH,SEMPY,SPHONE,FSBIRTH,FCBIRTH,FMBIRTH,MSBIRTH,MCBIRTH
 K FSBIRTHP,MSBIRTHP,DFN,EMPY,EPHONE,FNAME,MNAME,PNODE,SEMPYP,AUPNDOB
 K AUPNDAYS,AUPNPAT,AUPNSEX,LL,SEX,SSN,POP,AUPNDOD,DOB,AGE
 Q
 ;
DEM ;-- print demographics
 U IO
 W @IOF ;maw added form feed at print
 W !!,?80-$L(SITE)\2,SITE
 W !?16,$$CONF^ASDUT
 W !,?17,"*** PATIENT ADDRESS AND INSURANCE UPDATE ***"
 W !,?9,"*** PLEASE MAKE CORRECTIONS TO ANY INCORRECT INFORMATION ***"
 W !!,$E(NAME,1,27)
 ;-- searhc/maw start of mods 5/19
 W ?30,"HRCN: ",HRCN,?44,"DOB: ",DOB,?62,"AGE: ",$$AGE
 W !,"SSN: ",SSN
 ;W ?34,"HRCN: ",HRCN,?48,"DOB: ",DOB,?66,"SSN: ",SSN ;maw orig line
 ;-- searhc/maw end of mods 5/19
 I SDELIG["P" D
 . W !!,?3,"***** ELIGIBILITY PENDING - "
 . W "PLEASE SEND PATIENT TO ADMITTING *****"
 I ADDR="" D  G EMPLY
 . W !,?3,"Please enter your address,work and phone number on "
 . W "the line below."
 . W !!,?3," " N X S $P(X,"_",75)="" W X K X
 W ! F LL=1,2,3 W:$P(ADDR,U,LL)]"" !,$P(ADDR,U,LL)
 W ?48,"Home: ",$P(SDDPTN13,U,1)
 W !,$P(ADDR,U,4),","
 W:$D(^DIC(5,+$P(ADDR,U,5),0)) $P(^(0),U,2)
 W " "_$P(ADDR,U,6),?48,"Birth Place: ",PBIRTH
EMPLY W !!,?3,"Employer: ",EMPY,?48,"Work Phone: ",$P(SDDPTN13,U,2)
 W !,?3,"Spouse's Employer: ",SEMPY,?48,"Work Phone: ",SPHONE
 W !!,?3,"Father's Name: ",FNAME,?48,"Birthplace: ",FCBIRTH_" "_FSBIRTH
 W !,?3,"Mother's Name: ",MNAME,?48,"Birthplace: ",MCBIRTH_" "_MSBIRTH
 W !!,?3,"Emergency Contact: ",NKNAME
 W !,?3,"Relationship: ",NKREL,?48,"Phone No.: ",NKPHONE
 W !,?3,"Mailing Address: ",NKADD
 W !,?3,"City: ",NKCITY,?28,"State: ",NKST,?48,"Zip: ",NKZIP
 Q
 ;
TRIBE ;
 S N=$G(^AUPNPAT(DFN,11)) W !!
 W !,"ELIGIBILITY: " ;maw added
 S ELG=$P(N,U,12) ;maw added
 W $S(ELG="I":"INELIGIBLE",ELG="C":"CHS & DIRECT",ELG="D":"DIRECT ONLY",ELG="P":"PENDING VERIFICATION",1:"") ;maw added
 W !,"TRIBE OF MEMBERSHIP/CORP.   BLOOD QUANTUM   TRIBE QUANTUM   TRIBE"
 W !,"-------------------------   -------------   -------------   -----"
 W !,$E($P($G(^AUTTTRI(+$P(N,U,8),0)),U),1,25)
 W ?29,$P(N,U,10),?45,$P(N,U,9)
 W ?60,$P($G(^AUTTTRI(+$P(N,U,27),0)),U),! K N
 Q
 ;
PRVT1 ;print header for private insurance
 W !,?3,"INSURANCE COMPANY",?35,"POLICY #",?51,"ELIGIBILITY DATES",!
 N X,Y,Z S $P(X,"-",27)="",$P(Y,"-",12)="",$P(Z,"-",26)=""
 W ?3,X,?35,Y,?51,Z Q
 ;
MCR1 ;print medicare header
 W !!,?3,"MEDICARE NUMBER",?21,"RELEASE DATE"
 W ?35,"MEDICARE ELIGIBILITY DATES/COVERAGE"
 N X,Y,Z S $P(X,"-",16)="",$P(Y,"-",12)="",$P(Z,"-",36)=""
 W !,?3,X,?21,Y,?35,Z Q
 ;
MCD1 ;print medicaid header
 W !!,?3,"MEDICAID NUMBER",?35,"MEDICAID ELIGIBILITY DATES/COVERAGE"
 N X,Y S $P(X,"-",16)="",$P(Y,"-",36)="" W !,?3,X,?35,Y Q
 ;
PRVT ;find private insurance
 NEW X,Y,X0,Y0
 I '$D(^AUPNPRVT(DFN)) D  Q
 . W !,"   *** NO PRIVATE INSURANCE INFORMATION ON RECORD ***"
 D PRVT1 S X=0
 F  S X=$O(^AUPNPRVT(DFN,11,X)) Q:'X  D
 . Q:'$D(^AUPNPRVT(DFN,11,X,0))  S X0=^(0)
 . S Y=+X0 Q:'Y!('$D(^AUTNINS(+Y,0)))  S Y0=^(0)
 . W !,?3,$P(Y0,U),?35,$P(X0,U,2)
 . I +$P(X0,U,6) D
 .. N Y S Y=$P(X0,U,6) X ^DD("DD") W ?51,Y," to "
 . I +$P(X0,U,7) D
 .. N Y S Y=$P(X0,U,7) X ^DD("DD") W ?66,Y
 Q
 ;
MCR ;find medicare information
 N X,Y,X0,Y0
 I '$D(^AUPNMCR(DFN)) D  Q
 . W !,"   *** NO MEDICARE INFORMATION ON RECORD ***"
 D MCR1 S X0=^AUPNMCR(DFN,0) D
 . S Y=$P(X0,U,3) Q:'Y  W !,?3,Y               ;medicare number
 . S Y=$P(X0,U,4) Q:'Y!('$D(^AUTTMCS(+Y,0)))  S Y0=^(0) W ?14,Y0
 W ?21,$$VAL^XBDIQ1(9000001,DFN,.04)
 S X=0
 F  S X=$O(^AUPNMCR(DFN,11,X)) Q:'X  D
 . Q:'$D(^AUPNMCR(DFN,11,X,0))  S X0=^(0)
 . I $P(X0,U) D
 .. N Y S Y=$P(X0,U) X ^DD("DD") W ?35,Y," to "
 . I $P(X0,U,2) D
 .. N Y S Y=$P(X0,U,2) X ^DD("DD") W ?50,Y
 . I $P(X0,U,3)'="" D
 .. N Y S Y=$P(X0,U,3) W ?65,Y
 . W !
 Q
 ;
MCD ;find medicaid information 
 ;
 NEW X,Y,Z,X0,Y0,IFN
 I '$D(^AUPNMCD("B",DFN)) D  Q
 . W !,"   *** NO MEDICAID INFORMATION ON RECORD ***"
 D MCD1 S IFN=0 F  S IFN=$O(^AUPNMCD("B",DFN,IFN)) Q:IFN=""  D
 . S X0=^AUPNMCD(IFN,0) D
 .. S Y=$P(X0,U,3) W !,?3,Y               ;medicaid number
 .. S Y=$P(X0,U,4) Q:'Y!('$D(^DIC(5,+Y,0)))  S Y0=$P(^(0),U,2) W ?14,Y0
 .. S Y=$S($P(X0,U,8):$P(X0,U,8),1:"") Q:'Y  X ^DD("DD") S Z=Y
 . S X=0 F  S X=$O(^AUPNMCD(IFN,11,X)) Q:'X  D
 .. Q:'$D(^AUPNMCD(IFN,11,X,0))  S X0=^(0)
 .. I $P(X0,U) D
 ... N Y S Y=$P(X0,U) X ^DD("DD") W ?35,Y," to "
 .. I $P(X0,U,2) D
 ... N Y S Y=$P(X0,U,2) X ^DD("DD") W ?50,Y
 .. I $P(X0,U,3)'="" D
 ... N Y S Y=$P(X0,U,3) W ?65,Y
 I $G(Z) W !!,?3,"Medicaid date of last update: ",Z,!
 Q
 ;
PRT2 ;print request for current information
 NEW X,Y
 W !!,?3,"Does this include Dental coverage?  Yes___  No___"
 W !!,?3,"Is this a work related Injury?      Yes___ No___",!
 W ?3,"Date of Injury: _______________________"
 W !!,?8,"We appreciate your cooperation and assistance in filling"
 W " out this form."
 W !,?3,"It is important that we keep our patient registration"
 W " files accurate so"
 W !,?3,"that we can provide a better service to you."
 W !!,?3,"The Business Office, ",SITE,?50,"Printed at "
 D TIME^ASDUT W " " D ^%D
 Q
 ;
 ;
PARENT ; -- parents' birth info
 I FMBIRTH="" S (MCBIRTH,MSBIRTH,FCBIRTH,FSBIRTH)=" " Q
 S MCBIRTH=$P($G(FMBIRTH),U,5),MSBIRTHP=$P($G(FMBIRTH),U,6)
 S MSBIRTH=$P($G(^DIC(5,+MSBIRTHP,0)),U,2),FCBIRTH=$P($G(FMBIRTH),U,2)
 S FSBIRTHP=$P($G(FMBIRTH),U,3),FSBIRTH=$P($G(^DIC(5,+FSBIRTHP,0)),U,2)
 Q
EMPY ; -- employer name 
 S EMPY=$P($G(PNODE),U,19) I EMPY="" S EMPY="NONE" Q
 S EMPY=$P($G(^AUTNEMPL(EMPY,0)),U) Q
 ;
SEMPY ; -- spouse employer
 N Y S SEMPYP=$P($G(PNODE),U,22) I SEMPYP="" S SEMPY="NONE" Q
 S SEMPY=$P($G(^AUTNEMPL(SEMPYP,0)),U)
 Q
 ;
AGE() ; -- get the printable age
 N DA
 S DA=DFN
 ;S DR=1102.98,DIC=9000001 D ^AUDICLK ;IHS/DSD/ENM 01/22/99
 S DR=1102.98,DIC=9000001 D ^ASDZAGE ;IHS/DSD/ENM 01/22/99
 S AGE=$S($D(LKPRINT):LKPRINT,1:"")
 Q AGE
 ;
