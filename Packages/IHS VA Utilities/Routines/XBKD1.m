XBKD1 ; IHS/ADC/GTH - XBKD SUBROUTINES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Part of XBKD
 ;
BX ;
 KILL A
 S (I,C)=""
 F J=1:1 S I=$O(^DIC("B",I)) Q:I=""  I $D(^(I,N)) S C=C+1,A(C)=I
 I 'C S C=$O(^DD(N,"NM","")) I C]"" S A=C,C=1,A(C)=A
 Q
 ;
NCK ;
 G NCKER:'$D(^DIC(N,0)),NCKER:+$P(^(0),"^",2)'=N
 I $D(^DIC(N,0,"GL")) S G=^("GL") G NCKOK:G?1"^DIC(".E
 I @("$D("_G_"0))"),+$P(^(0),"^",2)=N G NCKOK
NCKER ;
 S E=1
 Q
 ;
NCKOK ;
 S E=0
 Q
 ;
FGLB ;
 G FGOK:'$D(^DD(N,.01,1))
 S I=0
 F J=1:1 S I=$O(^DD(N,.01,1,I)) Q:I=""  I $D(^(I,1)) S X=^(1) D SB1 G FGOK:G]""
 S G=""
FGOK ;
 Q
 ;
END ;
 Q
 ;
TEMPLP ;
 F TEMP="^DIE(","^DIBT(","^DIPT(" D TEMP
 Q
 ;
TEMP ;
 S XBKDB="F"_XBKDFILE,XBKDA=""
TEMP1 ;
 S @("XBKDA=$O("_TEMP_"XBKDB,XBKDA))")
 G TEMPE:XBKDA=""
 S DA=""
TEMP2 ;
 S @("DA=$O("_TEMP_"XBKDB,XBKDA,DA))")
 G TEMP1:DA=""
 S DIE=TEMP,DR=".01" ;D ^DIE
 W !,DIE,?8,DA,?12,XBKDB,?24,XBKDA
 G TEMP2
 ;
TEMPE ;
 KILL XBKDA,XBKDB
 Q
 ;
SB1 ;
 S G=""
 I X'?1"S ^"1UP.U1"(".N1",""B""".E
 S G=$E($P(X,"""B""",1),3,999)
 Q
 ;
