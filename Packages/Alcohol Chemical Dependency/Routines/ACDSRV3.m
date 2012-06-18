ACDSRV3 ;IHS/ADC/EDE/KML - PRESET DOMAINS FOR ACD SERVER(1) OPTIONS; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;*****************************************************************
 ;Set/edit domains on a pre-set basis via the option [ACD SUPER7]
 ;or on the fly (if not pre-defined) via routine ACDGSAVE.
 ;*****************************************************************
EN ;EP
 ;//^ACDVSAVE
 ;//^ACDPSAVE
 ;//[ACD SUPER7]
 ;
 I '$D(^ACDOMAIN(DUZ(2),0)) D
 .S X=DUZ(2)
 .S DINUM=X
 .S DIC(0)="L"
 .S DIC="^ACDOMAIN("
 .D FILE^ACDFMC
 ;
EDIT ;Edit the file entry in 9002174.9
 S DA=DUZ(2)
 S DR="1:99"
 S DIE=9002174.9
 D DIE^ACDFMC
 D K Q
 ;
DOM ;EP Set XMY array for transmissions
 ;//^ACDVSAVE
 ;//^ACDPSAVE
 ;Do not allow selection of ones own domain
 ;If the data is visit data. It is OK to send program data to
 ;ones own domain because it overwrites i.e. .01 is dinumed in
 ;file ^ACDF5PI
 S ACDOWND=$P(^XMB(1,1,0),U),ACDOWND=$P(^DIC(4.2,ACDOWND,0),U)
 W !!
 K XMY
 I $D(^ACDOMAIN(DUZ(2),0)) F ACDOM=0:0 S ACDOM=$O(^ACDOMAIN(DUZ(2),1,ACDOM)) Q:'ACDOM  I $D(^(ACDOM,0)) S ACDOMP=^(0),ACDOMAIN=$P(^DIC(4.2,ACDOMP,0),U)  D
 .I ACDOMAIN=ACDOWND,ACDSRVOP=2 W !!,*7,"I Cannot send data to: ",ACDOMAIN," because it is your own.",!! Q
 .I ACDSRVOP=2 S XMY("S.ACD SERVER@"_ACDOMAIN)=""
 .I ACDSRVOP=1 S XMY("S.ACD SERVER1@"_ACDOMAIN)=""
 .D
 ..W !,"Sending to domain: ",ACDOMAIN
K ;
 K X,Y,DIC,DINUM,DA,ACDOM,ACDOWND,ACDSRVOP
 K ACDOMAIN,ACDOMP ;              3-31-95 EDE
 Q
