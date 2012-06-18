XBLCALL ; IHS/ADC/GTH - LIST CALLABLE SUBROUTINES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine lists callable subroutines that are known to
 ; this routine.  To add subroutines to this routine just add
 ; them to the end of this routine in same manner.
 ;
START ;
 NEW I,X,Y
 F I=1:1 S X=$T(@("L")+I) Q:X=""  W !,$P(X,";",3),$E("...............",1,15-$L($P(X,";",3))),$P(X,";",4,99) I '(I#20) Q:'($$QUIT)
 Q
 ;
QUIT() ;
 NEW I,X,Y
 Q $$DIR^XBDIR("E")
 ;
STARDATE(X) ; Return Stardate of FM date/time.
 I X'?7N.1".".6N Q -1
 NEW Y
 S Y=$P(X,".",2),Y=+$E(Y,1,2)/24+(+$E(Y,3,4)/(60*24))+(+$E(Y,5,6)/(60*60*24))
 Q $FN($E(X,3,7)+Y,"-",2)
 ;
L ;
 ;;^XBCLS;Clears the screen
 ;;EP^XBCLM(STR);Lists numbered column headings over the passed string
 ;;^XBDAD0;Returns DA array for D0,D1, etc. or vice versa
 ;;KILL^XBDAD0;KILL D0, D1, ETC.
 ;;^XBDATE;Limits selected routines to those edited after given date
 ;;^XBDBQUE;Double Q'uing shell handler
 ;;^XBDIE;Exclusive NEW of Kernel vars for nesting DIE calls
 ;;^XBDIFF;Returns difference between two date/times
 ;;$$DIC^XBDIQ1(FN);Extrensic entry to return DIC from global
 ;;EN^XBDIQ1;Returns single entries
 ;;ENM^XBDIQ1;Returns multiple entries
 ;;ENP^XBDIQ1(DIC,DA,DR,DIQ,FMT);Param pass into EN
 ;;ENPM^XBDIQ1(DIC,DA,DR,DIQ,FMT);Param pass into EN
 ;;PARSE^XBDIQ1(DA);Parse DA literal into da array
 ;;$$VAL^XBDIQ1(DIC,DA,DR);Return a value for a field
 ;;$$VALI^XBDIQ1(DIC,DA,DR);Return internal value for a field
 ;;$$DIR^XBDIR();Standard interface to Reader
 ;;EN1^XBDSET;Return FileMan dictionaries
 ;;EN^XBENHANCE(NS);Print enhancements from PACKAGE given namespace
 ;;FLD^XBFDINFO(FILE,FIELD,ROOT);Return field info from dd
 ;;^XBFMK;Kills variables left around by FileMan
 ;;EN1^XBFRESET;Reset global(s), confirm with user
 ;;EN2^XBFRESET;Reset global(s), do not confirm with user
 ;;^XBGXFR;Copies global to another global
 ;;^XBGXREFS;Returns xrefs for file/subfile,field
 ;;$$C^XBFUNC(X,Y);Center X in field length Y/IOM/80.
 ;;$$CV^XBFUNC(N);Return current version for package with namespace N
 ;;$$DECFRAC^XBFUNC(DECIMAL VALUE);returns fraction equivilent
 ;;$$FNDPATRN^XBFUNC(STR,PAT);finds pattern in string
 ;;$$GDT^XBFUNC(JDT);Return Gregorian Date, given Julian Date.
 ;;$$GETPATRN^XBFUNC(STR,PAT);returns pattern from string
 ;;$$INTSET^XBFUNC(FILE,FIELD,EXTVAL);returns internal value
 ;;$$JDT^XBFUNC(FMDT);Return Julian Date, given FM date.
 ;;$$EXTSET^XBFUNC(FILE,FIELD,INTVAL);returns external value
 ;;$$LOC^XBFUNC;Return location name from file 4 based on DUZ(2).
 ;;$$USR^XBFUNC;Return name of current user for ^VA(200.
 ;;$$PROVCLS^XBFUNC1(PROV,FORM);Return Provider Class from New Person
 ;;$$PROVCLSC^XBFUNC1(PROV);Return Provider Class Code given New Person IEN
 ;;$$PCCPPINT^XBFUNC2(VISIT);Return primary provider ien from 200
 ;;$$PCCPPN^XBFUNC2(VISIT);Return visit primary provider (NAME)
 ;;$$PCCPPI^XBFUNC2(VISIT);Return visit primary provider (INITIALS)
 ;;$$PCCPPCLS^XBFUNC2(VISIT,FORM);Return visit primary provider class (CODE)
 ;;$$PCCPPCLC^XBFUNC2(VISIT);Return visit primary provider class (CODE)
 ;;$$PCCPPAFF^XBFUNC2(VISIT,FORM);Return visit primary provider (affiliation)
 ;;^XBGSAVE;Generic global save for transmission globals
 ;;HELP^XBHELP(L,R,T);Display text beginning at label L of routine R
 ;;EN1^XBKD;Kill DICs and globals, info in vars
 ;;EN2^XBKD;Kill DICs and globals, info in ^UTILITY("XBDSET",$J) 
 ;;^XBKERCLN;Clean out kernel namespace items prior to install
 ;;^XBKTMP;KILL nodes in ^TMP( that have $J as 1st or 2nd subscripts
 ;;^XBKVAR;Set minimum Kernel vars
 ;;ARRAY^XBLM(AR,HDR);Display array that has (...,n,0) structure
 ;;DIQ^XBLM(DIC,DA);Display DIC and DA after call to EN^DIQ
 ;;FILE^XBLM(DIR,FN);Read file into the TMP global for display
 ;;GUID^XBLM(ROU,Y);Give routine and target array for FM prints
 ;;GUIR^XBLM(ROU,Y);Give routine and target array
 ;;SFILE^XBLM;Select a host file for display
 ;;VIEWD^XBLM(ROU);Use ROU to print to a host file for viewing
 ;;VIEWR^XBLM(ROU,HDR);Use ROU to print to a host file for viewing
 ;;EN^XBLZRO;List 0th nodes of pre-selected list of FileMan files
 ;;MAIL^XBMAIL(NS,REF);Send mail msg to holders of NS* security key
 ;;EN^XBNEW(XBRET,XBNS);Nest Die calls, "TAG^ROUTINE:VAR;NSVAR*"
 ;;^XBOFF;Set reverse video off
 ;;^XBON;Set reverse video on
 ;;PFTV^XBPFTV(FILE,ENTRY,VALUE);Returns terminal value for pointer
 ;;^XBPKDEL;Delete parts of package, namespace in XBPKNSP
 ;;EN1^XBRESID;Clean up residuals in ^DD from XBRLO to XBRHI
 ;;EN^XBRPTL;Print routines down to first label
 ;;EN^XBSFGBL(SUBFILE,ref,FORM);Return global ref of file or sub-file.
 ;;^XBSITE;Ask user to select site to set DUZ(2)
 ;;SET^XBSITE;Request set of DUZ(2) from applications
 ;;^XBUPCASE;Upcases value in X
 ;;EN^XBVIDEO(X);Set video attribute in X, return cursor
 ;;EN^XBVK(NS);KILLS local variables in the passed namespace
 ;;^XBVL;List variables in the selected namespace
 ;;$$KILLOK^ZIBGCHAR(G);Allow kill of global G
 ;;$$KILLNO^ZIBGCHAR(G);Prevent kill'ing of global G
 ;;$$JOURN^ZIBGCHAR(G);Set Journaling to ALWAYS for global G
 ;;$$NOJOURN^ZIBGCHAR(G);Set Journaling for global G to NEVER
 ;;$$UCIJOURN^ZIBGCHAR(G);Journal global G when UCI is Journaled
 ;;$$ERR^ZIBGCHAR(#);Return cause of error #
 ;;$$Z^ZIBNSSV(ERR);Return values of Non-Standard ($Z) Special Variables
 ;;^ZIBRUN;Sets $T based on whether routine in X is running
 ;;$$RSEL^ZIBRSEL(NS,Y);Select a list or range of routines
