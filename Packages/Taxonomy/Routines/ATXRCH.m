ATXRCH ; IHS/OHPRD/TMJ -  SEARCH TEMPLATE PT FILE W/ PAT TAX NAMES ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 S U="^",ATXFIL=9000001,ATXTSK=0
 D DT^DICRW
 D START I '$D(ATXTP) S Y="" F ATXL=0:0 Q:Y]""  D SORTEMP^ATXPVT
 I '$D(ATXTP) D @$S($D(ATXPAT):"DATES^ATXPVT",1:"^ATXTSK") I '$D(ATXPAT),'ATXTSK,'$D(ATXTP) D SEARCH
 D EOJ
 Q
 ;
START ;
 S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("DR")="" D ^DIC K DIC
 I Y<1 S ATXTP=1 Q
 I $D(^TMP("ATXTAX",+Y)) W !,$C(7),"Taxonomy currently",^(+Y)," Try later.",! G START
 I '$O(^ATXPAT(+Y,11,0)) S ATXPAT="" ;IF NO PTS IN PT TAX FILE, GOES TO DATES^ATXPVT TO FIND PT DFNS
 S ATXX=+Y
 D:'$D(ATXPAT) USER
 Q
 ;
USER ;INFORMS USER AS TO WHERE ENTRIES COMING FROM
 D DATE S ATXONE="W ""Create a search template with patient entries from the patient list"",!,""in the Pt Taxonomy file.  This list of patients starts with the visit"",!,""date "",ATXDATE,""."""
 S ATXTWO="W ""Create a search template of patients seen during a range of visit dates."",!,""These patients will have had a purpose of visit that falls within this taxonomy."""
ASK W !!,"Select, by number, one of the following: ",!!,1," " X ATXONE W !,2," " X ATXTWO R !,"Your choice (1 or 2): ",ATXPCK:DTIME
 I "^"[ATXPCK S ATXTP="" G A
 I ATXPCK=2 S ATXPAT="" G A
 I $E(ATXPCK)="?" D HELP G ASK
 I ATXPCK'=1 G ASK
A Q
 ;
DATE ;GET DATE FOR LINE USER+2
 S Y=$P(^ATXAX(ATXX,0),U,6) X ^DD("DD")
 S ATXDATE=Y
 Q
 ;
HELP ;
 W:$D(IOF) @IOF
 W !!,"Either select option one and a template will be automatically created or",!,"select option two and you will be able to enter a range of visit dates during",!,"which time patients who fall within the selected taxonomy were seen."
 Q
 ;
ZTM ;ENTRY POINT FOR TASKMAN
 D SEARCH
 I $D(ZTQUEUED) S ZTREQ="@"
 D EOJ
 Q
 ;
SEARCH ;CREATES RESULT NODES AND SPECIFICATION NODES IN ^DIBT(ATXTMP,
 S (ATXCNT,ATXDFN)=0
 W:'ATXTSK !! F ATXL=0:0 S ATXDFN=$O(^ATXPAT(ATXX,11,ATXDFN)) Q:ATXDFN'=+ATXDFN  S ^DIBT(ATXTMP,1,ATXDFN)="" W:'ATXTSK "." S ATXCNT=ATXCNT+1
 W !!,"There ",$S(ATXCNT'=1:"were ",1:"was "),ATXCNT,$S(ATXCNT'=1:" entries",1:" entry")," in the ",$P(^DIBT(ATXTMP,0),U)," template."
 S ^DIBT(ATXTMP,1,0)=ATXCNT
 Q
 ;
EOJ ;
 K ATXFIL,ATXL,ATXTP,ATXTMP,ATXX,ATXO,ATXHI,ATXLOV,ATXLO,ATXPV,ATXY,ATXL,ATXTP,ATXX,ATXDFN,ATXTMP,ATXPAT,ATXONE,ATXTWO,ATXPCK,ATXCNT,ATXTSK,ATXDATE
 Q
 ;
