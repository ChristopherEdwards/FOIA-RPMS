ADGAD0 ; IHS/ADC/PDW/ENM - A&D UTILITIES ; [ 03/29/1999  8:51 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ; PD (previous date) used by VA G&L routines.
 ;
E ; -- error processor
 Q
 ;
FORMAT ;EP; -- format
 N DIR,Y
 K DIR S DIR(0)="SB^D:Detailed Format;S:Summary Format"
 S DIR("A")="Select Report Format - DETAILED or SUMMARY"
HLP S DIR("?",1)="DETAILED FORMAT uses a right margin of 110."
 S DIR("?",2)="It lists each patient name along with provider, age,"
 S DIR("?",3)="ward, service, community, and chart number."
 S DIR("?",4)="Newborn admissions and discharges are listed separately."
 S DIR("?",5)=" "
 S DIR("?",6)="SUMMARY FORMAT uses a right margin of 80."
 S DIR("?",7)="It gives a summary of movements by service."
 S DIR("?",8)="Then lists each patient with chart number, service,"
 S DIR("?",9)="and ward.",DIR("?",10)=" "
 S DIR("?")="Enter 'D' for DETAILED or 'S' for SUMMARY"
 D ^DIR G FORMAT:Y=-1 S DGZFM=Y
 I Y="D" W !!?20,"Paper margin must be at least 110."
 Q
 ;
MAN ; -- manual purge
 N Y,X,X1,X2,%DT,DIR
 ; -- date selection
 S %DT="AEPX",%DT("A")="Purge from what date: " D ^%DT K %DT
 G:Y=-1 MAN Q:$D(DTOUT)  S PD=Y
 ; -- procede?
 W !!,"Do you want to purge census file from " X ^DD("DD") W Y
 S DIR(0)="Y",DIR("A")="PURGE",DIR("B")="NO" D ^DIR
 ; -- call prg
 I 'Y K PD Q
 S X1=PD,X2=-1 D C^%DTC S PD=X
 D PRG K PD Q
 ;
PRG ;EP; -- purge (PD, (purge date)-1, required) called from recalc
 ; -- adgwd (ward)
 N W,T,D
 S W=0 F  S W=$O(^ADGWD(W)) Q:'W  D
 . S:$P($G(^ADGWD(W,1,0)),U,2)="" $P(^(0),U,2)="9009011.01D"
 . S D=RC F  S D=$O(^ADGWD(W,1,D)) Q:'D  D
 .. S DA(1)=W,DA=D,DIK="^ADGWD("_DA(1)_",1," D ^DIK K DA,DIK
 ; -- adgtx (ts)
 S T=0 F  S T=$O(^ADGTX(T)) Q:'T  D
 . S:$P($G(^ADGTX(T,1,0)),U,2)="" $P(^(0),U,2)="9009011.51D"
 . S D=RC F  S D=$O(^ADGTX(T,1,D)) Q:'D  D
 .. S DA(1)=T,DA=D,DIK="^ADGTX("_DA(1)_",1," D ^DIK K DA,DIK
 Q
OLDPRG ;IHS/DSD/ENM 03/16/99 PRG MODULE COPIED/MODIFIED
 ;EP; -- purge (PD, (purge date)-1, required) called from recalc
 ; -- adgwd (ward)
 N W,T,D
 S W=0 F  S W=$O(^ADGWD(W)) Q:'W  D
 . S:$P($G(^ADGWD(W,1,0)),U,2)="" $P(^(0),U,2)="9009011.01D"
 . S D=PD F  S D=$O(^ADGWD(W,1,D)) Q:'D  D
 .. S DA(1)=W,DA=D,DIK="^ADGWD("_DA(1)_",1," N W,D D ^DIK K DA,DIK
 ; -- adgtx (ts)
 S T=0 F  S T=$O(^ADGTX(T)) Q:'T  D
 . S:$P($G(^ADGTX(T,1,0)),U,2)="" $P(^(0),U,2)="9009011.51D"
 . S D=PD F  S D=$O(^ADGTX(T,1,D)) Q:'D  D
 .. S DA(1)=T,DA=D,DIK="^ADGTX("_DA(1)_",1," N T,D D ^DIK K DA,DIK
 Q
