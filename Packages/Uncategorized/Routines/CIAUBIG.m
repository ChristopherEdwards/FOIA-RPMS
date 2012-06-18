CIAUBIG ;MSC/IND/PLS - Print a banner in large letters;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Prints CIABIG to the current output device in large letters.
 ; Inputs:
 ;   CIABIG = Big letter string
 ;   CIARPT = # times to repeat (default=2)
 ;   CIATXT = Full text string (optional)
 ;=================================================================
ENTRY(CIABIG,CIARPT,CIATXT) ;
 N CIALT,CIAFS,CIAZ,CIAZ1,CIALEN,CIAPF,CIALN
 S CIAFS="ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789,-/.!#'$()*+?\=^&%"
 S:$D(CIATXT) CIATXT=$$REPEAT^XLFSTR("*"_CIATXT,$G(IOM,80)\($L(CIATXT)+1))
 S CIALEN=$L(CIABIG),CIARPT=$G(CIARPT,2)
 W !
 F CIALT=1:1:CIARPT D
 .W !
 .F CIAZ=1:8:65 D
 ..W !
 ..F CIAZ1=1:1:CIALEN D
 ...S CIALN=$F(CIAFS,$E(CIABIG,CIAZ1))-1
 ...S CIAPF=$P($T(TBL+CIALN),";;",2,99)
 ...W $E(CIAPF,CIAZ,CIAZ+7)
 ...W:CIAZ1<CIALEN ?(CIAZ1*12)
 .W !!,$G(CIATXT)
 Q
TBL ;; Table of character "raster images"
 ;; AAAAAA AA    AAAA    AAAAAAAAAAAAAAAAAAAA    AAAA    AAAA    AA
 ;;BBBBBBB BB    BBBB    BBBBBBBBB BBBBBBB BB    BBBB    BBBBBBBBB
 ;;CCCCCCCCCC      CC      CC      CC      CC      CC      CCCCCCCC
 ;;DDDDDD  DD   DD DD    DDDD    DDDD    DDDD    DDDD   DD DDDDDD
 ;;EEEEEEEEEE      EE      EEEEEE  EEEEEE  EE      EE      EEEEEEEE
 ;;FFFFFFFFFF      FF      FFFFFF  FFFFFF  FF      FF      FF
 ;;GGGGGGGGGG      GG      GG  GGGGGG  GGGGGG    GGGG    GGGGGGGGGG
 ;;HH    HHHH    HHHH     HHHHHHHHHHHHHHHHHHH    HHHH    HHHH    HH
 ;;IIIIIIII   II      II      II      II      II      II   IIIIIIII
 ;;JJJJJJJJ    JJ      JJ      JJ      JJ      JJ  JJ  JJ  JJJJJJ
 ;;KK    KKKK   KK KK  KK  KKKK    KKKK    KK  KK  KK   KK KK    KK
 ;;LL      LL      LL      LL      LL      LL      LL      LLLLLLLL
 ;;MM    MMMMM  MMMM MMMM MMM MM MMMM    MMMM    MMMM    MMMM    MM
 ;;N     NNNN    NNNNN   NNNN N  NNNN  N NNNN   NNNNN    NNNN     N
 ;; OOOOOO OO    OOOO    OOOO    OOOO    OOOO    OOOO    OO OOOOOO
 ;;PPPPPPP PP    PPPP    PPPPPPPPP PP      PP      PP      PP
 ;; QQQQQQ QQ    QQQQ    QQQQ    QQQQ  Q QQQQ   Q Q QQQQQQ        Q
 ;;RRRRRRR RR    RRRR    RRRRRRRRR RR RR   RR  RR  RR   RR RR    RR
 ;;SSSSSSSSSS      SS      SSSSSSSSSSSSSSSS      SS      SSSSSSSSSS
 ;;TTTTTTTT   TT      TT      TT      TT      TT      TT      TT
 ;;UU    UUUU    UUUU    UUUU    UUUU    UUUU    UUUUUUUUUU UUUUUU
 ;;VV    VVVV    VVVV    VVVV    VV VV  VV  VV  VV   VVVV     VV
 ;;WW    WWWW    WWWW    WWWW    WWWW    WWWW WW WWWWW  WWWWW    WW
 ;;XX    XXXX    XX XX  XX   XXXX     XX     XXXX   XX  XX XX    XX
 ;;YY    YY YY  YY   Y  Y     YY      YY      YY      YY      YY
 ;;ZZZZZZZZZZZZZZZZ     ZZ     ZZ    ZZ      ZZ    ZZZZZZZZZZZZZZZZ
 ;;
 ;;  0000 0 00  00 00   00000  0 0000 0  00000   00 00  00 0 0000
 ;;   11     111    1111      11      11      11      11   1111111
 ;;  2222   22  22 22    22      22    22    22     22     2222222
 ;;3333333      33     33   33333       33       33     33 33333
 ;;      44     444   44 44 44   44 4444444      44      44      44
 ;;5555555555      55      5555555       55      55     55 555555
 ;;   666   66  66 66      66      66 6666 666   66 66   66  6666
 ;;77777777      77     77    77      77     77     77      77
 ;;  8888   88  88 88  88   8888   88  88  88    88 88  88   8888
 ;;  99999 99    9999    99 9999999      99      99     99   9999
 ;;                                         ''        '      '
 ;;                        ----------------
 ;;              //     //     //    //      //      //
 ;;                                         ....    ....    ....
 ;;    !!     !!      !!      !!     !!               ....    ....
 ;;  #  #  ########  #  #  ########  #  #
 ;;
 ;;   $$   $$$$$$$$$$ $$   $$$$$$$$   $$ $$$$$$$$$$   $$
 ;;   ((     ((     ((     ((      ((       ((       ((
 ;;   ))      ))        ))       ))      ))     ))     ))    ))
 ;;*  **  * * ** *   ****  ********  ****   * ** * *  **  *
 ;;           ++      ++   ++++++++++++++++   ++      ++
 ;;  ???   ??   ??      ??     ??     ??      ??     ....    ....
 ;;         \\       \\       \\       \\       \\       \\
 ;;        ================       =================
 ;;    ^      ^^^    ^^ ^^  ^^   ^^
 ;; &&&    &   &   &   &    &&&  &  &&& && &   &&  &   &&   &&&   &
 ;;  %    % % %  %   %  %      %      %      %  %   %  % % %     %
