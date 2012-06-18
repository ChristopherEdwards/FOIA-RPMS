BGP0LSTF ; IHS/CMI/LAB - List 'BG08' files in pub ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to list all CRS 2010 files that are in a directory.",!,"These files begin with BG10.",!,"You must specify the directory in which the CRS 2010 data files reside.",!
FILE ;
 D HOME^%ZIS
DIR ;
 K DIR
 S BGPDIR=""
 S DIR(0)="F^3:50",DIR("A")="Enter directory path (i.e. /usr/spool/uucppublic/)" K DA D ^DIR K DIR
 I $D(DIRUT) W !!,"Directory not entered!!  Bye." K BGPDIR Q
 S BGPDIR=Y
 ;
 K BGPLIST S BGPLIST="",X=$$LIST^%ZISH(BGPDIR,"BG10*",.BGPLIST)
 I $O(BGPLIST(""))="" W !!,"There are no files in that directory." D EOP^BGP0DH D EN^XBVK("BGP") Q
 W !!,"The following CRS 2010 files reside in the ",BGPDIR," directory."
 S X="" F  S X=$O(BGPLIST(X)) Q:X'=+X  W !?5,BGPLIST(X)
 ;S X=$$TERMINAL^%HOSTCMD("ls /usr/spool/uucppublic/G* > /usr/spool/uucppublic/glist")
 ;S X=$$TERMINAL^%HOSTCMD("ls G* > glist")
 ;S X=$$TERMINAL^%HOSTCMD("cat /usr/spool/uucppublic/glist")
 ;S X=$$TERMINAL^%HOSTCMD("rm glist")
 K DIR S DIR(0)="E" D ^DIR
 K BGPDIR
 Q
