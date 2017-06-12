PSOORFI1 ;BIR/SAB - finish OP orders from OE/RR continued ;04-Jun-2013 22:36;PLS
 ;;7.0;OUTPATIENT PHARMACY;**7,15,23,27,32,44,51,46,71,90,108,131,152,1003,1005,1006,1008,1013,186,210,222,258,260,225,1015,1016,1017**;DEC 1997;Build 40
 ;Ref. ^PS(50.7 supp. DBIA 2223
 ;Ref. ^PSDRUG( supp. DBIA 221
 ;Ref. L^PSSLOCK supp. DBIA 2789
 ;Ref. ^PS(50.606 supp. DBIA 2174
 ;Ref. ^PS(55 supp. DBIA 2228
 ;Ref. ULK^ORX2 supp. DBIA 867
 ;
 ;PSO*186 add call to function $$DEACHK
 ;PSO*210 add call to WORDWRAP api
 ; Modified - IHS/CIA/PLS - 01/26/04 - Line PST+37
 ;                          02/09/05 - Added line ISSDT+11
 ;            IHS/MCS/PLS - 09/17/07 - ISSDT+12 - Added logic to set clinical indicator
 ;                          03/06/08 - ISSDT+14 - Added logic to set Substitution response
 ;                          03/13/08 - PST+46 - Added line for Substitution display
 ;                          01/23/09 - PST+47 - Added line for Cash Due display
 ;                          10/24/11 - OBX+1
 ;            IHS/MSC/PB    08/03/12 - Line tag SIGN added at line PST+8 to pull the SIGNS and SYMPTOMS and the INDICATION CODES for display
 ;            IHS/MSC/PLS   12/06/12 - PST+19
 ;                          06/04/13 - Added line for Discharge Medication
 S SIGOK=1
DSPL K ^TMP("PSOPO",$J),CLOZPAT,PSOPRC,PSODSPL
 S (OI,PSODRUG("OI"))=$P(OR0,"^",8),PSODRUG("OIN")=$P(^PS(50.7,$P(OR0,"^",8),0),"^"),OID=$P(OR0,"^",9)
 I $P($G(OR0),"^",9) S POERR=1,DREN=$P(OR0,"^",9) D DRG^PSOORDRG K POERR G DRG
 I '$P(OR0,"^",9) D DREN^PSOORNW2
DRG I $P($G(^PSDRUG(+$G(PSODRUG("IEN")),"CLOZ1")),"^")="PSOCLO1" D CLOZ^PSOORFI2
 ;PSO*186 modify If/Else below to use DEACHK
 I $G(PSODRUG("DEA"))]"" D
 .S PSOCS=0 K DIR,DIC,PSOX
 .N PSDEA,PSDAYS S PSDEA=PSODRUG("DEA"),PSDAYS=+$P(OR0,"^",22)
 .I $$DEACHK^PSOUTLA1("*",PSDEA,PSDAYS,$G(CLOZPAT),.PSOCS,.PSOMAX)
 E  D
 .S PSOMAX=$S($G(CLOZPAT)=2:3,$G(CLOZPAT)=1:1,1:$P(OR0,"^",11))
ISSDT S (PSOID,Y,PSONEW("ISSUE DATE"))=$S($G(PSONEW("ISSUE DATE")):PSONEW("ISSUE DATE"),$P($G(OR0),"^",6):$E($P(OR0,"^",6),1,7),1:DT)
 X ^DD("DD") S PSONEW("ISSUE DATE")=Y
 D USER^PSOORFI2($P(OR0,"^",4)) S PSONEW("CLERK CODE")=$P(OR0,"^",4),PSORX("CLERK CODE")=USER1
 S (PSONEW("DFLG"),PSONEW("QFLG"))=0,PSODFN=$P(OR0,"^",2),PSONEW("QTY")=$P(OR0,"^",10),PSONEW("MAIL/WINDOW")=$S($P(OR0,"^",17)="M":"M",1:"W")
 S:$G(PSONEW("CLINIC"))']"" PSONEW("CLINIC")=+$P(OR0,"^",13),PSORX("CLINIC")=$S($D(^SC(PSONEW("CLINIC"),0)):$P(^SC(PSONEW("CLINIC"),0),"^"),1:"")
 S:$G(PSORX("CLINIC"))']"" PSORX("CLINIC")=$S($D(^SC(+$P(OR0,"^",13),0)):$P(^SC($P(OR0,"^",13),0),"^"),1:"")
 D USER^PSOORFI2($P(OR0,"^",5))
 S PSONEW("CLERK CODE")=$P(OR0,"^",4),PSONEW("PROVIDER")=$P(OR0,"^",5),PSONEW("PROVIDER NAME")=USER1
 S PSONEW("PATIENT STATUS")=$S(+$G(^PS(55,PSODFN,"PS")):+$G(^PS(55,PSODFN,"PS")),1:"")
 S PSONEW("CHCS NUMBER")=$S($P($G(^PS(52.41,+$G(ORD),"EXT")),"^")'="":$P($G(^("EXT")),"^"),1:"")
 S PSONEW("EXTERNAL SYSTEM")=$S($P($G(^PS(52.41,+$G(ORD),"EXT")),"^",3)'="":$P($G(^("EXT")),"^",3),1:"")
 S PSONEW("CM")=$S($L($$VALUE^ORCSAVE2(+OR0,"CMF")):$$VALUE^ORCSAVE2(+OR0,"CMF"),APSPCMP=2:"Y",APSPCMP=3:"",1:"N")  ; IHS/CIA/PLS - 01/28/09 - Added check for no default
 S PSONEW("CLININD")=$S($L($$VALUE^ORCSAVE2(+OR0,"CLININD")):$$VALUE^ORCSAVE2(+OR0,"CLININD"),1:"")
 S PSONEW("CLININD2")=$S($L($$VALUE^ORCSAVE2(+OR0,"CLININD2")):$$VALUE^ORCSAVE2(+OR0,"CLININD2"),1:"")
 S PSONEW("DAW")=$S($L($$VALUE^ORCSAVE2(+OR0,"DAW")):$$VALUE^ORCSAVE2(+OR0,"DAW"),1:"")  ; IHS/MSC/PLS - 03/06/08 - Allow Substitutions
 S PSONEW("DSCMED")=$S($L($$VALUE^ORCSAVE2(+OR0,"DSCMED")):$$VALUE^ORCSAVE2(+OR0,"DSCMED"),1:"")  ;IHS/MSC/PLS - 06/04/13
 I $P(OR0,"^",22)>0 S PSONEW("DAYS SUPPLY")=$P(OR0,"^",22) G DS
 S PSONEW("DAYS SUPPLY")=$S(+$G(^PS(55,PSODFN,"PS"))&($P($G(^PS(53,+$G(^PS(55,PSODFN,"PS")),0)),"^",3)):$P(^PS(53,+$G(^PS(55,PSODFN,"PS")),0),"^",3),1:30)
DS S:$D(CLOZPAT) PSONEW("DAYS SUPPLY")=$S(CLOZPAT=2&(PSONEW("DAYS SUPPLY")>28):28,CLOZPAT=1&(PSONEW("DAYS SUPPLY")>14):14,'CLOZPAT&(PSONEW("DAYS SUPPLY")>7):7,1:PSONEW("DAYS SUPPLY"))
 S IEN=0 D OBX                ; Display Order Checks Information
 D LMDISP^PSOORFI5(+$G(ORD))  ; Display Flag/Unflag Information
 D DIN^PSONFI(PSODRUG("OI"),$S($D(PSODRUG("IEN")):PSODRUG("IEN"),1:"")) ;Setup for N/F & DIN indicator
 I $G(PKI1)!($G(PKI)=1) D L1^PSOPKIV1 K:$G(PKI)=1 PKI
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="*(1) Orderable Item: "_$P(^PS(50.7,PSODRUG("OI"),0),"^")_" "_$P(^PS(50.606,$P(^(0),"^",2),0),"^")_NFIO
 S:NFIO["<DIN>" NFIO=IEN_","_($L(^TMP("PSOPO",$J,IEN,0))-4)
 D FULL^VALM1 K LST I $G(PSODRUG("NAME"))]"" D  G PST
 .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" (2)"_$S($D(^PSDRUG("AQ",PSODRUG("IEN"))):"      CMOP ",1:"           ")_"Drug: "_PSODRUG("NAME")_NFID
 .S:NFID["<DIN>" NFID=IEN_","_($L(^TMP("PSOPO",$J,IEN,0))-4)
 .I $P(^PSDRUG(PSODRUG("IEN"),0),"^",10)]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="       Drug Message:" D DRGMSG^PSOORNEW
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" (2)           Drug: No Dispense Drug Selected"
PST D DOSE^PSOORFI4 K PSOINSFL
 S PSOINSFL=$P($G(^PS(52.41,ORD,"INS")),"^",2)
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" (4)   Pat Instruct:" D INST^PSOORFI4
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  Provider Comments:" S TY=3 D INST
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="       Instructions:" S TY=2 D INST
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                SIG:" D SIG
 ;IHS/MSC/PB - 08/03/12 Next line added to pull the SIGNS and SYMPTOMS and the INDICATION CODE for display
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="Clinical Indication: "_$G(PSONEW("CLININD"))_"  "_$G(PSONEW("CLININD2"))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" (5) Patient Status: "_$P($G(^PS(53,+PSONEW("PATIENT STATUS"),0)),"^")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" (6)     Issue Date: "_PSONEW("ISSUE DATE")
 S (Y,PSONEW("FILL DATE"))=$S($E($P(OR0,"^",6),1,7)<DT:DT,1:$E($P(OR0,"^",6),1,7)) X ^DD("DD") S PSORX("FILL DATE")=Y,^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_"        (7) Fill Date: "_Y
 I $P(OR0,"^",18) D
 .S IEN=IEN+1,Y=$P(OR0,"^",18) X ^DD("DD") S $P(^TMP("PSOPO",$J,IEN,0)," ",39)="Effective Date: "_Y
 D:$D(CLOZPAT) ELIG^PSOORFI2,CLQTY^PSOORFI4
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=" (8)    Days Supply: "_$S($G(PSONEW("DAYS SUPPLY")):PSONEW("DAYS SUPPLY"),+$G(^PS(55,PSODFN,"PS"))&($P(^PS(53,+$G(^PS(55,PSODFN,"PS")),0),"^",3)):$P(^PS(53,+$G(^PS(55,PSODFN,"PS")),0),"^",3),1:"")
 I +$G(^PS(55,PSODFN,"PS")) S RXPT=+^("PS") I $G(^PS(53,RXPT,0))]"" D
 .S PSONEW("# OF REFILLS")=$S(+$P(OR0,"^",11)>+$P(^PS(53,RXPT,0),"^",4):+$P(^PS(53,RXPT,0),"^",4),1:+$P(OR0,"^",11)),PSOX=+$P(^PS(53,RXPT,0),"^",4)
 .S PSONEW("# OF REFILLS")=$S(PSONEW("# OF REFILLS")>PSOMAX:PSOMAX,1:PSONEW("# OF REFILLS"))
 .S PSOMAX=$S(PSOMAX>+$P(^PS(53,RXPT,0),"^",4):+$P(^PS(53,RXPT,0),"^",4),1:PSOMAX) K RXPT
 .S MPSDY=PSONEW("DAYS SUPPLY")
 .;I PSOMAX=5 S MAXRF=$S(MPSDY<60:5,MPSDY'<60&(MPSDY'>89):2,1:1) I PSONEW("# OF REFILLS")>MAXRF S PSONEW("# OF REFILLS")=MAXRF K MAXRF,MPSDY Q
 .;IHS/MSC/PLS - 12/06/2012
 .;S MAXRF=$S(MPSDY<60:11,MPSDY'<60&(MPSDY'>89):5,MPSDY=90:3,1:0)
 .S MAXRF=$S(MPSDY<60:15,MPSDY<90:5,MPSDY=90:3,MPSDY<168:2,MPSDY<365:1,1:0)
 .I PSONEW("# OF REFILLS")>MAXRF S PSONEW("# OF REFILLS")=MAXRF K MAXRF,MPSDY
 E  D
 . I $G(PSOMAX) S PSONEW("# OF REFILLS")=$S(+$P(OR0,"^",11)>PSOMAX:PSOMAX,1:+$P(OR0,"^",11)) Q
 .S PSONEW("# OF REFILLS")=+$P(OR0,"^",11)
 S ^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_"                (9)   QTY"_$S($P($G(^PSDRUG(+$G(PSODRUG("IEN")),660)),"^",8)]"":" ("_$P($G(^PSDRUG(+$G(PSODRUG("IEN")),660)),"^",8)_")",1:" (  )")_": "
 S ^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_$S($D(CLOZPAT):+$G(PSONEW("QTY")),1:$P(OR0,"^",10))
 I $P($G(^PSDRUG(+$G(PSODRUG("IEN")),5)),"^")]"" D
 .S $P(RN," ",79)=" ",IEN=IEN+1
 .S ^TMP("PSOPO",$J,IEN,0)=$E(RN,$L("QTY DSP MSG: "_$P(^PSDRUG(PSODRUG("IEN"),5),"^"))+1,79)_"QTY DSP MSG: "_$P(^PSDRUG(PSODRUG("IEN"),5),"^") K RN
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="       Provider ordered "_+$P(OR0,"^",11)_" refills"
 D:$D(CLOZPAT) PQTY^PSOORFI4
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="(10)   # of Refills: "_PSONEW("# OF REFILLS")_$E("  ",$L(PSONEW("# OF REFILLS"))+1,2)_"               (11)   Routing: "_$S($G(PSONEW("MAIL/WINDOW"))="M":"MAIL",1:"WINDOW")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="(12)         Clinic: "_PSORX("CLINIC")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="(13)       Provider: "_PSONEW("PROVIDER NAME")
 I $P($G(^VA(200,$S($G(PSONEW("PROVIDER")):PSONEW("PROVIDER"),1:$P(OR0,"^",5)),"PS")),"^",7)&($P($G(^("PS")),"^",8)) S PSONEW("COSIGNING PROVIDER")=$P(^("PS"),"^",8) D
 .D USER^PSOORFI2(PSONEW("COSIGNING PROVIDER"))
 .S IEN=IEN+1 S ^TMP("PSOPO",$J,IEN,0)="        Cos-Provider: "_USER1
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="(14)         Copies: 1"
 S PSONEW("REMARKS")=$S($P(OR0,"^",17)="C":"Administered in Clinic.",1:"")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="(15)        Remarks: "_$S($G(PSONEW("REMARKS"))]"":PSONEW("REMARKS"),1:"")
 ; IHS/CIA/PLS - 01/26/04 - Add IHS Fields to display
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="Enter a zero (0) to edit IHS specific fields."
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                NDC: "_$G(PSODRUG("NDC"))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                AWP: "_$G(PSONEW("AWP"))_"       Unit Cost: "_$G(PSONEW("COST"))   ; IHS/CIA/PLS - 01/15/04
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="       Triplicate #: "_$G(PSONEW("TRIP"))   ; IHS/CIA/PLS - 01/15/04
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="        Bill Status: "_$$EXTERNAL^DILFD(52,9999999.07,,$G(PSONEW("BST")))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="       Manufacturer: "_$G(PSONEW("MANUFACTURER"))_"   Lot #: "_$G(PSODIR("LOT #"))_"  ExpDate: "_$$FMTE^XLFDT($G(PSODIR("EXPIRATION DATE")))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="        Chronic Med: "_$$EXTERNAL^DILFD(52,9999999.02,,$G(PSONEW("CM")))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="       Substitution: "_$$EXTERNAL^DILFD(52,9999999.25,,$G(PSONEW("DAW")))  ;IHS/MSC/PLS - 03/13/08
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="Discharge Medication: "_$$EXTERNAL^DILFD(52,9999999.28,,$G(PSONEW("DSCMED")))  ;IHS/MSC/PLS - 06/04/13
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="           Cash Due: "_$$EXTERNAL^DILFD(52,9999999.26,,$G(PSONEW("CASH DUE")))  ; IHS/MSC/PLS - 01/23/09
 ;S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="            Insurer: "_$G(PSONEW("INSURER"))
 ; End IHS Fields
 D USER^PSOORFI2($P(OR0,"^",4))
 S $P(RN," ",35)=" ",IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="   Entry By: "_USER1_$E(RN,$L(USER1)+1,35)
 S Y=$P(OR0,"^",12) X ^DD("DD") S ^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_"Entry Date: "_$E($P(OR0,"^",12),4,5)_"/"_$E($P(OR0,"^",12),6,7)_"/"_$E($P(OR0,"^",12),2,3)_" "_$P(Y,"@",2) K RN
 S PSOACT=$S($D(^XUSEC("PSORPH",DUZ)):"DEFX",'$D(^XUSEC("PSORPH",DUZ))&($P($G(PSOPAR),"^",2)):"F",1:"")
 ; - PSOACTOV is used to force the Pending Order to be Read-Only (no updates) even if invoked by a Pharmacist
 I $G(PSOACTOV) S PSOACT=""
 D:'$G(ACP) EN^PSOLMPO S:$G(ACP) VALMBCK="Q" D:$G(PKI1)=2 DCP^PSOPKIV1
 Q
POST ;post patient selection
 D POST^PSOORFI2 Q
SIG ;displays possible sig
 D SIG^PSOORFI2 Q
INST ;displays provider comments and pharmacy instructions
 S INST=0 F  S INST=$O(^PS(52.41,ORD,TY,INST)) Q:'INST  D     ;PSO*210
 . S (MIG,INST(INST))=^PS(52.41,ORD,TY,INST,0)
 . D WORDWRAP^PSOUTLA2(MIG,.IEN,$NA(^TMP("PSOPO",$J)),20)
 K INST,TY,MIG,SG
 Q
OBX ;formats obx section
 I 1 D
 .N X
 .S X="IORVON;IORVOFF;IOBON;IOBOFF" D ENDR^%ZISS   ;Patch 1013
 D OBX^PSOORFI4
 Q
ST ;sort by route or patient
 W !!,"Enter 'PA' to process orders by patients",!,"      'RT' to process orders by route (mail/window)",!,"      'PR' to process orders by priority",!,"      'CL' to process orders by clinic"
 W !,"      'FL' to process flagged orders",!,"   or 'E' or '^' to exit" W ! Q
RT ;which route to sort by
 W !!,"Enter 'W' to process window orders first",!,"      'M' to process mail orders first",!,"      'C' to process orders administered in clinic first",!,"   or 'E' or '^' to exit" Q
PT ;process for all or one patient
 W !!,"Enter 'A' to process all patient orders",!,"      'S' to process orders for a patient",!,"      or 'E' or '^' to exit" Q
EP ;continue processing or not
 W !,"If you want to continue processing orders Press RETURN or enter '^' to exit" Q
LOCK S PSOPLCK=$$L^PSSLOCK(PAT,0) I '$G(PSOPLCK) D LOCK^PSOORCPY S POERR("QFLG")=1
 K PSOPLCK
 Q
ULK S X=PAT_";DPT(" D ULK^ORX2 S:$G(PSOQUIT) POERR("QFLG")=1 ; not called anymore
 Q
LOCK1 S PSOACT=$S($D(^XUSEC("PSORPH",DUZ)):"DEFX",'$D(^XUSEC("PSORPH",DUZ))&($P($G(PSOPAR),"^",2)):"F",1:"")
 Q
EX K DRET,SIG,PSODRUG,PRC,PHI
 K DIR,DIRUT,DUOUT,DIRUT,X,Y,DIC,POERR,PSONEW,PSOSD,MAIL,CLI,WIN,OR0,OR1,OR2,ORD,SRT,PSRT,PSODFN,PSOFROM,T,OR3,PAT,%,%T,%Y,DI,DQ,DR,DRG,STA,I,T1,PSOSORT
 K TO,TC,TZ,PSOCPAY,PSOBILL,PSOIBQS,GROUPCNT,AGROUP,AGROUP1,OBX,%,%I,%H,D0,DFN,PSORX,PSOPTPST,PSOQFLG,PT,RTN,TM,TM1,DIPGM,PSOID,PSOCNT,PSOLK,PSZFIN,PSZFZZ D KVA^VADPT
 K PSOFDR,PSOQUIT,PSOFIN,^TMP("PSOAO",$J),^TMP("PSODA",$J),^TMP("PSOPO",$J),^TMP("PSOPF",$J),^TMP("PSOPI",$J),^TMP("PSOHDR",$J),MEDA,MEDP
 K C,CC,CNT,CRIT,D,DGI,DGS,DREN,IT,JJ,LG,MM,NIEN,PSOD,PATA,PSDAYS,PSOACT,PSOBM,PSOCOU,PSOCOUU,PSOFLAG,PSON,PSONOOR,PSOOPT,PSOPF,PSOPI,PSRF,RXFL,SDA,SEG1,SER,SERS,SLPPL,STAT,Z,Z4,ZDA
 D FULL^VALM1
 Q
