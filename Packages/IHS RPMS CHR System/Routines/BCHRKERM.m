BCHRKERM  ;IHS/TUCSON/LAB - receive file from remote    [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;
START ;EP - called from option
 W:$D(IOF) @IOF
 W !!,"This option is used to receive a file of CHR transactions from a remote",!,"computer.  This option should only be used if you are about to send"
 W !,"a file via the Kermit Protocol.  DO NOT CONTINUE if this is not the case.",!!!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" K DA D ^DIR K DIR
 G:$D(DIRUT) EXIT
 G:'Y EXIT
 W !!!!,"OKAY ....",!!
 S XTKHL7=1 G R^XTKERMIT
EXIT ;
 ;W !!!!,"All Done"
 Q
