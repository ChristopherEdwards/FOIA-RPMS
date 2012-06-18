BGP4UTL ; IHS/CMI/LAB - ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 ;utility calls
 ;
STMP ;EP
 Q:BGPTIME'=1
 I BGPLIST="P",$P(^AUPNPAT(DFN,0),U,14)'=BGPLPRV Q
 X ^BGPINDF(BGPIC,2) Q:'$T
 S BGPLIST(BGPIC)=$G(BGPLIST(BGPIC))+1
 S ^XTMP("BGP4D",BGPJ,BGPH,"LIST",BGPIC,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEB,DFN)=BGPVALUE
 Q
D(D) ;EP
 I D="" Q ""
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)_$S($P(D,".",2)]"":$P(D,".",2),1:"")
JRNL ;EP
 N (DT,U,ZTQUEUED) S %=$$NOJOURN^ZIBGCHAR("BGPGPDCF"),%=$$NOJOURN^ZIBGCHAR("BGPGPDPF"),%=$$NOJOURN^ZIBGCHAR("BGPGPDBF"),%=$$NOJOURN^ZIBGCHAR("BGPHEDCF"),%=$$NOJOURN^ZIBGCHAR("BGPHEDPF"),%=$$NOJOURN^ZIBGCHAR("BGPHEDBF")
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
EXCELGS ;EP
 ;W:'$D(ZTQUEUED) !!,"writing out excel file."
 S Y=$$OPEN^%ZISH(BGPUF,BGPFN,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open file to write out excel file.  Notify programmer." Q
 U IO
 ;I $P($G(^BGPSITE(DUZ(2),0)),U,4)="N" Q  ;site says stop NOT IN 04
 S BGPX="",$P(BGPX,U,11)="Diabetes DX Ever",$P(BGPX,U,20)="Documented HbA1c",$P(BGPX,U,29)="Poor Glycemic Control",$P(BGPX,U,38)="Good Glycemic Control",$P(BGPX,U,47)="Controlled BP <130/80"
 S $P(BGPX,U,56)="LDL Assessed",$P(BGPX,U,65)="Nephropathy Assessed"
 S $P(BGPX,U,74)="Retinopathy Exam",$P(BGPX,U,83)="Diabetic Dental Access",$P(BGPX,U,92)="Dental Access",$P(BGPX,U,101)="Dental Sealants",$P(BGPX,U,110)="Influenza 65+",$P(BGPX,U,119)="Pneumovax 65+"
 S $P(BGPX,U,128)="Pap Smear Rates",$P(BGPX,U,137)="Mammogram Rates",$P(BGPX,U,146)="FAS Prevention",$P(BGPX,U,155)="IPV/DV Screen 16-24",$P(BGPX,U,164)="With BMI",$P(BGPX,U,173)="Tobacco Assessment"
 S $P(BGPX,U,182)="Public Health Nursing",$P(BGPX,U,190)=""
 W BGPX,!
 K BGPX
 S BGPX="" S P=11 F  S $P(BGPX,U,P)="Current",P=P+9 Q:P>182
 S P=14 F  S $P(BGPX,U,P)="Previous",P=P+9 Q:P>185
 S P=17 F  S $P(BGPX,U,P)="Baseline",P=P+9 Q:P>188
 S $P(BGPX,U,190)=""
 W BGPX,!
 K BGPX
 S BGPX="",$P(BGPX,U,1)="Site Name",$P(BGPX,U,2)="ASUFAC",$P(BGPX,U,3)="DB Id",$P(BGPX,U,4)="Date Report Run",$P(BGPX,U,5)="Current Report Begin Date",$P(BGPX,U,6)="Current Report End Date",$P(BGPX,U,7)="Previous Year Begin Date"
 S $P(BGPX,U,8)="Previous Year End Date",$P(BGPX,U,9)="Baseline Year Begin Date",$P(BGPX,U,10)="Baseline Year End Date"
 S P=11 F  S $P(BGPX,U,P)="Num",P=P+3 Q:P>188
 S P=12 F  S $P(BGPX,U,P)="Den",P=P+3 Q:P>189
 S P=13 F  S $P(BGPX,U,P)="%",P=P+3 Q:P>190
 W BGPX,!
 S BGPX=0 F  S BGPX=$O(BGPEI(BGPX)) Q:BGPX'=+BGPX  S $P(BGPEI(BGPX),U,190)="" W BGPEI(BGPX),!
 K BGPEI
 D ^%ZISC  ;close host file
 Q
GS ;EP
 K ^TMP($J)
 I $P($G(^BGPSITE(DUZ(2),0)),U,3)="N" Q
 L +^BGPDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 ;NOTE:  Kill of unscripted global.  Export to area.  Using standard name.
 K ^BGPDATA S X="",C=0 F  S X=$O(^BGPGPDCF(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPGPDCF(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPGPDCF(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPGPDCF(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPGPDCF(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPGPDCF(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPGPDCF(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPGPDCF(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPGPDCF(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPGPDCF(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPGPDCF(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPGPDCF(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPGPDCF(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPGPDCF(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPGPDCF(BGPRPT,X,X2,X3,X4,X5)
 S X=0 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPGPDCF"_"|"_^BGPDATA(X)
PRGS ;
 S S=C+1,X="" F  S X=$O(^BGPGPDPF(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPGPDPF(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPGPDPF(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPGPDPF(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPGPDPF(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPGPDPF(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPGPDPF(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPGPDPF(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPGPDPF(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPGPDPF(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPGPDPF(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPGPDPF(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPGPDPF(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPGPDPF(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPGPDPF(BGPRPT,X,X2,X3,X4,X5)
 S X=S-1 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPGPDPF"_"|"_^BGPDATA(X)
BLGS ;save off baseline data
 S S=C+1,X="" F  S X=$O(^BGPGPDBF(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPGPDBF(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPGPDBF(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPGPDBF(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPGPDBF(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPGPDBF(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPGPDBF(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPGPDBF(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPGPDBF(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPGPDBF(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPGPDBF(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPGPDBF(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPGPDBF(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPGPDBF(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPGPDBF(BGPRPT,X,X2,X3,X4,X5)
 S X=S-1 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPGPDBF"_"|"_^BGPDATA(X)
 S XBGL="BGPDATA"
 S F="BG04"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_BGPRPT
 ;S F="BG04"_BGPRPT_"."_BGPRPT
 S XBMED="F",XBFN=F,XBTLE="SAVE OF GPRA DATA BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBFLT=1
 D ^XBGSAVE
 L -^BGPDATA
 K ^TMP($J),^BGPDATA ;NOTE:  kill of unsubscripted global for use in export to area.
 Q
REPORT ;EP
 S BGPRPT=""
 W !!
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 ;3 files must have the same ien
 L +^BGPGPDCF:30 I '$T W !!,"Unable to lock global, try later." G REPORTX
 L +^BGPGPDPF:30 I '$T W !!,"Unable to lock global, try later." G REPORTX
 L +^BGPGPDBF:30 I '$T W !!,"Unable to lock global, try later." G REPORTX
 D GETIEN
 I 'BGPIEN W !!,"Something wrong with control files, notify programmer!" S BGPRPT="" G REPORTX
 S DINUM=BGPIEN
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPGPDCF(",DLAYGO=90244.03,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPRTYPE_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 G REPORTX
 S BGPRPT=+Y
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPGPDPF(",DLAYGO=90244.04,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPRTYPE_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)
 S DINUM=BGPRPT D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DINUM I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 G REPORTX
 S BGPRPTP=+Y
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPGPDBF(",DLAYGO=90244.05,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPRTYPE_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)
 S DINUM=BGPRPT D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 G REPORTX
 S BGPRPTB=+Y
 ;add communities to 28 multiple
 K ^BGPGPDCF(BGPRPT,9999)
 S C=0,X="" F  S X=$O(BGPTAX(X)) Q:X=""  S C=C+1 S ^BGPGPDCF(BGPRPT,9999,C,0)=X,^BGPGPDCF(BGPRPT,9999,"B",X,C)=""
 S ^BGPGPDCF(BGPRPT,9999,0)="^90244.12999A^"_C_"^"_C
 S ^BGPGPDCF(BGPRPT,99999,0)="^90244.129999A^0^0"
 S ^BGPGPDPF(BGPRPT,99999,0)="^90244.139999A^0^0"
 S ^BGPGPDBF(BGPRPT,99999,0)="^90244.149999A^0^0"
REPORTX ;
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 L -^BGPGPDCF
 L -^BGPGPDPF
 L -^BGPGPDBF
 Q
GETIEN ;EP -Get next ien available in all 3 files
 S BGPF=90244.03 D ENT
 S BGPF=90244.04 D ENT
 S BGPF=90244.05 D ENT
 S BGPIEN=$P(^BGPGPDCF(0),U,3)+1
S I $D(^BGPGPDPF(BGPIEN))!($D(^BGPGPDBF(BGPIEN))) S BGPIEN=BGPIEN+1 G S
 Q
 ;
ENT ;
 NEW GBL,NXT,CTR,XBHI,XBX,XBY,ANS
 S GBL=^DIC(BGPF,0,"GL")
 S GBL=GBL_"NXT)"
 S (XBHI,NXT,CTR)=0
 F L=0:0 S NXT=$O(@(GBL)) Q:NXT'=+NXT  S XBHI=NXT,CTR=CTR+1 W:'(CTR#50) "."
 S NXT="",XBX=$O(@(GBL)),XBX=^(0),XBY=$P(XBX,U,4),XBX=$P(XBX,U,3)
 S NXT=0,$P(@(GBL),U,3)=XBHI,$P(^(0),U,4)=CTR
 ;
EOJ ;
 KILL ANS,XBHI,XBX,XBY,CTR,DIC,FILE,GBL,L,NXT,BGPF
 Q
 ;
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
RZERO(V,L) ;EP - right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
