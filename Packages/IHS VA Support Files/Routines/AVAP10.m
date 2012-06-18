AVAP10 ;IHS/ASDST/GTH - CORRECT GIHS XREF FROM 200 TO 6 ; [ 02/24/1999  1:45 PM ]
 ;;93.2;VA SUPPORT FILES;**10**;JUL 01, 1993
 ;
 S U="^"
 W !!!,"This is Patch 10 to AVA 93.2."
 W !!,"A correction will be made to the File 200 dd, Field 9999999.09,"
 W !,"which does not correctly set the GIHS x-ref on File 6."
 W !!,"Then, the x-ref will be fired for all entries in File 200, which"
 W !,"will correctly set the GIHS x-ref on File 6."
 W !!,"Based on your ",$P(^VA(200,0),U,4)," entries in File 200,"
 W !,"this should take about ",$FN($P(^VA(200,0),U,4)/100/60,"",2)," minutes."
 W !!,"Re-running this patch causes no harm."
 W !!
 NEW DIR
 S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="OKAY to run Patch 10"
 D ^DIR
 KILL DIR
 G:Y'=1 EOJ
 D WAIT^DICD
 ;
UPDATEDD ;
 W !,"Updating dd..."
 NEW DA
 F %=1:1 Q:'$D(^DD(200,9999999.09,1,%))  I $P(^(%,0),"^",2)="ACXIHS09" S DA=% Q
 I '$D(DA) W !,"X-REF 'ACXIHS09' not found in File 200, Field 9999999.09.",!,"Abnormal end of Patch 10!" G EOJ
 ;
 I '(^DD(200,9999999.09,1,DA,1)=$P($T(OLDSET),";",3)) W !,"You don't have the standard SET of the ACXIHS09 x-ref.",!,"Ending Patch 10 without updating." G EOJ
 ;
 I '(^DD(200,9999999.09,1,DA,2)=$P($T(OLDKILL),";",3)) W !,"You don't have the standard KILL of the ACXIHS09 x-ref.",!,"Ending Patch 10 without updating." G EOJ
 ;
 W !,"Updating SET of x-ref 'ACXIHS09'..."
 S ^DD(200,9999999.09,1,DA,1)=$P($T(SET),";",3)
 W "Done updating SET."
 ;
 W !,"Updating KILL of x-ref 'ACXIHS09'..."
 S ^DD(200,9999999.09,1,DA,2)=$P($T(KILL),";",3)
 W "Done updating KILL."
 ;
 S ^DD(200,9999999.09,"DT")=$$DT^XLFDT
 KILL DA
 ;
 W !,"dd update complete."
 ;
XREF ;
 W !!,"Beginning re-index of File 200, Field 9999999.09, x-ref 'ACXIHS09'..."
 NEW DIK
 S DIK="^VA(200,",DIK(1)="9999999.09^ACXIHS09"
 D ENALL^DIK
 KILL DIK
 W !,"Re-index complete."
 ;
 W !!,"Patch 10 to AVA 93.2 is complete.",!
 ;
EOJ ;     
 KILL DIC,DIR,DIE,DA,DR,X,Y
 Q
 ;
SET ;;N % S %=$P(^DIC(3,DA,0),U,16) I %]"" S:'$D(^DIC(6,%,9999999)) ^DIC(6,%,9999999)="" S $P(^(9999999),U,9)=X,^DIC(6,"GIHS",X,%)=""
 ;
KILL ;;N % S %=$P(^DIC(3,DA,0),U,16) I %]"",$D(^DIC(6,%,9999999)) S $P(^(9999999),U,9)="" K ^DIC(6,"GIHS",X,%)
 ;
OLDSET ;;N % S %=$P(^DIC(3,DA,0),U,16) I %]"" S:'$D(^DIC(6,%,9999999)) ^DIC(6,%,9999999)="" S $P(^(9999999),U,9)=X
 ;
OLDKILL ;;N % S %=$P(^DIC(3,DA,0),U,16) I %]"",$D(^DIC(6,%,9999999)) S $P(^(9999999),U,9)=""
 ;
