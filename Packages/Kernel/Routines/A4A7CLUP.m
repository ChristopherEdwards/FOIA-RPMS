A4A7CLUP ;SFISC/RWF - CLEAN UP THE NEW PERSON FILE FOF ;12/27/90  16:25
 ;;1;;
A I $G(DUZ(0))'="@" W !!,*7,"You must have VA FileMan Programmer access" Q
 W !!,"This routine will check and see if your site is using the new File Access",!,"method for VA FileMan. If not it will let you remove the fields in the "
 W !,"New Person and User file that could change the access method by accident"
N I $D(^DD(200,0))[0 W !!,"You don't have a New Person file" G USER
 I $D(^DD(200.032,0))=0 G USER
 I $D(^VA(200,"AFOF")) W !!,*7,"You have data in your File 200 'AFOF' X-ref. This means that you are using the",!,"'ACCESSIBLE FILE' access." G USER
 W !!,"Your NEW PERSON file has the 'ACCESSIBLE FILE' field:"
 S DIR("A")="Remove 'ACCESSIBLE FILE' field",DIR(0)="Y" D ^DIR G PROV:$D(DIRUT)
 I Y=1 S DIU=200.032,DIU(0)="SD" D EN^DIU2
USER ;
 I '$D(^DIC(3,"AFOF")) G U2
 W !!,*7,"You have data in your File 3 'AFOF' X-ref. This means that you are using the",!,"'ACCESSIBLE FILE' access."
 W !,"You must remove this FIRST if you want to run this option." G PROV
U2 ;
 I $D(^DD(3.032,0))=0 W !,"You don't have the 'ACCESSIBLE FILE' field in your user file." G PROV
 W !!,"Your USER file has the 'ACCESSIBLE FILE' field:"
 S DIR("A")="Remove 'ACCESSIBLE FILE' field",DIR(0)="Y" D ^DIR G PROV:$D(DIRUT)
 I Y=1 S DIU=3.032,DIU(0)="SD" D EN^DIU2
 ;
PROV ;
 I $D(^DD(6.01,.01,0))[0 G EXIT
 W !!,"The 'MNEMONIC' field in the PROVIDER file has been causing problems.",!,"It is sugested that it be removed."
 S DIR("A")="Remove 'MNEMONIC' field",DIR(0)="Y" D ^DIR G EXIT:$D(DIRUT)
 I Y=1 S DIU=6.01,DIU(0)="SD" D EN^DIU2
EXIT W !!,"EXIT" K DIR,DIU,Y Q
