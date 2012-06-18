INHMSR22 ;KN; 31 Oct 95 07:27; Statistical Report-Utility 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: Statistical Report Display Module (INHMSR22).
 ;
 ; DESCRIPTION: The purpose of the INHMSR22 is used to contain
 ;              the functions and support for INHMSR2, INHMSR20,
 ;        and INHMSR21.
 ;
 ;
HDCON(INFL,INFD,INVAL) ; conversion for header
 ; 
 ; Description:  Convert to external format to use in header
 ; Return: External value
 ; Parameters:
 ; INFL = File ien
 ;  INFD = Field ien
 ; INVAL= Internal value
 ;
 ; Code begins:
 N A,INT,STMP
 ; Get piece 2 and piece 3
 S INT=$$GPC2^INHMSR10(INFL,INFD),STMP=$$GPC3^INHMSR10(INFL,INFD)
 ; If piece 2 is a pointer reference to a file
 I INT["P" S A="^"_$E(STMP,1,$L(STMP)-1) Q $P(@A@(INVAL,0),U)
 ;Convert for set of code
 I INT["S" S C=$P(^DD(INFL,INFD,0),U,2),Y=INVAL D Y^DIQ Q Y
 ;Convert for date
 I INT["D" S Y=INVAL D DD^%DT Q Y
 ;If free text, leave it alone
 Q INVAL
 ;
INXMVG(INFL,INFD,INVAL) ; Internal to external, move variable into global 
 ; 
 ; Description:  Check if see INVAL before, convert and store in 
 ;  INAP array if neccessary for look up later.  If
 ;  INAP is too large, then move it to global.
 ; Return: External value
 ; : Null
 ; Parameters:
 ; INFL = File ien
 ;  INFD = Field ien
 ; INVAL= Internal value
 ;
 ; Code begins:
 ; Merge over to ^UTILITY when the space is full
 I $S<20000 K ^UTILITY("INAP",$J) M ^UTILITY("INAP",$J)=INAP K INAP S INAP="^UTILITY(""INAP"",$J)"
 ; If see internal before, get external value
 I $D(INAP(INFL,INFD,INVAL)) Q $G(INAP(INFL,INFD,INVAL))
 ; If not see internal before, convert to external then store in INAP array
 I '$D(INAP(INFL,INFD,INVAL)) S C=$P(^DD(INFL,INFD,0),U,2),Y=INVAL D Y^DIQ S INAP(INFL,INFD,INVAL)=Y Q Y
