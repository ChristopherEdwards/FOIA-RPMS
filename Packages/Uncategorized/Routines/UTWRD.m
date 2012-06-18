UTWRD(DIR,DIRH,DIRT,DIRFK) ;ESS,JSH ; 16 Sep 1999 09:40; SCREEN READER 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TLS_4603; GEN 1; 28-JUN-1999
 ;COPYRIGHT 1999 SAIC
 ;The CHCS version of this routine is part of the WindowMan function.
 ;The IHS version contains stub tags
 Q
HELP ;;
 S X="?" Q
EXIT ;;
 S X="^" Q
ABRT ;;
 S X="^^" Q
 ;
YN(DIR,DIRH,DIRT) ;EP - Yes/No reader 
 ; Returns 1 for YES, 0 for NO, 0^0=^, 0^1=TIMED OUT
 Q
 ;
MESS(DIR) ;entry point to print message DIR
 Q
 ;
UPCASE(X) ; FUNCTION, Convert X to uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;
