PSORXI ;IHS/DSD/JCM - logs pharmacy interventions ;16-Jan-2004 07:45;PLS
 ;;7.0;OUTPATIENT PHARMACY;;DEC 1997
 ; This routine is used to create entries in the APSP INTERVENTION file.
 ; Modified - IHS/CIA/PLS - 12/22/03 - Line DIC+2
START ;
 D INIT,DIC G:PSORXI("QFLG") END
 D EDIT
 S:'$D(PSONEW("PROVIDER")) PSONEW("PROVIDER")=$P(^APSPQA(32.4,PSORXI("DA"),0),"^",3)
END D EOJ
 Q
INIT ;
 W !!,"Now creating Pharmacy Intervention",!
 I $G(PSODRUG("IEN")) W "for  "_$P($G(^PSDRUG(PSODRUG("IEN"),0)),"^"),!
 K PSORXI S PSORXI("QFLG")=0
 Q
DIC ;
 K DIC,DR,DA,X,Y,DD,DO S DIC="^APSPQA(32.4,",DLAYGO=9009032.4,DIC(0)="L",X=DT
 ; IHS/CIA/PLS - 12/22/03 - Adjust .07 value
 N APSPCRI,APSPSIG,APSPINT
 S APSPINT=+$G(PSORX("INTERVENE"))
 S APSPCRI=$O(^APSPQA(32.3,"B","CRITICAL DRUG INTERACTION","")),APSPSIG=$O(^APSPQA(32.3,"B","SIGNIFICANT DRUG INTERACTION",""))
 S DIC("DR")=".02////"_+PSODFN_";.04////"_DUZ_";.05////"_PSODRUG("IEN")_";.06///PHARMACY"
 ;S DIC("DR")=DIC("DR")_";.07"_$S($G(PSORX("INTERVENE"))=1:"////18",$G(PSORX("INTERVENE"))=2:"////19",1:"////6")_";.14////0"_";.16////"_$S($G(PSOSITE)]"":PSOSITE,1:"")
 S DIC("DR")=DIC("DR")_";.07"_$S(APSPINT=1:"////"_APSPCRI,APSPINT=2:"////"_APSPSIG,APSPINT=3:"////6",APSPINT=4:"////10",1:"")_";.14////0"_";.16////"_$S($G(PSOSITE)]"":PSOSITE,1:"")
 D FILE^DICN K DIC,DR,DA
 ; IHS/CIA/PLS - 12/22/03 - Commented next line and modified to set interacting drug
 ;I Y>0 S PSORXI("DA")=+Y
 I Y>0 S PSORXI("DA")=+Y D
 .I APSPINT=1!(APSPINT=2) D
 ..S ^APSPQA(32.4,+Y,13,0)="^^1^1^"_$P(Y,U,2)_U,^(1,0)="INTERACTING DRUG IS "_$G(DRG)
 E  S PSORXI("QFLG")=1 G DICX
 D DIE
DICX K X,Y
 Q
DIE ;
 K DIE,DIC,DR,DA
 S DIE="^APSPQA(32.4,",DA=PSORXI("DA"),DR=$S($G(PSORXI("EDIT"))]"":".03:1600",1:".03;.08")
 L +^APSPQA(32.4,PSORXI("DA")) D ^DIE K DIE,DIC,DR,X,Y,DA L -^APSPQA(32.4,PSORXI("DA"))
 W $C(7),!!,"See 'Pharmacy Intervention Menu' if you want to delete this",!,"intervention or for more options.",!
 Q
EDIT ;
 K DIR W ! S DIR(0)="Y",DIR("A")="Would you like to edit this intervention ",DIR("B")="N" D ^DIR K DIR I $D(DIRUT)!'Y G EDITX
 S PSORXI("EDIT")=1 D DIE G EDIT
EDITX K X,Y
 Q
EOJ ;
 K PSORXI
 Q
EN1(PSOX) ; Entry Point if have internal rx #
 N PSODFN,PSONEW,PSODRUG,PSOY
 I $G(^PSRX(+$G(PSOX),0))']"" W !,$C(7),"No prescription data" G EN1X
 S PSORXI("IRXN")=PSOX K PSOY S PSOY=^PSRX(PSORXI("IRXN"),0)
 S PSODFN=$P(PSOY,"^",2),PSONEW("PROVIDER")=$P(PSOY,"^",4),PSODRUG("IEN")=$P(PSOY,"^",6)
 D START
EN1X Q
