ACDWSTAF ;IHS/ADC/EDE/KML - STAFF REPORTS 10:19; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;//[ACD R6-SAR]
EN ;
 K DIRUT
 ;
 ;Initialize counter forTOT CLIENT SERVICE HOURS (ACDTH)
 ;                      TOT PREVENTION HOURS   (ACDTHP)
 ;                      TOT CRISIS BRIEF HOURS (ACDTHOT)
 ;                      TOT CLIENT SERVICE VISITS (ACDCNUMT)
 ;                      TOT UNIQ CLIENTS SEEN (ACDCLIU)
 S ACDTH=0,ACDTHP=0,ACDTHOT=0,ACDCNUMT=0 K ACDCLIU
 ;
 ;Initialize counter for total visits found on report
 S ACDVNUM=0
 ;
 ;Set flag variable for tasking
 S ACDWSTAF(1)=1
 ;
 ;Ask for only one provider
 K ACDGVER
 ;K DIC S DIC="^DIC(6,",DIC(0)="AEQ" D ^DIC Q:Y<0  S ACDGVER=+Y
 K DIC S DIC="^VA(200,",DIC(0)="AEQ",DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y))" D ^DIC Q:Y<0  S ACDGVER=+Y
 I '$D(ACDGVER) S ACDQUIT=1 Q
 ;
 ;Ask for whole report or a summary only.
 S DIR(0)="S^1:PRINT FULL REPORT;2:PRINT SUMMARY REPORT" D ^DIR G:X["^"!($D(DTOUT)!(X="")) K
 K ACDSUMRP I Y=2 S ACDSUMRP=2
 ;
 ;Ask for date range to gather data
 D D^ACDWRQ G:$D(ACDQUIT) K
 D HV^ACDWUTL
 ;
 ;Queue
 D ^ACDWQ ;        call to XBDBQUE
 Q
 ;
L ;EP - FOR TASKMAN (XBDBQUE)
 Q
 ;
P ;EP - PRINT REPORT
 ; Order on visit i.e. ^ACDVIS
 K DIRUT
 U IO D H
 S ACDFR=$E(ACDFR,1,5)_"00"
 F ACD=ACDFR-.01:0 S ACD=$O(^ACDVIS("B",ACD)) Q:'ACD!(ACD>ACDTO)  F ACDV=0:0 S ACDV=$O(^ACDVIS("B",ACD,ACDV)) Q:'ACDV  S ACDDA=ACDV D ^ACDWVIS I ACD6DIG=ACDAUF D V1 Q:$D(DIRUT)
 ;
 ;Get prevention data
 D ^ACDWSTA1
 Q:$D(DIRUT)
 ;
 I $D(ACDSUMRP) W !,"S U M M A R Y   O N L Y",!!
 W !,"NOTE: THIS REPORT DOES 'NOT INCLUDE' ANY INTERVENTION DATA.",!!
 D EN^ACDV4MES
 W !!,"SEARCH CRITERIA IS THAT: THE PROVIDER NAME WAS ENTERED",!,"DURING DATA ENTRY INTO THE FIELD TITLED 'PROVIDER TO CREDIT WORKLOAD' FOR "
 W !,"CONTACT TYPES OF CLIENT SERVICE AND PREVENTIONS."
 W !!,"SEARCH CRITERIA IS THAT: FOR ALL OTHER CONTACT TYPES",!,"WHERE THERE IS NO FIELD CALLED 'PROVIDER TO CREDIT WORKLOAD', THE 'PROVIDER'",!,"FIELD IS USED TO FIND A MATCH.",!!
 W !,"H O U R S   W O R K - L O A D   D A T A"
 D F W !,"TOT HOURS FOR CLIENT SERVICE CONTACTS: ",?70,ACDTH
 D F W !,"TOT HOURS FOR PREVENTION CONTACTS: ",?70,ACDTHP
 D F W !,"TOT HOURS FOR CRISIS/BRIEF CONTACTS: ",?70,ACDTHOT
 W !!,"V I S I T   W O R K - L O A D   D A T A"
 D F W !,"TOT CLIENT VISITS: ",?70,ACDVNUM
 W !,"(INCLUDES PREVENTION VISITS)",!
 D F W !,"TOT CLIENT SERVICES:",?70,ACDCNUMT
 W !,"(REMEMBER: MANY CLIENTS SERVICES MAY BELONG TO THE SAME VISIT)",!!
 D F W !,"TOT UNIQ CLIENTS SEEN:",?70 S ACDCLIU=0 F ACD=0:0 S ACD=$O(ACDCLIU(ACD)) Q:'ACD  S ACDCLIU=ACDCLIU+1
 W ACDCLIU
 D F^ACDWUTL
 W @IOF
 Q
 ;
V1 ;
 ;
 ;If Contact is 'OT' get hours for grand total
 I ACDCONTL="CRISIS/BRIEF INT",ACDPROVP=ACDGVER S ACDOTHRS=$O(^ACDIIF("C",ACDV,0)) D
 . I ACDOTHRS]"" S ACDOTHRS=$P(^ACDIIF(ACDOTHRS,0),U,6),ACDTHOT=ACDTHOT+ACDOTHRS
 ;
 ;If contact is not a client service visit, then the provider for the
 ;visit must match the selected provider. All contacts except prevention
 ;and client service will have only one provider. Secondary providers
 ;may exist on preventions and client services.
 I ACDCONTL'="CLIENT SERVICE",ACDPROVP'=ACDGVER Q
 ;
 ;
 ;Increment visit counter,unique client counter
 S ACDVNUM=ACDVNUM+1 S ACDCLIU(ACDDFNP)=""
 ;
 ;Not a client service/prevention so simply output visit information
 ;then quit
 I ACDCONTL'="CLIENT SERVICE",ACDPROVP=ACDGVER D F Q:$D(DIRUT)  I '$D(ACDSUMRP) W !,ACDVNUM,")",?5,ACDCLIV,?18,$E(ACDPG,1,12),?31,ACDCONTL W:ACDCONTL="CRISIS/BRIEF INT" "/",ACDOTHRS W ?60,$E(ACDDFN,1,19) Q
 Q:$D(DIRUT)
 ;
 ;
 ;Initialize counter for number of client services the provider was
 ;involved in within the single visit. (ACDCNUM)
 ;
 ;Initialize the counter for grand total hours within the visit.
 S (ACDOK,ACDCNUM,ACDVH)=0
 ;
 D CK
 Q:'ACDOK
 D F Q:$D(DIRUT)  I '$D(ACDSUMRP) W !!,ACDVNUM,")",?5,ACDCLIV,?18,$E(ACDPG,1,12),?31,ACDCONTL,?60,$E(ACDDFN,1,19),!!?14,"Primary Provider: ",?40,$S($D(^VA(200,ACDPROVP,0)):$P(^VA(200,ACDPROVP,0),U),1:"UNKNOWN")
 Q:$D(DIRUT)
 ;
 ;F ACD1=0:0 S ACD1=$O(^ACDCS("C",ACDV,ACD1)) Q:'ACD1  I $D(^ACDCS(ACD1,1,ACDGVER,0)) S ACDDA=ACD1 D ^ACDWCS Q:$D(DIRUT)  D V2 Q:$D(DIRUT)
 ; replace above line (BUG fix). Needed to retrieve the ptr multiple    
 ; for the provider(s) to credit workload (bug fix) since the ptr is
 ; not always equal to the provider ien which the replaced logic assumes
 F ACD1=0:0 S ACD1=$O(^ACDCS("C",ACDV,ACD1)) Q:'ACD1  I $D(^ACDCS(ACD1,1,0)) D
 . S PRVCR=$P(^ACDCS(ACD1,1,0),U,3)
 . I $G(^ACDCS(ACD1,1,PRVCR,0))=ACDGVER S ACDDA=ACD1 D ^ACDWCS Q:$D(DIRUT)  D V2 Q:$D(DIRUT) 
 K PRVCR
 Q:$D(DIRUT)
 D F Q:$D(DIRUT)  I '$D(ACDSUMRP) W !?14,"TOT HOURS FOR VISIT: ",?40,ACDVH,!
 Q
V2 ;
 S ACDCNUM=ACDCNUM+1,ACDCNUMT=ACDCNUMT+1
 D F I '$D(ACDSUMRP) W !?8,ACDCNUM,")",?14,"Provider(s) credited: ",?40,$S($D(^VA(200,ACDGVER,0)):$P(^VA(200,ACDGVER,0),U),1:"UNKNOWN")
 D F I '$D(ACDSUMRP) W !?14,"DAY",?40,ACDDAY
 D F I '$D(ACDSUMRP) W !?14,"SERVICE",?40,ACDSVAC
 D F I '$D(ACDSUMRP) W !?14,"LOCATION",?40,ACDLOTY
 D F I '$D(ACDSUMRP) W !?14,"HOUR",?40,ACDHOUR
 S ACDTH=ACDTH+ACDHOUR,ACDVH=ACDVH+ACDHOUR
 Q
CK ;
 ;See if provider was involved with any of the client services. If so,
 ;set ok to 1 and now I can print out the visit data with the
 ;primary provider knowing the primary provider may not be the selected
 ;provider
 S ACDOK=0
 I ACDPROVP=ACDGVER S ACDOK=1 Q
 ;F ACD1=0:0 S ACD1=$O(^ACDCS("C",ACDV,ACD1)) Q:'ACD1  S ACDDA=ACD1 D ^ACDWCS I $D(^ACDCS(ACD1,1,ACDGVER,0)) S ACDOK=1
 ; replace above line (BUG fix). Needed to retrieve the ptr multiple    
 ; for the provider(s) to credit workload (bug fix) since the ptr is
 ; not always equal to the provider ien which the replaced logic assumes
 F ACD1=0:0 S ACD1=$O(^ACDCS("C",ACDV,ACD1)) Q:'ACD1  S ACDDA=ACD1 D ^ACDWCS I $D(^ACDCS(ACD1,1,0)) D
 . S PRVCR=$P(^ACDCS(ACD1,1,0),U,3)
 . I $G(^ACDCS(ACD1,1,PRVCR,0))=ACDGVER S ACDOK=1
 K PRVCR
 Q
H ;EP Header
 D H^ACDWSTA2
 Q
 ;
F ;Form Feed
 Q:$D(DIRUT)
 I $Y+4>IOSL D F^ACDWUTL D:'$D(DIRUT) H
 Q
EOJ ;EP - EOJ FOR XBDBQUE
K ; for gotos in this routine
 D ^ACDWK
 Q
