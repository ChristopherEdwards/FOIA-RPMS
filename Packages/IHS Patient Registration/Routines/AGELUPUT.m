AGELUPUT ;IHS/SET/GTH - UPDATE ELIGIBILITY FROM CMS FILE (UTILITIES) ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
FRMT ;EP - ask template and mode
 ;Select template.
 W !!
 S DIC="^AGELUP(",DIC("S")="I '$P(^(0),U,7)",DIC(0)="AEMQ"
 D ^DIC
 Q:+Y<0
 ;Load template into local vars.
 S AGTDA=+Y,AGZERO=^AGELUP(AGTDA,0),AGONE=$G(^(1)),AGTWO=$G(^(2)),AGTHREE=$G(^(3)),AGSEVEN=$G(^(7)),AGFPVL=$P(AGTHREE,U,3),AGPARSE=$P(AGZERO,U,3)
 I AGPARSE="V" S AGDEL=$$GET1^DIQ(9009062.01,AGTDA_",",.04)
 S AGTYPE=$P(AGZERO,U,2),AGAUTO=$P(AGZERO,U,6)
 I AGTYPE="D" D  I 'AGMCDST S DIRUT=1
 . S AGMCDST=0
 . I '$L($P(AGTWO,U,10)) D
 .. W !,"MEDICAID STATE isn't entered for this template.",!,"What's the State?"
 .. NEW DA,DIE,DR
 .. S DIE="^AGELUP(",DR=.295,DA=AGTDA
 .. D ^DIE
 .. S AGTWO=^AGELUP(AGTDA,2)
 ..Q
 . I '$L($P(AGTWO,U,10)) Q
 . S AGMCDST=$O(^DIC(5,"C",$P(AGTWO,U,10),0))
 .Q
 S AGMATCH=$G(^AGELUP(AGTDA,11))
 F %=1:1:$L(AGMATCH,"^") I '$L($P(AGMATCH,U,%)) S $P(AGMATCH,U,%)=0
 S AGMATCH=$TR(AGMATCH,"^")
 ;Select processing mode.
 NEW DA
 S AGAUTO=$$DIR^XBDIR("9009062.01,.06","",AGAUTO,"","","",2)
 I AGTYPE="D",AGAUTO="A" D DMC(AGTDA)
 Q
 ;
 ;Data auditing at the file level is indicated by a lower case "a"
 ;in the 2nd piece of the 0th node of the global.
 ;Data auditing at the field level is indicated by a lower case "a"
 ;in the 2nd piece of the 0th node of the field definition in ^DD(.
AUDS ;EP - Save current settings, and SET data auditing 'on'.
 S ^XTMP("AGELUP1",0)=$$FMADD^XLFDT(DT,56)_"^"_DT_"^"_"M/M ELIGIBILITY FILE PROCESSING"
 NEW G,P
 F %=1:1 S G=$P($T(AUD+%),";",3) Q:G="END"  D
 . S P=$P(@(G_"0)"),"^",2)
 . I '$D(^XTMP("AGELUP1",G)) S ^XTMP("AGELUP1",G)=P
 . S:'(P["a") $P(@(G_"0)"),"^",2)=P_"a"
 . Q:'(G["^DD(")
 . I '$D(^XTMP("AGELUP1",G,"AUDIT")) S ^XTMP("AGELUP1",G,"AUDIT")=$G(@(G_"""AUDIT"")"))
 . S (@(G_"""AUDIT"")"))="y"
 .Q
 Q
AUDR ;EP - Restore the file data audit values to their original values.
 NEW G,P
 F %=1:1 S G=$P($T(AUD+%),";",3) Q:G="END"  D
 . S $P(@(G_"0)"),"^",2)=^XTMP("AGELUP1",G)
 . Q:'(G["^DD(")
 . S (@(G_"""AUDIT"")"))=^XTMP("AGELUP1",G,"AUDIT")
 . K:@(G_"""AUDIT"")")="" @(G_"""AUDIT"")")
 .Q
 Q
AUD ;These are files/fields to be audited.
 ;;^AUPNMCR(
 ;;^DD(9000003,.01,
 ;;^DD(9000003,.02,
 ;;^DD(9000003,.03,
 ;;^DD(9000003,.04,
 ;;^DD(9000003,1101,
 ;;^DD(9000003,2101,
 ;;^DD(9000003,2102,
 ;;^AUPNMCD(
 ;;^DD(9000004,.01,
 ;;^DD(9000004,.02,
 ;;^DD(9000004,.03,
 ;;^DD(9000004,.04,
 ;;^DD(9000004,.07,
 ;;^DD(9000004,1101,
 ;;^DD(9000004,2101,
 ;;^DD(9000004,2102,
 ;;^AUPNRRE(
 ;;^DD(9000005,.01,
 ;;^DD(9000005,.02,
 ;;^DD(9000005,.03,
 ;;^DD(9000005,.04,
 ;;^DD(9000005,1101,
 ;;^DD(9000005,2101,
 ;;^DD(9000005,2102,
 ;;^AUTTMCS(
 ;;^DD(9999999.32,.01,
 ;;^AUTTRRP(
 ;;^DD(9999999.33,.01,
 ;;END
 ; -----------------------------------------------------
 ;
INSPT ;EP - Get the INSURER that is to be used.
 U IO(0)
 W !!,"Looking for an entry in the INSURER file named """,$S(AGTYPE="M":"MEDICARE",AGTYPE="R":"RAILROAD RETIREMENT",AGTYPE="D":"MEDICAID",1:"???"),"""..."
 NEW DA
 S AGINSPT=$$DIR^XBDIR("900000"_$S(AGTYPE="M":3,AGTYPE="D":4,AGTYPE="R":5,1:3)_",.02","",$S(AGTYPE="M":"MEDICARE",AGTYPE="D":"MEDICAID",AGTYPE="R":"RAILROAD RETIREMENT",1:""),"","","",1)
 I +Y>0 D INSPT9 Q
 W !,"An insurer named """,$S(AGTYPE="M":"MEDICARE",AGTYPE="D":"MEDICAID",AGTYPE="R":"RAILROAD RETIREMENT",1:"???"),""" could not be found in your INSURER file."
 W !,"What INSURER should be used for the elgibility update?"
 S DIC(0)="AEMZ"
 D ^DIC
INSPT9 ;
 I +Y>0 W !,"The insurer named """,$P(Y,U,2),""" will be used to update eligibility information." S AGINSPT=+Y
 Q
HEAD(AGHDR) ;EP - page header
 U IO(0)
 W @IOF,!,"FILE RECORD #: ",AGRCNT
 W !,"PATIENT: ",$P(^DPT(AG("DFN"),0),U,1),?35,"SSN: "
 W $E(AG("FSSN"),1,3)_"-"_$E(AG("FSSN"),4,5)_"-"_$E(AG("FSSN"),6,9)
 W ?58,"DOB: ",$$DOB^AUPNPAT(AG("DFN"),"S")
 W !,$$REPEAT^XLFSTR("=",80)
 W !?3,"RPMS ",AGHDR," ELIGIBILE File",?48,$S(AGTYPE="M":"CMS Medicare",AGTYPE="D":"State Medicaid",AGTYPE="P":"Private Ins.",AGTYPE="R":"CMS Railroad",1:"<unknown>")," FILE"
 W !,$$REPEAT^XLFSTR("-",80)
 Q
PEND ;EP - end of page
 W !
 S AGACT=$$DIR^XBDIR("SBM^F:FILE;S:SKIP;Q:QUIT","ACTION: (F)ILE, (S)KIP, (Q)UIT","QUIT")
 I $D(DIRUT) S AGACT="Q"
 Q
RUN ;EP - add run multiple
 S X=$$NOW^XLFDT,DIC="^AGELUPLG(",DIC(0)="LX",DLAYGO=9009062.02
 D ^DIC
 I +Y<0 U IO(0) W !!,"Could not create entry in Log file.",! Q
 S (AGRUN,DA)=+Y,DIE=DIC,DR=".02////"_AGTDA_";.03///"_AGFILE_";.04///"_AGCNT_";.05////"_DUZ_";.06///"_$P($G(^AUPNMCR(0)),U,4)_";.08///"_$P($G(^AUPNRRE(0)),U,4)_";.11///"_$P($G(^AUPNMCD(0)),U,4)
 D ^DIE
 Q
RUN1 ;EP - Update end of run file counts.
 S DIE="^AGELUPLG(",DA=AGRUN,DR=".07///"_$P($G(^AUPNMCR(0)),U,4)_";.09///"_$P($G(^AUPNRRE(0)),U,4)_";.12///"_$P($G(^AUPNMCD(0)),U,4)
 D ^DIE
 Q
MATCH() ;EP - Match the Patient for Medicaid Auto-processing, only.
 NEW AGQ,AGDPT0
 S AGDPT0=^DPT(AG("DFN"),0),AGQ=0
 ;SSN
 ;SSN must always match.
 ;
 ;NAME
 I $E(AGMATCH,2) D  Q:AGQ 0
 . S AGQ=AG("FLNM")_","_AG("FFNM")
 . S:AG("FMI")'="" AGQ=AGQ_" "_AG("FMI")
 . I $E(AGMATCH,2)=1,'($P(AGDPT0,U,1)=AGQ) S AGQ=1 Q
 . I $E(AGMATCH,2)=2,'($P($P(AGDPT0,U,1),",",1)=AG("FLNM")) S AGQ=1 Q
 . I $E(AGMATCH,2)=3,'($E($P($P(AGDPT0,U,1),",",1),1,6)=$E(AG("FLNM"),1,6)) S AGQ=1 Q
 .Q
 ;DOB
 I $E(AGMATCH,3) D  Q:AGQ 0
 . I $E(AGMATCH,3)=1,'($P(AGDPT0,U,3)=AG("FDOB")) S AGQ=1 Q
 . I $E(AGMATCH,3)=2,'($E($P(AGDPT0,U,3),1,3)=$E(AG("FDOB"),1,3)) S AGQ=1 Q
 . I $E(AGMATCH,3)=3,'($E($P(AGDPT0,U,3),1,5)=$E(AG("FDOB"),1,5)) S AGQ=1 Q
 .Q
 ;GENDER
 I $E(AGMATCH,4),'($P(AGDPT0,U,2)=AG("FSEX")) Q 0
 ;ZIP
 I $E(AGMATCH,5) D  Q:AGQ 0
 . I $E(AGMATCH,5)=1,'($P($G(^DPT(AG("DFN"),.11)),U,6)=AG("FMAZ")) S AGQ=1 Q
 . I $E(AGMATCH,5)=2,'($E($P($G(^DPT(AG("DFN"),.11)),U,6),1,5)=$E(AG("FMAZ"),1,5)) S AGQ=1 Q
 .Q
 Q 1
DMC(DA) ;EP - Display matching criteria.
 ;;You have chosen Medicaid upload in Auto mode.
 ;;Because of the widely differing methods used by States for verifying
 ;;Patient demographic data, additional matching criteria are available.
 ;;Matching is done on PtReg data, -not- Medicaid data.
 ;;@;!
 ;;The upload Matching criteria for this template is current set for:
 ;;###
 D HELP^XBHELP("DMC","AGELUPUT",0)
 NEW DIC,DR
 S DIC="^AGELUP(",DR="11"
 D EN^DIQ
 I $$DIR^XBDIR("E")
 Q
