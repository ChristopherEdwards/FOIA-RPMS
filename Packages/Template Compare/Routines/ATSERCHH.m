ATSERCHH ;TUCSON/DG;ASK FILE TO LINK TO IF TEMPLATES ON DIFF FILES [ 10/25/91  1:40 PM ]
 ;;2.5;SEARCH TEMPLATE COMPARISON;;OCT 25, 1991
 ;
ASKFILE5 ; - EP - PTRFILE,SRCHFILE1,SRCHFILE2, DIFF FILES, DIFFERENCE BETWEEN TEMPLATES
 S X="" F ATSL=0:0 Q:X=1!(X=2)!(X="^")!(ATSFLAG)  D:X["?" HELP^ATSERCH9 D ASKLOOP5
 I ATSFLAG Q
 S ATSEARCH("FILELINK")=$S(X=1:ATSEARCH(ATSENB,"SRCHFILENUM"),1:ATSEARCH("PTRFILENUM"))
 S ATSX=$S(X=1:ATSENB,1:3)
 D ^ATSERCH4
 Q
 ;
ASKLOOP5 ;CONTINUATION OF FOR LOOP IN ASKFILE5
 S ATSENB=$S(ATSMTCH=2:1,1:2)
 ;CAN ONLY LINK TO TEMPLATE THAT HAS THE ENTRIES YOU WANT
 ;THE "NOT TEMPLATE" CANNOT BE CHOSEN
 W !!,"Choose, by number, the file you want results linked to:",!!,1," ",@ATSEOP(ATSENB),!,2," ",@ATSEOP(3) R !!,"Your choice (1-2): 2// ",X:DTIME
 S:X=""&($T) X=2 S:'$T X="^" I "^"=X S ATSFLAG=$S($D(^UTILITY("ATSEARCH",$J,"MERGED")):2,1:1)
 Q
 ;